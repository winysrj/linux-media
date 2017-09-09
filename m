Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:62026 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750789AbdIITMq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 15:12:46 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] xc4000: Adjustments for xc4000_fwupload()
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <61016489-eb01-2977-b094-343aa70686b0@users.sourceforge.net>
Date: Sat, 9 Sep 2017 21:12:31 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 9 Sep 2017 21:00:12 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete two error messages for a failed memory allocation
  Adjust two null pointer checks

 drivers/media/tuners/xc4000.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.14.1
