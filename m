Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:53722 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760180AbZFQULd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 16:11:33 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5HKBQMd012946
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 15:11:31 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 0/11 - v3] ARM: DaVinci: Video: DM355/DM6446 VPFE Capture driver
Date: Wed, 17 Jun 2009 16:11:13 -0400
Message-Id: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

Big Thanks to all reviewers who have contributed to this driver
by reviewing and offering valuable comments.

VPFE Capture driver for DaVinci Media SOCs :- DM355 and DM6446

This is the version v3 of the patch series. This is the reworked
version of the driver based on comments received against the last
version (v2) of the patch and is expected to be final version
candidate for merge to upstream kernel

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
Patch 9: common vpss hw module for video drivers
Patch 10: Remove outdated driver files from davinci git tree
Patch 11: Makefile and config files for the davinci git tree (New
from v2)

NOTE:

1. Patches 10-11 are only for DaVinci GIT tree. Others applies to
DaVinci GIT and v4l-dvb

2. Dependent on the TVP514x decoder driver patch for migrating the
driver to sub device model from Vaibhav Hiremath. I am sending the
reworked version of this patch instead of Vaibhav.

Following tests are performed.
	1) Capture and display video (PAL & NTSC) from tvp5146 decoder.
	   Displayed using fbdev device driver available on davinci git tree
	2) Tested with driver built statically and dynamically

Muralidhara Karicheri

Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
Reviewed by: Alexey Klimov <klimov.linux@gmail.com>
Reviewed by: Kevin Hilman <khilman@deeprootsystems.com>
Reviewed by: David Brownell <david-b@pacbell.net>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
