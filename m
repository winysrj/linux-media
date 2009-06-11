Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39111 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZFKRAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 13:00:54 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5BH0pJO022624
	for <linux-media@vger.kernel.org>; Thu, 11 Jun 2009 12:00:56 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 0/10 - v2] ARM: DaVinci: Video: DM355/DM6446 VPFE Capture driver
Date: Thu, 11 Jun 2009 13:00:39 -0400
Message-Id: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

Resending to have all patches together since I had to resend couple of
them earlier and had to fix few issues...

VPFE Capture driver for DaVinci Media SOCs :- DM355 and DM6446

This is the version v2 of the patch series. This is the reworked
version of the driver based on comments received against the last
version of the patch.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
These patches add support for VPFE (Video Processing Front End) based
video capture on DM355 and DM6446 EVMs. For more details on the hardware
configuration and capabilities, please refer the vpfe_capture.c header.
This patch set consists of following:-

Patch 1: VPFE Capture bridge driver
Patch 2: CCDC hw device header file
Patch 3: DM355 CCDC hw module
Patch 4: DM644x CCDC hw module
Patch 5: ccdc types used across CCDC modules
Patch 6: Makefile and config files for the driver
Patch 7: DM355 platform and board setup
Patch 8: DM644x platform and board setup
Patch 9: Remove outdated driver files from davinci git tree
Patch 10: common vpss hw module for video drivers

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
