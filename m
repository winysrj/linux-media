Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:51802 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728717AbeHWLif (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 07:38:35 -0400
Subject: [PATCHv2 8/7] codec-fwht: fix out-of-range values when decoding
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180823073305.6518-1-hverkuil@xs4all.nl>
 <20180823073305.6518-8-hverkuil@xs4all.nl>
Message-ID: <b84cc6b3-74e3-b0aa-6949-f05c781b927d@xs4all.nl>
Date: Thu, 23 Aug 2018 10:10:05 +0200
MIME-Version: 1.0
In-Reply-To: <20180823073305.6518-8-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While decoding you need to make sure you do not get values < 0
or > 255. Note that since this code will also be used in userspace
utilities the clamp macro isn't used since that is kernel-only.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/codec-fwht.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index f91f90f7e5fc..47939160560e 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -625,8 +625,14 @@ static void fill_decoder_block(u8 *dst, const s16 *input, int stride)
 	int i, j;

 	for (i = 0; i < 8; i++) {
-		for (j = 0; j < 8; j++)
-			*dst++ = *input++;
+		for (j = 0; j < 8; j++, input++, dst++) {
+			if (*input < 0)
+				*dst = 0;
+			else if (*input > 255)
+				*dst = 255;
+			else
+				*dst = *input;
+		}
 		dst += stride - 8;
 	}
 }
-- 
2.18.0
