Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:65055 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753691AbdIRN4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 09:56:33 -0400
Subject: [PATCH 3/6] [media] go7007: Improve a size determination in four
 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b36ece3f-0f31-9bb6-14ae-c4abf7cd23ee@users.sourceforge.net>
Message-ID: <092d6885-5101-73b2-bb69-42873d940369@users.sourceforge.net>
Date: Mon, 18 Sep 2017 15:56:25 +0200
MIME-Version: 1.0
In-Reply-To: <b36ece3f-0f31-9bb6-14ae-c4abf7cd23ee@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 11:27:30 +0200

Replace the specification of data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/go7007/go7007-driver.c | 2 +-
 drivers/media/usb/go7007/go7007-usb.c    | 2 +-
 drivers/media/usb/go7007/s2250-board.c   | 2 +-
 drivers/media/usb/go7007/snd-go7007.c    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 390f66ec8fd2..f8c06b2f9d2f 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -699,5 +699,5 @@ struct go7007 *go7007_alloc(const struct go7007_board_info *board,
 	struct go7007 *go;
 	int i;
 
-	go = kzalloc(sizeof(struct go7007), GFP_KERNEL);
+	go = kzalloc(sizeof(*go), GFP_KERNEL);
 	if (!go)
diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 5ad40b77763d..f0f70a92541a 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1122,5 +1122,5 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	if (!go)
 		return -ENOMEM;
 
-	usb = kzalloc(sizeof(struct go7007_usb), GFP_KERNEL);
+	usb = kzalloc(sizeof(*usb), GFP_KERNEL);
 	if (!usb) {
diff --git a/drivers/media/usb/go7007/s2250-board.c b/drivers/media/usb/go7007/s2250-board.c
index d987c5f2b45a..1fd4c09dd516 100644
--- a/drivers/media/usb/go7007/s2250-board.c
+++ b/drivers/media/usb/go7007/s2250-board.c
@@ -515,5 +515,5 @@ static int s2250_probe(struct i2c_client *client,
 	if (!audio)
 		return -ENOMEM;
 
-	state = kzalloc(sizeof(struct s2250), GFP_KERNEL);
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state) {
diff --git a/drivers/media/usb/go7007/snd-go7007.c b/drivers/media/usb/go7007/snd-go7007.c
index 4e612cf1afd9..68e421bf38e1 100644
--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -235,5 +235,5 @@ int go7007_snd_init(struct go7007 *go)
 		dev++;
 		return -ENOENT;
 	}
-	gosnd = kmalloc(sizeof(struct go7007_snd), GFP_KERNEL);
+	gosnd = kmalloc(sizeof(*gosnd), GFP_KERNEL);
 	if (!gosnd)
-- 
2.14.1
