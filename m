Return-Path: <SRS0=+L2G=PM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDDBC43387
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 22:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BED69218D8
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 22:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="SASXcYiA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfADWgn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 4 Jan 2019 17:36:43 -0500
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:2017
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726105AbfADWgm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Jan 2019 17:36:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hepfAqFn9qm1SvlLipTWqo1FDDITgPB/Dc0Xyx5U4Ok=;
 b=SASXcYiA/NflEJyfWYFXrveZk6lyi85hZHVSr2F5i5lfPrDF9ps3wPFI4zI27Ep3QNoJaxS4SGFCflTTP37y6/YPmyiFJu/2xzgPYl0f6YAq93cz2yfiVbrkUTdFEIE9CX+XrfY4Q/n5TxnYNEDJoHwc/OB7VqW6azzwEEWdd20=
Received: from AM4PR0501MB2179.eurprd05.prod.outlook.com (10.165.82.10) by
 AM4PR0501MB2772.eurprd05.prod.outlook.com (10.172.216.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Fri, 4 Jan 2019 22:35:43 +0000
Received: from AM4PR0501MB2179.eurprd05.prod.outlook.com
 ([fe80::88a5:f979:5400:adf]) by AM4PR0501MB2179.eurprd05.prod.outlook.com
 ([fe80::88a5:f979:5400:adf%5]) with mapi id 15.20.1495.005; Fri, 4 Jan 2019
 22:35:43 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
CC:     Shiraz Saleem <shiraz.saleem@intel.com>,
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
Subject: [PATCH] lib/scatterlist: Provide a DMA page iterator
Thread-Topic: [PATCH] lib/scatterlist: Provide a DMA page iterator
Thread-Index: AQHUpH3T+Rn6hCeN4kq6RDaSbJgsYA==
Date:   Fri, 4 Jan 2019 22:35:43 +0000
Message-ID: <20190104223531.GA1705@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:104:1::28) To AM4PR0501MB2179.eurprd05.prod.outlook.com
 (2603:10a6:200:52::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [174.3.196.123]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM4PR0501MB2772;6:T+KWkjowF5jE7SSegfGmqnDwoFPyWSRS5Nn+2Ce9pDV5F71s4DkrdiWcK6IgCy0OR9M4shV43uMZy+dqXCVK2jBE91tPei0rvRbg1nxAS2Jidfo42C7G3b9Bnept+qSlhRIIfytskJb1Dhy3NXLoapp2/ApvtgwHszXM9xT8DO4SecnaFpIGNBChbU6AIEJjPO87znGE6CunSPltA/Kya5c3UKVTYN0zBzROI64LpaT9tBV0Eibyb4J3Kz9n5jTXWZBei7EF7uYi6+WMGeBSI+V70ggLlE35xyEQrR19XynbW6mjSbHDlLcdwHeCesijegqhQfmu9BfOnAM4RWZhnEjxrooJV0cTqSU3fEuePcGry4CybhZdVfalw5JSdWAhS9ZRyLwcUpPGi0i93HX1TmpTm8wRorx8XJqXCYR9LKQslWzpTFr0d0770sDiMUJ3IqD5i8fBvBNxjPd94RCtDw==;5:v6Mt9qhc7EsJ26DzaJK6t/gAToCQ3YwaHxA3TXFluQxAVa6/zvf4iz8xMGGYA1gWyFnMAEJ2KJwtLt9r5/OT4MvMbF9zFzDsO3gV7BE8YE6ZYYv1ZsEDNu0sCOBFUCklUhS+tsg1yflPtDc+Pk5AbvOxStxca5vcODyOAkNFf21RS3G0OMB/wkte7a77WT2uvIfx5JMX2P3FASUXRo5szQ==;7:rfGEqwzQN7tYH/XB118o6HhGMfGKFNrI28M44CKNQFszf6u46EvCJa0zFpUvxWeTzWib+QAiHXCz+n8BFJ0LyasRiBkG7w5RCTMR+ahgHgH2QKpmaLZEdMp2bpEcT2kDtnMnkZeGeRkYMC6VoIE2yQ==
x-ms-office365-filtering-correlation-id: 7e9df72a-2771-4b6d-ec07-08d67294f603
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM4PR0501MB2772;
x-ms-traffictypediagnostic: AM4PR0501MB2772:
x-microsoft-antispam-prvs: <AM4PR0501MB27727F02A694ABB09E747A8FCF8E0@AM4PR0501MB2772.eurprd05.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(10201501046)(93006095)(93001095)(3231475)(944501520)(52105112)(3002001)(6055026)(6041310)(20161123562045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:AM4PR0501MB2772;BCL:0;PCL:0;RULEID:;SRVR:AM4PR0501MB2772;
x-forefront-prvs: 0907F58A24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(366004)(39860400002)(346002)(199004)(189003)(386003)(14454004)(256004)(36756003)(7416002)(1076003)(81166006)(81156014)(8676002)(8936002)(4744004)(33656002)(26005)(25786009)(186003)(6506007)(6436002)(99286004)(478600001)(102836004)(305945005)(33896004)(97736004)(105586002)(71190400001)(71200400001)(6116002)(3846002)(7736002)(2501003)(52116002)(476003)(106356001)(66066001)(86362001)(575784001)(486006)(68736007)(54906003)(316002)(6486002)(110136005)(2906002)(9686003)(6512007)(53936002)(5660300001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2772;H:AM4PR0501MB2179.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0xOb92iKbYDmJQgPeKAk9VfWiX+gbC6E13PFa+HiYnTMB0Z2PPW00Nk4zAM2jYuFxsDk8edrIRlbEtG9oN115QhWJNNsifUoDHjje9ePdF4toe73269XHD+owFlsNAK3bjqfFY3JTjJRmbxYRjcWE9dBdux5V858w+SLSVss14putwj/8yhpQJqW08sExCI6QqAskWyl5kdDfFkYzON8M9tMHfAIqqxrwJxxzHwB/NF9WXPrQfXbOEDtO/FEGy3G7nzdDctMjign8bYud2Ua5M28BYWbV7TU6zBSyj0JO9Sz2RPeK9m/nTnzf1qYBgbf
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F99263AB32E56543B99CB6F9EEB8B483@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9df72a-2771-4b6d-ec07-08d67294f603
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 22:35:42.7682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2772
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
backing pages") introduced the sg_page_iter_dma_address() function without
providing a way to use it in the general case. If the sg_dma_len is not
equal to the dma_length callers cannot safely use the
for_each_sg_page/sg_page_iter_dma_address combination.

Resolve this API mistake by providing a DMA specific iterator,
for_each_sg_dma_page(), that uses the right length so
sg_page_iter_dma_address() works as expected with all sglists. A new
iterator type is introduced to provide compile-time safety against wrongly
mixing accessors and iterators.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h        | 26 ++++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c        | 26 +++++++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c | 42 +++++++++++++------
 drivers/media/pci/intel/ipu3/ipu3-cio2.c   |  4 +-
 include/linux/scatterlist.h                | 49 ++++++++++++++++++----
 lib/scatterlist.c                          | 26 ++++++++++++
 6 files changed, 134 insertions(+), 39 deletions(-)

I'd like to run this patch through the RDMA tree as we have another
series in the works that wants to use the for_each_sg_dma_page() API.

The changes to vmwgfx make me nervous, it would be great if someone
could test and ack them?

Changes since the RFC:
- Rework vmwgfx too [CH]
- Use a distinct type for the DMA page iterator [CH]
- Do not have a #ifdef [CH]

Thanks,
Jason

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/v=
mwgfx_drv.h
index 59f614225bcd72..3c6d71e13a9342 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -297,7 +297,10 @@ struct vmw_sg_table {
 struct vmw_piter {
 	struct page **pages;
 	const dma_addr_t *addrs;
-	struct sg_page_iter iter;
+	union {
+		struct sg_page_iter iter;
+		struct sg_dma_page_iter dma_iter;
+	};
 	unsigned long i;
 	unsigned long num_pages;
 	bool (*next)(struct vmw_piter *);
@@ -869,9 +872,24 @@ extern int vmw_bo_map_dma(struct ttm_buffer_object *bo=
);
 extern void vmw_bo_unmap_dma(struct ttm_buffer_object *bo);
 extern const struct vmw_sg_table *
 vmw_bo_sg_table(struct ttm_buffer_object *bo);
-extern void vmw_piter_start(struct vmw_piter *viter,
-			    const struct vmw_sg_table *vsgt,
-			    unsigned long p_offs);
+void _vmw_piter_start(struct vmw_piter *viter, const struct vmw_sg_table *=
vsgt,
+		      unsigned long p_offs, bool for_dma);
+
+/* Create a piter that can call vmw_piter_dma_addr() */
+static inline void vmw_piter_start(struct vmw_piter *viter,
+				   const struct vmw_sg_table *vsgt,
+				   unsigned long p_offs)
+{
+	_vmw_piter_start(viter, vsgt, p_offs, true);
+}
+
+/* Create a piter that can call vmw_piter_page() */
+static inline void vmw_piter_cpu_start(struct vmw_piter *viter,
+				   const struct vmw_sg_table *vsgt,
+				   unsigned long p_offs)
+{
+	_vmw_piter_start(viter, vsgt, p_offs, false);
+}
=20
 /**
  * vmw_piter_next - Advance the iterator one page.
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c b/drivers/gpu/drm/vmwgfx/v=
mwgfx_mob.c
index 7ed179d30ec51f..a13788017ad608 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -503,7 +503,8 @@ static void vmw_mob_assign_ppn(u32 **addr, dma_addr_t v=
al)
  */
 static unsigned long vmw_mob_build_pt(struct vmw_piter *data_iter,
 				      unsigned long num_data_pages,
-				      struct vmw_piter *pt_iter)
+				      struct vmw_piter *pt_iter_cpu,
+				      struct vmw_piter *pt_iter_dma)
 {
 	unsigned long pt_size =3D num_data_pages * VMW_PPN_SIZE;
 	unsigned long num_pt_pages =3D DIV_ROUND_UP(pt_size, PAGE_SIZE);
@@ -513,7 +514,7 @@ static unsigned long vmw_mob_build_pt(struct vmw_piter =
*data_iter,
 	struct page *page;
=20
 	for (pt_page =3D 0; pt_page < num_pt_pages; ++pt_page) {
-		page =3D vmw_piter_page(pt_iter);
+		page =3D vmw_piter_page(pt_iter_cpu);
=20
 		save_addr =3D addr =3D kmap_atomic(page);
=20
@@ -525,7 +526,8 @@ static unsigned long vmw_mob_build_pt(struct vmw_piter =
*data_iter,
 			WARN_ON(!vmw_piter_next(data_iter));
 		}
 		kunmap_atomic(save_addr);
-		vmw_piter_next(pt_iter);
+		vmw_piter_next(pt_iter_cpu);
+		vmw_piter_next(pt_iter_dma);
 	}
=20
 	return num_pt_pages;
@@ -547,29 +549,31 @@ static void vmw_mob_pt_setup(struct vmw_mob *mob,
 {
 	unsigned long num_pt_pages =3D 0;
 	struct ttm_buffer_object *bo =3D mob->pt_bo;
-	struct vmw_piter save_pt_iter;
-	struct vmw_piter pt_iter;
+	struct vmw_piter pt_iter_cpu, pt_iter_dma;
 	const struct vmw_sg_table *vsgt;
+	dma_addr_t root_page =3D 0;
 	int ret;
=20
 	ret =3D ttm_bo_reserve(bo, false, true, NULL);
 	BUG_ON(ret !=3D 0);
=20
 	vsgt =3D vmw_bo_sg_table(bo);
-	vmw_piter_start(&pt_iter, vsgt, 0);
-	BUG_ON(!vmw_piter_next(&pt_iter));
+	vmw_piter_start(&pt_iter_dma, vsgt, 0);
+	vmw_piter_cpu_start(&pt_iter_cpu, vsgt, 0);
+	BUG_ON(!vmw_piter_next(&pt_iter_cpu));
+	BUG_ON(!vmw_piter_next(&pt_iter_dma));
 	mob->pt_level =3D 0;
 	while (likely(num_data_pages > 1)) {
 		++mob->pt_level;
 		BUG_ON(mob->pt_level > 2);
-		save_pt_iter =3D pt_iter;
+		root_page =3D vmw_piter_dma_addr(&pt_iter_dma);
 		num_pt_pages =3D vmw_mob_build_pt(&data_iter, num_data_pages,
-						&pt_iter);
-		data_iter =3D save_pt_iter;
+						&pt_iter_cpu, &pt_iter_dma);
+		vmw_piter_start(&data_iter, vsgt, 0);
 		num_data_pages =3D num_pt_pages;
 	}
=20
-	mob->pt_root_page =3D vmw_piter_dma_addr(&save_pt_iter);
+	mob->pt_root_page =3D root_page;
 	ttm_bo_unreserve(bo);
 }
=20
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm/v=
mwgfx/vmwgfx_ttm_buffer.c
index 31786b200afc47..db8f3e40a4facb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
@@ -269,6 +269,11 @@ static bool __vmw_piter_sg_next(struct vmw_piter *vite=
r)
 	return __sg_page_iter_next(&viter->iter);
 }
=20
+static bool __vmw_piter_sg_dma_next(struct vmw_piter *viter)
+{
+	return __sg_page_iter_dma_next(&viter->dma_iter);
+}
+
=20
 /**
  * Helper functions to return a pointer to the current page.
@@ -309,9 +314,9 @@ static dma_addr_t __vmw_piter_dma_addr(struct vmw_piter=
 *viter)
 	return viter->addrs[viter->i];
 }
=20
-static dma_addr_t __vmw_piter_sg_addr(struct vmw_piter *viter)
+static dma_addr_t __vmw_piter_sg_dma_addr(struct vmw_piter *viter)
 {
-	return sg_page_iter_dma_address(&viter->iter);
+	return sg_page_iter_dma_address(&viter->dma_iter);
 }
=20
=20
@@ -325,32 +330,43 @@ static dma_addr_t __vmw_piter_sg_addr(struct vmw_pite=
r *viter)
  * the iterator doesn't point to a valid page after initialization; it has
  * to be advanced one step first.
  */
-void vmw_piter_start(struct vmw_piter *viter, const struct vmw_sg_table *v=
sgt,
-		     unsigned long p_offset)
+void _vmw_piter_start(struct vmw_piter *viter, const struct vmw_sg_table *=
vsgt,
+		      unsigned long p_offset, bool for_dma)
 {
 	viter->i =3D p_offset - 1;
 	viter->num_pages =3D vsgt->num_pages;
 	switch (vsgt->mode) {
 	case vmw_dma_phys:
 		viter->next =3D &__vmw_piter_non_sg_next;
-		viter->dma_address =3D &__vmw_piter_phys_addr;
-		viter->page =3D &__vmw_piter_non_sg_page;
+		if (for_dma)
+			viter->dma_address =3D &__vmw_piter_phys_addr;
+		else
+			viter->page =3D &__vmw_piter_non_sg_page;
 		viter->pages =3D vsgt->pages;
 		break;
 	case vmw_dma_alloc_coherent:
 		viter->next =3D &__vmw_piter_non_sg_next;
-		viter->dma_address =3D &__vmw_piter_dma_addr;
-		viter->page =3D &__vmw_piter_non_sg_page;
+		if (for_dma)
+			viter->dma_address =3D &__vmw_piter_dma_addr;
+		else
+			viter->page =3D &__vmw_piter_non_sg_page;
 		viter->addrs =3D vsgt->addrs;
 		viter->pages =3D vsgt->pages;
 		break;
 	case vmw_dma_map_populate:
 	case vmw_dma_map_bind:
-		viter->next =3D &__vmw_piter_sg_next;
-		viter->dma_address =3D &__vmw_piter_sg_addr;
-		viter->page =3D &__vmw_piter_sg_page;
-		__sg_page_iter_start(&viter->iter, vsgt->sgt->sgl,
-				     vsgt->sgt->orig_nents, p_offset);
+		if (for_dma) {
+			viter->next =3D &__vmw_piter_sg_dma_next;
+			viter->dma_address =3D &__vmw_piter_sg_dma_addr;
+			__sg_page_iter_start(&viter->dma_iter.base,
+					     vsgt->sgt->sgl,
+					     vsgt->sgt->orig_nents, p_offset);
+		} else {
+			viter->next =3D &__vmw_piter_sg_next;
+			viter->page =3D &__vmw_piter_sg_page;
+			__sg_page_iter_start(&viter->iter, vsgt->sgt->sgl,
+					     vsgt->sgt->orig_nents, p_offset);
+		}
 		break;
 	default:
 		BUG();
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/i=
ntel/ipu3/ipu3-cio2.c
index 447baaebca4486..32b6c6c217a46c 100644
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
index 093aa57120b0cf..c0592284e18b97 100644
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
index 7c6096a7170486..716a751be67357 100644
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
+EXPORT_SYMBOL(__sg_page_iter_next);
+
 /**
  * sg_miter_start - start mapping iteration over a sg list
  * @miter: sg mapping iter to be started
--=20
2.20.1

