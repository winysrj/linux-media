Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43246 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751664AbeFWPge (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:34 -0400
Received: by mail-wr0-f195.google.com with SMTP id p14-v6so629976wrq.10
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:33 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 17/19] [media] ddbridge/sx8: disable automatic PLS code search
Date: Sat, 23 Jun 2018 17:36:13 +0200
Message-Id: <20180623153615.27630-18-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The SX8 cards by default do an automatic search for the PLS code. This
is not necessarily wanted as this can eventually be detected wrong, so
disable this.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-sx8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-sx8.c b/drivers/media/pci/ddbridge/ddbridge-sx8.c
index 1a12f2105490..c87cefa10762 100644
--- a/drivers/media/pci/ddbridge/ddbridge-sx8.c
+++ b/drivers/media/pci/ddbridge/ddbridge-sx8.c
@@ -292,7 +292,7 @@ static int start(struct dvb_frontend *fe, u32 flags, u32 modmask, u32 ts_config)
 	cmd.dvbs2_search.frequency = p->frequency * 1000;
 	cmd.dvbs2_search.symbol_rate = p->symbol_rate;
 	cmd.dvbs2_search.scrambling_sequence_index =
-		p->scrambling_sequence_index;
+		p->scrambling_sequence_index | 0x80000000;
 	cmd.dvbs2_search.input_stream_id =
 		(p->stream_id != NO_STREAM_ID_FILTER) ? p->stream_id : 0;
 	cmd.tuner = state->mci.tuner;
-- 
2.16.4
