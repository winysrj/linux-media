Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([75.149.91.89]:57068 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab1FSVSP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 17:18:15 -0400
Date: Sun, 19 Jun 2011 16:13:11 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv6 PATCH 04/10] pvrusb2: fix g/s_tuner support.
In-Reply-To: <3cc586adf9fd70cb319bc3bcad1e7b20c13faab0.1308035134.git.hans.verkuil@cisco.com>
Message-ID: <alpine.DEB.1.10.1106191611050.6355@ivanova.isely.net>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl> <3cc586adf9fd70cb319bc3bcad1e7b20c13faab0.1308035134.git.hans.verkuil@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


I understand that this patch would not have been need had the pvrusb2 
driver been using videodev_ioctl2.  This is a situation that I'm going 
to (finally) remedy ASAP.  In the mean time...

Acked-By: Mike Isely <isely@pobox.com>

  -Mike


On Tue, 14 Jun 2011, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The tuner-core subdev requires that the type field of v4l2_tuner is
> filled in correctly. This is done in v4l2-ioctl.c, but pvrusb2 doesn't
> use that yet, so we have to do it manually based on whether the current
> input is radio or not.
> 
> Tested with my pvrusb2.
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
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
