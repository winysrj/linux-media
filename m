Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:60895 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0J3URs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Oct 2010 16:17:48 -0400
Subject: [PATCH] drivers/media/IR/ir-keytable.c: fix binary search
To: torvalds@linux-foundation.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, dmitry.torokhov@gmail.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	mchehab@infradead.org
Date: Sat, 30 Oct 2010 22:17:44 +0200
Message-ID: <20101030201744.2964.20624.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The input-large-scancode patches changed the binary search in
drivers/media/IR/ir-keytable.c to use unsigned integers, but
signed integers are actually necessary for the algorithm to work.

Signed-off-by: David Härdeman <david@hardeman.nu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/media/IR/ir-keytable.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 9186b45..647d52b 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -325,9 +325,9 @@ static int ir_setkeytable(struct ir_input_dev *ir_dev,
 static unsigned int ir_lookup_by_scancode(const struct ir_scancode_table *rc_tab,
 					  unsigned int scancode)
 {
-	unsigned int start = 0;
-	unsigned int end = rc_tab->len - 1;
-	unsigned int mid;
+	int start = 0;
+	int end = rc_tab->len - 1;
+	int mid;
 
 	while (start <= end) {
 		mid = (start + end) / 2;

