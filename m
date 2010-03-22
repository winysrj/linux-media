Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54321 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0CVMI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 08:08:59 -0400
Date: Mon, 22 Mar 2010 15:08:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Steven Toth <stoth@kernellabs.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] cx23885: strcpy() => strlcpy()
Message-ID: <20100322120849.GF21571@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cap->driver is a 16 char buffer and dev->name is a 32 char buffer.
I don't see an actual problem, but we may as well make the static
checkers happy.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index 2ab97ad..6fff89d 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1355,7 +1355,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct cx23885_dev *dev = fh->dev;
 	struct cx23885_tsport  *tsport = &dev->ts1;
 
-	strcpy(cap->driver, dev->name);
+	strlcpy(cap->driver, dev->name, sizeof(cap->driver));
 	strlcpy(cap->card, cx23885_boards[tsport->dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
