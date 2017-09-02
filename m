Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:49258 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdIBUkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 16:40:12 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/7] [media] Mantis: Adjustments for three function
 implementations
Message-ID: <9ba22d42-0ec0-b865-dec5-4ce67ad443fb@users.sourceforge.net>
Date: Sat, 2 Sep 2017 22:40:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 22:18:22 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (7):
  Delete an error message for a failed memory allocation in hopper_pci_probe()
  Improve a size determination in hopper_pci_probe()
  Adjust a null pointer check in two functions
  Delete an unnecessary variable initialisation in hopper_pci_probe()
  Delete an error message for a failed memory allocation in mantis_pci_probe()
  Improve a size determination in mantis_pci_probe()
  Delete an unnecessary variable initialisation in mantis_pci_probe()

 drivers/media/pci/mantis/hopper_cards.c | 9 ++++-----
 drivers/media/pci/mantis/mantis_cards.c | 8 +++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

-- 
2.14.1
