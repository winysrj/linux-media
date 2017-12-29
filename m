Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56870 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750741AbdL2NiB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 08:38:01 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Inki Dae <inki.dae@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH 0/4] Some patches for DVB VB2 kAPI documentation
Date: Fri, 29 Dec 2017 08:37:52 -0500
Message-Id: <cover.1514554610.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the new dvb-vb2 kAPI bits, in order to keep it in sync with
implementation, and shut up two new documentation warnings.

Mauro Carvalho Chehab (4):
  media: dvb_vb2: use strlcpy instead of strncpy
  media: dvb_vb2: get rid of DVB_BUF_TYPE_OUTPUT
  media: dvb kAPI docs: document dvb_vb2.h
  media: dmx.h documentation: fix a warning

 Documentation/media/dmx.h.rst.exceptions |   2 +
 Documentation/media/kapi/dtv-common.rst  |   5 +
 drivers/media/dvb-core/dvb_vb2.c         |   2 +-
 include/media/dmxdev.h                   |   2 +
 include/media/dvb_vb2.h                  | 184 +++++++++++++++++++++++++++++--
 5 files changed, 187 insertions(+), 8 deletions(-)

-- 
2.14.3
