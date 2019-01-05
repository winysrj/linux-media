Return-Path: <SRS0=yUb4=PN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF49C43387
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 03:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82B0C2173B
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 03:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="a1aCxV8m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfAEDV4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 4 Jan 2019 22:21:56 -0500
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:4287
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbfAEDV4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Jan 2019 22:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mc1zOtt3Xoj4RQckz1skKj2syqFLtDjzGRTfLCULYc4=;
 b=a1aCxV8mVbr+N25VpAjwqsensr+qoZdnTNPoDg5X1cZDg8TO6S3HduVpmW3aeXl6HGJxLd/F8h92A7g2DXEDYCqTH0EQ0Ngmmw6oZFeGQggUXlF7rQhg/uhSQXntdo8TkDEIZovw21km2L6vxftFcsfGDNAq3yfs53PvKhpV2GE=
Received: from AM4PR0501MB2179.eurprd05.prod.outlook.com (10.165.82.10) by
 AM4PR0501MB2644.eurprd05.prod.outlook.com (10.172.215.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Sat, 5 Jan 2019 03:21:50 +0000
Received: from AM4PR0501MB2179.eurprd05.prod.outlook.com
 ([fe80::88a5:f979:5400:adf]) by AM4PR0501MB2179.eurprd05.prod.outlook.com
 ([fe80::88a5:f979:5400:adf%5]) with mapi id 15.20.1495.005; Sat, 5 Jan 2019
 03:21:50 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     kbuild test robot <lkp@intel.com>
CC:     "kbuild-all@01.org" <kbuild-all@01.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
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
Thread-Index: AQHUpH3T+Rn6hCeN4kq6RDaSbJgsYKWf9imAgAAMaQA=
Date:   Sat, 5 Jan 2019 03:21:50 +0000
Message-ID: <20190105032142.GN28204@mellanox.com>
References: <20190104223531.GA1705@ziepe.ca>
 <201901051046.ew7HAHfl%fengguang.wu@intel.com>
In-Reply-To: <201901051046.ew7HAHfl%fengguang.wu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR06CA0033.namprd06.prod.outlook.com
 (2603:10b6:301:39::46) To AM4PR0501MB2179.eurprd05.prod.outlook.com
 (2603:10a6:200:52::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [174.3.196.123]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM4PR0501MB2644;6:j9nAggkHe5xCZLf4j/916Sp9Iswu7BDXObmTPJs/IG0+q/igObqKVFolO4HGFtL1oXKaxb+/f6GCh8FeGGNKiKgGEF7lrBpVPG1Aw3yJGUy7N0daJTndQxqleEt3E9lGHkUg4dBxC7rJskXbwaLK+fNdRnlV8n81YVz/sL0J0QmlIdFdqrDtExZRRbOpy7ceCr9w9rKHeJs+GwfwpE5DmjiNaZ3v1eqpJ3R9WyFfUQPtcuZTMINrl2RWwpANuQizeVwK8t/s6CDiFNMPjO/PL+cUli9hnsEaFOtF0C8AkaVSEqxft8YeyaeKO3XwODDH0AdDmSEOcFUPg5XKNeOM0Cyq/by0k/CQ+JFz6o35I+lpWAFN4TvKBnPysLtiZxDw9ObOf0Xpisr2hD8FnvVy0kQc0oTHYzOUhIQ+OL/yRg4EGTSKGQBzJYVlQlkH6vM659WhVIu4F8jAY5Gt7QNE4g==;5:jbShPwqR1vLqyNPSkhStOpVXgUCcUiXOHMnz5Nl8TXKxB809xoQ4XqEvg/ZmHTCXnnfA/J++nkt0w0/mLEmPdWRSCo41YqSkfbKPiIdZs20WAH4hq4yHhnaF4+u6bOrGn5siieE8XoCFck1uuVTvlsLqd6/BRPhCdj8qST2v1VgAn6IPQ1kAClo2Zf/iUxX1KetA90XlHJGAt5ceu+vQpg==;7:BrDVDmEq0dLJzpU2F9JhubGqsX6TnT0bSQabHeWgfqYgz72F/9Q1V/Q6HeZv0gH3gW8+oLagUwLbu1NcMm4ZcpH3IEhEziBEmV4c0BYgxePhQaUrGUhUCGLmkei2WgRyA8YGyDHt986nzbjN1uTOfQ==
x-ms-office365-filtering-correlation-id: 23021c34-6e8b-47f8-cc4f-08d672bcee5b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM4PR0501MB2644;
x-ms-traffictypediagnostic: AM4PR0501MB2644:
x-microsoft-antispam-prvs: <AM4PR0501MB2644A7BA9D64FF0B48CB23B6CF8F0@AM4PR0501MB2644.eurprd05.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(10201501046)(3231475)(944501520)(52105112)(93006095)(93001095)(3002001)(6055026)(6041310)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:AM4PR0501MB2644;BCL:0;PCL:0;RULEID:;SRVR:AM4PR0501MB2644;
x-forefront-prvs: 09086FB5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(366004)(396003)(39860400002)(376002)(189003)(199004)(25786009)(54906003)(14454004)(386003)(6116002)(4326008)(52116002)(76176011)(53936002)(1076003)(3846002)(305945005)(71190400001)(476003)(8936002)(86362001)(486006)(71200400001)(11346002)(256004)(6506007)(316002)(6306002)(229853002)(97736004)(5024004)(6246003)(36756003)(966005)(6512007)(446003)(7736002)(102836004)(7416002)(33656002)(5660300001)(478600001)(6486002)(6436002)(66066001)(2616005)(81166006)(106356001)(81156014)(8676002)(26005)(6916009)(99286004)(186003)(68736007)(105586002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2644;H:AM4PR0501MB2179.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rdN3Pa1IDFV1srMtu42dAc8n8minTyyOfLI6pI7qMrIn7ZnYVYdhG0UzHvueoDnLF5lntHOieGRjfWS7GJ7grQtpteQv3Ceq+cJAdBQ6Oxx1kEdB24cLjQn/M2KreBqCnb9oQ/E36T5yWb1HVEtnHgr2hpztS3C0i/SbRcwjwSmFz9cikzrxFmye0Xa4j/7pFqTf23tdHdAX5aeWkhNIxl7fRYgww7Xc1RHNQzyXaPN2n61MxMm6jrsxcaw63LM2fmwDVxjgOMjXapSRw/KsFHG9PneKxKcvTqSmj1gpkMK1r/m07fCH1GFrmjLRrGWX
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <82C95609B764554287F500BCF927501B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23021c34-6e8b-47f8-cc4f-08d672bcee5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2019 03:21:49.7915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2644
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Jan 05, 2019 at 10:37:17AM +0800, kbuild test robot wrote:
> Hi Jason,
>=20
> I love your patch! Yet something to improve:
>=20
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.20 next-20190103]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
>=20
> url:    https://github.com/0day-ci/linux/commits/Jason-Gunthorpe/lib-scat=
terlist-Provide-a-DMA-page-iterator/20190105-081739
> config: x86_64-randconfig-x017-201900 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Dx86_64=20
>=20
> All error/warnings (new ones prefixed by >>):
>=20
>    In file included from lib/scatterlist.c:9:0:
> >> include/linux/export.h:81:20: error: redefinition of '__kstrtab___sg_p=
age_iter_next'
>      static const char __kstrtab_##sym[]    \
>                        ^
>    include/linux/export.h:120:25: note: in expansion of macro '___EXPORT_=
SYMBOL'
>     #define __EXPORT_SYMBOL ___EXPORT_SYMBOL
>                             ^~~~~~~~~~~~~~~~
>    include/linux/export.h:124:2: note: in expansion of macro '__EXPORT_SY=
MBOL'
>      __EXPORT_SYMBOL(sym, "")
>      ^~~~~~~~~~~~~~~
> >> lib/scatterlist.c:652:1: note: in expansion of macro 'EXPORT_SYMBOL'
>     EXPORT_SYMBOL(__sg_page_iter_next);
>     ^~~~~~~~~~~~~

Woops, should be __sg_page_dma_iter_next.. Will resend after getting
some feedback.

Jason
