Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45253 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZEOSf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 14:35:26 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4FIZMQH021474
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:35:27 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 0/9] ARM: DaVinci: Video: DM355/DM6446 VPFE Capture driver
Date: Fri, 15 May 2009 14:35:19 -0400
Message-Id: <1242412519-11294-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

VPFE Capture driver for DaVinci Media SOCs :- DM355 and DM6446

These patches add support for VPFE (Video Processing Front End) based
video capture on DM355 and DM6446 EVMs. For more details on the hardware
configuration and capabilities, please refer the vpfe_capture.c header.
This patch set consists of following:-

Patch 1: VPFE Capture bridge driver
Patch 2: CCDC hw device header file
Patch 3: DM355 CCDC hw module
Patch 4: DM644x CCDC hw module
Patch 5: common types used across CCDC modules
Patch 6: Makefile and config files for the driver
Patch 7: DM355 platform and board setup
Patch 8: DM644x platform and board setup
Patch 9: Remove outdated driver files from davinci git tree

The initial version of this driver was reviewed by reviewers mentioned
below. Following are the Major comments incorporated into the driver
based on this :-

	1) Restructure the files into following:-
		vpfe_capture.[ch] - bridge driver
		ccdc_types.h - types used across ccdc modules
		vpfe_types.h - types used across vpfe specific drivers
		dm644x_ccdc.[ch] - ccdc module for DM644x
		dm644x_ccdc_regs.h - register defines for DM644x
		dm355_ccdc.[ch] - ccdc module for DM355
		dm355_ccdc_regs.h - register defines for DM644x
	2) Simplify data structures for vpfe capture driver (avoid
	structure based on multiple channels)
	3) Cleanup device registration and initialization
	4) Video buffer handling issues

In addition to this, the driver is ported to the new sub device model.
Tested the driver using the tvp5146 decoder (version migrated to sub device
model by Vaibhav Hiremath and is being reviewed currently on the list).
So this patch depends on the above driver.

NOTE:

Dependent on the TVP514x decoder driver patch for migrating the
driver to sub device model from Vaibhav Hiremath

Following tests are performed.
	1) Capture and display video (PAL & NTSC) from tvp5146 decoder.
	   Displayed using fbdev device driver available on davinci git tree
	2) Tested with driver built statically and dynamically

Muralidhara Karicheri

Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
