Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D323C04EBF
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 12:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1D1120838
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 12:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1D1120838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zte.com.cn
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbeLFMbi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 07:31:38 -0500
Received: from out1.zte.com.cn ([202.103.147.172]:55164 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728764AbeLFMbi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 07:31:38 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 519B5EE1C76C85211367;
        Thu,  6 Dec 2018 20:29:38 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id wB6CTY2M056602;
        Thu, 6 Dec 2018 20:29:34 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from LIN-A6CB96A0603.zte.intra ([10.90.106.118])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2018120620300448-15142737 ;
          Thu, 6 Dec 2018 20:30:04 +0800 
From:   Wen Yang <wen.yang99@zte.com.cn>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhong.weidong@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] media: siano: Use kmemdup instead of duplicating its function
Date:   Thu, 6 Dec 2018 20:29:10 +0800
Message-Id: <20181206122910.50908-1-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2018-12-06 20:30:04,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2018-12-06 20:29:22
Content-Transfer-Encoding: quoted-printable
X-MAIL: mse01.zte.com.cn wB6CTY2M056602
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

kmemdup has implemented the function that kmalloc() + memcpy().
We prefer to kmemdup rather than code opened implementation.

This issue was detected with the help of coccinelle.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
CC: linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/media/usb/siano/smsusb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/sms=
usb.c
index be3634407f1f..2ffded08407b 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -225,10 +225,9 @@ static int smsusb=5Fsendrequest(void *context, void *b=
uffer, size=5Ft size)
 		return -ENOENT;
 	}
=20
-	phdr =3D kmalloc(size, GFP=5FKERNEL);
+	phdr =3D kmemdup(buffer, size, GFP=5FKERNEL);
 	if (!phdr)
 		return -ENOMEM;
-	memcpy(phdr, buffer, size);
=20
 	pr=5Fdebug("sending %s(%d) size: %d\n",
 		  smscore=5Ftranslate=5Fmsg(phdr->msg=5Ftype), phdr->msg=5Ftype,
--=20
2.19.1

