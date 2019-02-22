Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9714CC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 14:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F3072075A
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 14:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfBVOud (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:50:33 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:39369 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfBVOuc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 09:50:32 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M3DBb-1h0l3S2JS9-003d51; Fri, 22 Feb 2019 15:50:23 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     natechancellor@gmail.com, ndesaulniers@google.com,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: vicodec: avoic clang frame size warning
Date:   Fri, 22 Feb 2019 15:50:03 +0100
Message-Id: <20190222145021.3518315-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6q78oP8JbTyfawMgSRmmqVIS26D+xz5WfNhWBLJwj4oxFfeg1VY
 29PuVcwSP7iJMboAsM2bTNaKaXRIZVHna2Q7UBQdI6zDiMvt+A00TK48drlh5wSmUEVxT4i
 m1g+A/k6SXPJ4qmD5ODEdTQ9r7Kx7L3FxjrrFS69sRA1TBpA9VyUHJmIeDV2hQveseFCsEK
 WoN3gc7dglbm4t4ni7L7A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hFM/ksKozPg=:t2pf6/7aRLWkjSdPqpRbn7
 3WlqZtBZJzye/tWCdkudLSicWY9MH4Ww/bF8rEPtijZqwK181qeWeRgbgfbzXbgiAP0BV88dp
 pCZ/6J65XM0LHDTeiZVqas73yG66nZyFkCh9+TXf6AspPiPM1pMB5YKbxqAjpw+/xQ1Z/MFcT
 c2HVnSdclWuMqGDTasOtz0CVKB01k9GFw5M9Q1KFMBwEfeBoIgxAjp4P5RRb6dYXK/6A4MfgA
 lixftGjTF8HQYYih0oDxylIwdxdapQ1FrRNeryX/q42R9Wit2+ET/TfDVZzLgo8e3tbJFh+ou
 pIoSB23hEPADjJL15bqQLhn7WWYvgynWUIdk3JefWF/pkt3GNPoeW25jTbwS84BLdHxRwvMn9
 x8w0xeGPxNporqrBzLEsj6pg7j8CTpbN4saemKqFkE8fF/gLEE00q5fHnQ/BUIgB5j+3vO9uL
 /+bGTU7T7fdmS/D4C7XMfP7xhh3crKUfaFv8PExe50NPMJHfGOO+teuca3hJm5KMcePAe9xNF
 OXhmbdkFXXqSzHuErs27J+Q3VdB4udAdybAKRhkmPbbt4ZcDu1LAVGslIERJVXDIsWot44L9j
 W4edbC3NSYk7navyG5U67eliWDo1tPq2SsgxmQq+Cq6wImvq7FHaY6te8Ac4NOTCVQHbh0W24
 6FrCTC5+49Z5yEa7D8J1AdUsEOMlbT1sy/CbuQRKKfahhsMJQjoTJheAM83IimLgMDK+xddow
 HgUN6cQgtiQUVVUQFDdaL01RI1I47mJqCoV5qw==
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
v2: annotate fwht() as well, add a comment
---
 drivers/media/platform/vicodec/codec-fwht.c | 29 +++++++++++++--------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index d1d6085da9f1..a9ae11783c90 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -46,8 +46,12 @@ static const uint8_t zigzag[64] = {
 	63,
 };
 
-
-static int rlc(const s16 *in, __be16 *output, int blocktype)
+/*
+ * noinline_for_stack to work around
+ * https://bugs.llvm.org/show_bug.cgi?id=38809
+ */
+static int noinline_for_stack
+rlc(const s16 *in, __be16 *output, int blocktype)
 {
 	s16 block[8 * 8];
 	s16 *wp = block;
@@ -106,8 +110,8 @@ static int rlc(const s16 *in, __be16 *output, int blocktype)
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
@@ -240,8 +244,9 @@ static void dequantize_inter(s16 *coeff)
 			*coeff <<= *quant;
 }
 
-static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
-		 unsigned int input_step, bool intra)
+static void noinline_for_stack
+fwht(const u8 *block, s16 *output_block, unsigned int stride,
+      unsigned int input_step, bool intra)
 {
 	/* we'll need more than 8 bits for the transformed coefficients */
 	s32 workspace1[8], workspace2[8];
@@ -373,7 +378,8 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
  * Furthermore values can be negative... This is just a version that
  * works with 16 signed data
  */
-static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
+static void noinline_for_stack
+fwht16(const s16 *block, s16 *output_block, int stride, int intra)
 {
 	/* we'll need more than 8 bits for the transformed coefficients */
 	s32 workspace1[8], workspace2[8];
@@ -456,7 +462,8 @@ static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
 	}
 }
 
-static void ifwht(const s16 *block, s16 *output_block, int intra)
+static noinline_for_stack void
+ifwht(const s16 *block, s16 *output_block, int intra)
 {
 	/*
 	 * we'll need more than 8 bits for the transformed coefficients
@@ -604,9 +611,9 @@ static int var_inter(const s16 *old, const s16 *new)
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

