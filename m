Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36361 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbbCaRsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 13:48:50 -0400
Received: by lbbug6 with SMTP id ug6so18242729lbb.3
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2015 10:48:48 -0700 (PDT)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v3 0/7] rc: Add IR encode based wakeup filtering
Date: Tue, 31 Mar 2015 20:48:05 +0300
Message-Id: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I'd like to revive efforts and discussion on adding IR encoding support to
rc-core.

Here is an updated patchset which adds support for modulating RC-5 scancodes
into raw IR events which can be written to hardware such as nuvoton-cir to
perform system wakeup with an IR pulse.

The previous patchset was posted by James Hogan roughly a year ago. I've
now updated the patchset to apply cleanly against latest linux-media tree.

For simplicity I've also dropped support for nec scancode encoding as the
nec format turned out to be ambiquous between variants. I'm hoping the nec
scancodes can be re-engineered and support for them added back later once the
initial encoding groundwork is in place. The remaining RC-5(X,SZ) support
should work in an unambiquous manner. I've also added an encoder for RC-6(A)
protocols as the encoding is very similar to RC-5.

Changes since v2:
 - Ported to apply against latest media-tree
 - Fixed new checkpatch.pl warnings
 - Dropped nec scancode support for now
 - Merged separate encoders for rc-5 and rc5-sz into single encoder
 - Added rc-6 encoder

Cc: James Hogan <james@albanarts.com>
Cc: David Härdeman <david@hardeman.nu>

Antti Seppälä (3):
  rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper
  rc: ir-rc6-decoder: Add encode capability
  rc: nuvoton-cir: Add support for writing wakeup samples via sysfs
    filter callback

James Hogan (4):
  rc: rc-ir-raw: Add scancode encoder callback
  rc: ir-rc5-decoder: Add encode capability
  rc: rc-core: Add support for encode_wakeup drivers
  rc: rc-loopback: Add loopback of filter scancodes

 drivers/media/rc/ir-rc5-decoder.c | 116 +++++++++++++++++++++++++++++++
 drivers/media/rc/ir-rc6-decoder.c | 121 +++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.c    | 127 ++++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h    |   1 +
 drivers/media/rc/rc-core-priv.h   |  36 ++++++++++
 drivers/media/rc/rc-ir-raw.c      | 139 ++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-loopback.c    |  36 ++++++++++
 drivers/media/rc/rc-main.c        |   7 +-
 include/media/rc-core.h           |   7 ++
 9 files changed, 589 insertions(+), 1 deletion(-)

-- 
2.0.5

