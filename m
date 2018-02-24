Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:43328 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbeBXSzr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 13:55:47 -0500
Received: by mail-wr0-f194.google.com with SMTP id u49so17217199wrc.10
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 10:55:47 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 10/12] [media] ngene: don't treat non-existing demods as error
Date: Sat, 24 Feb 2018 19:55:32 +0100
Message-Id: <20180224185534.13792-11-d.scheller.oss@gmail.com>
In-Reply-To: <20180224185534.13792-1-d.scheller.oss@gmail.com>
References: <20180224185534.13792-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

When probing the I2C busses in cineS2_probe(), it's no error when there's
no hardware connected to the probed expansion connector, so print this
informal message with info severity.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index d603d0af703e..37e9f0eb6d20 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -728,7 +728,7 @@ static int cineS2_probe(struct ngene_channel *chan)
 		dev_info(pdev, "STV0367 on channel %d\n", chan->number);
 		demod_attach_stv0367(chan, i2c);
 	} else {
-		dev_err(pdev, "No demod found on chan %d\n", chan->number);
+		dev_info(pdev, "No demod found on chan %d\n", chan->number);
 		return -ENODEV;
 	}
 	return 0;
-- 
2.16.1
