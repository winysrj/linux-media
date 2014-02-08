Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:50584 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaBHMHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 07:07:47 -0500
Received: by mail-lb0-f169.google.com with SMTP id q8so3542896lbi.0
        for <linux-media@vger.kernel.org>; Sat, 08 Feb 2014 04:07:45 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFC PATCH 0/3] rc: add RC5-SZ encoder and utilize encoders in nuvoton-cir
Date: Sat,  8 Feb 2014 14:07:27 +0200
Message-Id: <1391861250-26068-1-git-send-email-a.seppala@gmail.com>
In-Reply-To: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset is based and built on an earlier series posted by James Hogan
(rc: ir-raw: Add encode, implement NEC encode).

This set extends the series by adding a generic RC-5 encoder and adds support
for it to RC-5-SZ protocol.

In addition nuvoton-cir driver is modified to read wakeup filters from sysfs
and utilize encoding to convert the scancodes to format understood by the
underlying hardware.

Antti Seppälä (3):
  rc-core: Add Manchester encoder (phase encoder) support to rc-core
  ir-rc5-sz: Add ir encoding support
  nuvoton-cir: Add support for writing wakeup samples via sysfs filter
    callback

 drivers/media/rc/ir-raw.c            |  44 +++++++++++++
 drivers/media/rc/ir-rc5-sz-decoder.c |  35 ++++++++++
 drivers/media/rc/nuvoton-cir.c       | 121 +++++++++++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h       |   1 +
 drivers/media/rc/rc-core-priv.h      |  14 ++++
 include/media/rc-core.h              |   1 +
 6 files changed, 216 insertions(+)

-- 
1.8.3.2

