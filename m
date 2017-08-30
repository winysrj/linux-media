Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:61728 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751039AbdH3HSW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 03:18:22 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/6] [media] cx24116: Adjustments for two function
 implementations
Message-ID: <d01b4a11-6e93-bc40-72de-dab9ce7b997a@users.sourceforge.net>
Date: Wed, 30 Aug 2017 09:18:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 30 Aug 2017 09:05:04 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (6):
  Delete an error message for a failed memory allocation in cx24116_writeregN()
  Return directly after a failed kmalloc() in cx24116_writeregN()
  Delete an unnecessary variable initialisation in cx24116_writeregN()
  Improve a size determination in cx24116_attach()
  Delete an unnecessary variable initialisation in cx24116_attach()
  Delete jump targets in cx24116_attach()

 drivers/media/dvb-frontends/cx24116.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

-- 
2.14.1
