Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5754C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70474208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544190804;
	bh=4ny9OPatTdm3uqwiAQq+YuikAdzbQUe5Dg1Z3OCwfFs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=pFeq86nI4Hz2JGu3fYbd7T3vEldqDmX2AcfFZVUQMIRRgnwVFryuXLiXFNz6H75R9
	 yms5YEpYuKGo1qufCPOaMB6UrAvfDPObAY+8zslAzoD7iVoZgglFOoOBlzS5QNNuzw
	 GgKnuIWCWbk137oVqmcjp0yJLpwkiTsE0wEDNDLk=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70474208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbeLGNxY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:53:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:59164 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbeLGNxX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:53:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gtqQFW/auSwjd84yg1o+Nis9KeqH+eiKUXtf8JmkraQ=; b=D5o+lZ2N8MIMCcmrBOrEyBxW9N
        vi6zkv6EZS021nbbtv2gYPrzCFye+hdin2b24TyJXQEKr7ZL63OreytNNvQ4y2llKOdErggoGz3VN
        YBxFI/kF84MFyuFR4u8Rq290N0pVap+MHzp/ybm2V7N6mnFBVpeUeTVSf0d2VKdGeucG6MDSKH9YM
        dGNO8QVHMXyArF0JQG9k4lNv9kQunHG3xzSLCgrhU8vN1X5TzuktRA5xRV0LPyyekYnpImG3wisls
        pwZCeei2yB05CE1oXnunbTLhVC1oc5DjNOmJCv1NwMS/8XyZ0/CLGz8PKKkatokxXNXDwiAZpCuWH
        /uHRGMZw==;
Received: from [179.95.33.236] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVGZF-0002uC-CK; Fri, 07 Dec 2018 13:53:21 +0000
Date:   Fri, 7 Dec 2018 11:53:17 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [RFC PATCH] media/Kconfig: always enable MEDIA_CONTROLLER and
 VIDEO_V4L2_SUBDEV_API
Message-ID: <20181207115317.7a6d5feb@coco.lan>
In-Reply-To: <7b97e818-278f-0abd-0ee9-b2b7ec12f857@xs4all.nl>
References: <89b0af6f-1371-50d9-5c19-fac7bb6562a3@xs4all.nl>
        <20181207092655.40e89b88@coco.lan>
        <0c25b853-048d-65c3-31fd-9adf9a4a9b9e@xs4all.nl>
        <20181207104207.7db97930@coco.lan>
        <7b97e818-278f-0abd-0ee9-b2b7ec12f857@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 7 Dec 2018 14:27:48 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 12/07/2018 01:42 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 7 Dec 2018 12:47:24 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> On 12/07/2018 12:26 PM, Mauro Carvalho Chehab wrote:  
