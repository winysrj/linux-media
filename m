Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858A2C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 22:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 409472147C
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 22:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="dUw4UU2A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfBGW1B (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:27:01 -0500
Received: from mail-eopbgr50052.outbound.protection.outlook.com ([40.107.5.52]:10400
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbfBGW1B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 17:27:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1qPLMD+7a3+Ajnbc8p+yb9ODp+Q9GQjQFNPZdDpzVI=;
 b=dUw4UU2AOCt0ONKxXRtW+CRttajZN91cDSXHB1YO4Zll7xWCAUDnSGZDjLc+G9mh7P95Y8AoUzmV57x0Xd6zOeYtJzkfQ5dqayK6edZsgL5MeYYgJD0U/8VEIMGFmhRgc80TsCtSgtBhKCsC/OYGO/7/hqLzluCqPu6SlR7hXE0=
Received: from DBBPR05MB6426.eurprd05.prod.outlook.com (20.179.42.80) by
 DBBPR05MB6506.eurprd05.prod.outlook.com (20.179.43.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Thu, 7 Feb 2019 22:26:52 +0000
Received: from DBBPR05MB6426.eurprd05.prod.outlook.com
 ([fe80::c402:4592:e149:cb91]) by DBBPR05MB6426.eurprd05.prod.outlook.com
 ([fe80::c402:4592:e149:cb91%2]) with mapi id 15.20.1601.016; Thu, 7 Feb 2019
 22:26:52 +0000
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
Subject: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Thread-Topic: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Thread-Index: AQHUvzQ5rNYocWvZOkiWAVOxemV5Zg==
Date:   Thu, 7 Feb 2019 22:26:52 +0000
Message-ID: <20190207222647.GA30974@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0046.namprd08.prod.outlook.com
 (2603:10b6:300:c0::20) To DBBPR05MB6426.eurprd05.prod.outlook.com
 (2603:10a6:10:c9::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [174.3.196.123]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DBBPR05MB6506;6:cno0OXTc2EOBjGk9pRDBRdZ/FC5gJ4OtzKw4/bDGI27nCW5yaD8WhuDDRy2UL7hNTwyzyXFxS2T+zqCJNpBn9XafU2b2EVO/lDMz9Fm7SmevJnDt/oekaF19Q/Ssb32K2y/WD5jwMziJVRWUvdqiZHI3BrZ6TwfQXrTj7OYmfdIOgpk6ffhExw92okAR/L8wEgl89VUZwHFr+SEGcyipkWnYoFeHho6d4nOklyOxckVyR5e8HH44J1NMX2TYHiFd5nfC5XoTzsN5KdECYjbcoHN7IyCtsQwVQgNS3pt1DncvEwmDTgPjWBCK2Q3NqF+8nDMz4hvqjXcbpUbAdNL9IA9NYLZd3NkbMkB8vfpDeNb+EyAF8Ap8s/L97ygkjQKN1doWFcAKh9DKJOBge6EI2v8PAm2+VtCJPE0owiADJfmtXNIWGOYeGYggXxa7D3oDLe2RsAbgdEVaeGPIjMF3+Q==;5:GBggjs+fcUZwHKUcyIdguwqiP73G9oPatK9iQ7fKaJ34PGCiZtgmwdyv0pnVwLOhel0Q+T5iApgOSw/PqWXkAktD3HFiUd6WWiiSIJdCCYX261XYDr8gGJSbGw6F/DfTWSZK2iIxQNSPiu2aw47iUnKsmsnkB1fddmGlGer5gCYa/8qdfIg3GdzIOXCekRioSndxgmySVWculblf7L7Biw==;7:CIk9Xx/pbPuL0tDZRnR2fK1BFXgYsHBEmPjpJdr0q+KUzbPf94OW0hAfUSnV9KepDSLUV81w8VS5C3P4m96E/EI2XGfvJb7dyerCkp6Nu4p3UASiou70VnA9k1Puq74pAuhvdxHvkTxQPoNkkvmo0A==
x-ms-office365-filtering-correlation-id: d0b3c6a1-5327-4682-0c3e-08d68d4b5bd6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DBBPR05MB6506;
x-ms-traffictypediagnostic: DBBPR05MB6506:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DBBPR05MB6506337E98A0767152B0E0AFCF680@DBBPR05MB6506.eurprd05.prod.outlook.com>
x-forefront-prvs: 0941B96580
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(189003)(486006)(6116002)(7736002)(97736004)(36756003)(33896004)(1076003)(2501003)(14454004)(33656002)(3846002)(966005)(305945005)(52116002)(2906002)(478600001)(6506007)(386003)(71200400001)(8936002)(256004)(71190400001)(26005)(106356001)(102836004)(7416002)(105586002)(6306002)(81166006)(6512007)(81156014)(9686003)(6486002)(99286004)(53936002)(8676002)(68736007)(476003)(110136005)(86362001)(6436002)(2201001)(316002)(186003)(66066001)(25786009)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6506;H:DBBPR05MB6426.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qLwPbSHnvS3AmMDBUD5Wg/fpRb44pFEIIQptlqoQ0G46YVyghCoNSLb8If44iDDMyPmIvXhjyqcyJNE2PLQh/HO5lt4wZc0v2N20WLudCrHCWvBThgBWnKuq09gaE53SjVX+U5v78ujBZpAfQC/iYfC0kN0IDYPVw49tzO8wqVcJ+upW46CI9wB5yjqLZgPbFu5wEYz6OGgb4lwgJvH6iwdhhAJkXcSOwcoHfwXSuPb+18pABoc20jkN1/987Dk/7KXaxaNhxZv7VnS1sROON/OaRMT3fQdc3UH5BUgl0XY3Tx6fVqMNhsxvSvM9D6rm84rWzDYBHOk0OQIFA7pG+mpe38mppYfS8O1OtdIjSSl2c84hY0Qpa/DJh6wN1P2TuvldTizzyUAPNPI5VB93/ftPQnRstb5lIcqYLV+UXYg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7158A6D674FEAA4692D9F442D86369D9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b3c6a1-5327-4682-0c3e-08d68d4b5bd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2019 22:26:52.2301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6506
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
backing pages") introduced the sg_page_iter_dma_address() function without
providing a way to use it in the general case. If the sg_dma_len() is not
equal to the sg length callers cannot safely use the
for_each_sg_page/sg_page_iter_dma_address combination.

Resolve this API mistake by providing a DMA specific iterator,
for_each_sg_dma_page(), that uses the right length so
sg_page_iter_dma_address() works as expected with all sglists.

A new iterator type is introduced to provide compile-time safety against
wrongly mixing accessors and iterators.

Acked-by: Christoph Hellwig <hch@lst.de> (for scatterlist)
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 .clang-format                              |  1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c |  8 +++-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c   |  4 +-
 include/linux/scatterlist.h                | 49 ++++++++++++++++++----
 lib/scatterlist.c                          | 26 ++++++++++++
 5 files changed, 76 insertions(+), 12 deletions(-)

v2:
- Drop the vmwgfx fix in favor of keeping it unchanged as there is no
  reviewer. Use an ugly case with a comment instead.

I'd like to apply this to the RDMA tree next week, a large series from
Shiraz is waiting on it:

https://patchwork.kernel.org/project/linux-rdma/list/?series=3D71841&state=
=3D*

Regards,
Jason

diff --git a/.clang-format b/.clang-format
index bc2ffb2a0b5366..335ce29ab8132c 100644
--- a/.clang-format
+++ b/.clang-format
@@ -240,6 +240,7 @@ ForEachMacros:
   - 'for_each_set_bit'
   - 'for_each_set_bit_from'
   - 'for_each_sg'
+  - 'for_each_sg_dma_page'
   - 'for_each_sg_page'
   - 'for_each_sibling_event'
   - '__for_each_thread'
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm/v=
mwgfx/vmwgfx_ttm_buffer.c
index 31786b200afc47..e84f6aaee778f0 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
@@ -311,7 +311,13 @@ static dma_addr_t __vmw_piter_dma_addr(struct vmw_pite=
r *viter)
=20
 static dma_addr_t __vmw_piter_sg_addr(struct vmw_piter *viter)
 {
-	return sg_page_iter_dma_address(&viter->iter);
+	/*
+	 * FIXME: This driver wrongly mixes DMA and CPU SG list iteration and
+	 * needs revision. See
+	 * https://lore.kernel.org/lkml/20190104223531.GA1705@ziepe.ca/
+	 */
+	return sg_page_iter_dma_address(
+		(struct sg_dma_page_iter *)&viter->iter);
 }
=20
=20
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/i=
ntel/ipu3/ipu3-cio2.c
index cdb79ae2d8dc72..c0a5ce1d13b0bc 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -846,7 +846,7 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
 	unsigned int pages =3D DIV_ROUND_UP(vb->planes[0].length, CIO2_PAGE_SIZE)=
;
 	unsigned int lops =3D DIV_ROUND_UP(pages + 1, entries_per_page);
 	struct sg_table *sg;
-	struct sg_page_iter sg_iter;
+	struct sg_dma_page_iter sg_iter;
 	int i, j;
=20
 	if (lops <=3D 0 || lops > CIO2_MAX_LOPS) {
@@ -873,7 +873,7 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
 		b->offset =3D sg->sgl->offset;
=20
 	i =3D j =3D 0;
-	for_each_sg_page(sg->sgl, &sg_iter, sg->nents, 0) {
+	for_each_sg_dma_page(sg->sgl, &sg_iter, sg->nents, 0) {
 		if (!pages--)
 			break;
 		b->lop[i][j] =3D sg_page_iter_dma_address(&sg_iter) >> PAGE_SHIFT;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index b96f0d0b5b8f30..b4be960c7e5dba 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -339,12 +339,12 @@ int sg_alloc_table_chained(struct sg_table *table, in=
t nents,
 /*
  * sg page iterator
  *
- * Iterates over sg entries page-by-page.  On each successful iteration,
- * you can call sg_page_iter_page(@piter) and sg_page_iter_dma_address(@pi=
ter)
- * to get the current page and its dma address. @piter->sg will point to t=
he
- * sg holding this page and @piter->sg_pgoffset to the page's page offset
- * within the sg. The iteration will stop either when a maximum number of =
sg
- * entries was reached or a terminating sg (sg_last(sg) =3D=3D true) was r=
eached.
+ * Iterates over sg entries page-by-page.  On each successful iteration, y=
ou
+ * can call sg_page_iter_page(@piter) to get the current page and its dma
+ * address. @piter->sg will point to the sg holding this page and
+ * @piter->sg_pgoffset to the page's page offset within the sg. The iterat=
ion
+ * will stop either when a maximum number of sg entries was reached or a
+ * terminating sg (sg_last(sg) =3D=3D true) was reached.
  */
 struct sg_page_iter {
 	struct scatterlist	*sg;		/* sg holding the page */
@@ -356,7 +356,19 @@ struct sg_page_iter {
 						 * next step */
 };
=20
+/*
+ * sg page iterator for DMA addresses
+ *
+ * This is the same as sg_page_iter however you can call
+ * sg_page_iter_dma_address(@dma_iter) to get the page's DMA
+ * address. sg_page_iter_page() cannot be called on this iterator.
+ */
+struct sg_dma_page_iter {
+	struct sg_page_iter base;
+};
+
 bool __sg_page_iter_next(struct sg_page_iter *piter);
+bool __sg_page_iter_dma_next(struct sg_dma_page_iter *dma_iter);
 void __sg_page_iter_start(struct sg_page_iter *piter,
 			  struct scatterlist *sglist, unsigned int nents,
 			  unsigned long pgoffset);
@@ -372,11 +384,13 @@ static inline struct page *sg_page_iter_page(struct s=
g_page_iter *piter)
 /**
  * sg_page_iter_dma_address - get the dma address of the current page held=
 by
  * the page iterator.
- * @piter:	page iterator holding the page
+ * @dma_iter:	page iterator holding the page
  */
-static inline dma_addr_t sg_page_iter_dma_address(struct sg_page_iter *pit=
er)
+static inline dma_addr_t
+sg_page_iter_dma_address(struct sg_dma_page_iter *dma_iter)
 {
-	return sg_dma_address(piter->sg) + (piter->sg_pgoffset << PAGE_SHIFT);
+	return sg_dma_address(dma_iter->base.sg) +
+	       (dma_iter->base.sg_pgoffset << PAGE_SHIFT);
 }
=20
 /**
@@ -385,11 +399,28 @@ static inline dma_addr_t sg_page_iter_dma_address(str=
uct sg_page_iter *piter)
  * @piter:	page iterator to hold current page, sg, sg_pgoffset
  * @nents:	maximum number of sg entries to iterate over
  * @pgoffset:	starting page offset
+ *
+ * Callers may use sg_page_iter_page() to get each page pointer.
  */
 #define for_each_sg_page(sglist, piter, nents, pgoffset)		   \
 	for (__sg_page_iter_start((piter), (sglist), (nents), (pgoffset)); \
 	     __sg_page_iter_next(piter);)
=20
+/**
+ * for_each_sg_dma_page - iterate over the pages of the given sg list
+ * @sglist:	sglist to iterate over
+ * @dma_iter:	page iterator to hold current page
+ * @dma_nents:	maximum number of sg entries to iterate over, this is the v=
alue
+ *              returned from dma_map_sg
+ * @pgoffset:	starting page offset
+ *
+ * Callers may use sg_page_iter_dma_address() to get each page's DMA addre=
ss.
+ */
+#define for_each_sg_dma_page(sglist, dma_iter, dma_nents, pgoffset)       =
     \
+	for (__sg_page_iter_start(&(dma_iter)->base, sglist, dma_nents,        \
+				  pgoffset);                                   \
+	     __sg_page_iter_dma_next(dma_iter);)
+
 /*
  * Mapping sg iterator
  *
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 9ba349e775ef08..739dc9fe2c55ec 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -625,6 +625,32 @@ bool __sg_page_iter_next(struct sg_page_iter *piter)
 }
 EXPORT_SYMBOL(__sg_page_iter_next);
=20
+static int sg_dma_page_count(struct scatterlist *sg)
+{
+	return PAGE_ALIGN(sg->offset + sg_dma_len(sg)) >> PAGE_SHIFT;
+}
+
+bool __sg_page_iter_dma_next(struct sg_dma_page_iter *dma_iter)
+{
+	struct sg_page_iter *piter =3D &dma_iter->base;
+
+	if (!piter->__nents || !piter->sg)
+		return false;
+
+	piter->sg_pgoffset +=3D piter->__pg_advance;
+	piter->__pg_advance =3D 1;
+
+	while (piter->sg_pgoffset >=3D sg_dma_page_count(piter->sg)) {
+		piter->sg_pgoffset -=3D sg_dma_page_count(piter->sg);
+		piter->sg =3D sg_next(piter->sg);
+		if (!--piter->__nents || !piter->sg)
+			return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(__sg_page_iter_dma_next);
+
 /**
  * sg_miter_start - start mapping iteration over a sg list
  * @miter: sg mapping iter to be started
--=20
2.20.1

