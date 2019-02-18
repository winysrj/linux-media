Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E3BC00319
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 21:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367572146E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 21:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbfBRV7r convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:59:47 -0500
Received: from mail-oln040092067037.outbound.protection.outlook.com ([40.92.67.37]:42336
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731180AbfBRV7l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 16:59:41 -0500
Received: from VE1EUR02FT036.eop-EUR02.prod.protection.outlook.com
 (10.152.12.57) by VE1EUR02HT198.eop-EUR02.prod.protection.outlook.com
 (10.152.13.158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1580.10; Mon, 18 Feb
 2019 21:59:38 +0000
Received: from AM3PR03MB0966.eurprd03.prod.outlook.com (10.152.12.51) by
 VE1EUR02FT036.mail.protection.outlook.com (10.152.13.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 18 Feb 2019 21:59:37 +0000
Received: from AM3PR03MB0966.eurprd03.prod.outlook.com
 ([fe80::8011:1f4d:3804:e5f3]) by AM3PR03MB0966.eurprd03.prod.outlook.com
 ([fe80::8011:1f4d:3804:e5f3%10]) with mapi id 15.20.1622.018; Mon, 18 Feb
 2019 21:59:37 +0000
From:   Jonas Karlman <jonas@kwiboo.se>
To:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Karlman <jonas@kwiboo.se>
Subject: [PATCH 3/3] [media] rc/keymaps: add keytable for Khadas IR Remote
 Controller
Thread-Topic: [PATCH 3/3] [media] rc/keymaps: add keytable for Khadas IR
 Remote Controller
Thread-Index: AQHUx9U9SlIP3cAbvU2gDJwFK8tikg==
Date:   Mon, 18 Feb 2019 21:59:37 +0000
Message-ID: <AM3PR03MB096636BBCC606FCC3584951BAC630@AM3PR03MB0966.eurprd03.prod.outlook.com>
References: <20190218215915.2782-1-jonas@kwiboo.se>
In-Reply-To: <20190218215915.2782-1-jonas@kwiboo.se>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P189CA0034.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:206:15::47) To AM3PR03MB0966.eurprd03.prod.outlook.com
 (2a01:111:e400:884c::23)
x-incomingtopheadermarker: OriginalChecksum:667E64F9963CDDE5295112FBE3B1104E97C85E940A1C963AB07C0AA7339E397A;UpperCasedChecksum:F74164071DE9B40BB8C59177B1A33A916AF9E25FA3087CFA042F5C1C9909AF38;SizeAsReceived:8553;Count:64
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-tmn:  [NJDBw00T8u8Q5FFzspkuMsLiw4LaEGio]
x-microsoft-original-message-id: <20190218215915.2782-4-jonas@kwiboo.se>
x-ms-publictraffictype: Email
x-incomingheadercount: 64
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119070)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031322404)(2017031323274)(2017031324274)(1601125500)(1603101475)(1701031045);SRVR:VE1EUR02HT198;
x-ms-traffictypediagnostic: VE1EUR02HT198:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:VE1EUR02HT198;BCL:0;PCL:0;RULEID:;SRVR:VE1EUR02HT198;
x-microsoft-antispam-message-info: NP+86YAvJnOD9qkFWJ819TCFtA4yNR0kFM+f7/dTeDuOzMvakFK1VrZBRPJr8f3T
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-Network-Message-Id: bd89d5a7-0e69-4e23-253c-08d695ec5fd1
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2019 21:59:37.0175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR02HT198
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The mouse button key did not have an obvious target and
was mapped to KEY_CONTEXT_MENU.

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
---
 drivers/media/rc/keymaps/Makefile    |  1 +
 drivers/media/rc/keymaps/rc-khadas.c | 46 ++++++++++++++++++++++++++++
 include/media/rc-map.h               |  1 +
 3 files changed, 48 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-khadas.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 591a6ab25895..f3e9c0ccb6e9 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-it913x-v1.o \
 			rc-it913x-v2.o \
 			rc-kaiomy.o \
+			rc-khadas.o \
 			rc-kworld-315u.o \
 			rc-kworld-pc150u.o \
 			rc-kworld-plus-tv-analog.o \
diff --git a/drivers/media/rc/keymaps/rc-khadas.c b/drivers/media/rc/keymaps/rc-khadas.c
new file mode 100644
index 000000000000..e88c66903c8c
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-khadas.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Keytable for Khadas IR Remote Controller
+// Copyright (c) 2018 Jonas Karlman
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table khadas[] = {
+	{ 0x01, KEY_BACK },
+	{ 0x02, KEY_DOWN },
+	{ 0x03, KEY_UP },
+	{ 0x07, KEY_OK },
+	{ 0x0b, KEY_VOLUMEUP },
+	{ 0x0e, KEY_LEFT },
+	{ 0x13, KEY_MENU },
+	{ 0x14, KEY_POWER },
+	{ 0x1a, KEY_RIGHT },
+	{ 0x48, KEY_HOME },
+	{ 0x58, KEY_VOLUMEDOWN },
+	{ 0x5b, KEY_CONTEXT_MENU },
+};
+
+static struct rc_map_list khadas_map = {
+	.map = {
+		.scan     = khadas,
+		.size     = ARRAY_SIZE(khadas),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_KHADAS,
+	}
+};
+
+static int __init init_rc_map_khadas(void)
+{
+	return rc_map_register(&khadas_map);
+}
+
+static void __exit exit_rc_map_khadas(void)
+{
+	rc_map_unregister(&khadas_map);
+}
+
+module_init(init_rc_map_khadas)
+module_exit(exit_rc_map_khadas)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jonas Karlman");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 6d2f4da07807..d15585f6b1eb 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -218,6 +218,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_IT913X_V1                 "rc-it913x-v1"
 #define RC_MAP_IT913X_V2                 "rc-it913x-v2"
 #define RC_MAP_KAIOMY                    "rc-kaiomy"
+#define RC_MAP_KHADAS                    "rc-khadas"
 #define RC_MAP_KWORLD_315U               "rc-kworld-315u"
 #define RC_MAP_KWORLD_PC150U             "rc-kworld-pc150u"
 #define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
-- 
2.17.1

