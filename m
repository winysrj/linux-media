Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40324 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaBPQql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 11:46:41 -0500
Received: by mail-lb0-f177.google.com with SMTP id 10so8921928lbg.8
        for <linux-media@vger.kernel.org>; Sun, 16 Feb 2014 08:46:39 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 0/3] rc: add RC5-SZ encoder and utilize encoders in nuvoton-cir
Date: Sun, 16 Feb 2014 18:45:52 +0200
Message-Id: <1392569155-27659-1-git-send-email-a.seppala@gmail.com>
In-Reply-To: <CAKv9HNbh39=QjyHggge3w-ke658ndCnPP+0EqPL9iUFrf3+imQ@mail.gmail.com>
References: <CAKv9HNbh39=QjyHggge3w-ke658ndCnPP+0EqPL9iUFrf3+imQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset is an improved version of an earlier attempt to add RC5-SZ 
encoder to ir-core. The set is based on a series posted by James Hogan 
(rc: ir-raw: Add encode, implement NEC encode).

This set extends the series by adding a generic RC-5 encoder and adds 
support for it to RC-5-SZ protocol.

In addition nuvoton-cir driver is modified to read wakeup filters from 
sysfs and utilize encoding to convert the scancodes to format understood 
by the underlying hardware.

Changes in v2:
 - (Hopefully) fixed all buffer indexing issues
 - Write samples to fifo even if if encoded result won't completely fit
 - Check filter mask in encoder
 - Append some trailing ir silence to the encoded result
 - Some cleanups and readability improvements

Antti Seppälä (3):
  rc-core: Add Manchester encoder (phase encoder) support to rc-core
  ir-rc5-sz: Add ir encoding support
  nuvoton-cir: Add support for writing wakeup samples via sysfs filter callback

 drivers/media/rc/ir-raw.c            |  56 +++++++++++++++++
 drivers/media/rc/ir-rc5-sz-decoder.c |  39 ++++++++++++
 drivers/media/rc/nuvoton-cir.c       | 119 +++++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h       |   1 +
 drivers/media/rc/rc-core-priv.h      |  16 +++++
 include/media/rc-core.h              |   1 +
 6 files changed, 232 insertions(+)

-- 
1.8.3.2

