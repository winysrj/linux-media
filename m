Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:45844 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751812AbdLQPlB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 10:41:01 -0500
Received: by mail-wm0-f67.google.com with SMTP id 9so25050479wme.4
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 07:41:01 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 7/8] [media] ddbridge: detach first input if the second one failed to init
Date: Sun, 17 Dec 2017 16:40:48 +0100
Message-Id: <20171217154049.1125-8-d.scheller.oss@gmail.com>
In-Reply-To: <20171217154049.1125-1-d.scheller.oss@gmail.com>
References: <20171217154049.1125-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

In ddb_ports_attach(), if the second input of a dual tuner failed to
initialise, the first one can be detached (and resources be freed) as
this will be counted as the whole port having failed to initialise,
thus the first one won't be used anyway.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 548b7047ca09..940371067346 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1935,8 +1935,10 @@ static int ddb_port_attach(struct ddb_port *port)
 		if (ret < 0)
 			break;
 		ret = dvb_input_attach(port->input[1]);
-		if (ret < 0)
+		if (ret < 0) {
+			dvb_input_detach(port->input[0]);
 			break;
+		}
 		port->input[0]->redi = port->input[0];
 		port->input[1]->redi = port->input[1];
 		break;
-- 
2.13.6
