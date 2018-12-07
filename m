Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE21C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 978ED20882
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 978ED20882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbeLGJJJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 04:09:09 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41112 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbeLGJJJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 04:09:09 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VC88g53nkgJOKVC8BgXxHh; Fri, 07 Dec 2018 10:09:08 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] media/Kconfig: always enable MEDIA_CONTROLLER and
 VIDEO_V4L2_SUBDEV_API
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Message-ID: <89b0af6f-1371-50d9-5c19-fac7bb6562a3@xs4all.nl>
Date:   Fri, 7 Dec 2018 10:09:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHwdh5JO3qpj2QhyY10LOhhslDx8wNbK5b23/wngbRGbupxmCjwnwEqtSlIKr/nYyUmURuw38lbqHRWADiNIgQnTxJftJ5cT3M7JYTFh4DWNzowtLvMQ
 cjTXNsNizv4PQaiO2jku/555REMUmdwNtgJaN/9KQYLDJEWT2Vw/3oeslCgubSD6wR2zMVxvphAIkbDXCx4htfF0+C8h6YksCYpi8dk87mVrl1qb1H/L0Uuh
 TtdVf/RSyvsEDM2x9SvSF9TNSO1yQpsypQSPtqdoHwz0c6ikwI9i5+P4MXcv0Vz9t6HMFZbgu5c7pbatMGctSaIngBzP7/t8zPPcI7v/2bg=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch selects MEDIA_CONTROLLER for all camera, analog TV and
digital TV drivers and selects VIDEO_V4L2_SUBDEV_API automatically.

This will allow us to simplify drivers that currently have to add
#ifdef CONFIG_MEDIA_CONTROLLER or #ifdef VIDEO_V4L2_SUBDEV_API
to their code, since now this will always be available.

The original intent of allowing these to be configured by the
user was (I think) to save a bit of memory. But as more and more
drivers have a media controller and all regular distros already
enable one or more of those drivers, the memory for the MC code is
there anyway.

Complexity has always been the bane of media drivers, so reducing
complexity at the expense of a bit more memory (which is a rounding
error compared to the amount of video buffer memory needed) is IMHO
a good thing.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 8add62a18293..56eb01cc8bb4 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -31,6 +31,7 @@ comment "Multimedia core support"
 #
 config MEDIA_CAMERA_SUPPORT
 	bool "Cameras/video grabbers support"
+	select MEDIA_CONTROLLER
 	---help---
 	  Enable support for webcams and video grabbers.

@@ -38,6 +39,7 @@ config MEDIA_CAMERA_SUPPORT

 config MEDIA_ANALOG_TV_SUPPORT
 	bool "Analog TV support"
+	select MEDIA_CONTROLLER
 	---help---
 	  Enable analog TV support.

@@ -50,6 +52,7 @@ config MEDIA_ANALOG_TV_SUPPORT

 config MEDIA_DIGITAL_TV_SUPPORT
 	bool "Digital TV support"
+	select MEDIA_CONTROLLER
 	---help---
 	  Enable digital TV support.

@@ -95,7 +98,6 @@ source "drivers/media/cec/Kconfig"

 config MEDIA_CONTROLLER
 	bool "Media Controller API"
-	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
 	---help---
 	  Enable the media controller API used to query media devices internal
 	  topology and configure it dynamically.
@@ -119,16 +121,11 @@ config VIDEO_DEV
 	tristate
 	depends on MEDIA_SUPPORT
 	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
+	select VIDEO_V4L2_SUBDEV_API if MEDIA_CONTROLLER
 	default y

 config VIDEO_V4L2_SUBDEV_API
-	bool "V4L2 sub-device userspace API"
-	depends on VIDEO_DEV && MEDIA_CONTROLLER
-	---help---
-	  Enables the V4L2 sub-device pad-level userspace API used to configure
-	  video format, size and frame rate between hardware blocks.
-
-	  This API is mostly used by camera interfaces in embedded platforms.
+	bool

 source "drivers/media/v4l2-core/Kconfig"

