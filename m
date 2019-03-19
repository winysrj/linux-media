Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CF6C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 08:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD1C32133D
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 08:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfCSIKC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 04:10:02 -0400
Received: from retiisi.org.uk ([95.216.213.190]:58502 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725934AbfCSIKB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 04:10:01 -0400
Received: from lanttu.localdomain (unknown [IPv6:2a01:4f9:c010:4572::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id ECDCC634C7B
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 10:08:04 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l2-fwnode: Add a deprecation note in the old ACPI parsing example
Date:   Tue, 19 Mar 2019 10:09:58 +0200
Message-Id: <20190319080958.15925-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is not how ACPI tables are written. Add a deprecation note and refer
to the proper documentation.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 27827842dffd..014b3f11e1ba 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -828,7 +828,10 @@ static int v4l2_fwnode_reference_parse(struct device *dev,
  * underneath the fwnode identified by the previous tuple, etc. until you
  * reached the fwnode you need.
  *
- * An example with a graph, as defined in Documentation/acpi/dsd/graph.txt:
+ * THIS EXAMPLE EXISTS MERELY TO DOCUMENT THIS FUNCTION. DO NOT USE IT AS A
+ * REFERENCE IN HOW ACPI TABLES SHOULD BE WRITTEN!! See documentation under
+ * Documentation/acpi/dsd instead and especially graph.txt,
+ * data-node-references.txt and leds.txt .
  *
  *	Scope (\_SB.PCI0.I2C2)
  *	{
-- 
2.11.0

