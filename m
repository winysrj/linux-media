Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35361 "EHLO
	mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbcGROp1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 10:45:27 -0400
From: William Breathitt Gray <vilhelm.gray@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 0/6] radio: Utilize the module_isa_driver macro
Date: Mon, 18 Jul 2016 10:45:06 -0400
Message-Id: <cover.1468852798.git.vilhelm.gray@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The module_isa_driver macro is a helper macro for ISA drivers which do
not do anything special in module init/exit. This patchset eliminates a
lot of ISA driver registration boilerplate code by utilizing
module_isa_driver, which replaces module_init and module_exit.

William Breathitt Gray (6):
  radio: terratec: Utilize the module_isa_driver macro
  radio: rtrack2: Utilize the module_isa_driver macro
  radio: trust: Utilize the module_isa_driver macro
  radio: zoltrix: Utilize the module_isa_driver macro
  radio: aztech: Utilize the module_isa_driver macro
  radio: aimslab: Utilize the module_isa_driver macro

 drivers/media/radio/radio-aimslab.c  | 13 +------------
 drivers/media/radio/radio-aztech.c   | 13 +------------
 drivers/media/radio/radio-rtrack2.c  | 13 +------------
 drivers/media/radio/radio-terratec.c | 14 +-------------
 drivers/media/radio/radio-trust.c    | 13 +------------
 drivers/media/radio/radio-zoltrix.c  | 14 +-------------
 6 files changed, 6 insertions(+), 74 deletions(-)

-- 
2.7.3

