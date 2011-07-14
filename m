Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:50432 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1GNAZZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 20:25:25 -0400
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id BC4572C14C4
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 02:25:21 +0200 (CEST)
Received: from ffm.saftware.de ([127.0.0.1])
	by localhost (ffm.saftware.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 3rLWFFEeaWE6 for <linux-media@vger.kernel.org>;
	Thu, 14 Jul 2011 02:25:17 +0200 (CEST)
Message-ID: <4E1E376B.30108@linuxtv.org>
Date: Thu, 14 Jul 2011 02:25:15 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.1] [media] DVB: dvb_frontend: off by one
 in	dtv_property_dump()
References: <E1Qh7ma-00025Z-5V@www.linuxtv.org>
In-Reply-To: <E1Qh7ma-00025Z-5V@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.07.2011 23:28, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] DVB: dvb_frontend: off by one in dtv_property_dump()
> Author:  Dan Carpenter <error27@gmail.com>
> Date:    Thu May 26 05:44:52 2011 -0300
> 
> If the tvp->cmd == DTV_MAX_COMMAND then we read past the end of the
> array.

That's wrong, because the array size is DTV_MAX_COMMAND + 1. Using the
ARRAY_SIZE macro instead might reduce the confusion.

Regards,
Andreas

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/dvb/dvb-core/dvb_frontend.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=a3e4adf274f86b2363fedaa964297cb38526cef0
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index bed7bfe..c9c3c79 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -982,7 +982,7 @@ static void dtv_property_dump(struct dtv_property *tvp)
>  {
>  	int i;
>  
> -	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
> +	if (tvp->cmd <= 0 || tvp->cmd >= DTV_MAX_COMMAND) {
>  		printk(KERN_WARNING "%s: tvp.cmd = 0x%08x undefined\n",
>  			__func__, tvp->cmd);
>  		return;
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits

