Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33143
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752189AbdI0Vky (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:54 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 35/37] media: dmxdev: use the newly nested kernel-doc support
Date: Wed, 27 Sep 2017 18:40:36 -0300
Message-Id: <6f04cb4231eecec3b8f0672c5d3151b70e18302f.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that kernel-doc supports nested structs/unions, use it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dmxdev.h | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.h b/drivers/media/dvb-core/dmxdev.h
index 9aa3ce3fc407..2ef0a3b54de6 100644
--- a/drivers/media/dvb-core/dmxdev.h
+++ b/drivers/media/dvb-core/dmxdev.h
@@ -89,19 +89,24 @@ struct dmxdev_feed {
 /**
  * struct dmxdev_filter - digital TV dmxdev filter
  *
- * @filter:	a dmxdev filter. Currently used only for section filter:
- *		if the filter is Section, it contains a
- *		&struct dmx_section_filter @sec pointer.
- * @feed:	a dmxdev feed. Depending on the feed type, it can be:
- *		for TS feed: a &struct list_head @ts list of TS and PES
- *		feeds;
- *		for section feed: a &struct dmx_section_feed @sec pointer.
- * @params:	dmxdev filter parameters. Depending on the feed type, it
- *		can be:
- *		for section filter: a &struct dmx_sct_filter_params @sec
- *		embedded struct;
- *		for a TS filter: a &struct dmx_pes_filter_params @pes
- *		embedded struct.
+ * @filter:	a union describing a dmxdev filter.
+ * 		Currently used only for section filters.
+ * @filter.sec: a &struct dmx_section_filter pointer.
+ *		For section filter only.
+ * @feed:	an union describing a dmxdev feed.
+ *		Depending on the filter type, it can be either
+ *		@feed.ts or @feed.sec.
+ * @feed.ts:	a &struct list_head list.
+ *		For TS and PES feeds.
+ * @feed.sec:	a &struct dmx_section_feed pointer.
+ *		For section feed only.
+ * @params:	a union describing dmxdev filter parameters.
+ * 		Depending on the filter type, it can be either
+ *		@params.sec or @params.pes.
+ * @params.sec:	a &struct dmx_sct_filter_params embedded struct.
+ *		For section filter only.
+ * @params.pes:	a &struct dmx_pes_filter_params embedded struct.
+ *		For PES filter only.
  * @type:	type of the dmxdev filter, as defined by &enum dmxdev_type.
  * @state:	state of the dmxdev filter, as defined by &enum dmxdev_state.
  * @dev:	pointer to &struct dmxdev.
-- 
2.13.5
