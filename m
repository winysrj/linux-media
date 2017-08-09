Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38228 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752039AbdHIUbn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 16:31:43 -0400
Received: by mail-wr0-f194.google.com with SMTP id g32so5184521wrd.5
        for <linux-media@vger.kernel.org>; Wed, 09 Aug 2017 13:31:42 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v3 10/12] [media] ddbridge: fix dereference before check
Date: Wed,  9 Aug 2017 22:31:26 +0200
Message-Id: <20170809203128.31476-11-d.scheller.oss@gmail.com>
In-Reply-To: <20170809203128.31476-1-d.scheller.oss@gmail.com>
References: <20170809203128.31476-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Both ts_release() and ts_open() can use "output" before check (smatch):

  drivers/media/pci/ddbridge/ddbridge-core.c:816 ts_release() warn: variable dereferenced before check 'output' (see line 809)
  drivers/media/pci/ddbridge/ddbridge-core.c:836 ts_open() warn: variable dereferenced before check 'output' (see line 828)

Fix by performing checks on those pointers.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 1ec3782a6c88..05db3fb98a86 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -738,8 +738,13 @@ static unsigned int ts_poll(struct file *file, poll_table *wait)
 static int ts_release(struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-	struct ddb_input *input = output->port->input[0];
+	struct ddb_output *output = NULL;
+	struct ddb_input *input = NULL;
+
+	if (dvbdev) {
+		output = dvbdev->priv;
+		input = output->port->input[0];
+	}
 
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
 		if (!input)
@@ -757,8 +762,13 @@ static int ts_open(struct inode *inode, struct file *file)
 {
 	int err;
 	struct dvb_device *dvbdev = file->private_data;
-	struct ddb_output *output = dvbdev->priv;
-	struct ddb_input *input = output->port->input[0];
+	struct ddb_output *output = NULL;
+	struct ddb_input *input = NULL;
+
+	if (dvbdev) {
+		output = dvbdev->priv;
+		input = output->port->input[0];
+	}
 
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
 		if (!input)
-- 
2.13.0
