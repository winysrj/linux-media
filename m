Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3111 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1HYOIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/12] ddbridge: fix compiler warnings
Date: Thu, 25 Aug 2011 16:08:28 +0200
Message-Id: <882dc54d7b7c9535c3ba4f3ee4d9cffadb4384b5.1314281302.git.hans.verkuil@cisco.com>
In-Reply-To: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
References: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
References: <afd314e95a520c3a4de0f112735d1d5584ec8a9a.1314281302.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l-dvb-git/drivers/media/dvb/ddbridge/ddbridge-core.c: In function 'ddb_input_read':
v4l-dvb-git/drivers/media/dvb/ddbridge/ddbridge-core.c:515:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
v4l-dvb-git/drivers/media/dvb/ddbridge/ddbridge-core.c:514:11: warning: variable 'off' set but not used [-Wunused-but-set-variable]

'off' was unused and 'ret' really had to be used to return -EFAULT.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index 573d540..d2e85ea 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -507,15 +507,14 @@ static u32 ddb_input_avail(struct ddb_input *input)
 	return 0;
 }
 
-static size_t ddb_input_read(struct ddb_input *input, u8 *buf, size_t count)
+static ssize_t ddb_input_read(struct ddb_input *input, u8 *buf, size_t count)
 {
 	struct ddb *dev = input->port->dev;
 	u32 left = count;
-	u32 idx, off, free, stat = input->stat;
+	u32 idx, free, stat = input->stat;
 	int ret;
 
 	idx = (stat >> 11) & 0x1f;
-	off = (stat & 0x7ff) << 7;
 
 	while (left) {
 		if (input->cbuf == idx)
@@ -525,6 +524,8 @@ static size_t ddb_input_read(struct ddb_input *input, u8 *buf, size_t count)
 			free = left;
 		ret = copy_to_user(buf, input->vbuf[input->cbuf] +
 				   input->coff, free);
+		if (ret)
+			return -EFAULT;
 		input->coff += free;
 		if (input->coff == input->dma_buf_size) {
 			input->coff = 0;
@@ -939,6 +940,8 @@ static ssize_t ts_read(struct file *file, char *buf,
 				break;
 		}
 		read = ddb_input_read(input, buf, left);
+		if (read < 0)
+			return read;
 		left -= read;
 		buf += read;
 	}
-- 
1.7.5.4

