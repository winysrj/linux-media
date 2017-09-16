Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:54171 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbdIPNf4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 09:35:56 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] si470x: Adjustments for si470x_usb_driver_probe()
Message-ID: <b58222fa-99f8-f2d6-2755-5ccd4a91e783@users.sourceforge.net>
Date: Sat, 16 Sep 2017 15:35:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 15:16:17 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation
  Improve a size determination
  Delete an unnecessary variable initialisation

 drivers/media/radio/si470x/radio-si470x-usb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.14.1
