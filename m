Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:59833 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751621AbdIUTXP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 15:23:15 -0400
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] uvcvideo: Fine-tuning for some function
 implementations
Message-ID: <20a8d1a5-45f1-2f98-e4b3-cfc24e9c04b0@users.sourceforge.net>
Date: Thu, 21 Sep 2017 21:23:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 21 Sep 2017 21:20:12 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Use common error handling code in uvc_ioctl_g_ext_ctrls()
  Adjust 14 checks for null pointers
  Add some spaces for better code readability

 drivers/media/usb/uvc/uvc_v4l2.c | 53 ++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

-- 
2.14.1
