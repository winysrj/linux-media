Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDE5C41518
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E237A218AC
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfAXJw6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:52:58 -0500
Received: from mail.bootlin.com ([62.4.15.54]:59128 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfAXJw5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 04:52:57 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 1EE0F207B0; Thu, 24 Jan 2019 10:52:55 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id AF6A920798;
        Thu, 24 Jan 2019 10:52:44 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
Cc:     Pawel Osciak <pawel@osciak.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/2] media: cedrus: Remove completed item from TODO list (dma-buf references)
Date:   Thu, 24 Jan 2019 10:51:56 +0100
Message-Id: <20190124095156.21898-2-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124095156.21898-1-paul.kocialkowski@bootlin.com>
References: <20190124095156.21898-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Access to reference frames that were imported from dma-buf was taken
care of and is no longer a pending item on the driver's TODO list.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/staging/media/sunxi/cedrus/TODO | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/TODO b/drivers/staging/media/sunxi/cedrus/TODO
index a951b3fd1ea1..ec277ece47af 100644
--- a/drivers/staging/media/sunxi/cedrus/TODO
+++ b/drivers/staging/media/sunxi/cedrus/TODO
@@ -5,8 +5,3 @@ Before this stateless decoder driver can leave the staging area:
 * Userspace support for the Request API needs to be reviewed;
 * Another stateless decoder driver should be submitted;
 * At least one stateless encoder driver should be submitted.
-* When queueing a request containing references to I frames, the
-  refcount of the memory for those I frames needs to be incremented
-  and decremented when the request is completed. This will likely
-  require some help from vb2. The driver should fail the request
-  if the memory/buffer is gone.
-- 
2.20.1

