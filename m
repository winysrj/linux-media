Return-Path: <SRS0=+2CU=RU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17A3C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 13:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7673620828
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 13:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbfCQNXh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Mar 2019 09:23:37 -0400
Received: from gofer.mess.org ([88.97.38.141]:35779 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfCQNXg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Mar 2019 09:23:36 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id B64E5601BD; Sun, 17 Mar 2019 13:23:35 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] lircd2toml: convert lircd.conf rc6 remote definitions
Date:   Sun, 17 Mar 2019 13:23:35 +0000
Message-Id: <20190317132335.32234-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Sean Young <sean@mess.org>
---
 contrib/lircd2toml.py | 63 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/contrib/lircd2toml.py b/contrib/lircd2toml.py
index b1aa2403..9b93f198 100755
--- a/contrib/lircd2toml.py
+++ b/contrib/lircd2toml.py
@@ -218,6 +218,8 @@ class Converter:
 
         if 'rc5' in flags or 'shift_enc' in flags:
             return self.convert_rc5()
+        elif 'rc6' in flags:
+            return self.convert_rc6()
         elif 'rcmm' in flags:
             return self.convert_rcmm()
         elif 'space_enc' in flags:
@@ -425,6 +427,65 @@ class Converter:
 
         return res
 
+    def convert_rc6(self):
+        res = {
+            'protocol': 'rc-6',
+            'params': { },
+            'map': { }
+        }
+
+        res['name'] = self.remote['name']
+
+        if 'codes' not in self.remote or len(self.remote['codes']) == 0:
+            self.error("missing codes section")
+            return None
+
+        bits = int(self.remote['bits'][0])
+
+        pre_data = 0
+        if 'pre_data_bits' in self.remote:
+            pre_data_bits = int(self.remote['pre_data_bits'][0])
+            pre_data = int(self.remote['pre_data'][0]) << bits
+            bits += pre_data_bits
+
+        toggle_bit = 0
+        if 'toggle_bit_mask' in self.remote:
+            toggle_bit = ffs(int(self.remote['toggle_bit_mask'][0]))
+        if 'toggle_bit' in self.remote:
+            toggle_bit = bits - int(self.remote['toggle_bit'][0])
+
+        mask = (1<<(bits-5))-1
+        if toggle_bit >= 0 and toggle_bit < bits:
+            res['params']['toggle_bit'] = toggle_bit
+            mask &= ~(1<<toggle_bit)
+
+        # lircd explicitly encoded the five leading bits (start, 3 mode
+        # bits, toggle). rc-core does not, so we need to strip the first
+        # five bits.
+        bits -= 5
+        vendor = 0
+        res['params']['bits'] = bits
+        for s in self.remote['codes']:
+            # lircd inverts all the bits (not sure why), rc-core encoding
+            # matches https://www.sbprojects.net/knowledge/ir/rc6.php
+            d = ~(s|pre_data)&mask
+            if bits == 32:
+                vendor = d >> 16
+            res['map'][d] = self.remote['codes'][s]
+
+        if bits == 16:
+            res['params']['variant'] = "'rc-6-0'"
+        elif bits == 20:
+            res['params']['variant'] = "'rc-6-6a-20'"
+        elif bits == 24:
+            res['params']['variant'] = "'rc-6-6a-24'"
+        elif bits == 32 and vendor != 0x800f:
+            res['params']['variant'] = "'rc-6-6a-32'"
+        elif bits == 32 and vendor == 0x800f:
+            res['params']['variant'] = "'rc-6-mce'"
+
+        return res
+
     def convert_rc5(self):
         if 'one' not in self.remote or 'zero' not in self.remote:
             self.error("broken, missing parameter for 'zero' and 'one'")
@@ -533,7 +594,7 @@ parser = argparse.ArgumentParser(description="""Convert lircd.conf to rc-core to
 This program atempts to convert a lircd.conf remote definition to a
 ir-keytable toml format. This process is not perfect, and the result
 might need some tweaks for it to work. Please report any issues to
-linux-media@vger,kernel,org. If you have successfully generated and
+linux-media@vger.kernel.org. If you have successfully generated and
 tested a toml keymap, please send it to the same mailinglist so it
 can be include with the package.""")
 
-- 
2.20.1

