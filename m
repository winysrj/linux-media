Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77773C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 17:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4352E2070D
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 17:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="cUb2H7G+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfCSRiD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 13:38:03 -0400
Received: from mail-eopbgr10077.outbound.protection.outlook.com ([40.107.1.77]:22837
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726776AbfCSRiD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 13:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector1-arm-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GEdO+urFYK201AGrVojD/wmNr2znXbz+Qv+IBm4WAc=;
 b=cUb2H7G+zFR/Gi0/sjhFmFdPuiiFCKwBdFAkerYyJkacgCc0urckkRBd9ihpJvrdG/LkOqE4C1Z3jm0cPG8ozHcZVF8xgKEawVrUKfXfFQc0pMFtvmiOgeUTgpttYvgBUDsyx5FCStSNsJCuB3TzuPB4V58J2d23aE285dorQ3c=
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com (52.134.93.10) by
 AM0PR08MB3409.eurprd08.prod.outlook.com (20.177.43.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Tue, 19 Mar 2019 17:37:59 +0000
Received: from AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd]) by AM0PR08MB3025.eurprd08.prod.outlook.com
 ([fe80::7e:6dfb:116b:befd%2]) with mapi id 15.20.1709.015; Tue, 19 Mar 2019
 17:37:59 +0000
From:   Brian Starkey <Brian.Starkey@arm.com>
To:     Boris Brezillon <boris.brezillon@collabora.com>
CC:     Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Hirokazu Honda <hiroh@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>, nd <nd@arm.com>
Subject: Re: [RFC PATCH 2/3] media: v4l2: Extend pixel formats to unify
 single/multi-planar handling (and more)
Thread-Topic: [RFC PATCH 2/3] media: v4l2: Extend pixel formats to unify
 single/multi-planar handling (and more)
Thread-Index: AQHU3np+EEcpqsczEUSYs/NiJxDNkA==
Date:   Tue, 19 Mar 2019 17:37:59 +0000
Message-ID: <20190319173758.kerufidooegbhtyf@DESKTOP-E1NTVVP.localdomain>
References: <20190319145243.25047-1-boris.brezillon@collabora.com>
 <20190319145243.25047-3-boris.brezillon@collabora.com>
In-Reply-To: <20190319145243.25047-3-boris.brezillon@collabora.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: NeoMutt/20180716-849-147d51-dirty
x-originating-ip: [217.140.106.54]
x-clientproxiedby: LNXP265CA0069.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::33) To AM0PR08MB3025.eurprd08.prod.outlook.com
 (2603:10a6:208:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Brian.Starkey@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b46e6946-807d-4dda-865e-08d6ac91a0df
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR08MB3409;
x-ms-traffictypediagnostic: AM0PR08MB3409:
nodisclaimer: True
x-microsoft-antispam-prvs: <AM0PR08MB34092965EA5C09B9B966E4AEF0400@AM0PR08MB3409.eurprd08.prod.outlook.com>
x-forefront-prvs: 0981815F2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(366004)(396003)(346002)(376002)(199004)(189003)(478600001)(1076003)(68736007)(97736004)(6512007)(9686003)(54906003)(58126008)(3846002)(316002)(2906002)(8676002)(6486002)(81166006)(6116002)(6436002)(81156014)(256004)(86362001)(6916009)(8936002)(44832011)(5660300002)(229853002)(4744005)(3716004)(446003)(6246003)(26005)(66066001)(11346002)(476003)(4326008)(71190400001)(6506007)(76176011)(386003)(53936002)(102836004)(14454004)(25786009)(52116002)(71200400001)(99286004)(106356001)(105586002)(186003)(7736002)(72206003)(305945005)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB3409;H:AM0PR08MB3025.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CPFsZJ1u3dGB8xUTff7qh8cG7RZ4Cq/9FDK9jym/+ce0AvYHvVgFpd/uTqiAYUEyC1sQxJicH6dq5bvAwBomJBkYRhOs8/9gYPT+Uqfn9qeBYQiIU26SMCABt/U/ww/jJP6fxrzHj4acxU4k3MU+5RFqmHFgBW5xarHs5e9MwqZHlDUwfqS84izB7vKF1Gq56nN/wqJ+A+tkfDWCzDhpQmZhngR7g1SNNv1IAG481y+SnyhqqJDQKYKv7XB4SS0h0w3ZQn+hZ0bAVGXI3VUHeKkC1ibEpjvOE76t00W6AKZm0xFsXZrDx6Npx3GGq1HBv5pMUgwtYcaLSrmLSkhVqGSETjOQdCL5IdaQSpHzTwc2oCEO3VIXXNXJbrUVOVJdIqMpdT5TsSfp+E+AsLpMYRoa8g5U8oYSM5DAwxj8Zbw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0637647F26A56C44A31155207F7FFD84@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46e6946-807d-4dda-865e-08d6ac91a0df
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2019 17:37:59.1784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3409
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Boris,

On Tue, Mar 19, 2019 at 03:52:42PM +0100, Boris Brezillon wrote:
> This is part of the multiplanar and singleplanar unification process.
> v4l2_ext_pix_format is supposed to work for both cases.
>=20
> We also add the concept of modifiers already employed in DRM to expose
> HW-specific formats (like tiled or compressed formats) and allow
> exchanging this information with the DRM subsystem in a consistent way.

I'm quite happy to see modifiers working their way into v4l2, thank
you for picking up that torch.

I didn't see anything about format enumeration here - do you have any
thoughts on how you think it would work?

Cheers,
-Brian
