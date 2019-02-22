Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30D3C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 15:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81EB92086A
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 15:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfBVPAp convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:00:45 -0500
Received: from mail-oln040092066046.outbound.protection.outlook.com ([40.92.66.46]:28654
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726198AbfBVPAp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 10:00:45 -0500
Received: from VE1EUR01FT008.eop-EUR01.prod.protection.outlook.com
 (10.152.2.52) by VE1EUR01HT120.eop-EUR01.prod.protection.outlook.com
 (10.152.3.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1580.10; Fri, 22 Feb
 2019 15:00:42 +0000
Received: from AM3PR03MB0966.eurprd03.prod.outlook.com (10.152.2.53) by
 VE1EUR01FT008.mail.protection.outlook.com (10.152.2.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Fri, 22 Feb 2019 15:00:42 +0000
Received: from AM3PR03MB0966.eurprd03.prod.outlook.com
 ([fe80::8011:1f4d:3804:e5f3]) by AM3PR03MB0966.eurprd03.prod.outlook.com
 ([fe80::8011:1f4d:3804:e5f3%10]) with mapi id 15.20.1643.016; Fri, 22 Feb
 2019 15:00:42 +0000
From:   Jonas Karlman <jonas@kwiboo.se>
To:     Sean Young <sean@mess.org>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] [media] rc/keymaps: add keytable for Pine64 IR Remote
 Controller
Thread-Topic: [PATCH 1/3] [media] rc/keymaps: add keytable for Pine64 IR
 Remote Controller
Thread-Index: AQHUx9U8H3wCPt1wSEKj5vg9/61RJ6XodcEAgAN5U4A=
Date:   Fri, 22 Feb 2019 15:00:41 +0000
Message-ID: <AM3PR03MB0966FCDC11AA03A2BA9F73F9AC7F0@AM3PR03MB0966.eurprd03.prod.outlook.com>
References: <20190218215915.2782-1-jonas@kwiboo.se>
 <AM3PR03MB09661A45FEB90FFC3CB44508AC630@AM3PR03MB0966.eurprd03.prod.outlook.com>
 <20190220095738.ftshqrhccoa3hvyy@gofer.mess.org>
In-Reply-To: <20190220095738.ftshqrhccoa3hvyy@gofer.mess.org>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0102CA0034.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:14::47) To AM3PR03MB0966.eurprd03.prod.outlook.com
 (2a01:111:e400:884c::23)
x-incomingtopheadermarker: OriginalChecksum:802C8724CA4EA57D1B325590EFD2C998EB67E1086EFC19CFA802AE372C094BCB;UpperCasedChecksum:34467A56E16FAA1E4B0A5BA183698496E4AF876D6DB2C92B9C92E852308A14DB;SizeAsReceived:8658;Count:63
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Bs+vIyJk1qpaO6ilPTjhJyXPLaVccCvv]
x-microsoft-original-message-id: <83de063e-ac1b-a5f8-1952-c2d6b6771249@kwiboo.se>
x-ms-publictraffictype: Email
x-incomingheadercount: 63
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031324274)(2017031322404)(2017031323274)(1601125500)(1603101475)(1701031045);SRVR:VE1EUR01HT120;
x-ms-traffictypediagnostic: VE1EUR01HT120:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:VE1EUR01HT120;BCL:0;PCL:0;RULEID:;SRVR:VE1EUR01HT120;
x-microsoft-antispam-message-info: Jweztn52aEpyOXxe4mNI1Dm63IWIcmxVySn3aZq7OeY+o8lU2U5PFRehuW0mjG2j
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <78A470930AA6AA4E928E255C84872E4A@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d99815-2610-4fe2-00af-08d698d6833b
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2019 15:00:40.8066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR01HT120
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2019-02-20 10:57, Sean Young wrote:
> On Mon, Feb 18, 2019 at 09:59:36PM +0000, Jonas Karlman wrote:
>> This RC map is based on remote key schema at [1], the mouse button key
>> did not have an obvious target and was mapped to KEY_CONTEXT_MENU.
> How about BTN_LEFT ?

That should work, I only looked at the KEY_ events :-)

I will send a v2 using BTN_LEFT instead of KEY_CONTEXT_MENU.

Regards,
Jonas

