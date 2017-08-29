Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:51495 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbdH2LEL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 07:04:11 -0400
To: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geliang Tang <geliangtang@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] imon: Adjustments for two function
 implementations
Message-ID: <09417655-9241-72f4-6484-a3c8b3eae87a@users.sourceforge.net>
Date: Tue, 29 Aug 2017 13:03:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Aug 2017 12:56:54 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation in imon_init_intf0()
  Improve a size determination in two functions

 drivers/media/rc/imon.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

-- 
2.14.1
