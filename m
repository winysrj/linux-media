Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:57252 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbdIRUKb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 16:10:31 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] ViCam: Adjustments for vicam_dostream()
Message-ID: <78839a2c-2076-f480-79d3-e783d2f8c0bf@users.sourceforge.net>
Date: Mon, 18 Sep 2017 22:10:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 22:05:22 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation
  Return directly after a failed kmalloc()

 drivers/media/usb/gspca/vicam.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

-- 
2.14.1
