Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46740 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbZDHLlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2009 07:41:20 -0400
Received: from dflp53.itg.ti.com ([128.247.5.6])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n38BfAJO003936
	for <linux-media@vger.kernel.org>; Wed, 8 Apr 2009 06:41:15 -0500
From: Chaithrika U S <chaithrika@ti.com>
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Manjunath Hadli <mrh@ti.com>, Brijesh Jadav <brijesh.j@ti.com>,
	Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH v2 0/4] ARM: DaVinci: DM646x Video: DM646x display driver
Date: Wed,  8 Apr 2009 07:17:56 -0400
Message-Id: <1239189476-19863-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Display driver for TI DM646x EVM

Signed-off-by: Manjunath Hadli <mrh@ti.com>
Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Chaithrika U S <chaithrika@ti.com>

These patches add the display driver support for TI DM646x EVM.
This patch set has been tested for basic display functionality for
Composite and Component outputs.

In this version of the patches, the review comments got for the earlier version
have been incorporated. The standard information(timings) has been moved to 
the display driver. The display driver has been modified accordingly.
Also simplified the code by removing the redundant vpif_stdinfo data structure. 

Patch 1: Display device platform and board setup
Patch 2: VPIF driver
Patch 3: DM646x display driver
Patch 4: Makefile and config files modifications for Display

Some of the features like the HBI/VBI support are not yet implemented. 
Also there are some known issues in the code implementation like 
fine tuning to be done to TRY_FMT ioctl.The USERPTR usage has not been 
tested extensively.

-Chaithrika


