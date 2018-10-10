Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:47399 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726579AbeJJToP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 15:44:15 -0400
Subject: Re: [PATCH] media: vivid: Improve timestamping
To: Gabriel Francisco Mandaji <gfmandaji@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: lkcamp@lists.libreplanetbr.org
References: <20181010004921.GA6532@gfm-note>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dc6fa92d-2c11-e4df-e287-39d0944f5ea7@xs4all.nl>
Date: Wed, 10 Oct 2018 14:22:13 +0200
MIME-Version: 1.0
In-Reply-To: <20181010004921.GA6532@gfm-note>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gabriel,

Thank for you this patch!

I do have some comments, see below...

On 10/10/18 02:49, Gabriel Francisco Mandaji wrote:
> Simulate a more precise timestamp by calculating it based on the
> current framerate.
> 
> Signed-off-by: Gabriel Francisco Mandaji <gfmandaji@gmail.com>
> ---
>  drivers/media/platform/vivid/vivid-core.h        |  1 +
>  drivers/media/platform/vivid/vivid-kthread-cap.c | 24 ++++++++++++++++--------
>  2 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
> index cd4c823..cbdadd8 100644
> --- a/drivers/media/platform/vivid/vivid-core.h
> +++ b/drivers/media/platform/vivid/vivid-core.h
> @@ -384,6 +384,7 @@ struct vivid_dev {
>  	/* thread for generating video capture stream */
>  	struct task_struct		*kthread_vid_cap;
>  	unsigned long			jiffies_vid_cap;
> +	u64				cap_stream_start;
>  	u32				cap_seq_offset;
>  	u32				cap_seq_count;
>  	bool				cap_seq_resync;
> diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
> index f06003b..0793b15 100644
> --- a/drivers/media/platform/vivid/vivid-kthread-cap.c
> +++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
> @@ -416,6 +416,7 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
>  	char str[100];
>  	s32 gain;
>  	bool is_loop = false;
> +	u64 soe_time = 0;
>  
>  	if (dev->loop_video && dev->can_loop_video &&
>  		((vivid_is_svid_cap(dev) &&
> @@ -426,11 +427,11 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
>  
>  	buf->vb.sequence = dev->vid_cap_seq_count;
>  	/*
> -	 * Take the timestamp now if the timestamp source is set to
> -	 * "Start of Exposure".
> +	 * Store the current time to calculate the delta if source is set to
> +	 * "End of Frame".
>  	 */
> -	if (dev->tstamp_src_is_soe)
> -		buf->vb.vb2_buf.timestamp = ktime_get_ns();
> +	if (!dev->tstamp_src_is_soe)
> +		soe_time = ktime_get_ns();
>  	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
>  		/*
>  		 * 60 Hz standards start with the bottom field, 50 Hz standards
> @@ -556,12 +557,18 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
>  	}
>  
>  	/*
> -	 * If "End of Frame" is specified at the timestamp source, then take
> -	 * the timestamp now.
> +	 * If "End of Frame", then calculate the "exposition time" and add

exposition -> exposure

> +	 * it to the timestamp.
>  	 */
>  	if (!dev->tstamp_src_is_soe)
> -		buf->vb.vb2_buf.timestamp = ktime_get_ns();
> -	buf->vb.vb2_buf.timestamp += dev->time_wrap_offset;
> +		soe_time = ktime_get_ns() - soe_time;

This isn't going to work. The soe_time is variable since the time it takes
vivid to fill the buffer will be variable. And the whole purpose of this
patch is to make it constant (since that's what happens in a real webcam).

I would just set soe_time to 0.9 times the frame period, and then add this
constant to the calculated timestamp.

> +	buf->vb.vb2_buf.timestamp = dev->timeperframe_vid_cap.numerator *
> +				    1000000000 /
> +				    dev->timeperframe_vid_cap.denominator *

I would first calculate the frame period in ns and store it in a temporary
variable, then use that to calculate the timestamp.

Note that the current code is wrong in case of FIELD_ALTERNATE (i.e. each
buffer contains a top or bottom field: in that case you first need to divide
the frame period by 2 to get the field period.

> +				    dev->vid_cap_seq_count +
> +				    dev->cap_stream_start +
> +				    soe_time +
> +				    dev->time_wrap_offset;
>  }
>  
>  /*
> @@ -759,6 +766,7 @@ static int vivid_thread_vid_cap(void *data)
>  	dev->cap_seq_count = 0;
>  	dev->cap_seq_resync = false;
>  	dev->jiffies_vid_cap = jiffies;
> +	dev->cap_stream_start = ktime_get_ns();

You also need to do this in the 'if (dev->cap_seq_resync) {' a few lines below this.
cap_seq_resync is set to true whenever the framerate is modified by userspace.

In fact, I think it would help if the timestamp calculation is moved from
vivid_fillbuff() to vivid_thread_vid_cap_tick(), since the same timestamp should
be used for both video and vbi (with the vbi timestamp slightly later compared
to the video timestamp, 0.05*frame_period would be reasonable offset).

That means that vivid_sliced_vbi_cap_process() and vivid_raw_vbi_cap_process()
no longer set the timestamp there.

The same exercise should also be done for video output, but let's get video
capture right first.

>  
>  	for (;;) {
>  		try_to_freeze();
> 

Did you check what happens when you drop frames? And wrapping the timestamp around?

I think those corner cases will work fine, but make sure you test it.

Regards,

	Hans
