Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74EB9C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 22:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F1E2146E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 22:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731196AbfBRV7j convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:59:39 -0500
Received: from mail-oln040092069087.outbound.protection.outlook.com ([40.92.69.87]:11232
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731106AbfBRV7j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 16:59:39 -0500
Received: from VE1EUR02FT036.eop-EUR02.prod.protection.outlook.com
 (10.152.12.55) by VE1EUR02HT168.eop-EUR02.prod.protection.outlook.com
 (10.152.13.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1580.10; Mon, 18 Feb
 2019 21:59:35 +0000
Received: from AM3PR03MB0966.eurprd03.prod.outlook.com (10.152.12.51) by
 VE1EUR02FT036.mail.protection.outlook.com (10.152.13.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 18 Feb 2019 21:59:35 +0000
Received: from AM3PR03MB0966.eurprd03.prod.outlook.com
 ([fe80::8011:1f4d:3804:e5f3]) by AM3PR03MB0966.eurprd03.prod.outlook.com
 ([fe80::8011:1f4d:3804:e5f3%10]) with mapi id 15.20.1622.018; Mon, 18 Feb
 2019 21:59:35 +0000
From:   Jonas Karlman <jonas@kwiboo.se>
To:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Karlman <jonas@kwiboo.se>
Subject: [PATCH 0/3] Add keytable for Pine64, ODROID and Khadas IR Remote
Thread-Topic: [PATCH 0/3] Add keytable for Pine64, ODROID and Khadas IR Remote
Thread-Index: AQHUx9U8qnXBrkuSvUaWWC57rSIVJg==
Date:   Mon, 18 Feb 2019 21:59:35 +0000
Message-ID: <AM3PR03MB096649526489D5736234395AAC630@AM3PR03MB0966.eurprd03.prod.outlook.com>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P189CA0034.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:206:15::47) To AM3PR03MB0966.eurprd03.prod.outlook.com
 (2a01:111:e400:884c::23)
x-incomingtopheadermarker: OriginalChecksum:C33F02CCA291BD0E311B478AD6F8885BFA17DFE3D07CCF23D6699CBEF0C597D1;UpperCasedChecksum:FAD4B4FFDA041E38A55C00CE8D8D050B65E9B327D08E4CE805459DF147F71C46;SizeAsReceived:8403;Count:62
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-tmn:  [MUXxX8jlv+n615fvJlx0U9HmE93CPiwY]
x-microsoft-original-message-id: <20190218215915.2782-1-jonas@kwiboo.se>
x-ms-publictraffictype: Email
x-incomingheadercount: 62
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:VE1EUR02HT168;
x-ms-traffictypediagnostic: VE1EUR02HT168:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:VE1EUR02HT168;BCL:0;PCL:0;RULEID:;SRVR:VE1EUR02HT168;
x-microsoft-antispam-message-info: RaI258spcdLXQiMewQSqzKIxG/kBLhNZJ6+ox4+Z27uZrXlYfEXdB3Ecjn8gQFdD
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-Network-Message-Id: a14bc635-d681-4f82-207f-08d695ec5e4b
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2019 21:59:34.4614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR02HT168
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add keymaps for the following single board computer vendors IR remotes:
- Pine64 IR Remote
- ODROID IR Remote
- Khadas IR Remote

Regards,
Jonas

Jonas Karlman (3):
  [media] rc/keymaps: add keytable for Pine64 IR Remote Controller
  [media] rc/keymaps: add keytable for ODROID IR Remote Controller
  [media] rc/keymaps: add keytable for Khadas IR Remote Controller

 drivers/media/rc/keymaps/Makefile    |  3 ++
 drivers/media/rc/keymaps/rc-khadas.c | 46 ++++++++++++++++++++++
 drivers/media/rc/keymaps/rc-odroid.c | 46 ++++++++++++++++++++++
 drivers/media/rc/keymaps/rc-pine64.c | 59 ++++++++++++++++++++++++++++
 include/media/rc-map.h               |  3 ++
 5 files changed, 157 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-khadas.c
 create mode 100644 drivers/media/rc/keymaps/rc-odroid.c
 create mode 100644 drivers/media/rc/keymaps/rc-pine64.c

-- 
2.17.1

