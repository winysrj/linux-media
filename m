Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A528C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 13:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F485218AD
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 13:37:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="VIzNH7c2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfBRNhb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 08:37:31 -0500
Received: from mail-eopbgr760128.outbound.protection.outlook.com ([40.107.76.128]:6381
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727483AbfBRNhb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 08:37:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDL0LXv003l1zaQkyjeDEe56RMRZbJYrQPF32f3wauY=;
 b=VIzNH7c2A02OiwvnhaMr/rPxVOtt+FTkL4aFF93RVfqoD+1QR1ezO4At8d/ieRoQF/nnU5iYUONYI11iiNmQixT1KdAUquz718CuE0lacZFKzFMUAIHzgJ6nulG4NW+mudNYFApSlIOMyKWJ8bVG177aMAtsB8+qJ9tuLs9V5b8=
Received: from BL0PR07MB4115.namprd07.prod.outlook.com (52.132.10.149) by
 BL0PR07MB5426.namprd07.prod.outlook.com (10.167.241.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.19; Mon, 18 Feb 2019 13:37:27 +0000
Received: from BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::5516:87b1:344e:a27f]) by BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::5516:87b1:344e:a27f%6]) with mapi id 15.20.1622.018; Mon, 18 Feb 2019
 13:37:27 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     "Eugen.Hristev@microchip.com" <Eugen.Hristev@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Subject: RE: [PATCH] media: atmel: atmel-isc: reworked driver and formats
