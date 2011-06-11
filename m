Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600Ab1FKNzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:55:03 -0400
Message-ID: <4DF373B3.4000601@redhat.com>
Date: Sat, 11 Jun 2011 10:54:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner
 mode.
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <2a85334a8d3f0861fc10f2d6adbf46946d12bb0e.1307798213.git.hans.verkuil@cisco.com>
In-Reply-To: <2a85334a8d3f0861fc10f2d6adbf46946d12bb0e.1307798213.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-06-2011 10:34, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> According to the spec the tuner type field is not used when calling
> S_TUNER: index, audmode and reserved are the only writable fields.
> 
> So remove the type check. Instead, just set the audmode if the current
> tuner mode is set to radio.

I suspect that this patch also breaks support for a separate radio tuner.
if tuner-type is not properly filled, then the easiest fix would be to
revert some changes done at the tuner cleanup/fixup patches applied on .39.
Yet, the previous logic were trying to hint the device mode, with is bad
(that's why it was changed).

The proper change seems to add a parameter to this callback, set by the
bridge driver, informing if the device is using radio or video mode.
We need also to patch the V4L API specs, as it allows using a video node
for radio, and vice versa. This is not well supported, and it seems silly
to keep it at the specs and needing to add hints at the drivers due to
that.

Cheers,
Mauro

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/tuner-core.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> index 7280998..0ffcf54 100644
> --- a/drivers/media/video/tuner-core.c
> +++ b/drivers/media/video/tuner-core.c
> @@ -1156,12 +1156,10 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  {
>  	struct tuner *t = to_tuner(sd);
>  
> -	if (!set_mode(t, vt->type))
> -		return 0;
> -
> -	if (t->mode == V4L2_TUNER_RADIO)
> +	if (t->mode == V4L2_TUNER_RADIO) {
>  		t->audmode = vt->audmode;
> -	set_freq(t, 0);
> +		set_freq(t, 0);
> +	}
>  
>  	return 0;
>  }

