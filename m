Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35092 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752154AbdHAR6A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 13:58:00 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: corbet@lwn.net, mchehab@kernel.org, awalls@md.metrocast.net,
        hverkuil@xs4all.nl, serjk@netup.ru, aospan@netup.ru,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] [media] saa7164: constify pci_device_id.
Date: Tue,  1 Aug 2017 23:26:29 +0530
Message-Id: <1501610194-8231-14-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/saa7164/saa7164-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 75eed4c..fca36a4 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1490,7 +1490,7 @@ static void saa7164_finidev(struct pci_dev *pci_dev)
 	kfree(dev);
 }
 
-static struct pci_device_id saa7164_pci_tbl[] = {
+static const struct pci_device_id saa7164_pci_tbl[] = {
 	{
 		/* SAA7164 */
 		.vendor       = 0x1131,
-- 
2.7.4
