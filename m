Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34262 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaIXW17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jingoo Han <jg1.han@samsung.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: [PATCH 03/18] [media] sta2x11_vip: fix address space casting
Date: Wed, 24 Sep 2014 19:27:03 -0300
Message-Id: <f8b9315581e4c7c9add3c80f77ed6404ebb54f18.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:1140:30: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:1140:30:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:1140:30:    got void volatile [noderef] <asn:2>*iomem
drivers/media/pci/sta2x11/sta2x11_vip.c:1184:30: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:1184:30:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:1184:30:    got void volatile [noderef] <asn:2>*iomem
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38: warning: incorrect type in argument 1 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:226:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38: warning: incorrect type in argument 2 (different modifiers)
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    expected void [noderef] <asn:2>*<noident>
drivers/media/pci/sta2x11/sta2x11_vip.c:221:38:    got void volatile [noderef] <asn:2>*

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 365bd21301ba..22450f583da1 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -152,7 +152,7 @@ struct sta2x11_vip {
 	int tcount, bcount;
 	int overflow;
 
-	void *iomem;	/* I/O Memory */
+	void __iomem *iomem;	/* I/O Memory */
 	struct vip_config *config;
 };
 
-- 
1.9.3

