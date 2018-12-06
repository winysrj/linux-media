Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BB9C07E85
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 02:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC866208E7
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 02:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="OJO043c0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC866208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbeLFCPm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 21:15:42 -0500
Received: from plaes.org ([188.166.43.21]:35368 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727712AbeLFCPl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 21:15:41 -0500
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id D9C8440588;
        Thu,  6 Dec 2018 02:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1544062538; bh=9714Czk1Qqpg4HbknhpRUPDNUe7v/H2WZQf5+YJ+ii0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OJO043c0GChxb041Ey3YiZJsCNW5H+GcpSiM+QW9AsBnLNTzD3mcKbO/AKxR4wxKE
         iS0weBKIyhd1TPpcvFaxRsOHRnukfjadV6y0MRHq8n3+hM3BTYj7ptho4ZGeMP9x27
         hPu0o1Ap8kM5KwmZPF1vcFNunp+EMoUWS8WgIx9TUVpDItrl58glEwzdOBtgzHnW+q
         NKHIn2a74ELU2KxFA6HN06Nbr521SyTGEThyK5kbp1HiS9j7e5+RmI9U+lVT6bIckw
         GFh/tJQ5/V71SYFAElHt3/zqzykaXjcohMQuRLLxW8V9lUEfLjpRnVUrcES/dEXObG
         qtyMayG0B50/w==
Date:   Thu, 6 Dec 2018 02:15:37 +0000
From:   Priit Laes <plaes@plaes.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: Kconfig: Add configuration entry for
 MEDIA_MEM2MEM_SUPPORT
Message-ID: <20181206021537.24jz4x4bpn5xojwg@plaes.org>
References: <20181126163844.18729-1-plaes@plaes.org>
 <20181205174703.5d2a8529@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205174703.5d2a8529@coco.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 05, 2018 at 05:47:03PM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 26 Nov 2018 18:38:44 +0200
> Priit Laes <plaes@plaes.org> escreveu:
> 
> > Currently there is no easy way to enable mem2mem based video
> > processor drivers (cedrus for example). Simplify this by adding
> > separate category to media support.
> > 
> > Signed-off-by: Priit Laes <plaes@plaes.org>
> > ---
> >  drivers/media/Kconfig | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> > index 8add62a18293..f2a773896dcf 100644
> > --- a/drivers/media/Kconfig
> > +++ b/drivers/media/Kconfig
> > @@ -56,6 +56,14 @@ config MEDIA_DIGITAL_TV_SUPPORT
> >  	  Say Y when you have a board with digital support or a board with
> >  	  hybrid digital TV and analog TV.
> >  
> > +config MEDIA_MEM2MEM_SUPPORT
> > +    bool "Mem2mem devices (stateless media decoders/encoders support)"
> > +    ---help---
> > +	  Enable support for mem2mem / stateless media decoders/encoders.
> > +
> > +	  Say Y when you have a system with stateless media encoder/decoder
> > +	  support.
> > +
> >  config MEDIA_RADIO_SUPPORT
> >  	bool "AM/FM radio receivers/transmitters support"
> >  	---help---
> > @@ -95,7 +103,7 @@ source "drivers/media/cec/Kconfig"
> >  
> >  config MEDIA_CONTROLLER
> >  	bool "Media Controller API"
> > -	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
> > +	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_MEM2MEM_SUPPORT
> >  	---help---
> >  	  Enable the media controller API used to query media devices internal
> >  	  topology and configure it dynamically.
> > @@ -118,7 +126,7 @@ config MEDIA_CONTROLLER_DVB
> >  config VIDEO_DEV
> >  	tristate
> >  	depends on MEDIA_SUPPORT
> > -	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
> > +	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT || MEDIA_MEM2MEM_SUPPORT
> >  	default y
> >  
> >  config VIDEO_V4L2_SUBDEV_API
> 
> Hmm... this patch looks incomplete. I mean, the main goal of those
> MEDIA_*_SUPPORT is to make simpler for the users to select a
> subset of the drivers. Those options actually make visible
> the corresponding entries for pci/usb/... drivers. So,
> for example, drivers/media/usb/Kconfig contains:
> 
> 	if MEDIA_CAMERA_SUPPORT
> 		comment "Webcam devices"
> 	source "drivers/media/usb/uvc/Kconfig"
> 	source "drivers/media/usb/gspca/Kconfig"
> 	source "drivers/media/usb/pwc/Kconfig"
> 	source "drivers/media/usb/cpia2/Kconfig"
> 	source "drivers/media/usb/zr364xx/Kconfig"
> 	source "drivers/media/usb/stkwebcam/Kconfig"
> 	source "drivers/media/usb/s2255/Kconfig"
> 	source "drivers/media/usb/usbtv/Kconfig"
> 	endif
> 
> If we'll be adding it, I would expect a corresponding change at
> drivers/media/platform/Kconfig.

Thanks, I will look into it. The current approach at least made it
somewhat easier to enable sunxi-cedrus via menuconfig.
> 
> Thanks,
> Mauro
