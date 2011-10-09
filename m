Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39585 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1JIN0z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 09:26:55 -0400
Received: by wyg34 with SMTP id 34so5137571wyg.19
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 06:26:54 -0700 (PDT)
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>, linux-media@vger.kernel.org
Subject: [PATCH v2 0/2] Add support to ITU-R BT.656 video data format
Date: Sun,  9 Oct 2011 15:26:40 +0200
Message-Id: <1318166803-7392-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello folks,

This is a v2 patch-set that aims to add support to the ISP CCDC driver to
process video in interlaced mode.

The patch-set contains the following patches:

[PATCH v2 1/3] omap3isp: ccdc: Add interlaced field mode to platform data
[PATCH v2 2/3] omap3isp: ccdc: Add interlaced count field to isp_ccdc_device
[PATCH v2 3/3] omap3isp: ccdc: Add support to ITU-R BT.656 video data format

This is based on one of the earlier changes we made. This doesn't move the
buffer management logic to the VD1 interrupt handler so is less intrusive than
v1 patch-set.

Also, based on Laurent's comments I check not if we are in BT.656 but if the
ISP CCDC is configured to operate in interlaced mode (fldmode == 1).

Again, this patch-set is a proof-of-concept and was only compile tested since I
don't have the hardware to test right now. It is a forward porting, on top
of Laurent's omap3isp-omap3isp-yuv tree, of the changes we made to the ISP
driver to get interlaced video working. And this is one of the earlier changes
we made.

It is not intended to be merged, I'm posting here only for review and feedback.

Best regards,
