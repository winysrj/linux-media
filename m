Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58759
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751649AbdF3MA1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 08:00:27 -0400
Date: Fri, 30 Jun 2017 09:00:18 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 06/12] [media] v4l: add V4L2_EVENT_BUF_QUEUED event
Message-ID: <20170630090018.3a2f19c1@vento.lan>
In-Reply-To: <20170616073915.5027-7-gustavo@padovan.org>
References: <20170616073915.5027-1-gustavo@padovan.org>
        <20170616073915.5027-7-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Jun 2017 16:39:09 +0900
Gustavo Padovan <gustavo@padovan.org> escreveu:

> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Add a new event the userspace can subscribe to receive notifications
> when a buffer is queued onto the driver. The event provides the index of
> the queued buffer.

If you're changing uAPI, you need to update media uAPI book as well.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  include/uapi/linux/videodev2.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 750d511..c2eda75 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -2150,6 +2150,7 @@ struct v4l2_streamparm {
>  #define V4L2_EVENT_FRAME_SYNC			4
>  #define V4L2_EVENT_SOURCE_CHANGE		5
>  #define V4L2_EVENT_MOTION_DET			6
> +#define V4L2_EVENT_BUF_QUEUED			7
>  #define V4L2_EVENT_PRIVATE_START		0x08000000
>  
>  /* Payload for V4L2_EVENT_VSYNC */
> @@ -2202,6 +2203,10 @@ struct v4l2_event_motion_det {
>  	__u32 region_mask;
>  };
>  
> +struct v4l2_event_buf_queued {
> +	__u32 index;
> +};
> +
>  struct v4l2_event {
>  	__u32				type;
>  	union {
> @@ -2210,6 +2215,7 @@ struct v4l2_event {
>  		struct v4l2_event_frame_sync	frame_sync;
>  		struct v4l2_event_src_change	src_change;
>  		struct v4l2_event_motion_det	motion_det;
> +		struct v4l2_event_buf_queued	buf_queued;
>  		__u8				data[64];
>  	} u;
>  	__u32				pending;


-- 
Thanks,
Mauro
