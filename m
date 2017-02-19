Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35625 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbdBSNIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 08:08:02 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] saa7134: constify nxt200x_config structures
Date: Sun, 19 Feb 2017 18:36:38 +0530
Message-Id: <1487509598-26237-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare nxt200x_config structures as const as they are only passed as
an argument to the function dvb_attach. dvb_attach calls its first
argument on the rest of its arguments. The first argument of
dvb_attach in the changed cases is nxt200x_attach and the parameter of
this function to which the object references are passed is of type
const. So, nxt200x_config structures having this property can be made
const.

File size before:
   text	   data	    bss	    dec	    hex	filename
  21320	   3776	     16	  25112	   6218	saa7134/saa7134-dvb.o

File size after:
   text	   data	    bss	    dec	    hex	filename
  21384	   3744	     16	  25144	   6238	saa7134/saa7134-dvb.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/saa7134/saa7134-dvb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 598b8bb..36156f1 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1046,11 +1046,11 @@ static int md8800_set_high_voltage2(struct dvb_frontend *fe, long arg)
  * nxt200x based ATSC cards, helper functions
  */
 
-static struct nxt200x_config avertvhda180 = {
+static const struct nxt200x_config avertvhda180 = {
 	.demod_address    = 0x0a,
 };
 
-static struct nxt200x_config kworldatsc110 = {
+static const struct nxt200x_config kworldatsc110 = {
 	.demod_address    = 0x0a,
 };
 
-- 
1.9.1
