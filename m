Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZENMK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 08:10:57 -0400
Date: Thu, 14 May 2009 09:10:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0905_03] Siano: smsusb - remove old backward support
Message-ID: <20090514091053.3eca9080@pedra.chehab.org>
In-Reply-To: <23363.7021.qm@web110802.mail.gq1.yahoo.com>
References: <23363.7021.qm@web110802.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 May 2009 07:17:09 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> escreveu:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1242136071 -10800
> # Node ID 126c0974c2db4e2777e5d9b068fa976fe3a59675
> # Parent  697459f4baf6e95a906b852250699a18d1016724
> [0905_03] Siano: smsusb - remove old backward support
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> Remove backward support for kernel versions
> older than 2.6.19.
> 
> Priority: normal
> 
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> 
> diff -r 697459f4baf6 -r 126c0974c2db linux/drivers/media/dvb/siano/smsusb.c
> --- a/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 16:42:33 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 16:47:51 2009 +0300
> @@ -60,11 +60,7 @@ static int smsusb_submit_urb(struct smsu
>  static int smsusb_submit_urb(struct smsusb_device_t *dev,
>  			     struct smsusb_urb_t *surb);
>  
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
>  static void smsusb_onresponse(struct urb *urb)
> -#else
> -static void smsusb_onresponse(struct urb *urb, struct pt_regs *regs)
> -#endif
>  {
>  	struct smsusb_urb_t *surb = (struct smsusb_urb_t *) urb->context;
>  	struct smsusb_device_t *dev = surb->dev;

Why to remove this backport? Also, if you touch on supported versions, you'll
need to touch also on v4l.versions.txt




Cheers,
Mauro
