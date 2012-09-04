Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43111 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213Ab2IDONH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2012 10:13:07 -0400
Received: from localhost.localdomain (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q84Ejliv007234
	for <linux-media@vger.kernel.org>; Tue, 4 Sep 2012 15:45:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] cx88: Fix reset delays
To: linux-media@vger.kernel.org
Date: Tue, 04 Sep 2012 15:30:49 +0100
Message-ID: <20120904143042.9024.62031.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

This was reported in March 2011 by Mirek Slugen, and a simple fix posted at the time then
never got fixed and applied. The bug is still present.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=37703
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/pci/cx88/cx88-cards.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 4e9d4f7..0c25524 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -3028,9 +3028,9 @@ static int cx88_xc3028_winfast1800h_callback(struct cx88_core *core,
 		cx_set(MO_GP1_IO, 0x1010);
 		mdelay(50);
 		cx_clear(MO_GP1_IO, 0x10);
-		mdelay(50);
+		mdelay(75);
 		cx_set(MO_GP1_IO, 0x10);
-		mdelay(50);
+		mdelay(75);
 		return 0;
 	}
 	return -EINVAL;

