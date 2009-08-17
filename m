Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52713 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZHQTet (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 15:34:49 -0400
From: neilsikka@ti.com
To: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Cc: khilman@deeprootsystems.com, hverkuil@xs4all.nl,
	Neil Sikka <neilsikka@ti.com>
Subject: [PATCH v1 0/4] Adding capture support for DM365 device
Date: Mon, 17 Aug 2009 15:34:35 -0400
Message-Id: <1250537679-2239-1-git-send-email-neilsikka@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Neil Sikka <neilsikka@ti.com>

This patch series adds support for the VPSS capture on the DM365 SOC.
Specifically, it supports the CCDC/ISIF module. This code has been tested and
works with the TVP5146 decoder (using the tvp514x driver). During testing of
this code, the NTSC capture format was used. This patch depends on previous
other patches contributed by Muralidharan Karicheri. Please see the individual
patch notes for dependency details. The patches contained in this patch set are:

1) DM365 Platform support for VPFE-additions to the DM365 SOC files
2) DM365 VPSS support-additions to the VPSS.h and VPSS.c files
3) CCDC support on DM365-the actual DM365 CCDC driver and its supporting files

NOTE: All patches are to be applied before build.

Mandatory reviewers:
Hans Verkuil <hverkuil@xs4all.nl> for V4L tree
Kevin Hilman <khilman@deeprootsystems.com> for DaVinci tree

Reviewed-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Signed-off-by: Neil Sikka <neilsikka@ti.com>
