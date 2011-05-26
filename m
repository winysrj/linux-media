Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab1EZANz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 20:13:55 -0400
Message-ID: <4DDD9B34.9080103@redhat.com>
Date: Wed, 25 May 2011 21:13:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Define parameter description after the parameter itself.
References: <201105231327.11791.hselasky@c2i.net>
In-Reply-To: <201105231327.11791.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 08:27, Hans Petter Selasky escreveu:
> --HPS
> 
> 
> dvb-usb-0008.patch
> 
> 
> From 2f5378e5c5cc5528473f77321879fb075005d3dd Mon Sep 17 00:00:00 2001
> From: Hans Petter Selasky <hselasky@c2i.net>
> Date: Mon, 23 May 2011 13:26:04 +0200
> Subject: [PATCH] Define parameter description after the parameter itself.
> 
> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> ---
>  drivers/media/video/tda7432.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/tda7432.c b/drivers/media/video/tda7432.c
> index 3941f95..398b9fb 100644
> --- a/drivers/media/video/tda7432.c
> +++ b/drivers/media/video/tda7432.c
> @@ -50,8 +50,8 @@ static int loudness; /* disable loudness by default */
>  static int debug;	 /* insmod parameter */
>  module_param(debug, int, S_IRUGO | S_IWUSR);
>  module_param(loudness, int, S_IRUGO);
> -MODULE_PARM_DESC(maxvol,"Set maximium volume to +20db (0), default is 0db(1)");
>  module_param(maxvol, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(maxvol,"Set maximium volume to +20db (0), default is 0db(1)");

Ok, but this doesn't change the fact that debug and loudness aren't commented.
Could you please also add descriptions for those parameters where no descriptions
were provided? 

Thanks!
Mauro.
