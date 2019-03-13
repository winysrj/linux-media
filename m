Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3657C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 16:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB5DA206DF
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 16:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfCMQA7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 12:00:59 -0400
Received: from gofer.mess.org ([88.97.38.141]:52131 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfCMQA7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 12:00:59 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id AB37160DAC; Wed, 13 Mar 2019 16:00:57 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 1/2] lircd2toml: honour pre_data for rc-mm remote definitions
Date:   Wed, 13 Mar 2019 16:00:56 +0000
Message-Id: <20190313160057.3470-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 contrib/lircd2toml.py | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/contrib/lircd2toml.py b/contrib/lircd2toml.py
index 72ee50e3..f2f7cdd3 100755
--- a/contrib/lircd2toml.py
+++ b/contrib/lircd2toml.py
@@ -349,7 +349,7 @@ class Converter:
 
     def convert_rcmm(self):
         res  = {
-            'protocol': 'rc_mm',
+            'protocol': 'rc-mm',
             'params': {},
             'map': {}
         }
@@ -368,16 +368,24 @@ class Converter:
         if 'toggle_bit' in self.remote:
             toggle_bit = bits - int(self.remote['toggle_bit'][0])
 
-        if toggle_bit > 0 and toggle_bit < bits:
-            res['params']['toggle_bit'] = toggle_bit
-
-        res['params']['bits'] = bits
-
         if 'codes' not in self.remote or len(self.remote['codes']) == 0:
             self.error("missing codes section")
             return None
 
-        res['map'] = self.remote['codes']
+        if 'pre_data_bits' in self.remote:
+            pre_data_bits = int(self.remote['pre_data_bits'][0])
+            pre_data = int(self.remote['pre_data'][0]) << bits
+            bits += pre_data_bits
+            for s in self.remote['codes']:
+                res['map'][s|pre_data] = self.remote['codes'][s]
+        else:
+            res['map'] = self.remote['codes']
+
+        res['params']['bits'] = bits
+        res['params']['variant'] = "'rc-mm-" + str(bits) + "'"
+
+        if toggle_bit > 0 and toggle_bit < bits:
+            res['params']['toggle_bit'] = toggle_bit
 
         return res
 
-- 
2.11.0

