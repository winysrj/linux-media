Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab1FLOnw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 10:43:52 -0400
Message-ID: <4DF4D0A1.8050209@redhat.com>
Date: Sun, 12 Jun 2011 11:43:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 7/8] pvrusb2: fix g/s_tuner support.
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <a30d7d5847d05ad2e9f2e03b2368d1910d2c19bf.1307875512.git.hans.verkuil@cisco.com>
In-Reply-To: <a30d7d5847d05ad2e9f2e03b2368d1910d2c19bf.1307875512.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-06-2011 07:59, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The tuner-core subdev requires that the type field of v4l2_tuner is
> filled in correctly. This is done in v4l2-ioctl.c, but pvrusb2 doesn't
> use that yet, so we have to do it manually based on whether the current
> input is radio or not.
> 
> Tested with my pvrusb2.

OK.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/pvrusb2/pvrusb2-hdw.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> index 9d0dd08..e98d382 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> @@ -3046,6 +3046,8 @@ static void pvr2_subdev_update(struct pvr2_hdw *hdw)
>  	if (hdw->input_dirty || hdw->audiomode_dirty || hdw->force_dirty) {
>  		struct v4l2_tuner vt;
>  		memset(&vt, 0, sizeof(vt));
> +		vt.type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
> +			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>  		vt.audmode = hdw->audiomode_val;
>  		v4l2_device_call_all(&hdw->v4l2_dev, 0, tuner, s_tuner, &vt);
>  	}
> @@ -5171,6 +5173,8 @@ void pvr2_hdw_status_poll(struct pvr2_hdw *hdw)
>  {
>  	struct v4l2_tuner *vtp = &hdw->tuner_signal_info;
>  	memset(vtp, 0, sizeof(*vtp));
> +	vtp->type = (hdw->input_val == PVR2_CVAL_INPUT_RADIO) ?
> +		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>  	hdw->tuner_signal_stale = 0;
>  	/* Note: There apparently is no replacement for VIDIOC_CROPCAP
>  	   using v4l2-subdev - therefore we can't support that AT ALL right

