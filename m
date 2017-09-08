Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:63140 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932391AbdIHUvB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 16:51:01 -0400
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] S5P MFC: Adjustments for five function implementations
Message-ID: <482a6c92-a85e-0bcd-edf7-3c2f63ea74c5@users.sourceforge.net>
Date: Fri, 8 Sep 2017 22:50:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 8 Sep 2017 22:44:55 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation in s5p_mfc_probe()
  Improve a size determination ins5p_mfc_alloc_memdev()
  Adjust a null pointer check in four functions

 drivers/media/platform/s5p-mfc/s5p_mfc.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

-- 
2.14.1
