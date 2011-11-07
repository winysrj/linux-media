Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36164 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1KGWgR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 17:36:17 -0500
Received: by pzk2 with SMTP id 2so532065pzk.1
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2011 14:36:16 -0800 (PST)
From: Rick Bronson <rickbronson@gmail.com>
To: linux-media@vger.kernel.org
cc: laurent.pinchart@ideasonboard.com
Subject: Re: [RFC/PATCH 1/2] v4l: Add generic board subdev registration function
Message-Id: <E1RNXnK-00027i-QS@amazonia.comcast.net>
Date: Mon, 07 Nov 2011 14:35:58 -0800
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

  I'm trying to add a SPI camera to 2.6.39 but ran into trouble with
isp_register_subdev_group() in drivers/media/video/omap3isp/isp.c
hardcoded to use i2c.  The platform is a BeagleBoardXM.  I tried these
two patches:

http://patchwork.linuxtv.org/patch/6651/mbox/
http://patchwork.linuxtv.org/patch/6650/raw/

  or:

RFC-PATCH-2-2-omap3isp-Use-generic-subdev-registration-function.patch
RFC-PATCH-1-2-v4l-Add-generic-board-subdev-registration-function.patch

  It crashes, from what I can tell, it seems to be coming into
isp_register_entities(), then iterating in:

---------------------------------
	/* Register external entities */
	for (subdevs = pdata->subdevs; subdevs->subdevs; ++subdevs) {
---------------------------------

  But it's iterating through ev76c560_camera_subdevs (see
http://efn.org/~rick/pub/board-portal7-camera.c), seems like
it should be iterating through portal7_camera_subdevs in the same
file.

  Any help would be greatly appreciated.

  Thanks,

  Rick Bronson