Thread-Topic: [PATCH] media: atmel: atmel-isc: reworked driver and formats
Thread-Index: AQHUxQm2DhFZfyQ1n0i/a5kxwOkcZ6Xlk30w
Date:   Mon, 18 Feb 2019 13:37:26 +0000
Message-ID: <BL0PR07MB4115ECEE3BED0B46C342F4A9AD630@BL0PR07MB4115.namprd07.prod.outlook.com>
References: <1550219467-9532-1-git-send-email-eugen.hristev@microchip.com>
In-Reply-To: <1550219467-9532-1-git-send-email-eugen.hristev@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=KSloat@aampglobal.com; 
x-originating-ip: [96.59.174.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8551840e-27a2-4799-23f6-08d695a638db
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:BL0PR07MB5426;
x-ms-traffictypediagnostic: BL0PR07MB5426:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;BL0PR07MB5426;23:Y602/6T7cuxJtjqqFgLNmKM56VkfZxYgfkDan/V/J?=
 =?us-ascii?Q?QMY0jFQmZQsKMNOQvI2rmlmdXzyfS0UfBp7eT2dxe7WvWXNjYPef0EFaa2Ia?=
 =?us-ascii?Q?GGtH1D7FQfWZsyuFDAZN6i8lV47XW3PYKqrdcFFUdocpnZFcytM55Gd7Xy8J?=
 =?us-ascii?Q?FKV488Tn+q6BnGIP/eC3RavXja2xfW6nrDyo8U7MDkmKteuBhGQCzT4dLzJA?=
 =?us-ascii?Q?7I5wCQ5cgfeE3oio89bvXV6EjPmqdLxWh87KkFIsiaRdMBKomz0qRYlzTbYZ?=
 =?us-ascii?Q?RCAKZlh9OtZ911hIL9yQJtc+M38+iL2eOuT5sn1hTm6EEA5kuBlhVOoNOKM1?=
 =?us-ascii?Q?I9vXQ8+al60kF+yeQdIMVF8t5m9GHqPn/wUEHVPJLYIDjo2YFtmnzIagLJlO?=
 =?us-ascii?Q?U2itEwRZjGn546pSrvc9oEbvUcUqewPSaT0lDR+1XS5G6L+LIBAFt+Xbk4Vd?=
 =?us-ascii?Q?tN3LX2w/L0N1fYe0GMruD9szsbh22hVFiG9z3A/9z+ufzAT92HVg0u+PpT+B?=
 =?us-ascii?Q?/p+vja+liSTGBvGgKWdzRNI1DUMy6PkPX2F6OuD5fjRoi030PPC05qkEAMtR?=
 =?us-ascii?Q?ELrbbdMB4T5UW0OV4z/eYZElgUnge4X/XfMUNtLMcQJtitI546efYpKnCgg2?=
 =?us-ascii?Q?T6a8kMqrXvI3x1UN9IPVh06OIMVelTuIKpnr/hwQoOW/HoVgI1KM4CoovVOg?=
 =?us-ascii?Q?1wAKVMKRf6Lp3uS9klU+xANyFbBzmS1SZrnL0LThnyyK3/iq7oT4+IDdnMSe?=
 =?us-ascii?Q?vlZLGKsqlk/FZ6APiK1OTHrzvm2CR3W0fCrO41PDKydynUcHUH+vMYbnQ/jc?=
 =?us-ascii?Q?7rneMWXv7balMpF8PPefVSQItx6pjMKON36GW83jSCjhNR425TqeMNF/Wpwt?=
 =?us-ascii?Q?Ck5CVxG0Y70QK9PvcWOD+WDFcxWz7Hiif0dv4h4Pa6SB25vx+hpiZpFEiPmG?=
 =?us-ascii?Q?F60zYdy/y93WR/Th5VDcYZtvhKBfZg15K1GTepqFo+zCYgkdWafpOUMTPc0/?=
 =?us-ascii?Q?oze2Aeur8uBspr13BNabXsF6r550PfKCzs5lh8FBjJBJqCL2vAoaA1w2XefC?=
 =?us-ascii?Q?zPSMietbE2xZicjVN3LfLK0MHMgotx+DDNndbH/EOAaUc1hd1XAxcWjmW/vj?=
 =?us-ascii?Q?hEVhPvTDiotq4UKJUxRzVWzMNpsdCFVi4UPZfAAoR7OwstY17wr2pOjQGVN4?=
 =?us-ascii?Q?Ac4QrBRUhvmIt7164N5qgMFPYTlO70+q38wjS6A5KLQM/tay5cGH+4N4iJMT?=
 =?us-ascii?Q?wO8A6CiTJexVveLmzIVY/vLZwSDmL15p+9T+OZ75/JI+ulRnWFZczOarK9Vb?=
 =?us-ascii?B?dz09?=
x-microsoft-antispam-prvs: <BL0PR07MB5426C23CFC6C0F17AFF13BBFAD630@BL0PR07MB5426.namprd07.prod.outlook.com>
x-forefront-prvs: 09525C61DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(366004)(39840400004)(136003)(346002)(189003)(199004)(13464003)(53546011)(71190400001)(25786009)(5660300002)(6116002)(6436002)(26005)(2201001)(86362001)(71200400001)(6506007)(102836004)(229853002)(53936002)(6246003)(9686003)(3846002)(14454004)(97736004)(68736007)(55016002)(446003)(105586002)(106356001)(72206003)(478600001)(2501003)(186003)(66066001)(80792005)(33656002)(476003)(76176011)(305945005)(99286004)(7696005)(8936002)(74316002)(486006)(81166006)(11346002)(81156014)(316002)(110136005)(7736002)(256004)(14444005)(2906002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR07MB5426;H:BL0PR07MB4115.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NhJ83JBr5/c6Ul2Qv3Y15+0Wzzlt+QXIjFOOfppaucJZM6ETqihkn9xP0boWSvhKmH9C6C6z5qGTFY53XaUfCAvZzbvwekuEvD0C3bPuzepbEHyU7sTa9k5kX+XV6xKiTfMbzIOO6ogWg00lTM2po3yZjSDnERpRi6NxM+v7zd9qqETe/ySlN2pKx/Qp7yb/aL9UBhl7Pij78WW3BhPMm46JDP5PqIo0wzWiOmF5M8q/rau++1ZJyJIKH8z2BDtNVPNAe7qy+6HW4D3AojgcHyVnoSOoSGeR8zVZ7p4MwexMa1R+VThIZp9FNcCgqfuYp8DrIHok5JHTbrqPf7dwq9dHDUxPirDSEBIs0qrIJ1E7/a2FsDL4QOSQROaMrSnw8gD0eOk9aVK1UgW7xuQyOFAca4NK5Wn2XFSxLkj7L1k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8551840e-27a2-4799-23f6-08d695a638db
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2019 13:37:26.8868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB5426
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: BL0PR07MB4115.namprd07.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-TransportTrafficSubType: 
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 96.59.174.230
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-transporttrafficsubtype: 
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: BL0PR07MB5426.namprd07.prod.outlook.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

> -----Original Message-----
> From: Eugen.Hristev@microchip.com <Eugen.Hristev@microchip.com>
> Sent: Friday, February 15, 2019 3:38 AM
> To: linux-media@vger.kernel.org; linux-arm-kernel@lists.infradead.org; li=
nux-
> kernel@vger.kernel.org; mchehab@kernel.org;
> Nicolas.Ferre@microchip.com; Ken Sloat <KSloat@aampglobal.com>;
> sakari.ailus@iki.fi; hverkuil@xs4all.nl
> Cc: Eugen.Hristev@microchip.com
> Subject: [PATCH] media: atmel: atmel-isc: reworked driver and formats
>=20
> From: Eugen Hristev <eugen.hristev@microchip.com>
>=20
> This change is a redesign in the formats and the way the ISC is configure=
d
> w.r.t. sensor format and the output format from the ISC.
> I have changed the splitting between sensor output (which is also ISC inp=
ut)
> and ISC output.
> The sensor format represents the way the sensor is configured, and what I=
SC
> is receiving.
> The format configuration represents the way ISC is interpreting the data =
and
> formatting the output to the subsystem.
> Now it's much easier to figure out what is the ISC configuration for inpu=
t, and
> what is the configuration for output.
> The non-raw format can be obtained directly from sensor or it can be done
> inside the ISC. The controller format list will include a configuration f=
or each
> format.
> The old supported formats are still in place, if we want to dump the sens=
or
> format directly to the output, the try format routine will detect and con=
figure
> the pipeline accordingly.
> This also fixes the previous issues when the raw format was NULL which
> resulted in many crashes for sensors which did not have the expected/test=
ed
> formats.
>=20
> Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
> ---
> Hello Ken and possibly others using ISC driver,
>=20
> I would appreciate if you could test this patch with your sensor, because=
 I do
> not wish to break anything in your setups.
> Feedback is appreciated if any errors appear, so I can fix them.
> I tested with ov5640, ov7670, ov7740(only in 4.19 because on latest it's
> broken for me...) Rebased this patch on top of mediatree.git/master Thank=
s!
>=20
> Eugen
>=20
Hi Eugen,

No problem I will try to test sometime this week on my setup. I appreciate =
you keeping me in the loop.

Thanks,
Ken
