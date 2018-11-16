Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:39549 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728024AbeKQAZc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 19:25:32 -0500
Subject: Re: [PATCH v3] media: vivid: Improve timestamping
To: Gabriel Francisco Mandaji <gfmandaji@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: lkcamp@lists.libreplanetbr.org
References: <20181111223937.GA24963@gfm-note>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2623431d-fa96-30f9-2d1c-e5c8470d31ff@xs4all.nl>
Date: Fri, 16 Nov 2018 15:12:54 +0100
MIME-Version: 1.0
In-Reply-To: <20181111223937.GA24963@gfm-note>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/2018 11:39 PM, Gabriel Francisco Mandaji wrote:
> Simulate a more precise timestamp by calculating it based on the
> current framerate.
> 
> Signed-off-by: Gabriel Francisco Mandaji <gfmandaji@gmail.com>

Something is still wrong: the frame period calculation is fine for
input 0 (webcam), but if I switch to another input (S-Video/TV/HDMI),
then it is totally wrong: for input 3 (HDMI) the fps seems to be off
by a factor of 10000 (i.e. I see a framerate of over 60000 where I
expected to see 60 Hz), and for inputs 2 and 3 I get 7000 fps for
PAL and 110000 for NTSC.

v4l2-ctl -P (== VIDIOC_G_PARM) returns the right thing here.

This calculation is the problem:

	u64 f_period = dev->timeperframe_vid_cap.numerator * 1000000000 /
		       dev->timeperframe_vid_cap.denominator;

You need to cast dev->timeperframe_vid_cap.numerator to a u64
first otherwise the multiplication overflows the u32 if numerator is > 4.

Also note that you cannot divide 64 bit values: not all architectures
support that. Use do_div instead.

With that change it should work.

Regards,

	Hans

