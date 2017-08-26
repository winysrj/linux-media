Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:49244 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdHZUm1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 16:42:27 -0400
To: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Johan Hovold <johan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] usbvision: Adjustments for six function
 implementations
Message-ID: <f72f836e-6cab-8b79-9d87-a79bd62be174@users.sourceforge.net>
Date: Sat, 26 Aug 2017 22:42:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 26 Aug 2017 22:36:54 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation in usbvision_probe()
  Adjust eight checks for null pointers
  Improve a size determination in usbvision_alloc()

 drivers/media/usb/usbvision/usbvision-video.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

-- 
2.14.0
