Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BF4C61CE3
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 03:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DBA32087B
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 03:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfATD4p (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 22:56:45 -0500
Received: from www.osadl.org ([62.245.132.105]:54512 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730065AbfATD4p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 22:56:45 -0500
Received: from debian01.hofrr.at (178.115.242.59.static.drei.at [178.115.242.59])
        by www.osadl.org (8.13.8/8.13.8/OSADL-2007092901) with ESMTP id x0K3uIS5027500;
        Sun, 20 Jan 2019 04:56:18 +0100
From:   Nicholas Mc Guire <hofrat@osadl.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Brad Love <brad@nextdimension.cc>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] media: cx23885: check allocation return
Date:   Sun, 20 Jan 2019 04:52:23 +0100
Message-Id: <1547956343-11166-1-git-send-email-hofrat@osadl.org>
X-Mailer: git-send-email 2.1.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Checking of kmalloc() seems to have been committed - as
cx23885_dvb_register() is checking for != 0 return, returning
-ENOMEM should be fine here.  While at it address the coccicheck
suggestion to move to kmemdup rather than using kmalloc+memcpy.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: 46b21bbaa8a8 ("[media] Add support for DViCO FusionHDTV DVB-T Dual Express2")
---
Problem located with an experimental coccinelle script

Patch was compile tested with: x86_64_defconfig + MEDIA_SUPPORT=y
MEDIA_PCI_SUPPORT=y, MEDIA_DIGITAL_TV_SUPPORT=y,
MEDIA_ANALOG_TV_SUPPORT=y (for VIDEO_DEV), RC_CORE=y
VIDEO_CX23885=y

The coccicheck on the initial fix for kmalloc only reported:
drivers/media/pci/cx23885//cx23885-dvb.c:1477:33-40: WARNING opportunity for kmemdup
so that was merged into this patch - the return value still needs to
be checked.

Patch is against 5.0-rc2 (localversion-next is next-20190118)

 drivers/media/pci/cx23885/cx23885-dvb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 0d0929c..225cdfe 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1474,8 +1474,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		if (fe0->dvb.frontend != NULL) {
 			struct i2c_adapter *tun_i2c;
 
-			fe0->dvb.frontend->sec_priv = kmalloc(sizeof(dib7000p_ops), GFP_KERNEL);
-			memcpy(fe0->dvb.frontend->sec_priv, &dib7000p_ops, sizeof(dib7000p_ops));
+			fe0->dvb.frontend->sec_priv = kmemdup(&dib7000p_ops,
+							sizeof(dib7000p_ops),
+							GFP_KERNEL);
+			if (!fe0->dvb.frontend->sec_priv)
+				return -ENOMEM;
 			tun_i2c = dib7000p_ops.get_i2c_master(fe0->dvb.frontend, DIBX000_I2C_INTERFACE_TUNER, 1);
 			if (!dvb_attach(dib0070_attach, fe0->dvb.frontend, tun_i2c, &dib7070p_dib0070_config))
 				return -ENODEV;
-- 
2.1.4

