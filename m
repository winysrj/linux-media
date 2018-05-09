Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51185 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964883AbeEIUIJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 16:08:09 -0400
Received: by mail-wm0-f68.google.com with SMTP id t11-v6so519220wmt.0
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 13:08:08 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mchehab+samsung@kernel.org
Subject: [PATCH 2/4] [media] ddbridge/mci: add identifiers to function definition arguments
Date: Wed,  9 May 2018 22:08:01 +0200
Message-Id: <20180509200803.5253-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180509200803.5253-1-d.scheller.oss@gmail.com>
References: <20180509200803.5253-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes two checkpatch warnings

  WARNING: function definition argument 'xxx' should also have an identifier name

in the ddb_mci_attach() prototype definition. checkpatch keeps complaining
on the "int (**fn_set_input)" as it seems to have issues with the
ptr-to-ptr, though this probably needs fixing in checkpatch.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-mci.c | 2 +-
 drivers/media/pci/ddbridge/ddbridge-mci.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
index 8d9592e75ad5..4ac634fc96e4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
@@ -500,7 +500,7 @@ static int probe(struct mci *state)
 struct dvb_frontend
 *ddb_mci_attach(struct ddb_input *input,
 		int mci_type, int nr,
-		int (**fn_set_input)(struct dvb_frontend *, int))
+		int (**fn_set_input)(struct dvb_frontend *fe, int input))
 {
 	struct ddb_port *port = input->port;
 	struct ddb *dev = port->dev;
diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.h b/drivers/media/pci/ddbridge/ddbridge-mci.h
index 453dcb9f8208..209cc2b92dff 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.h
@@ -151,6 +151,6 @@ struct mci_result {
 struct dvb_frontend
 *ddb_mci_attach(struct ddb_input *input,
 		int mci_type, int nr,
-		int (**fn_set_input)(struct dvb_frontend *, int));
+		int (**fn_set_input)(struct dvb_frontend *fe, int input));
 
 #endif /* _DDBRIDGE_MCI_H_ */
-- 
2.16.1
