Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7953CC282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BC2F20823
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="hteQJRkr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfBHQi1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 11:38:27 -0500
Received: from mail-eopbgr50055.outbound.protection.outlook.com ([40.107.5.55]:23488
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726522AbfBHQi0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 11:38:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qzz/M9dSle+PRYkGF2+KjiExzpwm7F9fB8sflDkOtZY=;
 b=hteQJRkrnYDhRRR+h1muqFCP8XWhJfA/dDk3R2hIUXPw4SU1vnNEfbKC86RfJfkimi4LA7sruqGYLDwtuMVpu3hdFBKvSzdLI9VurTh/7THYp6v+9gyYV64UfLX4L4CRe0kdrx8+Gx7zcvY+7hbiavx3PEYQLg2NreAMjj8+gUo=
Received: from DBBPR05MB6426.eurprd05.prod.outlook.com (20.179.42.80) by
 DBBPR05MB6475.eurprd05.prod.outlook.com (20.179.43.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Fri, 8 Feb 2019 16:38:19 +0000
Received: from DBBPR05MB6426.eurprd05.prod.outlook.com
 ([fe80::c402:4592:e149:cb91]) by DBBPR05MB6426.eurprd05.prod.outlook.com
 ([fe80::c402:4592:e149:cb91%2]) with mapi id 15.20.1601.016; Fri, 8 Feb 2019
 16:38:19 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Daniel Stone <daniel@fooishbar.org>, "hch@lst.de" <hch@lst.de>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Thread-Topic: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Thread-Index: AQHUvzQ5rNYocWvZOkiWAVOxemV5ZqXWGvWA
Date:   Fri, 8 Feb 2019 16:38:19 +0000
Message-ID: <20190208163813.GC25136@mellanox.com>
References: <20190207222647.GA30974@ziepe.ca>
In-Reply-To: <20190207222647.GA30974@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0055.namprd07.prod.outlook.com (2603:10b6:100::23)
 To DBBPR05MB6426.eurprd05.prod.outlook.com (2603:10a6:10:c9::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [174.3.196.123]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DBBPR05MB6475;6:PD7latqHky7Px3Bimtdb7AmSUiJ3FVLoOxdaAJEUhnZXS40PvmHc6D/No3qiMMs7EJseqZ1/FTsVB7u/T5o8matQACYhTT6T9rW/MvnGxwTV76c1R54MF6AOcMn5FBu5frU3wJjwDU1KdWebpuhhHrgw/WylUqghHi6NZYcRpyi4kuKE4CW2rRl/T3MDBu51g91jYzLL+KQJL+FNk7qSIjChztyVHEUOILRuJDlt+HHFxhzyQkJCkGTKUfyPSXBNN/4cpMA8IATkAAditU+bGLKPgXTW2jGHzdTC8XMMw7+KIz4h8Op8JkjRoP49woUY3f4Jy64SwUKVZ/+nBGjPhsj59CAzBc5CfZJik58DLrKZpkv682MHUfILQSTTnLHgFMEYgT6EUssEKPw5Pw+U/H3GgPhtPNK9dEYBAbjcy/KenLDP3Y7OqlBMQpuE/Og/MtKC9VCJipT5buO2OaDaAA==;5:m5g0w+RvNPxKWFQuQZlJ3BPNFmmM07mJHGSm58dJhpeuUYaVLgQpDdBJsObRf7ol8NWKwQ++Yamg6gVLoHUFPaEfch0r9IqDcLfnCiHKK30xphONmAM1+5uEesjt3+6YkxN2Vhe22y/YSVOJ6MyQ3XPkEyAYOiiM+yr8YIezgBaC6Qq4S7mqz0ZThyhNlhLtSs0T1mGSppW1Y87IV93rwA==;7:ZGbvxJo1+81IuFDWVVSswK4+FKSbrqDA88tNKSRUKh2b+A42sDTtrQqUgqjnM5H6EGjyPIekPr8W8sX5yClk1w9X7lvpkiPvIGZ/AL20Wkep63VuQAcGii4B1cmN4rOYFJoEtgT9BRDy9EgV+royiw==
x-ms-office365-filtering-correlation-id: 97234c2a-2a47-4c4a-1d33-08d68de3d551
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:DBBPR05MB6475;
x-ms-traffictypediagnostic: DBBPR05MB6475:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DBBPR05MB64759C40CCEB75D328AE34FDCF690@DBBPR05MB6475.eurprd05.prod.outlook.com>
x-forefront-prvs: 094213BFEA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(366004)(376002)(39860400002)(199004)(189003)(66066001)(71190400001)(71200400001)(4744005)(76176011)(7736002)(6436002)(6246003)(53936002)(7416002)(6306002)(6512007)(6486002)(305945005)(106356001)(386003)(2201001)(52116002)(86362001)(105586002)(36756003)(256004)(2906002)(6506007)(1076003)(486006)(99286004)(110136005)(97736004)(81166006)(966005)(229853002)(186003)(316002)(26005)(81156014)(102836004)(2501003)(446003)(476003)(8936002)(25786009)(11346002)(3846002)(2616005)(6116002)(33656002)(8676002)(68736007)(14454004)(478600001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6475;H:DBBPR05MB6426.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bh5GCz3NIbfXNnthP/6RJtk0yFyvpC8sPrHLb1fiDLoQNWkAbnVdFvnkukank4FdS0KEikl9RFm3d0usSv/vjpWMR5HbF1rdIWSQNXz2M5+N5zkEpL3h4HqHscZSRbmzPJ+nZI35ElRGfdyJcJGnW/ckAKgiMcnxzwGeXtrBWbpYcdu2HGW4Eelc0uUSYU1gGifpl7lTbzqiAnZpiZgEoXnUr+cHKk14A1cCdu1FDfBz+iQZXP10k/+L9KbGRruocZugsdhnjmjduE3QwH0k0bcCVaytDjloHA7dCFaQfW46DHMbRsnO7HUjbV3iLnz88l4cbv+3sI2eh1qN7ii89huxI7aIBwc3Ktq+UYfv3bHiDyipGZktRYiT+06EcuYIVJqd2t9bziZoEHQkGc6NrWII5URsaVYbmrnT1uwkvyc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EBDE82DA2EA0DC4DB64DC1DCB43403FB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97234c2a-2a47-4c4a-1d33-08d68de3d551
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2019 16:38:19.5439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6475
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 07, 2019 at 03:26:47PM -0700, Jason Gunthorpe wrote:
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm=
/vmwgfx/vmwgfx_ttm_buffer.c
> index 31786b200afc47..e84f6aaee778f0 100644
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
> @@ -311,7 +311,13 @@ static dma_addr_t __vmw_piter_dma_addr(struct vmw_pi=
ter *viter)
> =20
>  static dma_addr_t __vmw_piter_sg_addr(struct vmw_piter *viter)
>  {
> -	return sg_page_iter_dma_address(&viter->iter);
> +	/*
> +	 * FIXME: This driver wrongly mixes DMA and CPU SG list iteration and
> +	 * needs revision. See
> +	 * https://lore.kernel.org/lkml/20190104223531.GA1705@ziepe.ca/
> +	 */
> +	return sg_page_iter_dma_address(
> +		(struct sg_dma_page_iter *)&viter->iter);

Occured to me this would be better written as:

	return sg_page_iter_dma_address(
		container_of(&viter->iter, struct sg_dma_page_iter, base));

Since I think we are done with this now I'll fix it when I apply this
patch

Thanks for all the acks everyone

Regards,
Jason
