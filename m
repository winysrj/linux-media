Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36133 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbdGAL2F (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Jul 2017 07:28:05 -0400
Received: by mail-wm0-f45.google.com with SMTP id 62so130254184wmw.1
        for <linux-media@vger.kernel.org>; Sat, 01 Jul 2017 04:28:05 -0700 (PDT)
Date: Sat, 1 Jul 2017 15:26:01 +0400
From: Anton Sviridenko <anton@corp.bluecherry.net>
To: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] solo6x10: fix detection of TW2864B chips
Message-ID: <20170701112558.GA18352@magpie-gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enables support for non-Bluecherry labeled solo6110
based PCI cards which have 3 x TW2864B chips and one TW2865.
These cards are displayed by lspci -nn as

"Softlogic Co., Ltd. SOLO6110 H.264 Video encoder/decoder [9413:6110]"

Bluecherry cards have 4 x TW2864A. According to datasheet register 0xFF
of TW2864B chips contains value 0x6A or 0x6B depending on revision 
which being shifted 3 bits right gives value 0x0d.
Existing version of solo6x10 fails on these cards with

[276582.344942] solo6x10 0000:07:00.0: Probing Softlogic 6110
[276582.402151] solo6x10 0000:07:00.0: Could not initialize any techwell chips
[276582.402781] solo6x10: probe of 0000:07:00.0 failed with error -22

Signed-off-by: Anton Sviridenko <anton@corp.bluecherry.net>
---
 drivers/media/pci/solo6x10/solo6x10-tw28.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/solo6x10/solo6x10-tw28.c b/drivers/media/pci/solo6x10/solo6x10-tw28.c
index 0632d3f7c73c..c74a0fdb35fb 100644
--- a/drivers/media/pci/solo6x10/solo6x10-tw28.c
+++ b/drivers/media/pci/solo6x10/solo6x10-tw28.c
@@ -606,6 +606,7 @@ int solo_tw28_init(struct solo_dev *solo_dev)
 			solo_dev->tw28_cnt++;
 			break;
 		case 0x0c:
+		case 0x0d:
 			solo_dev->tw2864 |= 1 << i;
 			solo_dev->tw28_cnt++;
 			break;
-- 
2.13.0
