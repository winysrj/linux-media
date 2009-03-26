Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54686 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZCZNlT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 09:41:19 -0400
Received: from dflp53.itg.ti.com ([128.247.5.6])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n2QDfAB7011749
	for <linux-media@vger.kernel.org>; Thu, 26 Mar 2009 08:41:15 -0500
From: Chaithrika U S <chaithrika@ti.com>
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH 0/4] ARM: DaVinci: DM646x Video: DM646x display driver
Date: Thu, 26 Mar 2009 09:21:22 -0400
Message-Id: <1238073682-9838-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Display driver for TI DM646x EVM

Signed-off-by: Chaithrika U S <chaithrika@ti.com>

This patch set has been updated with the review comments for the RFC sent earlier.

These patches add the display driver support for TI DM646x EVM.
This patch set has been tested for basic display functionality for
Composite and Component outputs.

Patch 1: Display device platform and board setup
Patch 2: VPIF driver
Patch 3: DM646x display driver
Patch 4: Makefile and config files modifications for Display

Some of the features like the HBI/VBI support are not yet implemented. 
Also there are some known issues in the code implementation like 
fine tuning to be done to TRY_FMT ioctl.The USERPTR usage has not been 
tested extensively.

These patches are based on the drivers written by:
        Manjunath Hadli <mrh@ti.com>
        Brijesh Jadav <brijesh.j@ti.com>

The files have been renamed as per the discussion. The header files have been 
moved to the same directory as the driver. Currently, the driver supports SDTV
formats only.
 
-Chaithrika


