Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:55216 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933426AbcJMQwt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:52:49 -0400
Subject: [PATCH 00/18] [media] RedRat3: Fine-tuning for several function
 implementations
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:15:51 +0200
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:06:18 +0200

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (18):
  Use kcalloc() in two functions
  Move two assignments in redrat3_transmit_ir()
  Return directly after a failed kcalloc() in redrat3_transmit_ir()
  One function call less in redrat3_transmit_ir() after error detection
  Delete six messages for a failed memory allocation
  Delete an unnecessary variable initialisation in redrat3_get_firmware_rev()
  Improve another size determination in redrat3_reset()
  Improve another size determination in redrat3_send_cmd()
  Move a variable assignment in redrat3_dev_probe()
  Delete an unnecessary variable initialisation in redrat3_init_rc_dev()
  Delete the variable "dev" in redrat3_init_rc_dev()
  Move a variable assignment in redrat3_init_rc_dev()
  Return directly after a failed rc_allocate_device() in redrat3_init_rc_dev()
  Rename a jump label in redrat3_init_rc_dev()
  Delete two variables in redrat3_set_timeout()
  Move a variable assignment in redrat3_set_timeout()
  Adjust two checks for null pointers in redrat3_dev_probe()
  Combine substrings for six messages

 drivers/media/rc/redrat3.c | 146 +++++++++++++++++++++------------------------
 1 file changed, 67 insertions(+), 79 deletions(-)

-- 
2.10.1

