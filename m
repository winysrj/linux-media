Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:53955 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdITQ4A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 12:56:00 -0400
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/5] [media] s2255drv: Fine-tuning for some function
 implementations
Message-ID: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Date: Wed, 20 Sep 2017 18:55:33 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 18:18:28 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (5):
  Delete three error messages for a failed memory allocation in s2255_probe()
  Adjust 13 checks for null pointers
  Improve two size determinations in s2255_probe()
  Use common error handling code in read_pipe_completion()
  Delete an unnecessary return statement in five functions

 drivers/media/usb/s2255/s2255drv.c | 64 ++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 38 deletions(-)

-- 
2.14.1
