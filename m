Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34469 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbZCMKJF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 06:09:05 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n2DA8vom011146
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 05:09:03 -0500
From: chaithrika@ti.com
To: linux-media@vger.kernel.org
Cc: Chaithrika U S <chaithrika@ti.com>
Subject: [RFC 0/7] ARM: DaVinci: DM646x Video: DM646x display driver
Date: Fri, 13 Mar 2009 14:17:43 +0530
Message-Id: <1236934063-31133-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Display driver for TI DM646x EVM

Signed-off-by: Chaithrika U S <chaithrika@ti.com>

This patch set is being submitted to get review and opinion on the approaches
used to implement the sub devices and display drivers.

This set adds the display driver support for TI DM646x EVM.
This patch set has been tested for basic display functionality for
Composite and Component outputs.

Patch 1: Display device platform and board setup
Patch 2: ADV7343 video encoder driver
Patch 3: THS7303 video amplifier driver
Patch 4: Defintions for standards supported by display
Patch 5: Makefile and config files modifications for Display
Patch 6: VPIF driver
Patch 7: DM646x display driver

The 'v4l2-subdevice' interface has been used to interact with the encoder and
video amplifier.

Some of the features like the HBI/VBI support are not yet implemented. 
Also there are some known issues in the code implementation like 
fine tuning to be done to TRY_FMT ioctl and ENUM_OUTPUT ioctl.The USERPTR usage 
has not been tested extensively,also some HD standards are yet to be tested.

These patches are based on the drivers written by:
        Manjunath Hadli <mrh@ti.com>
        Brijesh Jadav <brijesh.j@ti.com>

-Chaithrika


