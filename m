Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38361 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdHAR5n (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 13:57:43 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: corbet@lwn.net, mchehab@kernel.org, awalls@md.metrocast.net,
        hverkuil@xs4all.nl, serjk@netup.ru, aospan@netup.ru,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/18] [media] bt8xx: constify pci_device_id.
Date: Tue,  1 Aug 2017 23:26:24 +0530
Message-Id: <1501610194-8231-9-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/bt8xx/bt878.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index 8aa7266..a5f5213 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -383,7 +383,7 @@ EXPORT_SYMBOL(bt878_device_control);
 		.driver_data = (unsigned long) name \
 	}
 
-static struct pci_device_id bt878_pci_tbl[] = {
+static const struct pci_device_id bt878_pci_tbl[] = {
 	BROOKTREE_878_DEVICE(0x0071, 0x0101, "Nebula Electronics DigiTV"),
 	BROOKTREE_878_DEVICE(0x1461, 0x0761, "AverMedia AverTV DVB-T 761"),
 	BROOKTREE_878_DEVICE(0x11bd, 0x001c, "Pinnacle PCTV Sat"),
-- 
2.7.4
