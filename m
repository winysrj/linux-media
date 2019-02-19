Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02ABC4360F
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 17:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89FC0217D9
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 17:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbfBSRCl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 12:02:41 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:41431 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbfBSRCj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 12:02:39 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N1g3U-1h2v7v0rTE-0121Q1; Tue, 19 Feb 2019 18:02:31 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Mark Brown <broonie@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dafna Hirschfeld <dafna3@gmail.com>,
        Tom aan de Wiel <tom.aandewiel@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] media: vicodec: avoic clang frame size warning
Date:   Tue, 19 Feb 2019 18:01:57 +0100
Message-Id: <20190219170209.4180739-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190219170209.4180739-1-arnd@arndb.de>
References: <20190219170209.4180739-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:g3znxI/S5xnDkg9Wo/D5wh5t5Hsi2OmQeyEHXvKEecfS9DuX84+
 nY1feFvodvSCf3T+Iq/YOia9EwfUqYXvmR7TgseZOfxNmKk/1XgqE5pPLzwWEYQkmqC+h+J
 TpRBpS5grwf9zvHmB3wkDZc4pG3yk1uzCQ1ymjBWJIS0dEPFGKE0LbK3zMdoiY5He+dQTDI
 ogBqLHSjrrQVq8o0FnGZQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:NjfAPwaaOKc=:GfqSa4Qkn5dajg+UW9UJm8
 xhxtplujGY28bIVix3xacsMgHfW0xT0G/CV9Vf6BDeWkUvUiSYvfOYeZOlx05igtmixda2MoE
 v0NajU7//WYKQj5X+D4ZgJT8+i1mKIgAYM8IURdJhhNreyrWghF/CK+w0WJOPQKEN2Xk8xpVt
 IRfaiQFkSRZw91at/GguaxdIXM6u7l88aWRiWskbb1e0CyQMuzj80lkwLI62MYYkVtT0FIYRX
 bv+EFnUVrmUSfZetZyirHIuc5B/fzbs4cnlLZnmzhIMuo50gq1J02TYmFnvUD+xaRfGowkJw3
 1pDsCqr1Zhrhi19w+EKmmQQLQZxIClV6urxEXlsVsrQW05vfxynwJGDtZXDE3JpqQTQ4DJeFd
 aYlBb+EsJoIKZXQu0GhHq8y5j82tGDaVDWpGgQiD72bBOllq4aM1iw2bkC5ION0JrR0+IYUFy
 pP07acz9PzNeMWGdL18fIpZAH/7LwrAwcFlZli3mdldlfHnkOA/fhU3y4WkHdiixUkRVTD8Pj
 m9+DKUQ/+59dCxLYi7baGl61636ttT87d3LuXyyp+JcVg3posMFSbExp9cUnVtRjdXgDHM3fS
 IiEiX8IXfVG5/odYvO+e0HmtBZyx7iwZYecLbN1Yr8Zcqn1Yqghlp9pJEuPAMA+dT9z+K/zRz
 c02B/dZcEyDvEVyEIe8c0NI3cGjpVDp6PCWdHBIhVTGi7+j62tAfPYi2pM6xAff8lv+B6M2vt
 Oh2TOUGeLFsPHNy/pe2EzpK8VOLhPmtaImUnHw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Clang-9 makes some different inlining decisions compared to gcc, which
leads to a warning about a possible stack overflow problem when building
with CONFIG_KASAN, including when setting asan-stack=0, which avoids
most other frame overflow warnings:

drivers/media/platform/vicodec/codec-fwht.c:673:12: error: stack frame size of 2224 bytes in function 'encode_plane'

Manually adding noinline_for_stack annotations in those functions
called by encode_plane() or decode_plane() that require a significant
amount of kernel stack makes this impossible to happen with any
compiler.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/vicodec/codec-fwht.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index d1d6085da9f1..135d56bcc2c5 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -47,7 +47,7 @@ static const uint8_t zigzag[64] = {
 };
 
 
-static int rlc(const s16 *in, __be16 *output, int blocktype)
+static int noinline_for_stack rlc(const s16 *in, __be16 *output, int blocktype)
 {
 	s16 block[8 * 8];
 	s16 *wp = block;
@@ -106,8 +106,8 @@ static int rlc(const s16 *in, __be16 *output, int blocktype)
  * This function will worst-case increase rlc_in by 65*2 bytes:
  * one s16 value for the header and 8 * 8 coefficients of type s16.
  */
-static u16 derlc(const __be16 **rlc_in, s16 *dwht_out,
-		 const __be16 *end_of_input)
+static noinline_for_stack u16
+derlc(const __be16 **rlc_in, s16 *dwht_out, const __be16 *end_of_input)
 {
 	/* header */
 	const __be16 *input = *rlc_in;
@@ -373,7 +373,8 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
  * Furthermore values can be negative... This is just a version that
  * works with 16 signed data
  */
-static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
+static void noinline_for_stack
+fwht16(const s16 *block, s16 *output_block, int stride, int intra)
 {
 	/* we'll need more than 8 bits for the transformed coefficients */
 	s32 workspace1[8], workspace2[8];
@@ -456,7 +457,8 @@ static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
 	}
 }
 
-static void ifwht(const s16 *block, s16 *output_block, int intra)
+static noinline_for_stack void
+ifwht(const s16 *block, s16 *output_block, int intra)
 {
 	/*
 	 * we'll need more than 8 bits for the transformed coefficients
@@ -604,9 +606,9 @@ static int var_inter(const s16 *old, const s16 *new)
 	return ret;
 }
 
-static int decide_blocktype(const u8 *cur, const u8 *reference,
-			    s16 *deltablock, unsigned int stride,
-			    unsigned int input_step)
+static noinline_for_stack int
+decide_blocktype(const u8 *cur, const u8 *reference, s16 *deltablock,
+		 unsigned int stride, unsigned int input_step)
 {
 	s16 tmp[64];
 	s16 old[64];
-- 
2.20.0

