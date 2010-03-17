Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:53325 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0CQPMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 11:12:08 -0400
Date: Wed, 17 Mar 2010 18:11:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ivtv: sizeof() => ARRAY_SIZE()
Message-ID: <20100317151156.GG5331@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a smatch warning:
drivers/media/video/ivtv/ivtv-vbi.c +138 ivtv_write_vbi(43) 
	error: buffer overflow 'vi->cc_payload' 256 <= 1023

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/ivtv/ivtv-vbi.c b/drivers/media/video/ivtv/ivtv-vbi.c
index f420d31..d73af45 100644
--- a/drivers/media/video/ivtv/ivtv-vbi.c
+++ b/drivers/media/video/ivtv/ivtv-vbi.c
@@ -134,7 +134,7 @@ void ivtv_write_vbi(struct ivtv *itv, const struct v4l2_sliced_vbi_data *sliced,
 			}
 		}
 	}
-	if (found_cc && vi->cc_payload_idx < sizeof(vi->cc_payload)) {
+	if (found_cc && vi->cc_payload_idx < ARRAY_SIZE(vi->cc_payload)) {
 		vi->cc_payload[vi->cc_payload_idx++] = cc;
 		set_bit(IVTV_F_I_UPDATE_CC, &itv->i_flags);
 	}
