Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:56138 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751569AbdICUaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 16:30:24 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/7] [media] SAA71..: Adjustments for four function
 implementations
Message-ID: <170abf7f-3b62-a37c-966a-8b574acae230@users.sourceforge.net>
Date: Sun, 3 Sep 2017 22:30:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 2f421e83375df1aeef50ce053f1dbcd1366c2365 Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 3 Sep 2017 20:50:10 +0200
Subject: [PATCH 0/7] [media] SAA71..: Adjustments for four function implementations

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (7):
  Delete an error message for a failed memory allocation in saa7164_buffer_alloc()
  SAA7164: Improve a size determination in two functions
  Gemini: Delete an error message for a failed memory allocation in hexium_attach()
  Gemini: Improve a size determination in hexium_attach()
  Orion: Delete an error message for a failed memory allocation in hexium_probe()
  Orion: Improve a size determination in hexium_probe()
  Orion: Adjust one function call together with a variable assignment

 drivers/media/pci/saa7146/hexium_gemini.c  |  7 +++----
 drivers/media/pci/saa7146/hexium_orion.c   | 10 +++++-----
 drivers/media/pci/saa7164/saa7164-buffer.c |  8 +++-----
 3 files changed, 11 insertions(+), 14 deletions(-)

-- 
2.14.1
