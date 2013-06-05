Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49409 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753756Ab3FEX5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Jun 2013 19:57:41 -0400
Date: Thu, 6 Jun 2013 02:57:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Roberto =?iso-8859-1?Q?Alc=E2ntara?= <roberto@eletronica.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] smscoreapi: memory leak fix
Message-ID: <20130605235707.GB2675@valkosipuli.retiisi.org.uk>
References: <CAEt6MX=6BHTufFgNpo1cRRxGGkzaLYDZQtkuX4WWxHT7arkZ0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEt6MX=6BHTufFgNpo1cRRxGGkzaLYDZQtkuX4WWxHT7arkZ0w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Roberto,

Thanks for the patch.

On Tue, May 21, 2013 at 05:32:30PM -0300, Roberto Alcântara wrote:
> Ensure release_firmware is called if kmalloc fails.
> 
> Signed-off-by:Roberto Alcantara <roberto@eletronica.org>
> diff --git a/linux/drivers/media/common/siano/smscoreapi.c
> b/linux/drivers/media/common/siano/smscoreapi.c
> index dbe9b4d..f65b4e3 100644
> --- a/linux/drivers/media/common/siano/smscoreapi.c
> +++ b/linux/drivers/media/common/siano/smscoreapi.c
> @@ -1173,16 +1173,16 @@ static int
> smscore_load_firmware_from_file(struct smscore_device_t *coredev,
>               GFP_KERNEL | GFP_DMA);
>      if (!fw_buf) {
>          sms_err("failed to allocate firmware buffer");
> -        return -ENOMEM;

How about instead adding a label before release_firmware() for error
handling? I think that'd be cleaner than this.

Could you also use git send-email to send the patch, please?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
