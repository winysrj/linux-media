Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B15C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46FA920892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544182024;
	bh=smKJ7RiICpWeTxGKD6H1n2kD+cOa5WFmKgLG24cYVoQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=RnUrQBFQRDd0jpx23JbxfuIMqFn74Z8NFRpvEEC1uwn4dfEy30aLD1HrVpaBT4kIQ
	 HW98snCtO7zEu1suPjqq71I7tOL7hh8ZbmH4eBehx55GRjjpXg0gif04IdGjGsYEf0
	 MSUFH8hhkb25ou5aqBHjcY/tZo2zj+18AvNdI/aU=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46FA920892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbeLGL1D (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:27:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:47570 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbeLGL1D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 06:27:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FoqD8zdgq/b6nXnUKi3GsLLmZlRorjDPHzOid7e3+KU=; b=HvM1RABFx86mIyFAjmJTbFxPN7
        SwEGWpilxSHrJ3/nm8Qdm0muBQvg5gWi1wY7zBA3gfhx2liQJpQXwsbLmgtmNjIR8ALL/rDJomANg
        rX508l/FoIK9aMqTqFiE5bQnvTgocxgc1uVJHlxizus6DRzBZopJdX+mAckPS6Qjp/jtN6/krGDFp
        FURoBE5U25EqsggXoYqKqz1Jr2vhgi/7GWaZgkbpd0jheFb14oCpRPuhg95vZBBgNqrN/wO2Xr8Cr
        4U7vOEATDDHNRBbPf/K3aOS/Co0bhhU/goiMxjFQJMM80mih+PPhcg+CEh19phjA8R8x93ETGPuWw
        3Xxfjw7g==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVEHc-00068o-75; Fri, 07 Dec 2018 11:27:00 +0000
Date:   Fri, 7 Dec 2018 09:26:55 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [RFC PATCH] media/Kconfig: always enable MEDIA_CONTROLLER and
 VIDEO_V4L2_SUBDEV_API
Message-ID: <20181207092655.40e89b88@coco.lan>
In-Reply-To: <89b0af6f-1371-50d9-5c19-fac7bb6562a3@xs4all.nl>
References: <89b0af6f-1371-50d9-5c19-fac7bb6562a3@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 7 Dec 2018 10:09:04 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> This patch selects MEDIA_CONTROLLER for all camera, analog TV and
> digital TV drivers and selects VIDEO_V4L2_SUBDEV_API automatically.
> 
> This will allow us to simplify drivers that currently have to add
> #ifdef CONFIG_MEDIA_CONTROLLER or #ifdef VIDEO_V4L2_SUBDEV_API
> to their code, since now this will always be available.
> 
> The original intent of allowing these to be configured by the
> user was (I think) to save a bit of memory. 

No. The original intent was/is to be sure that adding the media
controller support won't be breaking existing working drivers.

> But as more and more
> drivers have a media controller and all regular distros already
> enable one or more of those drivers, the memory for the MC code is
> there anyway.
> 
> Complexity has always been the bane of media drivers, so reducing
> complexity at the expense of a bit more memory (which is a rounding
> error compared to the amount of video buffer memory needed) is IMHO
> a good thing.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 8add62a18293..56eb01cc8bb4 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -31,6 +31,7 @@ comment "Multimedia core support"
>  #
>  config MEDIA_CAMERA_SUPPORT
>  	bool "Cameras/video grabbers support"
> +	select MEDIA_CONTROLLER
>  	---help---
>  	  Enable support for webcams and video grabbers.
> 
> @@ -38,6 +39,7 @@ config MEDIA_CAMERA_SUPPORT
> 
>  config MEDIA_ANALOG_TV_SUPPORT
>  	bool "Analog TV support"
> +	select MEDIA_CONTROLLER
>  	---help---
>  	  Enable analog TV support.
> 
> @@ -50,6 +52,7 @@ config MEDIA_ANALOG_TV_SUPPORT
> 
>  config MEDIA_DIGITAL_TV_SUPPORT
>  	bool "Digital TV support"
> +	select MEDIA_CONTROLLER
>  	---help---
>  	  Enable digital TV support.

See my comments below.

> 
> @@ -95,7 +98,6 @@ source "drivers/media/cec/Kconfig"
> 
>  config MEDIA_CONTROLLER
>  	bool "Media Controller API"
> -	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
>  	---help---
>  	  Enable the media controller API used to query media devices internal
>  	  topology and configure it dynamically.

I have split comments with regards to it. Yeah, nowadays media controller
has becoming more important. Still, a lot of media drivers work fine
without them.

Anyway, if we're willing to make it mandatory, better to just remove the
entire config option or to make it a silent one. 

> @@ -119,16 +121,11 @@ config VIDEO_DEV
>  	tristate
>  	depends on MEDIA_SUPPORT
>  	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
> +	select VIDEO_V4L2_SUBDEV_API if MEDIA_CONTROLLER
>  	default y
> 
>  config VIDEO_V4L2_SUBDEV_API
> -	bool "V4L2 sub-device userspace API"
> -	depends on VIDEO_DEV && MEDIA_CONTROLLER
> -	---help---
> -	  Enables the V4L2 sub-device pad-level userspace API used to configure
> -	  video format, size and frame rate between hardware blocks.
> -
> -	  This API is mostly used by camera interfaces in embedded platforms.
> +	bool

NACK. 

There is a very good reason why the subdev API is optional: there
are drivers that use camera sensors but are not MC-centric. On those,
the USB bridge driver is responsible to setup the subdevice. 

This options helps to ensure that camera sensors used by such drivers
won't stop working because of the lack of the subdev-API.

> 
>  source "drivers/media/v4l2-core/Kconfig"
> 



Thanks,
Mauro
