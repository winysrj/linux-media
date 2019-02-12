Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7CBC282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 14:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2854A21773
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 14:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="HmS6kyve"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbfBLO5s (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 09:57:48 -0500
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:41351 "EHLO
        rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfBLO5s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 09:57:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3744; q=dns/txt; s=iport;
  t=1549983466; x=1551193066;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=qzq6uH9s2wpVXR8y4LllNnyBqWJlIxeJhgkiDor5fjg=;
  b=HmS6kyvexa0jX4C4vrgL3mATKWsWg28JeuS9nA0297CTKcgAwvzEYkob
   GgqqRKZ0RkqC1PM6VlaTipJyAlyhyFw7X0wCmAXB+mmsS56Nd7P1G6CyQ
   Ij8QPgSALvAYAtjlFqqPGUxb84QjqvP5PgScICdxRCt/rfvhwSfEliLaT
   k=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AKAAAh3mJc/5xdJa1jGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBUwMBAQEBCwGCA2eBAycKsiaBewsBARuEUYNHIjYHDQEDAQE?=
 =?us-ascii?q?CAQECbRwMhgs/EgE+QicEDg2DHYIBrSCKL4xDF4FAP48EAol/mSAJAoc2ixA?=
 =?us-ascii?q?hgj+QIZwVAhEUgScmAy6BVnAVgycJgh8XiF+FP0ExjnyBHwEB?=
X-IronPort-AV: E=Sophos;i="5.58,362,1544486400"; 
   d="scan'208";a="517184361"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2019 14:57:45 +0000
Received: from XCH-ALN-011.cisco.com (xch-aln-011.cisco.com [173.36.7.21])
        by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id x1CEvj25029820
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 12 Feb 2019 14:57:45 GMT
Received: from xch-aln-012.cisco.com (173.36.7.22) by XCH-ALN-011.cisco.com
 (173.36.7.21) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 12 Feb
 2019 08:57:45 -0600
Received: from xch-aln-012.cisco.com ([173.36.7.22]) by XCH-ALN-012.cisco.com
 ([173.36.7.22]) with mapi id 15.00.1395.000; Tue, 12 Feb 2019 08:57:45 -0600
From:   "Hans Verkuil (hansverk)" <hansverk@cisco.com>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
CC:     Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [GIT PULL FOR v5.1] Various fixes/enhancements
Thread-Topic: [GIT PULL FOR v5.1] Various fixes/enhancements
Thread-Index: AQHUwuNOyBC7s16vPECKOblX7Zl27w==
Date:   Tue, 12 Feb 2019 14:57:44 +0000
Message-ID: <285cc8bf16ad4be08cd2630c38c49f97@XCH-ALN-012.cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.47.79.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Outbound-SMTP-Client: 173.36.7.21, xch-aln-011.cisco.com
X-Outbound-Node: rcdn-core-5.cisco.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Main addition is adding proper packed 32-bit YUV support.=0A=
=0A=
Also fixes a long-standing vsp1 smatch warning and reorganizes the=0A=
extended control part of the documentation.=0A=
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
  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1o=0A=
=0A=
for you to fetch changes up to 5625b89c7bff945b294f91073416bf9e1524d9b5:=0A=
=0A=
  vsp1: fix smatch warning (2019-02-12 15:35:07 +0100)=0A=
=0A=
----------------------------------------------------------------=0A=
Tag branch=0A=
=0A=
----------------------------------------------------------------=0A=
Hans Verkuil (2):=0A=
      extended-controls.rst: split up per control class=0A=
      vsp1: fix smatch warning=0A=
=0A=
Vivek Kasireddy (4):=0A=
      media: v4l: Add 32-bit packed YUV formats=0A=
      media: v4l2-tpg-core: Add support for 32-bit packed YUV formats (v2)=
=0A=
      media: vivid: Add definitions for the 32-bit packed YUV formats=0A=
      media: imx-pxp: Start using the format VUYA32 instead of YUV32 (v2)=
=0A=
=0A=
 Documentation/media/uapi/v4l/common.rst                  |   11 +=0A=
 Documentation/media/uapi/v4l/ext-ctrls-camera.rst        |  508 +++++++=0A=
 Documentation/media/uapi/v4l/ext-ctrls-codec.rst         | 2451 ++++++++++=
+++++++++++++++++++++=0A=
 Documentation/media/uapi/v4l/ext-ctrls-detect.rst        |   71 +=0A=
 Documentation/media/uapi/v4l/ext-ctrls-dv.rst            |  166 +++=0A=
 Documentation/media/uapi/v4l/ext-ctrls-flash.rst         |  192 +++=0A=
 Documentation/media/uapi/v4l/ext-ctrls-fm-rx.rst         |   95 ++=0A=
 Documentation/media/uapi/v4l/ext-ctrls-fm-tx.rst         |  188 +++=0A=
 Documentation/media/uapi/v4l/ext-ctrls-image-process.rst |   63 +=0A=
 Documentation/media/uapi/v4l/ext-ctrls-image-source.rst  |   57 +=0A=
 Documentation/media/uapi/v4l/ext-ctrls-jpeg.rst          |  113 ++=0A=
 Documentation/media/uapi/v4l/ext-ctrls-rf-tuner.rst      |   96 ++=0A=
 Documentation/media/uapi/v4l/extended-controls.rst       | 3920 +---------=
----------------------------------------=0A=
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst       |  170 ++-=0A=
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c            |   12 +=0A=
 drivers/media/platform/imx-pxp.c                         |   14 +-=0A=
 drivers/media/platform/vivid/vivid-vid-common.c          |   30 +=0A=
 drivers/media/platform/vsp1/vsp1_drm.c                   |    6 +-=0A=
 drivers/media/v4l2-core/v4l2-ioctl.c                     |    4 +=0A=
 include/uapi/linux/videodev2.h                           |    4 +=0A=
 20 files changed, 4246 insertions(+), 3925 deletions(-)=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-camera.rst=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-codec.rst=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-detect.rst=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-dv.rst=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-flash.rst=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-fm-rx.rst=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-fm-tx.rst=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-image-process.rs=
t=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-image-source.rst=
=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-jpeg.rst=0A=
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-rf-tuner.rst=0A=
