Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:60365 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751185AbdIPKuX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 06:50:23 -0400
To: linux-media@vger.kernel.org,
        Alexey Klimov <klimov.linux@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] MR800: Adjustments for usb_amradio_probe()
Message-ID: <7efe75db-dbb4-0fe7-509d-908b81072ca1@users.sourceforge.net>
Date: Sat, 16 Sep 2017 12:50:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 12:35:43 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete two error messages for a failed memory allocation
  Improve a size determination
  Delete an unnecessary variable initialisation

 drivers/media/radio/radio-mr800.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

-- 
2.14.1
