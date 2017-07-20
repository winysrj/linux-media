Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53318 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964827AbdGTKaU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 06:30:20 -0400
From: Colin King <colin.king@canonical.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][media-next] media: v4l: make local function v4l2_fwnode_endpoint_parse_csi1_bus static
Date: Thu, 20 Jul 2017 11:30:14 +0100
Message-Id: <20170720103014.19545-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The function v4l2_fwnode_endpoint_parse_csi1_bus does not need to be
in global scope, so make it static.  Also reformat the function arguments
as adding the static keyword made one of the source lines more than 80
chars wide and checkpatch does not like that.

Cleans up sparse warning:
"symbol 'v4l2_fwnode_endpoint_parse_csi1_bus' was not declared. Should it
be static?"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index ca755a4832fc..5fd69f59d8c8 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -154,9 +154,10 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
 
 }
 
-void v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnode,
-					 struct v4l2_fwnode_endpoint *vep,
-					 u32 bus_type)
+static void v4l2_fwnode_endpoint_parse_csi1_bus(
+	struct fwnode_handle *fwnode,
+	struct v4l2_fwnode_endpoint *vep,
+	u32 bus_type)
 {
 	struct v4l2_fwnode_bus_mipi_csi1 *bus = &vep->bus.mipi_csi1;
 	u32 v;
-- 
2.11.0
