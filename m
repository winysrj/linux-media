Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:37679 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbbFSGb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 02:31:27 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 98F9A2A0091
	for <linux-media@vger.kernel.org>; Fri, 19 Jun 2015 08:31:05 +0200 (CEST)
Message-ID: <5583B729.30601@xs4all.nl>
Date: Fri, 19 Jun 2015 08:31:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v4.2] cobalt: set Kconfig default to n
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since this board is a Cisco-internal board there is no point in having it compiled
by default. So set the Kconfig default to n.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
index 3be1b2c..4d0777a 100644
--- a/drivers/media/pci/cobalt/Kconfig
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_COBALT
 	select VIDEO_ADV7511
 	select VIDEO_ADV7842
 	select VIDEOBUF2_DMA_SG
+	default n
 	---help---
 	  This is a video4linux driver for the Cisco PCIe Cobalt card.
 
