Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33073 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754708AbcIVADj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 20:03:39 -0400
Received: by mail-lf0-f53.google.com with SMTP id b71so28061945lfg.0
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2016 17:03:38 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: ismael@iodev.co.uk, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hans.verkuil@cisco.com
Cc: maintainers@bluecherrydvr.com, andrey_utkin@fastmail.com,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] [media] solo6x10: avoid delayed register write
Date: Thu, 22 Sep 2016 03:03:31 +0300
Message-Id: <20160922000331.4193-1-andrey.utkin@corp.bluecherry.net>
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

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
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
2.9.2

