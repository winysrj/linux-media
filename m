Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:56541 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750998AbdHaTzp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 15:55:45 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] mb86a20s: Adjustments for mb86a20s_attach()
Message-ID: <9571ee6c-5137-15f4-4cdb-9f03b5cb9268@users.sourceforge.net>
Date: Thu, 31 Aug 2017 21:55:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 31 Aug 2017 21:46:12 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation
  Improve a size determination
  Delete a jump target

 drivers/media/dvb-frontends/mb86a20s.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

-- 
2.14.1
