Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:62679 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755042AbcJLO0X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:26:23 -0400
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 00/34] [media] DaVinci-Video Processing: Fine-tuning for
 several function implementations
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:26:09 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:20:02 +0200

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (34):
  Use kmalloc_array() in vpbe_initialize()
  Delete two error messages for a failed memory allocation
  Adjust 16 checks for null pointers
  Combine substrings for four messages
  Return an error code only as a constant in vpbe_probe()
  Return an error code only by a single variable in vpbe_initialize()
  Delete an unnecessary variable initialisation in vpbe_initialize()
  Return the success indication only as a constant in vpbe_set_mode()
  Reduce the scope for a variable in vpbe_set_default_output()
  Check return value of a setup_if_config() call in vpbe_set_output()
  Rename a jump label in vpbe_set_output()
  Delete an unnecessary variable initialisation in vpbe_set_output()
  Capture: Use kmalloc_array() in vpfe_probe()
  Capture: Delete three error messages for a failed memory allocation
  Capture: Improve another size determination in vpfe_probe()
  Capture: Delete an unnecessary variable initialisation in vpfe_probe()
  Capture: Improve another size determination in vpfe_enum_input()
  Capture: Combine substrings for an error message in vpfe_enum_input()
  Capture: Improve another size determination in vpfe_open()
  Capture: Adjust 13 checks for null pointers
  Capture: Delete an unnecessary variable initialisation in 11 functions
  Capture: Move two assignments in vpfe_s_input()
  Capture: Delete unnecessary braces in vpfe_isr()
  Capture: Delete an unnecessary return statement in vpfe_unregister_ccdc_device()
  Capture: Use kcalloc() in vpif_probe()
  Capture: Delete an error message for a failed memory allocation
  Capture: Adjust ten checks for null pointers
  Capture: Delete an unnecessary variable initialisation in vpif_querystd()
  Capture: Delete an unnecessary variable initialisation in vpif_channel_isr()
  Display: Use kcalloc() in vpif_probe()
  Display: Delete an error message for a failed memory allocation
  Display: Adjust 11 checks for null pointers
  Display: Delete an unnecessary variable initialisation in vpif_channel_isr()
  Display: Delete an unnecessary variable initialisation in process_progressive_mode()

 drivers/media/platform/davinci/vpbe.c         | 93 ++++++++++++---------------
 drivers/media/platform/davinci/vpfe_capture.c | 88 ++++++++++++-------------
 drivers/media/platform/davinci/vpif_capture.c | 28 ++++----
 drivers/media/platform/davinci/vpif_display.c | 30 ++++-----
 4 files changed, 109 insertions(+), 130 deletions(-)

-- 
2.10.1

