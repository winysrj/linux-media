Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:53960 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751556AbdIOUko (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 16:40:44 -0400
To: linux-media@vger.kernel.org,
        Alexey Klimov <klimov.linux@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] MA901: Adjustments for usb_ma901radio_probe()
Message-ID: <6d4d9e92-9ac5-1e46-99ed-2b7d93bd7121@users.sourceforge.net>
Date: Fri, 15 Sep 2017 22:40:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 22:31:23 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete two error messages for a failed memory allocation
  Improve a size determination

 drivers/media/radio/radio-ma901.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
2.14.1
