Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:59448 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726253AbeHULAn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 07:00:43 -0400
Subject: [PATCH 8/6] codec-fwht.h: update two cframe_hdr references in
 comments.
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180821073119.3662-1-hverkuil@xs4all.nl>
 <20180821073119.3662-7-hverkuil@xs4all.nl>
 <9cf8a2a2-a97c-9c8f-462f-c696e7dd01ce@xs4all.nl>
Message-ID: <907ed857-5326-4e1f-eab4-8993f79f80c8@xs4all.nl>
Date: Tue, 21 Aug 2018 09:41:36 +0200
MIME-Version: 1.0
In-Reply-To: <9cf8a2a2-a97c-9c8f-462f-c696e7dd01ce@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cframe_hdr has been renamed to fwht_cframe_hdr, but the old name
was still used in two comments.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/codec-fwht.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index dce376c516d0..1f9e47331197 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -12,7 +12,7 @@
 #include <asm/byteorder.h>

 /*
- * The compressed format consists of a cframe_hdr struct followed by the
+ * The compressed format consists of a fwht_cframe_hdr struct followed by the
  * compressed frame data. The header contains the size of that data.
  * Each Y, Cb and Cr plane is compressed separately. If the compressed
  * size of each plane becomes larger than the uncompressed size, then
@@ -35,7 +35,7 @@
  *
  * All 16 and 32 bit values are stored in big-endian (network) order.
  *
- * Each cframe_hdr starts with an 8 byte magic header that is
+ * Each fwht_cframe_hdr starts with an 8 byte magic header that is
  * guaranteed not to occur in the compressed frame data. This header
  * can be used to sync to the next frame.
  *
-- 
2.18.0