> ---
> Changes in v2:
>     - fix spelling
>     - end of exposure is offset by 90% of the frame period
>     - fix timestamp calculation for FIELD_ALTERNATE (untested)
>     - timestamp is now calculated and set from vivid_thread_cap_tick()
>     - capture vbi uses the same timestamp as non-vbi, but offset by 5%
>     - timestamp stays consistent even if the FPS changes
>     - tested with dropped frames
> Changes in v3:
>     - fix calculating offset for 'End of Frame'
>     - fix changing 'Timestamp Source' mid-capture
>     - change order of operation when calculating the VBI's offset
> ---
>  drivers/media/platform/vivid/vivid-core.h        |  3 ++
>  drivers/media/platform/vivid/vivid-kthread-cap.c | 47 +++++++++++++++++-------
>  drivers/media/platform/vivid/vivid-vbi-cap.c     |  4 --
>  3 files changed, 36 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
> index 1891254..f7b2a0b 100644
> --- a/drivers/media/platform/vivid/vivid-core.h
> +++ b/drivers/media/platform/vivid/vivid-core.h
> @@ -392,6 +392,9 @@ struct vivid_dev {
>  	/* thread for generating video capture stream */
>  	struct task_struct		*kthread_vid_cap;
>  	unsigned long			jiffies_vid_cap;
> +	u64				cap_stream_start;
> +	u64				cap_frame_period;
> +	u64				cap_frame_eof_offset;
>  	u32				cap_seq_offset;
>  	u32				cap_seq_count;
>  	bool				cap_seq_resync;
> diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
> index eebfff2..f97cb6a 100644
> --- a/drivers/media/platform/vivid/vivid-kthread-cap.c
> +++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
> @@ -425,12 +425,6 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
>  		is_loop = true;
>  
>  	buf->vb.sequence = dev->vid_cap_seq_count;
> -	/*
> -	 * Take the timestamp now if the timestamp source is set to
> -	 * "Start of Exposure".
> -	 */
> -	if (dev->tstamp_src_is_soe)
> -		buf->vb.vb2_buf.timestamp = ktime_get_ns();
>  	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
>  		/*
>  		 * 60 Hz standards start with the bottom field, 50 Hz standards
> @@ -554,14 +548,6 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
>  			}
>  		}
>  	}
> -
> -	/*
> -	 * If "End of Frame" is specified at the timestamp source, then take
> -	 * the timestamp now.
> -	 */
> -	if (!dev->tstamp_src_is_soe)
> -		buf->vb.vb2_buf.timestamp = ktime_get_ns();
> -	buf->vb.vb2_buf.timestamp += dev->time_wrap_offset;
>  }
>  
>  /*
> @@ -667,10 +653,25 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
>  	}
>  }
>  
> +static void vivid_cap_update_frame_period(struct vivid_dev *dev)
> +{
> +	u64 f_period = dev->timeperframe_vid_cap.numerator * 1000000000 /
> +		       dev->timeperframe_vid_cap.denominator;
> +	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
> +		f_period /= 2;
> +	/*
> +	 * If "End of Frame", then offset the exposure time by 0.9
> +	 * of the frame period.
> +	 */
> +	dev->cap_frame_eof_offset = f_period * 9 / 10;
> +	dev->cap_frame_period = f_period;
> +}
> +
>  static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
>  {
>  	struct vivid_buffer *vid_cap_buf = NULL;
>  	struct vivid_buffer *vbi_cap_buf = NULL;
> +	u64 f_time = 0;
>  
>  	dprintk(dev, 1, "Video Capture Thread Tick\n");
>  
> @@ -702,6 +703,11 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
>  	if (!vid_cap_buf && !vbi_cap_buf)
>  		goto update_mv;
>  
> +	f_time = dev->cap_frame_period * dev->vid_cap_seq_count +
> +		 dev->cap_stream_start + dev->time_wrap_offset;
> +	if (!dev->tstamp_src_is_soe)
> +		f_time += dev->cap_frame_eof_offset;
> +
>  	if (vid_cap_buf) {
>  		v4l2_ctrl_request_setup(vid_cap_buf->vb.vb2_buf.req_obj.req,
>  					&dev->ctrl_hdl_vid_cap);
> @@ -721,9 +727,13 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
>  				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>  		dprintk(dev, 2, "vid_cap buffer %d done\n",
>  				vid_cap_buf->vb.vb2_buf.index);
> +
> +		vid_cap_buf->vb.vb2_buf.timestamp = f_time;
>  	}
>  
>  	if (vbi_cap_buf) {
> +		u64 vbi_period;
> +
>  		v4l2_ctrl_request_setup(vbi_cap_buf->vb.vb2_buf.req_obj.req,
>  					&dev->ctrl_hdl_vbi_cap);
>  		if (dev->stream_sliced_vbi_cap)
> @@ -736,6 +746,10 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
>  				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>  		dprintk(dev, 2, "vbi_cap %d done\n",
>  				vbi_cap_buf->vb.vb2_buf.index);
> +
> +		/* If capturing a VBI, offset by 0.05 */
> +		vbi_period = dev->cap_frame_period * 5 / 100;
> +		vbi_cap_buf->vb.vb2_buf.timestamp = f_time + vbi_period;
>  	}
>  	dev->dqbuf_error = false;
>  
> @@ -767,6 +781,8 @@ static int vivid_thread_vid_cap(void *data)
>  	dev->cap_seq_count = 0;
>  	dev->cap_seq_resync = false;
>  	dev->jiffies_vid_cap = jiffies;
> +	dev->cap_stream_start = ktime_get_ns();
> +	vivid_cap_update_frame_period(dev);
>  
>  	for (;;) {
>  		try_to_freeze();
> @@ -779,6 +795,9 @@ static int vivid_thread_vid_cap(void *data)
>  			dev->jiffies_vid_cap = cur_jiffies;
>  			dev->cap_seq_offset = dev->cap_seq_count + 1;
>  			dev->cap_seq_count = 0;
> +			dev->cap_stream_start += dev->cap_frame_period *
> +						 dev->cap_seq_offset;
> +			vivid_cap_update_frame_period(dev);
>  			dev->cap_seq_resync = false;
>  		}
>  		numerator = dev->timeperframe_vid_cap.numerator;
> diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
> index 903cebe..17aa4b0 100644
> --- a/drivers/media/platform/vivid/vivid-vbi-cap.c
> +++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
> @@ -95,8 +95,6 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
>  
>  	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
>  		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
> -
> -	buf->vb.vb2_buf.timestamp = ktime_get_ns() + dev->time_wrap_offset;
>  }
>  
>  
> @@ -119,8 +117,6 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev,
>  		for (i = 0; i < 25; i++)
>  			vbuf[i] = dev->vbi_gen.data[i];
>  	}
> -
> -	buf->vb.vb2_buf.timestamp = ktime_get_ns() + dev->time_wrap_offset;
>  }
>  
>  static int vbi_cap_queue_setup(struct vb2_queue *vq,
> 
