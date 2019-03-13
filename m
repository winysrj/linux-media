Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97937C10F03
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 16:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 658B620643
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 16:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfCMQA7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 12:00:59 -0400
Received: from gofer.mess.org ([88.97.38.141]:60095 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfCMQA7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 12:00:59 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id C55F36076A; Wed, 13 Mar 2019 16:00:57 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 2/2] lircd2toml: detect NEC if bit 0 and 1 are inverted
Date:   Wed, 13 Mar 2019 16:00:57 +0000
Message-Id: <20190313160057.3470-2-sean@mess.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190313160057.3470-1-sean@mess.org>
References: <20190313160057.3470-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This fixes conversion of:

	http://lirc.sourceforge.net/remotes/goldstar/VCR

Signed-off-by: Sean Young <sean@mess.org>
---
 contrib/lircd2toml.py | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/contrib/lircd2toml.py b/contrib/lircd2toml.py
index f2f7cdd3..b1aa2403 100755
--- a/contrib/lircd2toml.py
+++ b/contrib/lircd2toml.py
@@ -340,6 +340,42 @@ class Converter:
 
             if variant:
                 res['params']['variant'] = "'" + variant + "'"
+        elif ('header_pulse' in res['params'] and
+            'header_space' in res['params'] and
+            'reverse' not in res['params'] and
+            'trailer_pulse' in res['params'] and
+            'header_optional' not in res['params'] and
+            'pulse_distance' == res['protocol'] and
+            eq_margin(res['params']['header_pulse'], 9000, 1000) and
+            eq_margin(res['params']['header_space'], 4500, 1000) and
+            eq_margin(res['params']['bit_pulse'], 560, 300) and
+            eq_margin(res['params']['bit_1_space'], 560, 300) and
+            eq_margin(res['params']['bit_0_space'], 1680, 300) and
+            eq_margin(res['params']['trailer_pulse'], 560, 300) and
+            res['params']['bits'] == 32 and
+            ('repeat_pulse' not in res['params'] or
+             (eq_margin(res['params']['repeat_pulse'], 9000, 1000) and
+              eq_margin(res['params']['repeat_space'], 2250, 1000)))):
+            self.warning('remote looks exactly like NEC, converting')
+            res['protocol'] = 'nec'
+            res['params'] = {}
+            # bit_0_space and bit_1_space have been swapped, scancode
+            # will need to be inverted
+
+            variant = None
+
+            for s in self.remote['codes']:
+                p = (s<<post_data_bits)|pre_data
+                v, n = decode_nec_scancode(~p)
+                if variant == None:
+                    variant = v
+                elif v != variant:
+                    variant = ""
+
+                res['map'][n] = self.remote['codes'][s]
+
+            if variant:
+                res['params']['variant'] = "'" + variant + "'"
         else:
             for s in self.remote['codes']:
                 p = (s<<post_data_bits)|pre_data
-- 
2.11.0

