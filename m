Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:51158 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753184AbdCFOY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:24:56 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 27/29] drivers, usb: convert ep_data.count from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:14 +0200
Message-Id: <1488810076-3754-28-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/usb/gadget/legacy/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 81d76f3..d21a5f8 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -191,7 +191,7 @@ enum ep_state {
 struct ep_data {
 	struct mutex			lock;
 	enum ep_state			state;
-	atomic_t			count;
+	refcount_t			count;
 	struct dev_data			*dev;
 	/* must hold dev->lock before accessing ep or req */
 	struct usb_ep			*ep;
@@ -206,12 +206,12 @@ struct ep_data {
 
 static inline void get_ep (struct ep_data *data)
 {
-	atomic_inc (&data->count);
+	refcount_inc (&data->count);
 }
 
 static void put_ep (struct ep_data *data)
 {
-	if (likely (!atomic_dec_and_test (&data->count)))
+	if (likely (!refcount_dec_and_test (&data->count)))
 		return;
 	put_dev (data->dev);
 	/* needs no more cleanup */
@@ -1562,7 +1562,7 @@ static int activate_ep_files (struct dev_data *dev)
 		init_waitqueue_head (&data->wait);
 
 		strncpy (data->name, ep->name, sizeof (data->name) - 1);
-		atomic_set (&data->count, 1);
+		refcount_set (&data->count, 1);
 		data->dev = dev;
 		get_dev (dev);
 
-- 
2.7.4
