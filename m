Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:53682 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751834AbdH1IqB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 04:46:01 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cobalt: do not register subdev nodes
Message-ID: <d913ad14-79e1-1c2d-e692-4941ccf9b9a5@xs4all.nl>
Date: Mon, 28 Aug 2017 10:45:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the distant past the adv7604 driver used private controls. In order to access
them the v4l-subdevX nodes were needed. Later the is_private tag was removed in
the adv7604 driver and the need for v4l-subdevX device nodes disappeared.

Remove the creation of those device nodes from this driver.

Note: the cobalt card is only used inside Cisco and we never actually used the
v4l-subdevX nodes for anything. So this API change can be done safely without
breaking anything.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 98b6cb9505d1..c9d8006ff697 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -738,9 +738,6 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 			goto err_i2c;
 	}

-	retval = v4l2_device_register_subdev_nodes(&cobalt->v4l2_dev);
-	if (retval)
-		goto err_i2c;
 	retval = cobalt_nodes_register(cobalt);
 	if (retval) {
 		cobalt_err("Error %d registering device nodes\n", retval);
