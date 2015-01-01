Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbAAPvo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 10:51:44 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] mb86a20s: remove unused debug modprobe parameter
Date: Thu,  1 Jan 2015 13:51:22 -0200
Message-Id: <21390f03602bc2d796e406e8a70a57c59ee61daf.1420127255.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420127255.git.mchehab@osg.samsung.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420127255.git.mchehab@osg.samsung.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The debug parameter is not used anymore, as this module was
converted already to use dev_dbg().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index e6f165a5b90d..8f54c39ca63f 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -22,10 +22,6 @@
 
 #define NUM_LAYERS 3
 
-static int debug = 1;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
-
 enum mb86a20s_bandwidth {
 	MB86A20S_13SEG = 0,
 	MB86A20S_13SEG_PARTIAL = 1,
-- 
2.1.0

