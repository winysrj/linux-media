Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38405 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936498AbcJVOeU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 10:34:20 -0400
Received: by mail-wm0-f52.google.com with SMTP id c78so35804735wme.1
        for <linux-media@vger.kernel.org>; Sat, 22 Oct 2016 07:34:19 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: mchehab@kernel.org
Cc: stable@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, maintainers@bluecherrydvr.com,
        andrey_utkin@fastmail.com, ismael@iodev.co.uk, hverkuil@xs4all.nl,
        hans.verkuil@cisco.com, khalasa@piap.pl,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH v2] media: solo6x10: fix lockup by avoiding delayed register write
Date: Sat, 22 Oct 2016 16:34:36 +0100
Message-Id: <20161022153436.12076-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a lockup at device probing which happens on some solo6010
hardware samples. This is a regression introduced by commit e1ceb25a1569
("[media] SOLO6x10: remove unneeded register locking and barriers")

The observed lockup happens in solo_set_motion_threshold() called from
solo_motion_config().

This extra "flushing" is not fundamentally needed for every write, but
apparently the code in driver assumes such behaviour at last in some
places.

Actual fix was proposed by Hans Verkuil.

Fixes: e1ceb25a1569 ("[media] SOLO6x10: remove unneeded register locking and barriers")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
This is a second submission, the first one was
"[PATCH] [media] solo6x10: avoid delayed register write" from 22 Sep 2016,
with same content.

Dear maintainers - please take this at last into v4.9 if possible.

Changes since v1:
 - changed subject to show that this fixes a lockup
 - added Cc: stable
 - added Fixes: tag

 drivers/media/pci/solo6x10/solo6x10.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 5bd4987..3f8da5e 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -284,7 +284,10 @@ static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
 static inline void solo_reg_write(struct solo_dev *solo_dev, int reg,
 				  u32 data)
 {
+	u16 val;
+
 	writel(data, solo_dev->reg_base + reg);
+	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);
 }
 
 static inline void solo_irq_on(struct solo_dev *dev, u32 mask)
-- 
2.10.1

