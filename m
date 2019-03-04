Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833E3C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DB97208E4
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfCDU3e (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 15:29:34 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:33047 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDU3e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 15:29:34 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MfL5v-1hTeGI1x75-00gsto; Mon, 04 Mar 2019 21:29:21 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yong Zhi <yong.zhi@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: staging/intel-ipu3: mark PM function as __maybe_unused
Date:   Mon,  4 Mar 2019 21:29:10 +0100
Message-Id: <20190304202920.1845797-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Oduro/Z8h4f5zL2ki3+FwzaOFf6y8ct9rHJB4s1ikIYed/yz0Sx
 KyNx1kehdv+RMNHC2Chnl7puMV5q0Z325d9kP+itNV5O7uUYh/px+s6UBM1YpQL83cTNAbN
 MbcOM+uVYMwkgKveOfkeJ/CwBUY/rRM4BeXqVR3cEQGgCD6ZIW6UNcINFcUnVMnzme/LU0E
 WO3VPEO9iT4cv7ksFDNIg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:it6ue09fJrc=:xsYpVCAeJEPrGT9Ih0EeyT
 KGREskLgibWH0MrImXPTPEb8ayfoMN/Ekj5+mk54XxFXJoZUeseub/g3bMNjazi3Q407JqrSM
 RHfSlRCZby9Xni073jL4vWCQvMbbb51kso6Tp5VUfv3sjUlcc6UDQ2n6avNmzAvYA75eNoqnB
 Gq9hic5EpjPk7yMwH5GBYAhfvXsqWMcHCVQAT4xBTIZYnOULgyfThX66ETOyN39ZBnuFuTsdt
 h65vR+DD+DEXjMOy7P3XrGp7CVoQGtOWUoa9ezym+xZzebjstHkPpe7xxyVjO9WBckunq6w6B
 AQY3dzFRc8mN0KLhO+XAeMxvzIVyLluGXyODgmFqxWFLgPDMpvQljtD1caERTKkWlwE6vREMJ
 5eZAfxeWeInEfbIfcS1Od/U00BZTTBHsUqUe8Z4R+KpHFMcn3tlKjpQYTXbzCbaKeUgiLIro7
 +SXTTHtzYCHNblZhwUtt9Yuri23kSMiBoB5bGuutlKeES/gfhj0yKIb8wfEwpsPUv2Q6tmGmk
 ZZ6d9hgkqD5BNq/QZwbuOOQtW2AQTcRbeM6xsthkLm4U3BMB3XEzRAqYs5ZA2hZRmKBG41D/s
 UQwN1K0C/qplcRVeRrFZ7x7vR2oFdNaMdq3T2MwkENOLANwfL5tS0vtFX+pjHH9sILz/vPYT5
 bUInKgmC1dA2r5mTIWZYM68JYPLoR12Zql6v40NQ0+mAsW5ppiOz3r6yWudQg5s4mNhxC89bc
 If3oaMpdEzL75UNQO76T1L6W63qP5OJHWvaDfA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The imgu_rpm_dummy_cb() looks like an API misuse that is explained
in the comment above it. Aside from that, it also causes a warning
when power management support is disabled:

drivers/staging/media/ipu3/ipu3.c:794:12: error: 'imgu_rpm_dummy_cb' defined but not used [-Werror=unused-function]

The warning is at least easy to fix by marking the function as
__maybe_unused.

Fixes: 7fc7af649ca7 ("media: staging/intel-ipu3: Add imgu top level pci device driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/ipu3/ipu3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
index d575ac78c8f0..d00d26264c37 100644
--- a/drivers/staging/media/ipu3/ipu3.c
+++ b/drivers/staging/media/ipu3/ipu3.c
@@ -791,7 +791,7 @@ static int __maybe_unused imgu_resume(struct device *dev)
  * PCI rpm framework checks the existence of driver rpm callbacks.
  * Place a dummy callback here to avoid rpm going into error state.
  */
-static int imgu_rpm_dummy_cb(struct device *dev)
+static __maybe_unused int imgu_rpm_dummy_cb(struct device *dev)
 {
 	return 0;
 }
-- 
2.20.0

