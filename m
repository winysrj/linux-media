Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:55452 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbdH2Uah (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 16:30:37 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] cx24113: Adjustments for cx24113_attach()
Message-ID: <36a5402f-c7a2-edf0-1af8-b98b0684d8e5@users.sourceforge.net>
Date: Tue, 29 Aug 2017 22:30:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Aug 2017 22:23:45 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation
  Return directly after a failed kzalloc()
  Improve a size determination

 drivers/media/dvb-frontends/cx24113.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

-- 
2.14.1
