Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387A2C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 12:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF3DC2192B
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 12:14:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="JGaA5161"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394668AbfBOMO7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 07:14:59 -0500
Received: from alln-iport-5.cisco.com ([173.37.142.92]:22309 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393015AbfBOMO7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 07:14:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4449; q=dns/txt; s=iport;
  t=1550232898; x=1551442498;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=MtnPurkCQLFe8xjS82cPwE58jolopiAZfscYs71rNuA=;
  b=JGaA5161efHbY5asR42Gt+rt485u+yJyxvvmuTRflsKcYJ3D5Gn6YFdE
   mIq5GeBhyLyYndJQw1moCk6E00gkHisltq+71Wv82w5qVg/TR9DtlOMCC
   ZBIyOnqEtVqkaMhmgbip6146pa+8GnSZfHSkrUheKewPZmy2P75acKszQ
   E=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AUAABArGZc/5pdJa1kGwEBAQEDAQE?=
 =?us-ascii?q?BBwMBAQGBUgUBAQELAYICZ4EDJwqXepokgXsLAQEbhFGDaiI1CA0BAwEBAgE?=
 =?us-ascii?q?BAm0cDIYLPxIBPkInBA4NgxmBcqx2ijGMRBeBQD+BEY1zAooHmS8JAoc6ixE?=
 =?us-ascii?q?hgkSQNZw2AhEUgSchATWBVnAVgycJixWFP0ExjxuBHwEB?=
X-IronPort-AV: E=Sophos;i="5.58,372,1544486400"; 
   d="scan'208";a="237691328"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2019 12:14:57 +0000
Received: from XCH-ALN-015.cisco.com (xch-aln-015.cisco.com [173.36.7.25])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id x1FCEvfI027908
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 15 Feb 2019 12:14:57 GMT
Received: from xch-aln-012.cisco.com (173.36.7.22) by XCH-ALN-015.cisco.com
 (173.36.7.25) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 15 Feb
 2019 06:14:56 -0600
Received: from xch-aln-012.cisco.com ([173.36.7.22]) by XCH-ALN-012.cisco.com
 ([173.36.7.22]) with mapi id 15.00.1395.000; Fri, 15 Feb 2019 06:14:56 -0600
From:   "Hans Verkuil (hansverk)" <hansverk@cisco.com>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
CC:     Ezequiel Garcia <ezequiel@collabora.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [GIT PULL FOR v5.1] Various fixes/improvements
Thread-Topic: [GIT PULL FOR v5.1] Various fixes/improvements
Thread-Index: AQHUxSgQ5Yku9OSHDkWkqY/8qEmVCQ==
Date:   Fri, 15 Feb 2019 12:14:56 +0000
Message-ID: <580fb36fac3b421cbfe111469a6dbe22@XCH-ALN-012.cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.47.79.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Outbound-SMTP-Client: 173.36.7.25, xch-aln-015.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,=0A=
=0A=
I decided to include Jacopo's arch/sh patch since there hasn't been a reply=
=0A=
for 10 days, and it is a simple fix for an annoying problem.=0A=
=0A=
I also merged Ezequiel's 'Correct return type' series: it's a bit painful=
=0A=
as it touches on more sources than you would expect, but this is a good tim=
e=0A=
to get this in. Having proper type checking is a good thing, after all.=0A=
=0A=
Regards,=0A=
=0A=
	Hans=0A=
=0A=
The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d=
:=0A=
=0A=
  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -=
0500)=0A=
=0A=
are available in the Git repository at:=0A=
=0A=
  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1p=0A=
=0A=
for you to fetch changes up to 79b66349d5580365ea9bcc3f699906bdd70f3671:=0A=
=0A=
  media: cedrus: mpeg2: Use v4l2_m2m_get_vq helper for capture queue (2019-=
02-15 12:13:03 +0100)=0A=
=0A=
----------------------------------------------------------------=0A=
Tag branch=0A=
=0A=
----------------------------------------------------------------=0A=
Chen-Yu Tsai (3):=0A=
      media: sun6i: Fix CSI regmap's max_register=0A=
      media: sun6i: Add support for RGB565 formats=0A=
      media: sun6i: Add support for JPEG media bus format=0A=
=0A=
Colin Ian King (1):=0A=
      media: exynos4-is: remove redundant check on type=0A=
=0A=
Ezequiel Garcia (10):=0A=
      mtk-jpeg: Correct return type for mem2mem buffer helpers=0A=
      mtk-mdp: Correct return type for mem2mem buffer helpers=0A=
      mtk-vcodec: Correct return type for mem2mem buffer helpers=0A=
      mx2_emmaprp: Correct return type for mem2mem buffer helpers=0A=
      rockchip/rga: Correct return type for mem2mem buffer helpers=0A=
      s5p-g2d: Correct return type for mem2mem buffer helpers=0A=
      s5p-jpeg: Correct return type for mem2mem buffer helpers=0A=
      sh_veu: Correct return type for mem2mem buffer helpers=0A=
      rockchip/vpu: Correct return type for mem2mem buffer helpers=0A=
      media: v4l2-mem2mem: Correct return type for mem2mem buffer helpers=
=0A=
=0A=
Jacopo Mondi (1):=0A=
      sh: migor: Include missing dma-mapping header=0A=
=0A=
Paul Kocialkowski (2):=0A=
      media: cedrus: Forbid setting new formats on busy queues=0A=
      media: cedrus: mpeg2: Use v4l2_m2m_get_vq helper for capture queue=0A=
=0A=
Tim Harvey (1):=0A=
      media: tda1997x: fix get_edid=0A=
=0A=
 arch/sh/boards/mach-migor/setup.c                           |  1 +=0A=
 drivers/media/i2c/tda1997x.c                                |  4 ++++=0A=
 drivers/media/platform/exynos4-is/fimc-isp-video.c          |  4 +---=0A=
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c             | 40 +++++++++=
+++++++++++--------------------=0A=
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c                | 20 +++++++--=
-----------=0A=
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c          | 62 +++++++++=
+++++++++++++++++------------------------------------=0A=
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c          | 72 +++++++++=
+++++++++++++++++++--------------------------------------------=0A=
 drivers/media/platform/mx2_emmaprp.c                        |  6 +++---=0A=
 drivers/media/platform/rockchip/rga/rga.c                   |  6 +++---=0A=
 drivers/media/platform/s5p-g2d/g2d.c                        |  6 +++---=0A=
 drivers/media/platform/s5p-jpeg/jpeg-core.c                 | 38 +++++++++=
++++++++++-------------------=0A=
 drivers/media/platform/sh_veu.c                             |  4 ++--=0A=
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c          | 27 +++++++++=
+++++++++++++++---=0A=
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h          |  3 +++=0A=
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c        |  3 +++=0A=
 drivers/media/v4l2-core/v4l2-mem2mem.c                      |  6 +++---=0A=
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c |  6 +++---=0A=
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c |  6 +++---=0A=
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c           | 10 +++++----=
-=0A=
 drivers/staging/media/sunxi/cedrus/cedrus_video.c           | 10 +++++++++=
+=0A=
 include/media/v4l2-mem2mem.h                                | 24 +++++++++=
++++++---------=0A=
 21 files changed, 186 insertions(+), 172 deletions(-)=0A=
