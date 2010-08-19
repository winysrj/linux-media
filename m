Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65229 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0HSKBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Aug 2010 06:01:07 -0400
Date: Thu, 19 Aug 2010 12:00:22 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] V4L/DVB: saa7164: move dereference under NULL check
Message-ID: <20100819100022.GA6674@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The original code dereferenced "port" before checking it for NULL.  I
moved the test down below the check.  Also I changed the comparisons a
little so people wouldn't get confused and think "port" and "buf" were
ints instead of pointers.  (Probably that's what lead to this issue in
the first place.)

There is only one caller for this function and it passes non-NULL
pointers, so this is essentially a cleanup rather than a bugfix.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/saa7164/saa7164-buffer.c b/drivers/media/video/saa7164/saa7164-buffer.c
index 5713f3a..ddd25d3 100644
--- a/drivers/media/video/saa7164/saa7164-buffer.c
+++ b/drivers/media/video/saa7164/saa7164-buffer.c
@@ -136,10 +136,11 @@ ret:
 int saa7164_buffer_dealloc(struct saa7164_tsport *port,
 	struct saa7164_buffer *buf)
 {
-	struct saa7164_dev *dev = port->dev;
+	struct saa7164_dev *dev;
 
-	if ((buf == 0) || (port == 0))
+	if (!buf || !port)
 		return SAA_ERR_BAD_PARAMETER;
+	dev = port->dev;
 
 	dprintk(DBGLVL_BUF, "%s() deallocating buffer @ 0x%p\n", __func__, buf);
 

