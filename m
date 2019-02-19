Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6029AC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 17:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 398252147A
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 17:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbfBSRCX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 12:02:23 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:58081 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729574AbfBSRCW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 12:02:22 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MF3Y8-1gpUx110si-00FOyH; Tue, 19 Feb 2019 18:02:11 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Mark Brown <broonie@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] media: saa7146: avoid high stack usage with clang
Date:   Tue, 19 Feb 2019 18:01:56 +0100
Message-Id: <20190219170209.4180739-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:f17Grli5DiRWtm73DDP6MNHKjIcKP4kUCt8yTLp1WethQDw9LhW
 qv86EcVZ/81xQ0kMCKXjaTBoXe5EdOh41HcBu5xWyUC2y7BFAftViI8ub9GwaSCBNDN0uPW
 5pI9Jt4lbcbCyGrRFCjeKsXR2CtrWzoZKAmSxU+Xb4U01pEzkoCRPJrmPmyD5H43DTQVwN9
 L7Ecjvy/jLZUkdyu0kPGQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:57pD253Ows8=:gcY+mv6OFOSjxIulmh/3Jw
 cEouaU5dMvs1jIrYO8aOahIOtngKiWVd/mMZHUlHXbjipUQxAP52lRYQug3vsFyE1iaixK58c
 rg+kXHvDqKlbosy316li/b+UoIQKYRP54s/ckL8kfj5/UCX3IICntAAOaEeWSuIStaBEN9EGR
 JjUcfAejsssIgnkVhujdW2lEVaV4yUMajz9PElOvsJfd2rcur8Lcxx/8gJYMUlSHWfr4TxNMr
 tw41a1M1236lAJaiDAK3x6kiEdVjovE2G/Bu1IbdF8u7HfR0D3b1oJRijZURHdWdbwLJNkDrZ
 l6A/fx/8KGQvimSEUyfTiolG4ThpVE8n5OZkuMJzCsabWxaaUa1B9ke9O1nJMYowM7hD2W/tH
 5eiK1siQmUwCoN4WVioZfwZOFJPemBNWtCoePKuG+OwwJ94okVajNlSMA8jRw9FXBUevfY909
 ARMXbxhcW6LgUb8URBzFAzktp1Ali0IERlCxetQkGDtE+FI7CEFnD/9AmmdWLZavFmsitO23C
 zSywski7VY0C1IOLVogZRBv0u6r9QiBoZ6Sqokrby2Tyn7Y5GRZNe/y9yzeKg3HwjRm7W96uR
 wIAhF12t/G5bB11xaJ0ytt/lgO/uJVfPpUyzpxtazjHCdbT05GUasNwMDDwpICtd+86DiDuNH
 TEqPmK1kKXDo7ryTBrM1CK8F01zBThcL6A+g07sKO2FYFtF0QYdYxqwWtSOaMWdqP5JU9QehE
 y8lYGj1Pis+RTS5NT6KqZFFgoWAD1vw8ge737w==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Two saa7146/hexium files contain a construct that causes a warning
when built with clang:

drivers/media/pci/saa7146/hexium_orion.c:210:12: error: stack frame size of 2272 bytes in function 'hexium_probe'
      [-Werror,-Wframe-larger-than=]
static int hexium_probe(struct saa7146_dev *dev)
           ^
drivers/media/pci/saa7146/hexium_gemini.c:257:12: error: stack frame size of 2304 bytes in function 'hexium_attach'
      [-Werror,-Wframe-larger-than=]
static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
           ^

This one happens regardless of KASAN, and the problem is that a
constructor to initalize a dynamically allocated structure leads
to a copy of that structure on the stack, whereas gcc initializes
it in place.

Link: https://bugs.llvm.org/show_bug.cgi?id=40776
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/saa7146/hexium_gemini.c | 4 +---
 drivers/media/pci/saa7146/hexium_orion.c  | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index 5817d9cde4d0..f7ce0e1770bf 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -270,9 +270,7 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	/* enable i2c-port pins */
 	saa7146_write(dev, MC1, (MASK_08 | MASK_24 | MASK_10 | MASK_26));
 
-	hexium->i2c_adapter = (struct i2c_adapter) {
-		.name = "hexium gemini",
-	};
+	strscpy(hexium->i2c_adapter.name, "hexium gemini", sizeof(hexium->i2c_adapter.name));
 	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
 	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
 		DEB_S("cannot register i2c-device. skipping.\n");
diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
index 0a05176c18ab..b9f4a09c744d 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -231,9 +231,7 @@ static int hexium_probe(struct saa7146_dev *dev)
 	saa7146_write(dev, DD1_STREAM_B, 0x00000000);
 	saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
 
-	hexium->i2c_adapter = (struct i2c_adapter) {
-		.name = "hexium orion",
-	};
+	strscpy(hexium->i2c_adapter.name, "hexium orion", sizeof(hexium->i2c_adapter.name));
 	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
 	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
 		DEB_S("cannot register i2c-device. skipping.\n");
-- 
2.20.0

