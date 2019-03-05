Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DE0C4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 15:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38EDC20848
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 15:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfCEPYL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 10:24:11 -0500
Received: from gofer.mess.org ([88.97.38.141]:46177 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbfCEPYK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 10:24:10 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 5292960298; Tue,  5 Mar 2019 15:24:08 +0000 (GMT)
Date:   Tue, 5 Mar 2019 15:24:08 +0000
From:   Sean Young <sean@mess.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ettore Chimenti <ek5.chimenti@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: [linux-next:master 1790/12310]
 drivers/media/platform/seco-cec/seco-cec.c:355: undefined reference to
 `devm_rc_allocate_device'
Message-ID: <20190305152407.xxhjg27nvpfrxppv@gofer.mess.org>
References: <201903052237.gt4I65bn%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201903052237.gt4I65bn%fengguang.wu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 05, 2019 at 10:53:40PM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   baf5a9d1f9b95eb97e9eb54932e20dbbf814771c
> commit: f27dd0ad68850fdb806536a733a32d8f74810f1e [1790/12310] media: seco-cec: fix RC_CORE dependency
> config: x86_64-randconfig-s5-03051951 (attached as .config)
> compiler: gcc-8 (Debian 8.3.0-2) 8.3.0
> reproduce:
>         git checkout f27dd0ad68850fdb806536a733a32d8f74810f1e
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    ld: drivers/media/platform/seco-cec/seco-cec.o: in function `secocec_ir_probe':
> >> drivers/media/platform/seco-cec/seco-cec.c:355: undefined reference to `devm_rc_allocate_device'
> >> ld: drivers/media/platform/seco-cec/seco-cec.c:395: undefined reference to `devm_rc_register_device'
>    ld: drivers/media/platform/seco-cec/seco-cec.o: in function `secocec_ir_rx':
> >> drivers/media/platform/seco-cec/seco-cec.c:432: undefined reference to `rc_keydown'
> 
> vim +355 drivers/media/platform/seco-cec/seco-cec.c
> 
> b03c2fb9 Ettore Chimenti 2018-10-21  345  
> daef9576 Ettore Chimenti 2018-10-21  346  #ifdef CONFIG_VIDEO_SECO_RC
> daef9576 Ettore Chimenti 2018-10-21  347  static int secocec_ir_probe(void *priv)
> daef9576 Ettore Chimenti 2018-10-21  348  {
> daef9576 Ettore Chimenti 2018-10-21  349  	struct secocec_data *cec = priv;
> daef9576 Ettore Chimenti 2018-10-21  350  	struct device *dev = cec->dev;
> daef9576 Ettore Chimenti 2018-10-21  351  	int status;
> daef9576 Ettore Chimenti 2018-10-21  352  	u16 val;
> daef9576 Ettore Chimenti 2018-10-21  353  
> daef9576 Ettore Chimenti 2018-10-21  354  	/* Prepare the RC input device */
> daef9576 Ettore Chimenti 2018-10-21 @355  	cec->ir = devm_rc_allocate_device(dev, RC_DRIVER_SCANCODE);

So the config has:

CONFIG_CEC_CORE=y
CONFIG_RC_CORE=m
CONFIG_VIDEO_SECO_CEC=y
CONFIG_VIDEO_SECO_RC=y

So devm_rc_allocate_device() is in a module, while seco-cec is not.
CONFIG_VIDEO_SECO_RC itself is a boolean and depends on CONFIG_RC_CORE.


Sean

From f0f5df60c88075162483965014f9319d19f121d2 Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Tue, 5 Mar 2019 15:14:40 +0000
Subject: [PATCH] media: seco-cec: depend on CONFIG_RC_CORE=y when not a module

Ensure that if seco-cec is not compiled as a module, then neither
should rc-core. Found by 0-day.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 4acbed189644..02756c018c0f 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -649,7 +649,7 @@ config VIDEO_SECO_CEC
 config VIDEO_SECO_RC
 	bool "SECO Boards IR RC5 support"
 	depends on VIDEO_SECO_CEC
-	depends on RC_CORE
+	depends on RC_CORE=y || (RC_CORE=m && VIDEO_SECO_CEC=m)
 	help
 	  If you say yes here you will get support for the
 	  SECO Boards Consumer-IR in seco-cec driver.
-- 
2.20.1

