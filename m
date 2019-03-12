Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B469C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 22:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F8AD214AE
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 22:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfCLWqg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 18:46:36 -0400
Received: from gofer.mess.org ([88.97.38.141]:44153 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfCLWqg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 18:46:36 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 3B61260664; Tue, 12 Mar 2019 22:46:35 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] lircd2toml: toggle_bit is offset from bits including pre-data
Date:   Tue, 12 Mar 2019 22:46:35 +0000
Message-Id: <20190312224635.24037-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This causes the following lircd.conf to be converted incorrectly.

	http://lirc.sourceforge.net/remotes/cambridge_audio/X40A

Signed-off-by: Sean Young <sean@mess.org>
---
 contrib/lircd2toml.py | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/contrib/lircd2toml.py b/contrib/lircd2toml.py
index f9408ecc..72ee50e3 100755
--- a/contrib/lircd2toml.py
+++ b/contrib/lircd2toml.py
@@ -404,18 +404,18 @@ class Converter:
 
         bits = int(self.remote['bits'][0])
 
-        toggle_bit = 0
-        if 'toggle_bit_mask' in self.remote:
-            toggle_bit = ffs(int(self.remote['toggle_bit_mask'][0]))
-        if 'toggle_bit' in self.remote:
-            toggle_bit = bits - int(self.remote['toggle_bit'][0])
-
         pre_data = 0
         if 'pre_data_bits' in self.remote:
             pre_data_bits = int(self.remote['pre_data_bits'][0])
             pre_data = int(self.remote['pre_data'][0]) << bits
             bits += pre_data_bits
 
+        toggle_bit = 0
+        if 'toggle_bit_mask' in self.remote:
+            toggle_bit = ffs(int(self.remote['toggle_bit_mask'][0]))
+        if 'toggle_bit' in self.remote:
+            toggle_bit = bits - int(self.remote['toggle_bit'][0])
+
         if 'plead' in self.remote:
             plead = self.remote['plead'][0]
             one_pulse = self.remote['one'][0]
-- 
2.20.1

