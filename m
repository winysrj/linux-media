Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:55412 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751989AbcLJUqU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 15:46:20 -0500
To: linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] [media] bt8xx: Fine-tuning for three functions
Message-ID: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
Date: Sat, 10 Dec 2016 21:45:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 10 Dec 2016 21:40:12 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  One function call less in bttv_input_init() after error detection
  Delete two error messages for a failed memory allocation
  Delete unnecessary variable initialisations in ca_send_message()
  Less function calls in dst_ca_ioctl() after error detection

 drivers/media/pci/bt8xx/bttv-input.c | 14 +++++---
 drivers/media/pci/bt8xx/dst_ca.c     | 62 +++++++++++++++++++++---------------
 2 files changed, 46 insertions(+), 30 deletions(-)

-- 
2.11.0

