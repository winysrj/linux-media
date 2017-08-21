Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:36032 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751941AbdHUMw0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 08:52:26 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: devicetree@vger.kernel.org, linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] device property: preserve usecount for node passed to of_fwnode_graph_get_port_parent()
Date: Mon, 21 Aug 2017 14:51:07 +0200
Message-Id: <20170821125107.20746-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using CONFIG_OF_DYNAMIC=y uncovered an imbalance in the usecount of the
node being passed to of_fwnode_graph_get_port_parent(). Preserve the
usecount just like it is done in of_graph_get_port_parent().

Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmware specific locations")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/of/property.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 067f9fab7b77c794..637dcb4833e2af60 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -922,6 +922,12 @@ of_fwnode_graph_get_port_parent(struct fwnode_handle *fwnode)
 {
 	struct device_node *np;
 
+	/*
+	 * Preserve usecount for passed in node as of_get_next_parent()
+	 * will do of_node_put() on it.
+	 */
+	of_node_get(to_of_node(fwnode));
+
 	/* Get the parent of the port */
 	np = of_get_next_parent(to_of_node(fwnode));
 	if (!np)
-- 
2.14.0

For posterity here is the console log:

OF: ERROR: Bad of_node_put() on /soc/i2c@e66d8000/gmsl-deserializer@1/ports/port@4
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.13.0-rc4-00418-g32df6aeea9a6f626 #14
Hardware name: Renesas Salvator-X board based on r8a7795 ES1.x (DT)
Call trace:
[<ffff000008088f58>] dump_backtrace+0x0/0x238
[<ffff00000808929c>] show_stack+0x14/0x20
[<ffff000008ed6c50>] dump_stack+0x9c/0xbc
[<ffff000008c58450>] of_node_release+0xb8/0xc0
[<ffff000008edb644>] kobject_put+0x84/0xf0
[<ffff000008c57c04>] of_node_put+0x14/0x28
[<ffff000008c5677c>] of_fwnode_put+0x24/0x40
[<ffff0000087be488>] fwnode_graph_get_port_parent+0x60/0xb0
[<ffff000008b85e2c>] match_fwnode+0x2c/0x88
[<ffff000008b85f98>] v4l2_async_belongs+0x78/0x120
[<ffff000008b8615c>] v4l2_async_notifier_register+0x11c/0x1d8
[<ffff000008b86270>] v4l2_async_test_notify+0x58/0x160
[<ffff000008b86130>] v4l2_async_notifier_register+0xf0/0x1d8
[<ffff000008bcd39c>] rcar_vin_probe+0x65c/0x718
[<ffff0000087b9848>] platform_drv_probe+0x58/0xb8
[<ffff0000087b8014>] driver_probe_device+0x22c/0x2d8
[<ffff0000087b817c>] __driver_attach+0xbc/0xc0
[<ffff0000087b622c>] bus_for_each_dev+0x4c/0x98
[<ffff0000087b82b8>] driver_attach+0x20/0x28
[<ffff0000087b6c98>] bus_add_driver+0x1b8/0x228
[<ffff0000087b8b80>] driver_register+0x60/0xf8
[<ffff0000087ba550>] __platform_driver_register+0x40/0x48
[<ffff000009482830>] rcar_vin_driver_init+0x18/0x20
[<ffff000009440c5c>] do_one_initcall+0x80/0x110
[<ffff000009440e74>] kernel_init_freeable+0x188/0x224
[<ffff000008ee8ab8>] kernel_init+0x10/0x100
[<ffff0000080836c0>] ret_from_fork+0x10/0x50
