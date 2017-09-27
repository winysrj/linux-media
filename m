Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33174
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752133AbdI0Vkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:49 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 21/37] media: dvb_demux.h: get rid of unused timer at struct dvb_demux_filter
Date: Wed, 27 Sep 2017 18:40:22 -0300
Message-Id: <f517bf329e5011a7763ef382f116dd95c1e064cb.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This field is not used. So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index b24d69b5a20f..045f7fd1a8b1 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -73,7 +73,6 @@ struct dvb_demux_filter {
 	enum dvb_dmx_filter_type type;
 
 	u16 hw_handle;
-	struct timer_list timer;
 };
 
 #define DMX_FEED_ENTRY(pos) list_entry(pos, struct dvb_demux_feed, list_head)
-- 
2.13.5
