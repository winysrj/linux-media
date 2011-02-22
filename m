Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:34841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1BVMMf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 07:12:35 -0500
Message-ID: <4D63A830.20805@redhat.com>
Date: Tue, 22 Feb 2011 09:12:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some fixes for tuner, tvp5150 and em28xx
References: <20110221231741.71a2149e@pedra> <4D6324DB.5030801@redhat.com> <201102220853.59343.hverkuil@xs4all.nl>
In-Reply-To: <201102220853.59343.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-02-2011 04:53, Hans Verkuil escreveu:
> Actually, v4l2-ctrl and qv4l2 handle 'holes' correctly. I think this is a
> different bug relating to the handling of V4L2_CTRL_FLAG_NEXT_CTRL. Can you
> try this patch:
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index ef66d2a..15eda86 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -1364,6 +1364,8 @@ EXPORT_SYMBOL(v4l2_queryctrl);
>  
>  int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
>  {
> +	if (qc->id & V4L2_CTRL_FLAG_NEXT_CTRL)
> +		return -EINVAL;
>  	return v4l2_queryctrl(sd->ctrl_handler, qc);

Ok, this fixed the issue:
                     brightness (int)  : min=0 max=255 step=1 default=128 value=128
                       contrast (int)  : min=0 max=255 step=1 default=128 value=128
                     saturation (int)  : min=0 max=255 step=1 default=128 value=128
                            hue (int)  : min=-128 max=127 step=1 default=0 value=0
                         volume (int)  : min=0 max=65535 step=655 default=58880 value=65500 flags=slider
                        balance (int)  : min=0 max=65535 step=655 default=32768 value=32750 flags=slider
                           bass (int)  : min=0 max=65535 step=655 default=32768 value=32750 flags=slider
                         treble (int)  : min=0 max=65535 step=655 default=32768 value=32750 flags=slider
                           mute (bool) : default=0 value=0
                       loudness (bool) : default=0 value=0

Also, v4l2-compliance is now complaining less about it.

Control ioctls:
		fail: does not support V4L2_CTRL_FLAG_NEXT_CTRL
	test VIDIOC_QUERYCTRL/MENU: FAIL
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: Not Supported
	Standard Controls: 0 Private Controls: 0

(yet, it is showing "standard controls = 0").

Could you provide your SOB to the above patch?

Thanks!
Mauro
