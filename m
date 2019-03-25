Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3603BC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 105472070D
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfCYV1w (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:27:52 -0400
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:45157 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730260AbfCYV1v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 17:27:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 26948100E86CD;
        Mon, 25 Mar 2019 21:27:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: cent87_26fa9457d0750
X-Filterd-Recvd-Size: 3831
Received: from joe-laptop.perches.com (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Mon, 25 Mar 2019 21:27:47 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Bad file pattern in MAINTAINERS section 'ROCKCHIP VPU CODEC DRIVER'
Date:   Mon, 25 Mar 2019 14:27:46 -0700
Message-Id: <20190325212747.27463-1-joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
References: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A file pattern line in this section of the MAINTAINERS file in linux-next
does not have a match in the linux source files.

This could occur because a matching filename was never added, was deleted
or renamed in some other commit.

The commits that added and if found renamed or removed the file pattern
are shown below.

Please fix this defect appropriately.

1: ---------------------------------------------------------------------------

linux-next MAINTAINERS section:

	13312	ROCKCHIP VPU CODEC DRIVER
	13313	M:	Ezequiel Garcia <ezequiel@collabora.com>
	13314	L:	linux-media@vger.kernel.org
	13315	S:	Maintained
-->	13316	F:	drivers/staging/media/platform/rockchip/vpu/
	13317	F:	Documentation/devicetree/bindings/media/rockchip-vpu.txt

2: ---------------------------------------------------------------------------

The most recent commit that added or modified file pattern 'drivers/staging/media/platform/rockchip/vpu/':

commit 775fec69008d30ed5e4ce9fa7701c5591e424c87
Author: Ezequiel Garcia <ezequiel@collabora.com>
Date:   Wed Dec 5 11:09:52 2018 -0500

    media: add Rockchip VPU JPEG encoder driver
    
    Add a mem2mem driver for the VPU available on Rockchip SoCs.
    Currently only JPEG encoding is supported, for RK3399 and RK3288
    platforms.
    
    Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
    Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
    [hverkuil-cisco@xs4all.nl: fix checkpatch.pl alignment warning]
    Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 MAINTAINERS                                        |   7 +
 drivers/staging/media/Kconfig                      |   2 +
 drivers/staging/media/Makefile                     |   1 +
 drivers/staging/media/rockchip/vpu/Kconfig         |  13 +
 drivers/staging/media/rockchip/vpu/Makefile        |  10 +
 drivers/staging/media/rockchip/vpu/TODO            |  13 +
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c | 118 ++++
 .../media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c    | 130 ++++
 .../staging/media/rockchip/vpu/rk3288_vpu_regs.h   | 442 ++++++++++++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c | 118 ++++
 .../media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c    | 164 +++++
 .../staging/media/rockchip/vpu/rk3399_vpu_regs.h   | 600 ++++++++++++++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu.h  | 232 +++++++
 .../media/rockchip/vpu/rockchip_vpu_common.h       |  29 +
 .../staging/media/rockchip/vpu/rockchip_vpu_drv.c  | 537 ++++++++++++++++
 .../staging/media/rockchip/vpu/rockchip_vpu_enc.c  | 676 +++++++++++++++++++++
 .../staging/media/rockchip/vpu/rockchip_vpu_hw.h   |  58 ++
 .../staging/media/rockchip/vpu/rockchip_vpu_jpeg.c | 290 +++++++++
 .../staging/media/rockchip/vpu/rockchip_vpu_jpeg.h |  14 +
 19 files changed, 3454 insertions(+)

3: ---------------------------------------------------------------------------

No commit with file pattern 'drivers/staging/media/platform/rockchip/vpu/' was found
