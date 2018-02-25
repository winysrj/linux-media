Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34890 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbeBYMby (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 07:31:54 -0500
Received: by mail-wm0-f67.google.com with SMTP id x7so9987570wmc.0
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 04:31:54 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 10/12] [media] ngene: don't treat non-existing demods as error
Date: Sun, 25 Feb 2018 13:31:38 +0100
Message-Id: <20180225123140.19486-11-d.scheller.oss@gmail.com>
In-Reply-To: <20180225123140.19486-1-d.scheller.oss@gmail.com>
References: <20180225123140.19486-1-d.scheller.oss@gmail.com>
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
