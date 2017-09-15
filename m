Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:61614 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbdIOSkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 14:40:22 -0400
To: linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] TI-VPE: Adjustments for five function
 implementations
Message-ID: <8137a759-cbfd-e04d-0adb-06de1b3246d1@users.sourceforge.net>
Date: Fri, 15 Sep 2017 20:40:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 20:30:40 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation in two functions
  Adjust nine checks for null pointers

 drivers/media/platform/ti-vpe/csc.c   |  6 ++----
 drivers/media/platform/ti-vpe/sc.c    |  4 +---
 drivers/media/platform/ti-vpe/vpdma.c |  2 +-
 drivers/media/platform/ti-vpe/vpe.c   | 14 +++++++-------
 4 files changed, 11 insertions(+), 15 deletions(-)

-- 
2.14.1
