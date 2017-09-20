Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:52526 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751798AbdITTKe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:10:34 -0400
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] TTUSB DVB Budget: Fine-tuning for three function
 implementations
Message-ID: <1ad3c3ce-3738-fee1-2ee5-37142fa1bc70@users.sourceforge.net>
Date: Wed, 20 Sep 2017 21:10:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 21:03:45 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Use common error handling code in ttusb_probe()
  Improve two size determinations in ttusb_probe()
  Adjust eight checks for null pointers

 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 34 +++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

-- 
2.14.1
