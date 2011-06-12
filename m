Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1FLOmM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 10:42:12 -0400
Message-ID: <4DF4D040.3020706@redhat.com>
Date: Sun, 12 Jun 2011 11:42:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 5/8] tuner-core: fix tuner_resume: use t->mode instead
 of t->type.
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <ce2a9bf37e65aba48a2835bfcb4b84abe497bcb7.1307875512.git.hans.verkuil@cisco.com>
In-Reply-To: <ce2a9bf37e65aba48a2835bfcb4b84abe497bcb7.1307875512.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-06-2011 07:59, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> set_mode is called with t->type, which is the tuner type. Instead, use
> t->mode which is the actual tuner mode (i.e. radio vs tv).
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Not tested, but it seems ok.

> ---
>  drivers/media/video/tuner-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> index bf7fc33..ffe5de3 100644
> --- a/drivers/media/video/tuner-core.c
> +++ b/drivers/media/video/tuner-core.c
> @@ -1201,7 +1201,7 @@ static int tuner_resume(struct i2c_client *c)
>  	tuner_dbg("resume\n");
>  
>  	if (!t->standby)
> -		if (set_mode(t, t->type))
> +		if (set_mode(t, t->mode))
>  			set_freq(t, 0);
>  	return 0;
>  }

