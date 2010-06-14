Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:65524 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab0FNU0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 16:26:51 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	clemens@ladisch.de, debora@linux.vnet.ibm.com,
	dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/8]bluetooth/hci_ldisc.c Fix warning: variable 'tty' set but not used
Date: Mon, 14 Jun 2010 13:26:42 -0700
Message-Id: <1276547208-26569-3-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Im getting this while building:
  CC [M]  drivers/bluetooth/hci_ldisc.o
drivers/bluetooth/hci_ldisc.c: In function 'hci_uart_send_frame':
drivers/bluetooth/hci_ldisc.c:213:21: warning: variable 'tty' set but not used

the below fixed it for me, but am not sure if
it's correct.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/bluetooth/hci_ldisc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 76a1abb..f693dfe 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -210,7 +210,6 @@ static int hci_uart_close(struct hci_dev *hdev)
 static int hci_uart_send_frame(struct sk_buff *skb)
 {
 	struct hci_dev* hdev = (struct hci_dev *) skb->dev;
-	struct tty_struct *tty;
 	struct hci_uart *hu;
 
 	if (!hdev) {
@@ -222,8 +221,7 @@ static int hci_uart_send_frame(struct sk_buff *skb)
 		return -EBUSY;
 
 	hu = (struct hci_uart *) hdev->driver_data;
-	tty = hu->tty;
-
+	
 	BT_DBG("%s: type %d len %d", hdev->name, bt_cb(skb)->pkt_type, skb->len);
 
 	hu->proto->enqueue(hu, skb);
-- 
1.7.1.rc1.21.gf3bd6

