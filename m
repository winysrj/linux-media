Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35511 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754108AbdJISPC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 14:15:02 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, sean@mess.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, andi.shyti@samsung.com,
        andreyknvl@google.com, arnd@arndb.de, dvyukov@google.com,
        kcc@google.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        syzkaller@googlegroups.com
Subject: [PATCH] media: imon: Fix null-ptr-deref in imon_probe
Date: Mon,  9 Oct 2017 23:44:48 +0530
Message-Id: <71782d84353db85a9fb9e45ac09f1c2b53c5a04a.1507572539.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that the return value of usb_ifnum_to_if() can be NULL and
needs to be checked.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
This bug report by Andrey Konovalov usb/media/imon: null-ptr-deref
in imon_probe

 drivers/media/rc/imon.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 7b3f31c..0c46155 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2517,6 +2517,11 @@ static int imon_probe(struct usb_interface *interface,
 	mutex_lock(&driver_lock);
 
 	first_if = usb_ifnum_to_if(usbdev, 0);
+	if (!first_if) {
+		ret = -ENODEV;
+		goto fail;
+	}
+
 	first_if_ctx = usb_get_intfdata(first_if);
 
 	if (ifnum == 0) {
-- 
2.7.4
