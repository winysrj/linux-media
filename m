Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B0BC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 10:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A4F92075D
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 10:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730751AbfCZKFA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 06:05:00 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:65396 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbfCZKFA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 06:05:00 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2Q9ugbv026877;
        Tue, 26 Mar 2019 11:03:49 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2rddhbgpqb-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 26 Mar 2019 11:03:49 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 39C963F;
        Tue, 26 Mar 2019 10:03:48 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas22.st.com [10.75.90.92])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id DEF6F5166;
        Tue, 26 Mar 2019 10:03:47 +0000 (GMT)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas22.st.com
 (10.75.90.92) with Microsoft SMTP Server (TLS) id 14.3.361.1; Tue, 26 Mar
 2019 11:03:47 +0100
Received: from localhost (10.129.172.100) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.361.1; Tue, 26 Mar 2019 11:03:47
 +0100
From:   Mickael Guene <mickael.guene@st.com>
To:     <linux-media@vger.kernel.org>
CC:     <hugues.fruchet@st.com>, Mickael Guene <mickael.guene@st.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        <devicetree@vger.kernel.org>,
        "Todor Tomov" <todor.tomov@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Ben Kao <ben.kao@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Petr Cvek <petrcvekcz@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Rob Herring" <robh+dt@kernel.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Ricardo Ribalda Delgado <ricardo@ribalda.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH v3 0/2] Add support for MIPID02 CSI-2 to PARALLEL bridge I2C device
Date:   Tue, 26 Mar 2019 11:03:38 +0100
Message-ID: <1553594620-88280-1-git-send-email-mickael.guene@st.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.129.172.100]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-26_05:,,
 signatures=0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

This is the v3 of my MIPID02 series which introduces support of
STMicroelectronics MIPID02 CSI-2 to PARALLEL I2C bridge. It allows using a CSI-2
sensor with a PARALLEL interface. Current driver implementation doesn't support
CSI-2 second input port usage. It doesn't support also YUV420, RGB565 and RGB444
input formats.

Thanks to Sakari for review.

Changes in v3:
- Fix potential wrong error code for mipid02_stream_disable and mipid02_stream_enable
- Remove useless memset for ep in mipid02_parse_rx_ep and mipid02_parse_tx_ep
- Add second CSI-2 input pad even if it's not yet supported
- Add support of get_fmt, set_fmt and link_validate and only access subdev connected to mipid02

Changes in v2:
- Add precision about first CSI-2 port data rate
- Document endpoints supported properties
- Rename 'mipid02@14' into generic 'csi2rx@14' in example
- Merge MAINTAINERS patch 3 into patch 1 and 2
- Fix line too long in Kconfig
- Add missing delay after reset release
- Various style fixes
- Fix mipid02_stream_enable returning no error when mipid02_find_sensor failed

Mickael Guene (2):
  dt-bindings: Document MIPID02 bindings
  media:st-mipid02: MIPID02 CSI-2 to PARALLEL bridge driver

 .../bindings/media/i2c/st,st-mipid02.txt           |   83 ++
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |   14 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/st-mipid02.c                     | 1012 ++++++++++++++++++++
 5 files changed, 1118 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/st,st-mipid02.txt
 create mode 100644 drivers/media/i2c/st-mipid02.c

-- 
2.7.4

