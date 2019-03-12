Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A42AC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 06:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4E062147C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 06:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfCLGqD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 02:46:03 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:24561 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbfCLGqC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 02:46:02 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2C6alST026105;
        Tue, 12 Mar 2019 07:45:52 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2r43u3052s-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 12 Mar 2019 07:45:52 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id BF9D131;
        Tue, 12 Mar 2019 06:45:51 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id A17CB14AA;
        Tue, 12 Mar 2019 06:45:51 +0000 (GMT)
Received: from SAFEX1HUBCAS23.st.com (10.75.90.47) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.435.0; Tue, 12 Mar
 2019 07:45:51 +0100
Received: from localhost (10.129.172.100) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.435.0; Tue, 12 Mar 2019 07:45:50
 +0100
From:   Mickael Guene <mickael.guene@st.com>
To:     <linux-media@vger.kernel.org>
CC:     Mickael Guene <mickael.guene@st.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 3/3] media: MAINTAINERS: add entry for STMicroelectronics MIPID02 media driver
Date:   Tue, 12 Mar 2019 07:44:05 +0100
Message-ID: <1552373045-134493-4-git-send-email-mickael.guene@st.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.129.172.100]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-12_05:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add maintainer entry for the STMicroelectronics MIPID02 CSI-2 to PARALLEL
bridge driver and dt-bindings.

Signed-off-by: Mickael Guene <mickael.guene@st.com>
---

 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1c6ecae..4bd36b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14424,6 +14424,14 @@ S:	Maintained
 F:	drivers/iio/imu/st_lsm6dsx/
 F:	Documentation/devicetree/bindings/iio/imu/st_lsm6dsx.txt
 
+ST MIPID02 CSI-2 TO PARALLEL BRIDGE DRIVER
+M:	Mickael Guene <mickael.guene@st.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/st-mipid02.c
+F:	Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
+
 ST STM32 I2C/SMBUS DRIVER
 M:	Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
 L:	linux-i2c@vger.kernel.org
-- 
2.7.4

