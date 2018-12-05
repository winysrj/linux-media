Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66C3C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB14208E7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 19:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544039235;
	bh=UqkXWPHNv1XvQMJ8OUYkWy/qMqN0OR0w+e9LSuV4k4s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=U2I1xHW4CxBvactRu8407jY1lYhiRqT6tknv1dyNvm+vEvVjyKK2nESxaa7Pbav6g
	 Cc9yLlVzaAl35mfEFPQW0wMRYTF/dmbX70JhG7DIPyUmHP1M+IPMyAFCdBn8XRF8pP
	 jJ5Dfj03cohsifj9OsJ1jaFYW4t1w/0MQeOUfbHI=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DB14208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbeLETrJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:47:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:44652 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728511AbeLETrJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 14:47:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4BkC2rXPatfvxAjvZnTuHGoLT9CgV6T7MD6lkCq2Xg0=; b=pi7lUND1PQmfeHgyf2e7oynP2w
        MuNXHltDCxYEmigX38EIwBmKfEon2Oqa2lqiXMhjPJ8O73Hye+zSni7IRRb1xf4sOAIVnri7f7Acn
        tx2WVsHTQGXGRZ0bVCqrDm9pgYR0KZYkkj7oJP2c8/MktkfinuCAfpY1YM3/on6cDAcSjDtrB9T3b
        ds4cmsqgDV8R/H0YSTkq/2VOf4wxBrKRqMvWRRAt+vQJ/t/0j6DsfQdZciiG2hC4vy/b0cHt8Fcl2
        x/807KnxLlsCq5NcVCtdz1yRzWXOnJd2ygjNV4ET4YD2D7JIejyaqZ6n3OJKesAiPjhXgF2nYPh/g
        QOrrWjbA==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUd8V-0006Xd-Fq; Wed, 05 Dec 2018 19:47:08 +0000
Date:   Wed, 5 Dec 2018 17:47:03 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Priit Laes <plaes@plaes.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: Kconfig: Add configuration entry for
 MEDIA_MEM2MEM_SUPPORT
Message-ID: <20181205174703.5d2a8529@coco.lan>
In-Reply-To: <20181126163844.18729-1-plaes@plaes.org>
References: <20181126163844.18729-1-plaes@plaes.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon, 26 Nov 2018 18:38:44 +0200
Priit Laes <plaes@plaes.org> escreveu:

> Currently there is no easy way to enable mem2mem based video
> processor drivers (cedrus for example). Simplify this by adding
> separate category to media support.
> 
> Signed-off-by: Priit Laes <plaes@plaes.org>
> ---
>  drivers/media/Kconfig | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 8add62a18293..f2a773896dcf 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -56,6 +56,14 @@ config MEDIA_DIGITAL_TV_SUPPORT
>  	  Say Y when you have a board with digital support or a board with
>  	  hybrid digital TV and analog TV.
>  
> +config MEDIA_MEM2MEM_SUPPORT
> +    bool "Mem2mem devices (stateless media decoders/encoders support)"
> +    ---help---
> +	  Enable support for mem2mem / stateless media decoders/encoders.
> +
> +	  Say Y when you have a system with stateless media encoder/decoder
> +	  support.
> +
>  config MEDIA_RADIO_SUPPORT
>  	bool "AM/FM radio receivers/transmitters support"
>  	---help---
> @@ -95,7 +103,7 @@ source "drivers/media/cec/Kconfig"
>  
>  config MEDIA_CONTROLLER
>  	bool "Media Controller API"
> -	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
> +	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_MEM2MEM_SUPPORT
>  	---help---
>  	  Enable the media controller API used to query media devices internal
>  	  topology and configure it dynamically.
> @@ -118,7 +126,7 @@ config MEDIA_CONTROLLER_DVB
>  config VIDEO_DEV
>  	tristate
>  	depends on MEDIA_SUPPORT
> -	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
> +	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT || MEDIA_MEM2MEM_SUPPORT
>  	default y
>  
>  config VIDEO_V4L2_SUBDEV_API

Hmm... this patch looks incomplete. I mean, the main goal of those
MEDIA_*_SUPPORT is to make simpler for the users to select a
subset of the drivers. Those options actually make visible
the corresponding entries for pci/usb/... drivers. So,
for example, drivers/media/usb/Kconfig contains:

	if MEDIA_CAMERA_SUPPORT
		comment "Webcam devices"
	source "drivers/media/usb/uvc/Kconfig"
	source "drivers/media/usb/gspca/Kconfig"
	source "drivers/media/usb/pwc/Kconfig"
	source "drivers/media/usb/cpia2/Kconfig"
	source "drivers/media/usb/zr364xx/Kconfig"
	source "drivers/media/usb/stkwebcam/Kconfig"
	source "drivers/media/usb/s2255/Kconfig"
	source "drivers/media/usb/usbtv/Kconfig"
	endif

If we'll be adding it, I would expect a corresponding change at
drivers/media/platform/Kconfig.

Thanks,
Mauro
