Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEC0C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 06:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7EE3214D8
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 06:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfCLGpb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 02:45:31 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42903 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbfCLGpb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 02:45:31 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2C6aKc3013526;
        Tue, 12 Mar 2019 07:45:07 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2r458m87d1-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 12 Mar 2019 07:45:07 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id CD55F3D;
        Tue, 12 Mar 2019 06:45:04 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 804FA147B;
        Tue, 12 Mar 2019 06:45:04 +0000 (GMT)
Received: from SAFEX1HUBCAS23.st.com (10.75.90.47) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.361.1; Tue, 12 Mar
 2019 07:45:04 +0100
Received: from localhost (10.129.172.100) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.435.0; Tue, 12 Mar 2019 07:45:03
 +0100
From:   Mickael Guene <mickael.guene@st.com>
To:     <linux-media@vger.kernel.org>
CC:     Mickael Guene <mickael.guene@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <devicetree@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Ben Kao <ben.kao@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        "Bingbu Cao" <bingbu.cao@intel.com>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mark Rutland <mark.rutland@arm.com>,
        Jason Chen <jasonx.z.chen@intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH v1 0/3] Add support for MIPID02 CSI-2 to PARALLEL bridge I2C device
Date:   Tue, 12 Mar 2019 07:44:02 +0100
Message-ID: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.129.172.100]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-12_05:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset introduces support of STMicroelectronics MIPID02 CSI-2 to PARALLEL
I2C bridge. It allows using a CSI-2 sensor with a PARALLEL interface.
Current driver implementation doesn't support CSI-2 second input port usage. It
doesn't support also YUV420, RGB565 and RGB444 input formats.


Mickael Guene (3):
  dt-bindings: Document MIPID02 bindings
  media:st-mipid02: MIPID02 CSI-2 to PARALLEL bridge driver
  media: MAINTAINERS: add entry for STMicroelectronics MIPID02 media
    driver

 .../bindings/media/i2c/st,st-mipid02.txt           |  69 ++
 MAINTAINERS                                        |   8 +
 drivers/media/i2c/Kconfig                          |  13 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/st-mipid02.c                     | 878 +++++++++++++++++++++
 5 files changed, 969 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
 create mode 100644 drivers/media/i2c/st-mipid02.c

-- 
2.7.4