> >>> Em Fri, 7 Dec 2018 10:09:04 +0100
> >>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>     
> >>>> This patch selects MEDIA_CONTROLLER for all camera, analog TV and
> >>>> digital TV drivers and selects VIDEO_V4L2_SUBDEV_API automatically.
> >>>>
> >>>> This will allow us to simplify drivers that currently have to add
> >>>> #ifdef CONFIG_MEDIA_CONTROLLER or #ifdef VIDEO_V4L2_SUBDEV_API
> >>>> to their code, since now this will always be available.
> >>>>
> >>>> The original intent of allowing these to be configured by the
> >>>> user was (I think) to save a bit of memory.     
> >>>
> >>> No. The original intent was/is to be sure that adding the media
> >>> controller support won't be breaking existing working drivers.    
> >>
> >> That doesn't make sense. If enabling this option would break existing
> >> drivers, then something is really wrong, isn't it?  
> > 
> > It is the opposite: disabling it should not break any driver that don't
> > depend on them to work.
> >   
> >>  
> >>>     
> >>>> But as more and more
> >>>> drivers have a media controller and all regular distros already
> >>>> enable one or more of those drivers, the memory for the MC code is
> >>>> there anyway.
> >>>>
> >>>> Complexity has always been the bane of media drivers, so reducing
> >>>> complexity at the expense of a bit more memory (which is a rounding
> >>>> error compared to the amount of video buffer memory needed) is IMHO
> >>>> a good thing.
> >>>>
> >>>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >>>> ---
> >>>> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> >>>> index 8add62a18293..56eb01cc8bb4 100644
> >>>> --- a/drivers/media/Kconfig
> >>>> +++ b/drivers/media/Kconfig
> >>>> @@ -31,6 +31,7 @@ comment "Multimedia core support"
> >>>>  #
> >>>>  config MEDIA_CAMERA_SUPPORT
> >>>>  	bool "Cameras/video grabbers support"
> >>>> +	select MEDIA_CONTROLLER
> >>>>  	---help---
> >>>>  	  Enable support for webcams and video grabbers.
> >>>>
> >>>> @@ -38,6 +39,7 @@ config MEDIA_CAMERA_SUPPORT
> >>>>
> >>>>  config MEDIA_ANALOG_TV_SUPPORT
> >>>>  	bool "Analog TV support"
> >>>> +	select MEDIA_CONTROLLER
> >>>>  	---help---
> >>>>  	  Enable analog TV support.
> >>>>
> >>>> @@ -50,6 +52,7 @@ config MEDIA_ANALOG_TV_SUPPORT
> >>>>
> >>>>  config MEDIA_DIGITAL_TV_SUPPORT
> >>>>  	bool "Digital TV support"
> >>>> +	select MEDIA_CONTROLLER
> >>>>  	---help---
> >>>>  	  Enable digital TV support.    
> >>>
> >>> See my comments below.
> >>>     
> >>>>
> >>>> @@ -95,7 +98,6 @@ source "drivers/media/cec/Kconfig"
> >>>>
> >>>>  config MEDIA_CONTROLLER
> >>>>  	bool "Media Controller API"
> >>>> -	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
> >>>>  	---help---
> >>>>  	  Enable the media controller API used to query media devices internal
> >>>>  	  topology and configure it dynamically.    
> >>>
> >>> I have split comments with regards to it. Yeah, nowadays media controller
> >>> has becoming more important. Still, a lot of media drivers work fine
> >>> without them.
> >>>
> >>> Anyway, if we're willing to make it mandatory, better to just remove the
> >>> entire config option or to make it a silent one.     
> >>
> >> Well, that assumes that the media controller will only be used by media
> >> drivers, and not alsa or anyone else who wants to experiment with the MC.
> >>
> >> I won't object to making it silent (since it does reflect the current
> >> situation), but since this functionality is not actually specific to media
> >> drivers I think that is a good case to be made to allow it to be selected
> >> manually.
> >>  
> >>>     
> >>>> @@ -119,16 +121,11 @@ config VIDEO_DEV
> >>>>  	tristate
> >>>>  	depends on MEDIA_SUPPORT
> >>>>  	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
> >>>> +	select VIDEO_V4L2_SUBDEV_API if MEDIA_CONTROLLER
> >>>>  	default y
> >>>>
> >>>>  config VIDEO_V4L2_SUBDEV_API
> >>>> -	bool "V4L2 sub-device userspace API"
> >>>> -	depends on VIDEO_DEV && MEDIA_CONTROLLER
> >>>> -	---help---
> >>>> -	  Enables the V4L2 sub-device pad-level userspace API used to configure
> >>>> -	  video format, size and frame rate between hardware blocks.
> >>>> -
> >>>> -	  This API is mostly used by camera interfaces in embedded platforms.
> >>>> +	bool    
> >>>
> >>> NACK. 
> >>>
> >>> There is a very good reason why the subdev API is optional: there
> >>> are drivers that use camera sensors but are not MC-centric. On those,
> >>> the USB bridge driver is responsible to setup the subdevice. 
> >>>
> >>> This options helps to ensure that camera sensors used by such drivers
> >>> won't stop working because of the lack of the subdev-API.    
> >>
> >> But they won't stop working if this is enabled.  
> > 
> > That's not the issue. I've seen (and nacked) several patches breaking
> > drivers by assuming that all init would happen via subdev API.
> > 
> > By having this as an optional feature that can be disabled, developers
> > need to ensure that either the driver won't be built as a hole, if
> > no subdev API suport is enabled, or need to add the needed logic inside
> > the sub-device in order to support both cases.
> >   
> >> This option is used as
> >> a dependency by drivers that require this functionality, but enabling
> >> it will never break other drivers that don't need this. Those drivers
> >> simply won't use it.  
> > 
> > Not a 100% sure about that. There are some parts of the logic that seems
> > to assume that the device has subdev API and MC initialized.
> > 
> > See, for example:
> > 
> > 	static inline struct v4l2_mbus_framefmt
> > 	*v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
> > 				    struct v4l2_subdev_pad_config *cfg,
> > 				    unsigned int pad)
> > 	{
> > 		if (WARN_ON(pad >= sd->entity.num_pads))
> > 			pad = 0;
> > 		return &cfg[pad].try_fmt;
> > 	}
> > 
> > If the USB bridge driver doesn't use the media controller, the above
> > code will OOPS. See, for example, ov2659_get_fmt() logic.  
> 
> So if I have that USB bridge driver, and I also enable the V4L2_SUBDEV_API
> for another driver, then the USB bridge driver would crash?!
> 
> If that's the case, then this is really, really broken.

