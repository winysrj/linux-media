Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38828 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751202AbdGPIIB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 04:08:01 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: dvb-core/demux.h: fix kernel-doc warning
Message-ID: <4da6d9c7-f19e-ea6a-9a66-380ca7f20efd@xs4all.nl>
Date: Sun, 16 Jul 2017 10:07:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this kernel-doc warning:

WARNING: kernel-doc 'media-git/scripts/kernel-doc -rst -enable-lineno media-git/drivers/media/dvb-core/demux.h' processing failed with: 'ascii' codec can't decode byte 0xe2 in position 6368: ordinal
not in range(128)

Caused by using fancy quotes instead of regular quotes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index f854309ba8a5..c4df6cee48e6 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -210,7 +210,7 @@ struct dmx_section_feed {
  * the start of the first undelivered TS packet within a circular buffer.
  * The @buffer2 buffer parameter is normally NULL, except when the received
  * TS packets have crossed the last address of the circular buffer and
- * ”wrapped” to the beginning of the buffer. In the latter case the @buffer1
+ * "wrapped" to the beginning of the buffer. In the latter case the @buffer1
  * parameter would contain an address within the circular buffer, while the
  * @buffer2 parameter would contain the first address of the circular buffer.
  * The number of bytes delivered with this function (i.e. @buffer1_length +
