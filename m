Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C77C43612
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12E5E21738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 11:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axentia.se header.i=@axentia.se header.b="RVt9NfTs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbfAILZB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:25:01 -0500
Received: from mail-eopbgr30100.outbound.protection.outlook.com ([40.107.3.100]:57820
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729843AbfAILZA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 06:25:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4VAUQaiNNXXaZ24pqGkeEHByqzljPvk4KxIhLV6TPk=;
 b=RVt9NfTsEXK1Nc1E7cgtCvzfQThsvjnkhJiEV49o1NAmzmLeKpy5hZEvM0jY294QwG5tptRjxo/I1szXksd/YsQybHif4TelvHfpEMlCOsvS3MvZbqw9IJPUirUuscjXoDY39EnOsDszJtSI9gBlheqobrcfPheGAYOpEv8iE4g=
Received: from AM6PR02MB4470.eurprd02.prod.outlook.com (20.177.191.218) by
 AM6PR02MB4311.eurprd02.prod.outlook.com (20.177.113.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1516.14; Wed, 9 Jan 2019 11:24:56 +0000
Received: from AM6PR02MB4470.eurprd02.prod.outlook.com
 ([fe80::e5f3:a239:2ec4:4453]) by AM6PR02MB4470.eurprd02.prod.outlook.com
 ([fe80::e5f3:a239:2ec4:4453%6]) with mapi id 15.20.1516.010; Wed, 9 Jan 2019
 11:24:56 +0000
From:   Peter Rosin <peda@axentia.se>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Peter Rosin <peda@axentia.se>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] media: saa7146: make use of i2c_8bit_addr_from_msg
Thread-Topic: [PATCH] media: saa7146: make use of i2c_8bit_addr_from_msg
Thread-Index: AQHUqA3z/Lu6KZ5JE0CqAUfpN+EB2A==
Date:   Wed, 9 Jan 2019 11:24:56 +0000
Message-ID: <20190109112449.7723-1-peda@axentia.se>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.11.0
x-originating-ip: [85.226.244.23]
x-clientproxiedby: HE1P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:3:cf::12)
 To AM6PR02MB4470.eurprd02.prod.outlook.com (2603:10a6:20b:60::26)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peda@axentia.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM6PR02MB4311;6:10KXnc+8aDzMg5T0j5IZRfroWwqxKIdMYlj6AFtsg9zw8HxtzmcbxjdEkskQNAGm06thPxR2J3imumQoBY6Pof8o+j2GEXb9L/2gkKsbq31YNRT1xj4qiIW8mQNo9yDCbX11MJMrPduatXxpHf9uJZaCVsoDbH6JZJL8Kf0i8JjSUS7mcjS+Y54qlAqeZPJyno3ybSSJMCQrtMebqs232s6Iu4NSVEd3LzYTyP330l/93/cfYPXIqYZcyIwvgZ9XUsarRpHbNPfmJUBZ0T27fsqPsGqxWs8C4Z3zOavWuPFzfGBe7GmUdUjq7eHbZLqeSJ/8R1+Ib+gZr1hyJLoWGBntclkHqcnz5fD+X5Ug1QdQF//+OmQOZ/0OYbrb2ZiUbXdybvT+22B+dh8aa5fmWLZWOZAYJ4J3akfcybdgu3RQ5+EJ1MNqw/wBQTmMz+Z/FGnFaoUw7uocig1hUqQ6Aw==;5:gvttDhLj8ZOZ7iVr/eycSOJvv45aJ/oFsWwQu5SbLSrnMktOMasNlTCCKpxD5Rj3dy0+ztHV8/Dntj/BTO+ZlDQfdMEH7T1cT0XIJ7ODYw46uALLT8WoITqQIlwOv1U5w1fIjVhh3HbIXoYNeooKORzyFvULoWmGaWbwB6ilU+S1NgdCkDZBxi1n6jphGsjpOoXIUTQNbNqElR/caGQrYA==;7:YkHmwzOfoPU0on7jRkx7lFlQv5Yta/PCqfk0BymH4BGN0JwJK+6lmzYDGFMZHck2CegS0I71UhmKCXst745xTZuz0bjQxx56GOu41PntiqiX3LcvK8SHa/sG1sQK0AClV+BUrvWdF26unNgotSq8/Q==
