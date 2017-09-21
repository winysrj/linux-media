Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50294 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdIUPFq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:05:46 -0400
To: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] [media] usbvision-core: Fine-tuning for some function
 implementations
Message-ID: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
Date: Thu, 21 Sep 2017 17:04:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 21 Sep 2017 17:00:17 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Use common error handling code in usbvision_set_input()
  Use common error handling code in usbvision_set_compress_params()
  Delete unnecessary braces in 11 functions
  Replace four printk() calls by dev_err()

 drivers/media/usb/usbvision/usbvision-core.c | 128 ++++++++++++---------------
 1 file changed, 58 insertions(+), 70 deletions(-)

-- 
2.14.1
