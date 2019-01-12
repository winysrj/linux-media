Return-Path: <SRS0=PrKG=PU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16989C43387
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 18:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8C292086C
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 18:38:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="HY5mIc9e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfALSiG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 12 Jan 2019 13:38:06 -0500
Received: from mail-eopbgr40075.outbound.protection.outlook.com ([40.107.4.75]:56688
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfALSiG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Jan 2019 13:38:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVh98C983fVAY392/y9cuKyO5bFgaqDkKcavH+hna4c=;
 b=HY5mIc9edK3DinBBA9NYFeTmo+aOQWB/6L8WWUYM9FpeRZ967szSlj6hLZlgdg8iLjhapx/8awKXut1Wo/3af2OHTUFN2Fn6iHp/aQtCaMrGt7QnWTdVdCgl+gf7fe/ClQireM8OcHritue9jpkqGgmkybRj6/8QA86PIuQ4WyQ=
Received: from HE1PR05MB4601.eurprd05.prod.outlook.com (20.176.163.138) by
 HE1PR05MB1146.eurprd05.prod.outlook.com (10.161.119.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Sat, 12 Jan 2019 18:37:58 +0000
Received: from HE1PR05MB4601.eurprd05.prod.outlook.com
 ([fe80::75a0:a89d:1227:7ed3]) by HE1PR05MB4601.eurprd05.prod.outlook.com
 ([fe80::75a0:a89d:1227:7ed3%5]) with mapi id 15.20.1516.019; Sat, 12 Jan 2019
 18:37:58 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Thread-Topic: [PATCH] lib/scatterlist: Provide a DMA page iterator
Thread-Index: AQHUpH3T+Rn6hCeN4kq6RDaSbJgsYKWr/9qAgAADAwA=
Date:   Sat, 12 Jan 2019 18:37:58 +0000
Message-ID: <20190112183752.GC16457@mellanox.com>
References: <20190104223531.GA1705@ziepe.ca>
 <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com>
In-Reply-To: <20190112182704.GA15320@ssaleem-MOBL4.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0015.namprd19.prod.outlook.com
 (2603:10b6:300:d4::25) To HE1PR05MB4601.eurprd05.prod.outlook.com
 (2603:10a6:7:99::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [174.3.196.123]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR05MB1146;6:4zmrQgT1sdX1fezCxCmZWi1z0FiebKpe2hAodNpfuhv59Br+pD4qZ6Nk1elIvj50nwoDTFoSgpM06xLx7/J+UpcScOMVHE7rJaTVUcN28u65JJXwDBVYJdqmy0zRa6j/0UAWRsrxh74hexStWWuMwbQRk6sDP2Z2PeLTQLChwI51J6NthDc7+KIRkMeqK4frnURq0mjFxPzLOytO2hMr44V5SYa4SSDSW1IFM8ekn058uGM8WPvCHDMNIug35UnUV91wukmIYPtDDyIuA62jRQv73M9Nm6cERBDxm6lTYjqRulJSs1ajGq6wJOJsDpVZ4ikjnLDKV8pMNmJGL0+2W1zLpTBAKpR+iWjsAtVURDpQJddsEbLNtPvCgF9PYRGJGG9rRDjbgklWnKWCjPyUjvKaQ8iHKVO1QPcT9eBx3GfJZVq8WGJ1JItyfYZQfPBLUFLpIwxcn9RKhcogI1BVjA==;5:XjDJLEDR2Ur3VEvsPcKKXCHgEp/tgEqAY4HG5tOYzdqw/zEtaU2HlCCONAZ3n4tTa3kViB4EzP201yr8wb+zfcxdqXww8YFcE/Fepnakgyal7HRsIlzgxO1Q+JQcpsoYZeuHF9hdCmnR9q7EL5s4VITEvkCODqcm2eOEGk7rIEqpQhukZxNTQkyYBNjx/hBBbm2vVtDEZ2Y535XHZsxrhg==;7:RDA6/ZahcIbAfLC2pc/2zG4O//Fl6MTSlORbfn4Ktx6Z4ng7Q9cOzCGPejPgldOxg4g/lSzI1nchoqnUIZbqzT7jq/fw0d8NfKZGvuZY9tk7UHdaeIIPVcyBEtWr5MvsJrhusJiim5FmIaVmNS/QOg==
x-ms-office365-filtering-correlation-id: f2f62996-e30f-4d8b-2a89-08d678bd1315
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:HE1PR05MB1146;
x-ms-traffictypediagnostic: HE1PR05MB1146:
x-microsoft-antispam-prvs: <HE1PR05MB11463C58A083A3F6E186F9D2CF860@HE1PR05MB1146.eurprd05.prod.outlook.com>
x-forefront-prvs: 0915875B28
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(51444003)(189003)(199004)(7416002)(6436002)(6486002)(68736007)(76176011)(71190400001)(71200400001)(53936002)(25786009)(6246003)(6916009)(446003)(8676002)(81166006)(256004)(14454004)(33656002)(8936002)(102836004)(81156014)(1076003)(5660300001)(305945005)(7736002)(2616005)(229853002)(186003)(2906002)(476003)(36756003)(4326008)(99286004)(486006)(6506007)(386003)(86362001)(54906003)(106356001)(105586002)(3846002)(26005)(6116002)(498600001)(52116002)(66066001)(11346002)(6512007)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB1146;H:HE1PR05MB4601.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4L5/KU+N/kJF89KXgAVRP+wugHYqGHneWmm01/4qaz6rMUJXmhksRgYmarfTFQp87RXyCU0P8XAq2jAAFbhtkhgSowilhpQ5AOneUQ0h1ApDJBYstIaVhpe3d/qU7nR9T8INcXy0Fs5KiJVo+y5yL51VN2WrrRb/LfPLipbEdfumH+pulidIr/B8BX5xfUG47lqfYW3fkTUZvZI4wCIqTPk7AQ5dNyG9kmpHQCuZIDWf9HvCxBOuypYWayLPhiz7C+/pF0tfscbOb58qtls5FX28VA6+CI468vvB59GltOdX1gtuApf4v6wNX60TfpMVO1E4Dt3Cbr+azW8CnxEfUaFEGSzr6oY/GF0bvxMRtULqAl0KVrKMMNZgnnB9g/r6XJak3gv4Gkg3UpV0jv6t77Ahf6GPxm1MerKPUtOhv8E=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DAC65A5B3277C34FAF842AB1917DE54E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2f62996-e30f-4d8b-2a89-08d678bd1315
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2019 18:37:58.3780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB1146
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Jan 12, 2019 at 12:27:05PM -0600, Shiraz Saleem wrote:
> On Fri, Jan 04, 2019 at 10:35:43PM +0000, Jason Gunthorpe wrote:
> > Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w=
/o
> > backing pages") introduced the sg_page_iter_dma_address() function with=
out
> > providing a way to use it in the general case. If the sg_dma_len is not
> > equal to the dma_length callers cannot safely use the
> > for_each_sg_page/sg_page_iter_dma_address combination.
> >=20
> > Resolve this API mistake by providing a DMA specific iterator,
> > for_each_sg_dma_page(), that uses the right length so
> > sg_page_iter_dma_address() works as expected with all sglists. A new
> > iterator type is introduced to provide compile-time safety against wron=
gly
> > mixing accessors and iterators.
> [..]
>=20
> > =20
> > +/*
> > + * sg page iterator for DMA addresses
> > + *
> > + * This is the same as sg_page_iter however you can call
> > + * sg_page_iter_dma_address(@dma_iter) to get the page's DMA
> > + * address. sg_page_iter_page() cannot be called on this iterator.
> > + */
> Does it make sense to have a variant of sg_page_iter_page() to get the
> page descriptor with this dma_iter? This can be used when walking DMA-map=
ped
> SG lists with for_each_sg_dma_page.

I think that would be a complicated cacluation to find the right
offset into the page sg list to get the page pointer back. We can't
just naively use the existing iterator location.

Probably places that need this are better to run with two iterators,
less computationally expensive.

Did you find a need for this?=20

Jason
