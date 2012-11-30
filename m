Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50700 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab2K3Ln5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Nov 2012 06:43:57 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v4 0/3] Davinci VPSS helper functions for VPFE
Date: Fri, 30 Nov 2012 17:13:38 +0530
Message-Id: <1354275821-25235-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch series adds helper functions and enables the VPSS
and ISP registers required for VPFE to work.

Changes for v4:
1: Fixed review comment from Sakari.

Manjunath Hadli (3):
  davinci: vpss: dm365: enable ISP registers
  davinci: vpss: dm365: set vpss clk ctrl
  davinci: vpss: dm365: add vpss helper functions to be used in the
    main driver for setting hardware parameters

 drivers/media/platform/davinci/vpss.c |   70 ++++++++++++++++++++++++++++++++-
 include/media/davinci/vpss.h          |   16 +++++++
 2 files changed, 85 insertions(+), 1 deletions(-)

-- 
1.7.4.1

