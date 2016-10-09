Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:60555 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752190AbcJITzp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Oct 2016 15:55:45 -0400
To: adi-buildroot-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] blackfin-capture: Fine-tuning for two function
 implementations
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <ae9a008f-35e2-e4e0-be18-635050c8277e@users.sourceforge.net>
Date: Sun, 9 Oct 2016 21:55:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Oct 2016 21:44:33 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use kcalloc() in bcap_init_sensor_formats()
  Delete an error message for a failed memory allocation in bcap_probe()

 drivers/media/platform/blackfin/bfin_capture.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.10.1

