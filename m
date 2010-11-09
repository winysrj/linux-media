Return-path: <mchehab@pedra>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:57803 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815Ab0KIPw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 10:52:29 -0500
Received: from mail-in-17-z2.arcor-online.net (mail-in-17-z2.arcor-online.net [151.189.8.34])
	by mx.arcor.de (Postfix) with ESMTP id DC05E99B7
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 16:52:27 +0100 (CET)
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net [151.189.21.49])
	by mail-in-17-z2.arcor-online.net (Postfix) with ESMTP id ADF453663AD
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 16:52:27 +0100 (CET)
Received: from [192.168.2.100] (dslb-188-103-163-087.pools.arcor-ip.net [188.103.163.87])
	(Authenticated sender: stefan.ringel@arcor.de)
	by mail-in-09.arcor-online.net (Postfix) with ESMTPA id 8D969197556
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 16:52:27 +0100 (CET)
Message-ID: <4CD96E3A.3090705@arcor.de>
Date: Tue, 09 Nov 2010 16:52:26 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v2.6.38] [media] tm6000: bugfix set tv standards
References: <E1PFo6P-0004Q1-Mj@www.linuxtv.org>
In-Reply-To: <E1PFo6P-0004Q1-Mj@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  Am 09.11.2010 13:20, schrieb Mauro Carvalho Chehab:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] tm6000: bugfix set tv standards
> Author:  Stefan Ringel<stefan.ringel@arcor.de>
> Date:    Wed Oct 27 16:48:05 2010 -0300
>
> bugfix set tv standards
>
> Signed-off-by: Stefan Ringel<stefan.ringel@arcor.de>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
>   drivers/staging/tm6000/tm6000-video.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=8eb5e30293e2460a37feaaa94abc7c6ede6cc29d
>
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index 9ec8279..c5690b2 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -1032,6 +1032,7 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
>   	struct tm6000_fh   *fh=priv;
>   	struct tm6000_core *dev = fh->dev;
>
> +	dev->norm = *norm;
>   	rc = tm6000_init_analog_mode(dev);
>
>   	fh->width  = dev->width;
Why not in 2.6.37-rc2 ?
