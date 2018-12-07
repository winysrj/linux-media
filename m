Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C53C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 10:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BB2620989
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 10:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BB2620989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbeLGKog (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 05:44:36 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59925 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbeLGKog (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 05:44:36 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VDcTg5jhGgJOKVDcWgYMVo; Fri, 07 Dec 2018 11:44:33 +0100
Subject: Re: [PATCH v4] media: vivid: Improve timestamping
To:     Gabriel Francisco Mandaji <gfmandaji@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     lkcamp@lists.libreplanetbr.org
References: <20181202134538.GA18886@gfm-note>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <abdac455-669f-de3d-729d-2c18d188046b@xs4all.nl>
Date:   Fri, 7 Dec 2018 11:44:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181202134538.GA18886@gfm-note>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfH3A/wBPNB+IHPeZdOX8gB0O9+d2S2qOjaqNMmKqoKSGQ7ojst2DLQ478a/riBi/pOpgxagCcxP6J/Em0HPi6IvxSi9KJ/lNuO+ad00sJJHB67rqt7TI
 awIiQ3MHpgmxdkBgBiq2+CTTEsz+wzCO9pRr4rt2YlWUF+NTr3H6JuHp9saIvpAOfiDLseXhr52eeGll+3H524mYSCc1Z9b6DzWpPxxXB/FLwuT798+/lskv
 nhi/29B5AtoajKrmGimyxJgOAyp8BY/cOlSr3uD9R80ytng7QDMhsfg3Pd/nDJgzDFkF6/etVz6+EZeBi6iVUSVHsZRslhWwkT9TLw24KgA=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Gabriel,

On 12/02/2018 02:45 PM, Gabriel Francisco Mandaji wrote:
> Simulate a more precise timestamp by calculating it based on the
> current framerate.
> 
> Signed-off-by: Gabriel Francisco Mandaji <gfmandaji@gmail.com>
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
> Changes in v4:
>     - fix calculations with 64 bit values

I decided to accept this patch. The only change I made was to replace the
do_div(f_period, 2) by a bit shift.

Thanks for working on this!

Can you look at adding the same support for the video output as well?
And also SDR capture (in a separate patch).

Regards,

	Hans

> ---
>  drivers/media/platform/vivid/vivid-core.h        |  3 ++
>  drivers/media/platform/vivid/vivid-kthread-cap.c | 51 +++++++++++++++++-------
>  drivers/media/platform/vivid/vivid-vbi-cap.c     |  4 --
>  3 files changed, 40 insertions(+), 18 deletions(-)
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
> index 46e46e3..91c7c67 100644
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
> @@ -667,10 +653,28 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
>  	}
>  }
>  
> +static void vivid_cap_update_frame_period(struct vivid_dev *dev)
> +{
> +	u64 f_period;
> +
> +	f_period = (u64)dev->timeperframe_vid_cap.numerator * 1000000000;
> +	do_div(f_period, dev->timeperframe_vid_cap.denominator);
> +	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
> +		do_div(f_period, 2);
> +	/*
> +	 * If "End of Frame", then offset the exposure time by 0.9
> +	 * of the frame period.
> +	 */
> +	dev->cap_frame_eof_offset = f_period * 9;
> +	do_div(dev->cap_frame_eof_offset, 10);
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
> @@ -702,6 +706,11 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
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
> @@ -721,9 +730,13 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
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
> @@ -736,6 +749,11 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
>  				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>  		dprintk(dev, 2, "vbi_cap %d done\n",
>  				vbi_cap_buf->vb.vb2_buf.index);
> +
> +		/* If capturing a VBI, offset by 0.05 */
> +		vbi_period = dev->cap_frame_period * 5;
> +		do_div(vbi_period, 100);
> +		vbi_cap_buf->vb.vb2_buf.timestamp = f_time + vbi_period;
>  	}
>  	dev->dqbuf_error = false;
>  
> @@ -767,6 +785,8 @@ static int vivid_thread_vid_cap(void *data)
>  	dev->cap_seq_count = 0;
>  	dev->cap_seq_resync = false;
>  	dev->jiffies_vid_cap = jiffies;
> +	dev->cap_stream_start = ktime_get_ns();
> +	vivid_cap_update_frame_period(dev);
>  
>  	for (;;) {
>  		try_to_freeze();
> @@ -779,6 +799,9 @@ static int vivid_thread_vid_cap(void *data)
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

