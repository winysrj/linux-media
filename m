Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:60623 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751568AbdIRIMi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 04:12:38 -0400
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] dvb_usb_core: Adjustments for two function
 implementations
Message-ID: <38627457-f64f-7356-bf5e-fc41296a26e4@users.sourceforge.net>
Date: Mon, 18 Sep 2017 10:12:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 09:51:23 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete two error messages for a failed memory allocation in dvb_usbv2_probe()
  Improve a size determination in two functions

 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

-- 
2.14.1
