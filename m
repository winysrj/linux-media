Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2AOTZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 14:25:09 -0500
Received: by iagf6 with SMTP id f6so1364671iag.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 11:25:08 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Jan 2012 14:25:08 -0500
Message-ID: <CAOcJUbwoeL1xvmDM6+s9i3L+eVax4VpEi_0JDxD_i=v4ve2EvA@mail.gmail.com>
Subject: [PULL] git://linuxtv.org/mkrufky/tuners LEDs | Add Support for LED
 feedback on WinTV Nova-TD / WinTV Duet
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please pull from the LEDs branch on my tuners tree for patches that
add support for LED signal lock feedback  on WinTV Nova-TD / WinTV
Duet

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:
  Linus Torvalds (1):
        Linux 3.2

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners LEDs

Jiri Slaby (4):
      DVB: dib0700, move Nova-TD Stick to a separate set
      DVB: dib0700, separate stk7070pd initialization
      DVB: dib0700, add corrected Nova-TD frontend_attach
      DVB: dib0700, add support for Nova-TD LEDs

 drivers/media/dvb/dvb-usb/dib0700.h         |    2 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c |  150 ++++++++++++++++++++++++---
 2 files changed, 139 insertions(+), 13 deletions(-)

Cheers,

Mike
