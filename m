Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33754 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdH1XKS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 19:10:18 -0400
To: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 2/2] media: dvb-core: fix demux.h non-ASCII characters
Message-ID: <5fb15c64-e376-f461-8a7c-d0c6776870c9@infradead.org>
Date: Mon, 28 Aug 2017 16:10:16 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix non-ASCII charactes in kernel-doc comment to prevent the kernel-doc
build warning below.

WARNING: kernel-doc '../scripts/kernel-doc -rst -enable-lineno ../drivers/media/dvb-core/demux.h' processing failed with: 'ascii' codec can't decode byte 0xe2 in position 6368: ordinal not in range(128)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/media/dvb-core/demux.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-413-rc7.orig/drivers/media/dvb-core/demux.h
+++ lnx-413-rc7/drivers/media/dvb-core/demux.h
@@ -210,7 +210,7 @@ struct dmx_section_feed {
  * the start of the first undelivered TS packet within a circular buffer.
  * The @buffer2 buffer parameter is normally NULL, except when the received
  * TS packets have crossed the last address of the circular buffer and
- * ”wrapped” to the beginning of the buffer. In the latter case the @buffer1
+ * "wrapped" to the beginning of the buffer. In the latter case the @buffer1
  * parameter would contain an address within the circular buffer, while the
  * @buffer2 parameter would contain the first address of the circular buffer.
  * The number of bytes delivered with this function (i.e. @buffer1_length +
