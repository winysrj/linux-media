Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE56C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 21:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4B2E2146E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 21:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731276AbfBRV7r convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:59:47 -0500
Received: from mail-oln040092068019.outbound.protection.outlook.com ([40.92.68.19]:34816
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731179AbfBRV7l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 16:59:41 -0500
Received: from VE1EUR02FT036.eop-EUR02.prod.protection.outlook.com
 (10.152.12.52) by VE1EUR02HT048.eop-EUR02.prod.protection.outlook.com
 (10.152.13.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1580.10; Mon, 18 Feb
 2019 21:59:37 +0000
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
Subject: [PATCH 2/3] [media] rc/keymaps: add keytable for ODROID IR Remote
 Controller
Thread-Topic: [PATCH 2/3] [media] rc/keymaps: add keytable for ODROID IR
 Remote Controller
Thread-Index: AQHUx9U9/i+QwFIu3kuz3MVaVQ5Qnw==
Date:   Mon, 18 Feb 2019 21:59:36 +0000
Message-ID: <AM3PR03MB0966D095F9AC8E3443DAE2FBAC630@AM3PR03MB0966.eurprd03.prod.outlook.com>
References: <20190218215915.2782-1-jonas@kwiboo.se>
In-Reply-To: <20190218215915.2782-1-jonas@kwiboo.se>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P189CA0034.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:206:15::47) To AM3PR03MB0966.eurprd03.prod.outlook.com
 (2a01:111:e400:884c::23)
x-incomingtopheadermarker: OriginalChecksum:357AD7A698A4CF7AD55A955019C2F2872048713ED7907486DAE5926129FBD6FD;UpperCasedChecksum:4BCAA5337DFD86A57D4DA9F8EF0C2D8A1F13FF45E156BE0F55E3784ED3B4D29B;SizeAsReceived:8538;Count:64
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-tmn:  [eswB4rJC+sV6BCswO3NIOK0pEXQtLG2W]
x-microsoft-original-message-id: <20190218215915.2782-3-jonas@kwiboo.se>
x-ms-publictraffictype: Email
x-incomingheadercount: 64
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031322404)(2017031323274)(2017031324274)(1601125500)(1603101475)(1701031045);SRVR:VE1EUR02HT048;
x-ms-traffictypediagnostic: VE1EUR02HT048:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:VE1EUR02HT048;BCL:0;PCL:0;RULEID:;SRVR:VE1EUR02HT048;
x-microsoft-antispam-message-info: vvpHI8mw6wH/MamuoAYyc5AyByAZvox4nEFXaoVUfaK6x8uYREJT2pbe9Mif1yQO
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-Network-Message-Id: c252d290-2f34-46b2-d5e4-08d695ec5f5f
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2019 21:59:36.2749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR02HT048
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This RC map is based on remote key schema at [1]

[1] https://wiki.odroid.com/accessory/connectivity/ir_remote_controller

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
---
 drivers/media/rc/keymaps/Makefile    |  1 +
 drivers/media/rc/keymaps/rc-odroid.c | 46 ++++++++++++++++++++++++++++
 include/media/rc-map.h               |  1 +
 3 files changed, 48 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-odroid.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 0ea52f65bb03..591a6ab25895 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -75,6 +75,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-nec-terratec-cinergy-xs.o \
 			rc-norwood.o \
 			rc-npgtech.o \
+			rc-odroid.o \
 			rc-pctv-sedna.o \
 			rc-pine64.o \
 			rc-pinnacle-color.o \
diff --git a/drivers/media/rc/keymaps/rc-odroid.c b/drivers/media/rc/keymaps/rc-odroid.c
new file mode 100644
index 000000000000..2eb4b6f7f403
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-odroid.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Keytable for ODROID IR Remote Controller
+// Copyright (c) 2017 Jonas Karlman
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table odroid[] = {
+	{ 0xb280, KEY_VOLUMEUP },
+	{ 0xb281, KEY_VOLUMEDOWN },
+	{ 0xb282, KEY_HOME },
+	{ 0xb288, KEY_MUTE },
+	{ 0xb299, KEY_LEFT },
+	{ 0xb29a, KEY_BACK },
+	{ 0xb2c1, KEY_RIGHT },
+	{ 0xb2c5, KEY_MENU },
+	{ 0xb2ca, KEY_UP },
+	{ 0xb2ce, KEY_OK },
+	{ 0xb2d2, KEY_DOWN },
+	{ 0xb2dc, KEY_POWER },
+};
+
+static struct rc_map_list odroid_map = {
+	.map = {
+		.scan     = odroid,
+		.size     = ARRAY_SIZE(odroid),
+		.rc_proto = RC_PROTO_NEC,
+		.name     = RC_MAP_ODROID,
+	}
+};
+
+static int __init init_rc_map_odroid(void)
+{
+	return rc_map_register(&odroid_map);
+}
+
+static void __exit exit_rc_map_odroid(void)
+{
+	rc_map_unregister(&odroid_map);
+}
+
+module_init(init_rc_map_odroid)
+module_exit(exit_rc_map_odroid)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jonas Karlman");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 52b554aa784d..6d2f4da07807 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -235,6 +235,7 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_NEC_TERRATEC_CINERGY_XS   "rc-nec-terratec-cinergy-xs"
 #define RC_MAP_NORWOOD                   "rc-norwood"
 #define RC_MAP_NPGTECH                   "rc-npgtech"
+#define RC_MAP_ODROID                    "rc-odroid"
 #define RC_MAP_PCTV_SEDNA                "rc-pctv-sedna"
 #define RC_MAP_PINE64                    "rc-pine64"
 #define RC_MAP_PINNACLE_COLOR            "rc-pinnacle-color"
-- 
2.17.1

