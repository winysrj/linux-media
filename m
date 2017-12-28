Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59220 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdL1Q3o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 11:29:44 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Hirokazu Honda <hiroh@chromium.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 0/5] some VB2 bug fixes and improvements
Date: Thu, 28 Dec 2017 14:29:33 -0200
Message-Id: <cover.1514478428.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While working with DVB memory mapped patches, a few issues were
noticed at VB2. None of those patches are directly related to
dvb-vb2 logic, but they fix 3 issues found at VB2.

There are two other patches that improve vb2 print messages, by
defining pr_fmt() macro and by making clearer what's happening
when VB2 prints a stack dump.

Mauro Carvalho Chehab (3):
  media: vb2: don't go out of the buffer range
  media: vb2: add pr_fmt() macro
  media: vb2: add a new warning about pending buffers

Sakari Ailus (1):
  media: vb2: Enforce VB2_MAX_FRAME in vb2_core_reqbufs better

Satendra Singh Thakur (1):
  media: vb2: Fix a bug about unnecessary calls to queue cancel and free

 drivers/media/common/videobuf/videobuf2-core.c | 50 ++++++++++++++++----------
 1 file changed, 31 insertions(+), 19 deletions(-)

-- 
2.14.3