Yes.

> I always enable
> this option whenever I build the media drivers, and I have never seen
> anything break because of this. And if a driver would break then that
> is an enormous bug in that driver or the subdev driver.

Last time I checked, PC distros usually disable it. Not sure how many
devices are out there that use it. I carefully review the patches for the
devices I have myself and that I know it would be affected by this
issue.

> Please note that bridge drivers that do not rely on this config option
> will never call these subdev ops with V4L2_SUBDEV_FORMAT_TRY.
> 
> So it will also never crash on this.

Yes, USB bridges typically handles it on another way. That could be
a reason why we never received a bug report (the other reason is
because PC distros may not be enabling subdev API).

> Basically what you want is a way to check that bridge drivers that do
> not support the media controller or the subdev API (i.e. V4L2_SUBDEV_FORMAT_TRY)
> do not attempt to use features that rely on subdevs supporting it.

Yes. I also want sensor drivers to either be written considering that
they can be called by bridges that don't export subdev API or to
be explicitly tagged as dependent of V4L2_SUBDEV_API.

This way, if someone ever need to use those on a bridge driver
that doesn't export the subdev API, he will also be aware that
the sensor driver will require changes in order to work.

> I'm not sure that's possible, but let me think about it.
> 
> Regards,
> 
> 	Hans
> 
> > 
> > Ok, this particular driver (AFAIKT) is only used on platform drivers,
> > but if the same sensor would be used by another driver that don't
> > expose subdev API, VIDIOC_GET_FMT won't work. Also, if
> > CONFIG_VIDEO_V4L2_SUBDEV_API is disabled, the ioctl will just return
> > an error, but if it is enabled, it will OOPS.
> >   
> >> Also note that it is the bridge driver that controls whether or not
> >> the v4l-subdevX devices are created. If the bridge driver doesn't
> >> explicitly enable it AND the subdev driver explicitly supports it,
> >> those devices will not be created.  
> > 
> > The problem is not related to subdev creation. It is related to
> > having support for being fully set without using the subdev API
> > (or DT).
> > 
> > I'm not saying that it is not doable to solve this issue, but, right
> > now, some parts at the V4L2 core assumes that subdev API is
> > used if CONFIG_VIDEO_V4L2_SUBDEV_API is enabled.
> > 
> > See, for example, the drivers/media/i2c/mt9v011.c driver, with is 
> > used by a USB bridge driver that doesn't expose subdev API.
> > 
> > On this driver, even the probe logic had to be different, as it has 
> > to explicitly support platform data, as otherwise the sensor won't be
> > properly initialized, and it won't work.
> > 
> > Frankly, I don't see an easy way to make a sensor driver that would
> > be fully independent, as we would need to move all DT-specific
> > stuff to be handled outside the sensors and have a common way for
> > the V4L2 core to handle it, either as platform data or as DT,
> > and calling subdev-specific logic to handle it depending on the
> > case.
> > 
> > While we don't have the V4L2 fully abstracting the logic
> > if a device has subdev API or not, we can't get rid of
> > VIDEO_V4L2_SUBDEV_API.
> > 
> > 
> > Thanks,
> > Mauro
> >   
> 



Thanks,
Mauro