x-ms-office365-filtering-correlation-id: 599e4ccf-fbd9-4b28-8918-08d676251569
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:AM6PR02MB4311;
x-ms-traffictypediagnostic: AM6PR02MB4311:
x-microsoft-antispam-prvs: <AM6PR02MB4311EA3CB54CAC5D904EEE86BC8B0@AM6PR02MB4311.eurprd02.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(93006095)(93001095)(3231475)(944501520)(52105112)(10201501046)(3002001)(6041310)(20161123558120)(2016111802025)(20161123562045)(20161123560045)(20161123564045)(6043046)(201708071742011)(7699051)(76991095);SRVR:AM6PR02MB4311;BCL:0;PCL:0;RULEID:;SRVR:AM6PR02MB4311;
x-forefront-prvs: 0912297777
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39830400003)(136003)(189003)(199004)(6512007)(5640700003)(25786009)(6436002)(4326008)(14454004)(86362001)(66066001)(81156014)(81166006)(8676002)(8936002)(105586002)(74482002)(106356001)(6116002)(3846002)(2616005)(97736004)(1076003)(476003)(102836004)(386003)(6506007)(71190400001)(71200400001)(186003)(2501003)(26005)(36756003)(52116002)(54906003)(256004)(316002)(2906002)(2351001)(99286004)(486006)(7736002)(305945005)(53936002)(6916009)(50226002)(68736007)(5660300001)(508600001)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR02MB4311;H:AM6PR02MB4470.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: axentia.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aDgX2OwurW0uwcSQKMxyAuOb0aLRuiYcAnt4arRJsjKNJG3G0IQbnZDN5JpaUgag+HXiVpyi3Z4fi05T+kyyofFUwtk5b1YMp//RH2euhblCJf1pNYtJwMQRxBP1FZ5SyO93Fna3SZOpFQ2Gz58BXh97XcU3533KnxWDHRwMSv5Xobw9gqFQgSOLmN9Av9GvToo1pFbwQjNYQ7GXRk8nPdRaFmunhkzsc083FHl8qZC+eRNyg+cbTFhajtSiiUWeQ1QnIPEWpTyqGsbuBxbm3GNW1lUUWQ17rID61GCTzayP2K5vOzVzWrnHEMqN4vE0
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: 599e4ccf-fbd9-4b28-8918-08d676251569
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2019 11:24:56.1156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR02MB4311
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Because it looks neater.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/common/saa7146/saa7146_i2c.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_i2c.c b/drivers/media/com=
mon/saa7146/saa7146_i2c.c
index 3feddc52c446..df9ebe2a168c 100644
--- a/drivers/media/common/saa7146/saa7146_i2c.c
+++ b/drivers/media/common/saa7146/saa7146_i2c.c
@@ -54,10 +54,7 @@ static int saa7146_i2c_msg_prepare(const struct i2c_msg =
*m, int num, __le32 *op)
 	/* loop through all messages */
 	for(i =3D 0; i < num; i++) {
=20
-		/* insert the address of the i2c-slave.
-		   note: we get 7 bit i2c-addresses,
-		   so we have to perform a translation */
-		addr =3D (m[i].addr*2) + ( (0 !=3D (m[i].flags & I2C_M_RD)) ? 1 : 0);
+		addr =3D i2c_8bit_addr_from_msg(&m[i]);
 		h1 =3D op_count/3; h2 =3D op_count%3;
 		op[h1] |=3D cpu_to_le32(	    (u8)addr << ((3-h2)*8));
 		op[h1] |=3D cpu_to_le32(SAA7146_I2C_START << ((3-h2)*2));
--=20
2.11.0

