Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53704 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZEHN4n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2009 09:56:43 -0400
Received: from dflp53.itg.ti.com ([128.247.5.6])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n48Duc0b005867
	for <linux-media@vger.kernel.org>; Fri, 8 May 2009 08:56:43 -0500
From: Chaithrika U S <chaithrika@ti.com>
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Manjunath Hadli <mrh@ti.com>, Brijesh Jadav <brijesh.j@ti.com>,
	Chaithrika U S <chaithrika@ti.com>
Subject: [PATCH v3 0/4] ARM: DaVinci: DM646x Video: DM646x display driver
Date: Fri,  8 May 2009 09:25:26 -0400
Message-Id: <1241789126-23317-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Display driver for TI DM646x EVM

Signed-off-by: Manjunath Hadli <mrh@ti.com>
Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Chaithrika U S <chaithrika@ti.com>

These patches add the display driver support for TI DM646x EVM.
This patch set has been tested for basic display functionality for
Composite and Component outputs.

This patch set consists of the updates based on the review comments by
Hans Verkuil.

Patch 1: Display device platform and board setup
Patch 2: VPIF driver
Patch 3: DM646x display driver
Patch 4: Makefile and config files modifications for Display

Some of the features like the HBI/VBI support are not yet implemented. 
Also there are some known issues in the code implementation like 
fine tuning to be done to TRY_FMT ioctl.The USERPTR usage has not been 
tested extensively.

-Chaithrika


