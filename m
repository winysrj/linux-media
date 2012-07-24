Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46076 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab2GXPEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 11:04:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH, RESEND] az6007: fix incorrect memcpy
To: linux-media@vger.kernel.org, akpm@linux-foundation.org
Date: Tue, 24 Jul 2012 17:02:46 +0100
Message-ID: <20120724160235.7031.21809.stgit@bluebook>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

Some parts of the C language are subtle and evil. This is one example.

Reported-by: dcb314@hotmail.com
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44041
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/dvb/dvb-usb/az6007.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 8ffcad0..86861e6 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -590,7 +590,7 @@ static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 	int ret;
 
 	ret = az6007_read(d, AZ6007_READ_DATA, 6, 0, st->data, 6);
-	memcpy(mac, st->data, sizeof(mac));
+	memcpy(mac, st->data, 6);
 
 	if (ret > 0)
 		deb_info("%s: mac is %pM\n", __func__, mac);

