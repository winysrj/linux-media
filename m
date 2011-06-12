Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab1FLOn3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 10:43:29 -0400
Message-ID: <4DF4D08C.8050801@redhat.com>
Date: Sun, 12 Jun 2011 11:43:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 8/8] bttv: fix s_tuner for radio.
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <cd5f6808084d0b1c2aba3e690c35cf3e7abfa445.1307875512.git.hans.verkuil@cisco.com>
In-Reply-To: <cd5f6808084d0b1c2aba3e690c35cf3e7abfa445.1307875512.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-06-2011 07:59, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Fix typo: g_tuner should have been s_tuner.
> 
> Tested with a bttv card.

OK.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index a97cf27..834a483 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -3474,7 +3474,7 @@ static int radio_s_tuner(struct file *file, void *priv,
>  	if (0 != t->index)
>  		return -EINVAL;
>  
> -	bttv_call_all(btv, tuner, g_tuner, t);
> +	bttv_call_all(btv, tuner, s_tuner, t);
>  	return 0;
>  }
>  

