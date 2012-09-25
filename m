Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab2IYNdn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 09:33:43 -0400
Date: Tue, 25 Sep 2012 10:33:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFCv1 API PATCH 4/4] tuner-core: map audmode to STEREO for
 radio devices.
Message-ID: <20120925103340.76a5db3c@redhat.com>
In-Reply-To: <97c2130954d0c14e16e0e7b08b29405e48a9687e.1347620872.git.hans.verkuil@cisco.com>
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
	<97c2130954d0c14e16e0e7b08b29405e48a9687e.1347620872.git.hans.verkuil@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Sep 2012 13:15:36 +0200
Hans Verkuil <hans.verkuil@cisco.com> escreveu:

> Fixes a v4l2-compliance error: setting audmode to a value other than mono
> or stereo for a radio device should map to MODE_STEREO.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/tuner-core.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> index b5a819a..ea71371 100644
> --- a/drivers/media/v4l2-core/tuner-core.c
> +++ b/drivers/media/v4l2-core/tuner-core.c
> @@ -1235,8 +1235,11 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  	if (set_mode(t, vt->type))
>  		return 0;
>  
> -	if (t->mode == V4L2_TUNER_RADIO)
> +	if (t->mode == V4L2_TUNER_RADIO) {
>  		t->audmode = vt->audmode;
> +		if (t->audmode > V4L2_TUNER_MODE_STEREO)
> +			t->audmode = V4L2_TUNER_MODE_STEREO;

NACK. It is not a core's task to fix driver's bugs. It would be ok to have here a
WARN_ON(), but, if a driver is reporting a wrong radio audmode, the fix should be
there at the drivers, and not here at the core.

> +	}
>  	set_freq(t, 0);
>  
>  	return 0;


-- 
Regards,
Mauro
