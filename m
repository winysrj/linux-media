Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43493 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab2FUTxY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:53:24 -0400
Received: by gglu4 with SMTP id u4so880748ggl.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:23 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Jun 2012 16:53:23 -0300
Message-ID: <CALF0-+XSJ_Jm3YLtiFRwYH0E0XD=q7Sf78w6YYdBXtc8Wx-HoA@mail.gmail.com>
Subject: [PATCH 0/10] staging: solo6x10: General cleaning with ./scripts/checkpatch.pl
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ben Collins <bcollins@bluecherry.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset aims at cleaning most issues reported by ./scripts/checkpatch.pl.
I'm not sure if all of them are useful, so if you feel any of the
patches are too dumb just drop it.

I'm Ccing the author Ben Collins, dispite he's no longer working for
the device manufacturer Bluecherry.

The patches are based on today's linux-next; I hope this is okey.
As I don't own this device, I can't provide any test beyond compilation.

Ezequiel Garcia (10):
 staging: solo6x10: Avoid extern declaration by reworking module parameter
 staging: solo6x10: Fix several over 80 character lines
 staging: solo6x10: Declare static const array properly
 staging: solo6x10: Merge quoted string split across lines
 staging: solo6x10: Replace printk(KERN_WARNING with dev_warn
 staging: solo6x10: Remove format type mismatch warning
 staging: solo6x10: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
 staging: solo6x10: Replace C++ style comment with C style
 staging: solo6x10: Use linux/{io,uaccess}.h instead of asm/{io,uaccess}.h
 staging: solo6x10: Fix TODO file with proper maintainer

 drivers/staging/media/solo6x10/TODO       |    2 +-
 drivers/staging/media/solo6x10/core.c     |   14 ++++++---
 drivers/staging/media/solo6x10/gpio.c     |    2 +-
 drivers/staging/media/solo6x10/i2c.c      |    3 +-
 drivers/staging/media/solo6x10/p2m.c      |    8 +++---
 drivers/staging/media/solo6x10/solo6x10.h |    6 ++--
 drivers/staging/media/solo6x10/tw28.c     |    6 ++--
 drivers/staging/media/solo6x10/v4l2-enc.c |   39 ++++++++++++++---------------
 drivers/staging/media/solo6x10/v4l2.c     |   25 +++++++++---------
 9 files changed, 54 insertions(+), 51 deletions(-)

Regards,
Ezequiel.
