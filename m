Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA52BC43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 18:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AD2020836
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 18:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387603AbeLUSCK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 13:02:10 -0500
Received: from muru.com ([72.249.23.125]:58920 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbeLUSCK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 13:02:10 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id BAB9E8068;
        Fri, 21 Dec 2018 18:02:12 +0000 (UTC)
Date:   Fri, 21 Dec 2018 10:02:05 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
Message-ID: <20181221180205.GH6707@atomide.com>
References: <20181221011752.25627-1-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181221011752.25627-1-sre@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

* Sebastian Reichel <sre@kernel.org> [181221 01:18]:
> The new code has been tested on the Motorola Droid 4. For testing the audio
> should be configured to route Ext to Speaker or Headphone. Then you need to
> plug headphone, since its cable is used as antenna. For testing there is a
> 'radio' utility packages in Debian. When you start the utility you need to
> specify a frequency, since initial get_frequency returns an error:

Nice, good to see that ti-st kim stuff gone :) I gave this a quick
try using fmtools.git and fmscan works just fine. No luck yet with
fm though, it gives VIDIOC_G_CTRL: Not a tty error somehow so
maybe I'm missing some options, patch below for omap2plus_defconfig.

Hmm so looks like nothing to configure for the clocks or
CPCAP_BIT_ST_L_TIMESLOT bits for cap for the EXT? So the
wl12xx audio is wired directly to cpcap EXT then and not a
TDM slot on the mcbsp huh?

> Merry Christmas!

Same to you!

Tony

8< --------------------------------
From tony Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Fri, 21 Dec 2018 07:57:09 -0800
Subject: [PATCH] ARM: omap2plus_defconfig: Add RADIO_WL128X as a loadable
 module

This allows using the FM radio in the wl12xx chips after modprobe
fm_drv using radio from xawt, or fmtools.

Note that the firmware placed into /lib/firmware/ti-connectivity
directory:

fm_rx_ch8_1283.2.bts
fmc_ch8_1283.2.bts

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/configs/omap2plus_defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -126,6 +126,7 @@ CONFIG_AF_RXRPC=m
 CONFIG_RXKAD=y
 CONFIG_CFG80211=m
 CONFIG_MAC80211=m
+CONFIG_RFKILL=m
 CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_DMA_CMA=y
@@ -343,12 +344,14 @@ CONFIG_IR_GPIO_TX=m
 CONFIG_IR_PWM_TX=m
 CONFIG_MEDIA_SUPPORT=m
 CONFIG_MEDIA_CAMERA_SUPPORT=y
+CONFIG_MEDIA_RADIO_SUPPORT=y
 CONFIG_MEDIA_CEC_SUPPORT=y
 CONFIG_MEDIA_CONTROLLER=y
 CONFIG_VIDEO_V4L2_SUBDEV_API=y
 CONFIG_V4L_PLATFORM_DRIVERS=y
 CONFIG_VIDEO_OMAP3=m
 CONFIG_CEC_PLATFORM_DRIVERS=y
+CONFIG_RADIO_WL128X=m
 # CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
 CONFIG_VIDEO_TVP5150=m
 CONFIG_DRM=m
-- 
2.19.2