>
> Thanks,
>
> Sean
>
>> [1] http://files.pine64.org/doc/Pine%20A64%20Schematic/remote-wit-logo.jpg
>>
>> Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
>> ---
>>  drivers/media/rc/keymaps/Makefile    |  1 +
>>  drivers/media/rc/keymaps/rc-pine64.c | 59 ++++++++++++++++++++++++++++
>>  include/media/rc-map.h               |  1 +
>>  3 files changed, 61 insertions(+)
>>  create mode 100644 drivers/media/rc/keymaps/rc-pine64.c
>>
>> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
>> index 5b1399af6b3a..0ea52f65bb03 100644
>> --- a/drivers/media/rc/keymaps/Makefile
>> +++ b/drivers/media/rc/keymaps/Makefile
>> @@ -76,6 +76,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>>  			rc-norwood.o \
>>  			rc-npgtech.o \
>>  			rc-pctv-sedna.o \
>> +			rc-pine64.o \
>>  			rc-pinnacle-color.o \
>>  			rc-pinnacle-grey.o \
>>  			rc-pinnacle-pctv-hd.o \
>> diff --git a/drivers/media/rc/keymaps/rc-pine64.c b/drivers/media/rc/keymaps/rc-pine64.c
>> new file mode 100644
>> index 000000000000..94e5624f63f4
>> --- /dev/null
>> +++ b/drivers/media/rc/keymaps/rc-pine64.c
>> @@ -0,0 +1,59 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +// Keytable for Pine64 IR Remote Controller
>> +// Copyright (c) 2017 Jonas Karlman
>> +
>> +#include <media/rc-map.h>
>> +#include <linux/module.h>
>> +
>> +static struct rc_map_table pine64[] = {
>> +	{ 0x404000, KEY_NUMERIC_0 },
>> +	{ 0x404001, KEY_NUMERIC_1 },
>> +	{ 0x404002, KEY_NUMERIC_2 },
>> +	{ 0x404003, KEY_NUMERIC_3 },
>> +	{ 0x404004, KEY_NUMERIC_4 },
>> +	{ 0x404005, KEY_NUMERIC_5 },
>> +	{ 0x404006, KEY_NUMERIC_6 },
>> +	{ 0x404007, KEY_NUMERIC_7 },
>> +	{ 0x404008, KEY_NUMERIC_8 },
>> +	{ 0x404009, KEY_NUMERIC_9 },
>> +	{ 0x40400a, KEY_MUTE },
>> +	{ 0x40400b, KEY_UP },
>> +	{ 0x40400c, KEY_BACKSPACE },
>> +	{ 0x40400d, KEY_OK },
>> +	{ 0x40400e, KEY_DOWN },
>> +	{ 0x404010, KEY_LEFT },
>> +	{ 0x404011, KEY_RIGHT },
>> +	{ 0x404017, KEY_VOLUMEDOWN },
>> +	{ 0x404018, KEY_VOLUMEUP },
>> +	{ 0x40401a, KEY_HOME },
>> +	{ 0x40401d, KEY_MENU },
>> +	{ 0x40401f, KEY_WWW },
>> +	{ 0x404045, KEY_BACK },
>> +	{ 0x404047, KEY_CONTEXT_MENU },
>> +	{ 0x40404d, KEY_POWER },
>> +};
>> +
>> +static struct rc_map_list pine64_map = {
>> +	.map = {
>> +		.scan     = pine64,
>> +		.size     = ARRAY_SIZE(pine64),
>> +		.rc_proto = RC_PROTO_NECX,
>> +		.name     = RC_MAP_PINE64,
>> +	}
>> +};
>> +
>> +static int __init init_rc_map_pine64(void)
>> +{
>> +	return rc_map_register(&pine64_map);
>> +}
>> +
>> +static void __exit exit_rc_map_pine64(void)
>> +{
>> +	rc_map_unregister(&pine64_map);
>> +}
>> +
>> +module_init(init_rc_map_pine64)
>> +module_exit(exit_rc_map_pine64)
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Jonas Karlman");
>> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
>> index d621acadfbf3..52b554aa784d 100644
>> --- a/include/media/rc-map.h
>> +++ b/include/media/rc-map.h
>> @@ -236,6 +236,7 @@ struct rc_map *rc_map_get(const char *name);
>>  #define RC_MAP_NORWOOD                   "rc-norwood"
>>  #define RC_MAP_NPGTECH                   "rc-npgtech"
>>  #define RC_MAP_PCTV_SEDNA                "rc-pctv-sedna"
>> +#define RC_MAP_PINE64                    "rc-pine64"
>>  #define RC_MAP_PINNACLE_COLOR            "rc-pinnacle-color"
>>  #define RC_MAP_PINNACLE_GREY             "rc-pinnacle-grey"
>>  #define RC_MAP_PINNACLE_PCTV_HD          "rc-pinnacle-pctv-hd"
>> -- 
>> 2.17.1

