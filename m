Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38105 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3BGIY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 03:24:59 -0500
Date: Thu, 7 Feb 2013 11:24:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] dvb-usb: check for invalid length in
 ttusb_process_muxpack()
Message-ID: <20130207082449.GA18610@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205201001.60fe547e@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is driven by a static checker warning.

The ttusb_process_muxpack() function is only called from
ttusb_process_frame().  Before calling, it verifies that len >= 2.  The
problem is that len == 2 is not valid and would lead to an array
underflow.

Odd number values for len are also invalid and would lead to reading
past the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Moved the check from the caller into the function.  Added a check
for odd values.  Added an error message.  Increment the numinvalid
counter.

diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index 5b682cc..e407185 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -561,6 +561,13 @@ static void ttusb_process_muxpack(struct ttusb *ttusb, const u8 * muxpack,
 {
 	u16 csum = 0, cc;
 	int i;
+
+	if (len < 4 || len & 0x1) {
+		pr_warn("%s: muxpack has invalid len %d\n", __func__, len);
+		numinvalid++;
+		return;
+	}
+
 	for (i = 0; i < len; i += 2)
 		csum ^= le16_to_cpup((__le16 *) (muxpack + i));
 	if (csum) {
