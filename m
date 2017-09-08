Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:49852 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754713AbdIHM3N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 08:29:13 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] DaVinci-VPBE-Display: Adjustments for some
 function implementations
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <e980c48c-9525-4942-a58e-20af8a96e531@users.sourceforge.net>
Date: Fri, 8 Sep 2017 14:29:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 8 Sep 2017 14:12:10 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation in init_vpbe_layer()
  Improve a size determination in two functions
  Adjust 12 checks for null pointers

 drivers/media/platform/davinci/vpbe_display.c | 37 +++++++++++----------------
 1 file changed, 15 insertions(+), 22 deletions(-)

-- 
2.14.1
