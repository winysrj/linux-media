Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:51663 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3CLPY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 11:24:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Volokh Konstantin <volokh84@gmail.com>
Subject: Re: [PATCH 1/2] hverkuil/go7007: staging: media: go7007: Restore b_frame control
Date: Tue, 12 Mar 2013 16:24:14 +0100
Cc: linux-media@vger.kernel.org
References: <1363100970-11080-1-git-send-email-volokh84@gmail.com>
In-Reply-To: <1363100970-11080-1-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121624.14971.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 12 March 2013 16:09:29 Volokh Konstantin wrote:
> Signed-off-by: Volokh Konstantin <volokh84@gmail.com>

Just wondering: did you test this?

If you get the latest v4l-utils code and run:

v4l2-ctl --stream-mmap=3

(first set the format to MPEG2) you should see B frames appearing.

> ---
>  drivers/staging/media/go7007/go7007-priv.h |    1 +
>  drivers/staging/media/go7007/go7007-v4l2.c |    7 +++++--
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
> index 0914fa3..5f9b389 100644
> --- a/drivers/staging/media/go7007/go7007-priv.h
> +++ b/drivers/staging/media/go7007/go7007-priv.h
> @@ -166,6 +166,7 @@ struct go7007 {
>  	struct v4l2_ctrl *mpeg_video_gop_closure;
>  	struct v4l2_ctrl *mpeg_video_bitrate;
>  	struct v4l2_ctrl *mpeg_video_aspect_ratio;
> +	struct v4l2_ctrl *mpeg_video_b_frames;
>  	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
>  	spinlock_t spinlock;
>  	struct mutex hw_lock;
> diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
> index 3634580..06fc930 100644
> --- a/drivers/staging/media/go7007/go7007-v4l2.c
> +++ b/drivers/staging/media/go7007/go7007-v4l2.c
> @@ -170,7 +170,7 @@ static void set_formatting(struct go7007 *go)
>  			go->gop_size == 15 &&
>  			go->closed_gop;

What should the ipb mode be for 'dvd_mode'? I think 0, but I'm not sure.

>  	go->repeat_seqhead = go->dvd_mode;
> -	go->ipb = 0;
> +	go->ipb = v4l2_ctrl_g_ctrl(go->mpeg_video_b_frames);
>  
>  	switch (v4l2_ctrl_g_ctrl(go->mpeg_video_aspect_ratio)) {
>  	default:
> @@ -935,7 +935,7 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
>  	struct v4l2_ctrl_handler *hdl = &go->hdl;
>  	struct v4l2_ctrl *ctrl;
>  
> -	v4l2_ctrl_handler_init(hdl, 12);
> +	v4l2_ctrl_handler_init(hdl, 13);
>  	go->mpeg_video_gop_size = v4l2_ctrl_new_std(hdl, NULL,
>  			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, 34, 1, 15);
>  	go->mpeg_video_gop_closure = v4l2_ctrl_new_std(hdl, NULL,
> @@ -943,6 +943,9 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
>  	go->mpeg_video_bitrate = v4l2_ctrl_new_std(hdl, NULL,
>  			V4L2_CID_MPEG_VIDEO_BITRATE,
>  			64000, 10000000, 1, 9800000);
> +	go->mpeg_video_b_frames = v4l2_ctrl_new_std(hdl, NULL,
> +			V4L2_CID_MPEG_VIDEO_B_FRAMES, 0, 2, 1, 0);

Set the step value to '2'. As I understand it it is either 0 or 2 and value 1
isn't supported.

> +
>  	go->mpeg_video_aspect_ratio = v4l2_ctrl_new_std_menu(hdl, NULL,
>  			V4L2_CID_MPEG_VIDEO_ASPECT,
>  			V4L2_MPEG_VIDEO_ASPECT_16x9, 0,
> 

Regards,

	Hans
