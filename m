Return-path: <linux-media-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:63512 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab3CYDWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 23:22:46 -0400
Message-ID: <514FC2E9.9090300@asianux.com>
Date: Mon, 25 Mar 2013 11:22:17 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] drivers/staging/media/go7007: using strlcpy instead of strncpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


  for NUL terminated string, need always set '\0' in the end.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/staging/media/go7007/saa7134-go7007.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index cf7c34a..2d1c6c2 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -456,7 +456,7 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 	if (go == NULL)
 		goto allocfail;
 	go->board_id = GO7007_BOARDID_PCI_VOYAGER;
-	strncpy(go->name, saa7134_boards[dev->board].name, sizeof(go->name));
+	strlcpy(go->name, saa7134_boards[dev->board].name, sizeof(go->name));
 	go->hpi_ops = &saa7134_go7007_hpi_ops;
 	go->hpi_context = saa;
 	saa->dev = dev;
-- 
1.7.7.6
