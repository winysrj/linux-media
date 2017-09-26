Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:63616 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030804AbdIZNdz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 09:33:55 -0400
To: linux-media@vger.kernel.org,
        Devendra Sharma <devendra.sharma9091@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] dmxdev: Fine-tuning for two function
 implementations
Message-ID: <5f169dcb-b834-5ca3-2195-668e5295a7ca@users.sourceforge.net>
Date: Tue, 26 Sep 2017 15:33:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 26 Sep 2017 15:30:03 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use common error handling code in dvb_dmxdev_start_feed()
  Improve a size determination in dvb_dmxdev_add_pid()

 drivers/media/dvb-core/dmxdev.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

-- 
2.14.1
