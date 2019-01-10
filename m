Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385D3C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 07:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09B2320685
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 07:55:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Vl4CO/gV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfAJHzg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 02:55:36 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40203 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbfAJHzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 02:55:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AF3FF22709
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 02:55:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 10 Jan 2019 02:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=333s9O
        fNrwWgG77HR6/kjgBHh195x43WYGNwidMQzr4=; b=Vl4CO/gVSHMlKLDFoe1KmR
        yfc9u1L2tcWy17lxGVsBfmtweAjTIkCavLtOUIPusbaV5R0muzd0ndVCjNQaUMAp
        +bOOULzx4in9fMUV44LliJuZ87fwmqI2AqFWAcw2sB6RC3UT/C6H9PghWSfJI8c0
        7HVFTNGkE8qP/vXKI1E2gNk2wsBBHggM0xYvd3/wfitaSTN6rnz5m7h4XPuBsLsA
        8azKFOKIMp3QQBpAi2t6S122BhtCT+t4+ljs/Qdqabo0yLXfXpaY0QWJLakP0u4M
        ky4QF5W/gxjIcYoztrKOAYJCfARGGNOfBESUGwBlZScuDr6n/Ij4JgDdX9L+Wslw
        ==
X-ME-Sender: <xms:dPo2XKgYffC2n0s_ovDQkXXYPo0K3hh3KcptUSZ33kbS8nnImnCCig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrfedvgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhhtnecuuegrihhlohhuthemucef
    tddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefvhffukffffg
    ggtgfgsehtjeertddtfeejnecuhfhrohhmpefgughgrghrucfvhhhivghruceoihhnfhho
    segvughgrghrthhhihgvrhdrnhgvtheqnecukfhppeefuddrvddtledrleehrddvgedvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehinhhfohesvggughgrrhhthhhivghrrdhnvght
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:dPo2XGe94IKWau4ps7YBlt4hZ1uS4QbyfykLKaKsFpRdXZg8VLIzYA>
    <xmx:dPo2XFlCuhjeqarvqJk2Zo7ls7iApe3yDVyGzXr5BTZ7JP7LBmzuSA>
    <xmx:dPo2XHscI1IFr7h9lLFhDkjC2-AOEDdbIxL4HVWqsRGX58M71mFooA>
    <xmx:dPo2XBGHdGpSdnz7L0yJLJD7pLgxw1ak_grkZGKDeYv4XL1piGU99w>
Received: from [192.168.0.111] (unknown [31.209.95.242])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16D4AE41AC
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 02:55:31 -0500 (EST)
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Edgar Thier <info@edgarthier.net>
Subject: [Patch v2] uvcvideo: Add simple packed bayer 12-bit formats
Message-ID: <b9dc4c99-5aaa-db43-f6cb-f829da9fd654@edgarthier.net>
Date:   Thu, 10 Jan 2019 08:55:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


These formats are compressed 12-bit raw bayer formats with four different
pixel orders. They are similar to 10-bit bayer formats 'IPU3'.

Signed-off-by: Edgar Thier <info@edgarthier.net>
---
drivers/media/usb/uvc/uvcvideo.h | 14 +++++++++++++-
1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index e5f5d84f1d1d..3cf4a6d17dc1 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -108,7 +108,19 @@
#define UVC_GUID_FORMAT_RGGB \
{ 'R',  'G',  'G',  'B', 0x00, 0x00, 0x10, 0x00, \
0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
-#define UVC_GUID_FORMAT_BG16 \
+#define UVC_GUID_FORMAT_BG12SP \
+	{ 'B',  'G',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_GB12SP \
+	{ 'G',  'B',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_RG12SP \
+	{ 'R',  'G',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_GR12SP \
+	{ 'G',  'R',  'C',  'p', 0x00, 0x00, 0x10, 0x00, \
+	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BG16                         \
{ 'B',  'G',  '1',  '6', 0x00, 0x00, 0x10, 0x00, \
0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
#define UVC_GUID_FORMAT_GB16 \
--
2.20.1
