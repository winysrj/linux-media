Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33148
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752192AbdI0Vky (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:54 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 36/37] media: dvb_demux: use the newly nested kernel-doc support
Date: Wed, 27 Sep 2017 18:40:37 -0300
Message-Id: <6632a2f1dff21ff9d2f8570322d46344cbb89e6b.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that kernel-doc supports nested structs/unions, use it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.h | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index 15ee2ea23efe..97bf5ee7ef57 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -94,15 +94,20 @@ struct dvb_demux_filter {
 /**
  * struct dvb_demux_feed - describes a DVB field
  *
- * @feed:	a digital TV feed. It can either be a TS or a section feed:
- *		if the feed is TS, it contains &struct dvb_ts_feed @ts;
- *		if the feed is section, it contains
- *		&struct dmx_section_feed @sec.
- * @cb:		digital TV callbacks. depending on the feed type, it can be:
- *		if the feed is TS, it contains a dmx_ts_cb() @ts callback;
- *		if the feed is section, it contains a dmx_section_cb() @sec
- * 		callback.
- *
+ * @feed:	a union describing a digital TV feed.
+ *		Depending on the feed type, it can be either
+ *		@feed.ts or @feed.sec.
+ * @feed.ts:	a &struct dmx_ts_feed pointer.
+ *		For TS feed only.
+ * @feed.sec:	a &struct dmx_section_feed pointer.
+ *		For section feed only.
+ * @cb:		a union describing digital TV callbacks.
+ *		Depending on the feed type, it can be either
+ *		@cb.ts or @cb.sec.
+ * @cb.ts:	a dmx_ts_cb() calback function pointer.
+ *		For TS feed only.
+ * @cb.sec:	a dmx_section_cb() callback function pointer.
+ *		For section feed only.
  * @demux:	pointer to &struct dvb_demux.
  * @priv:	private data that can optionally be used by a DVB driver.
  * @type:	type of the filter, as defined by &enum dvb_dmx_filter_type.
-- 
2.13.5
