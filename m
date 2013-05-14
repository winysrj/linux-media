Return-path: <linux-media-owner@vger.kernel.org>
Received: from gfz-potsdam.de ([139.17.3.251]:56851 "EHLO gfz-potsdam.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3ENQaS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 12:30:18 -0400
Received: from [139.17.114.3] (account knb@gfz-potsdam.de HELO [139.17.114.3])
  by cgp2.gfz-potsdam.de (CommuniGate Pro SMTP 5.4.10)
  with ESMTPSA id 12061266 for linux-media@vger.kernel.org; Tue, 14 May 2013 18:00:16 +0200
Message-ID: <51925F90.30305@gfz-potsdam.de>
Date: Tue, 14 May 2013 18:00:16 +0200
From: Knut Behrends <knb@gfz-potsdam.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: terratec grabby 2 on linux - follow-up Q to discussion from mar/apr
 2013
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
my first post
I am a Linux user who bought a Terratec Grabby 2 analog-video-to-usb
encoding device, which I cannot get to work on Linux.

I noticed a thread on this mailing list a few weeks ago.

http://www.mail-archive.com/linux-media@vger.kernel.org/msg60286.html

I get exactly the same error messages (from dmesg) as the initiator of
that forum-thread.

In any event, I infer from the long forum-thread that the problem with
the new chips inside the Grabby 2 has been solved, or partly solved.
Some people posted patches to this mailing list.
I don't know how complete  the new solution is.
Do  I just need to grab an em28xx*.c file from the bleeding edge of the
 kernel source tree?

How can I, as an interested end-user use that new driver code? Should  I
simply wait for a new kernel being distributed by Canonical that will
have new patches included eventually?

Do I have to compile a patched .c file myself and copy it to
/lib/modules/3.8.0-19-generic/kernel/drivers/media/usb/em28xx/
directory on my linux box, replacing an older version? SHould I use DKMS
for this following a howto guide such as

http://wiki.centos.org/HowTos/BuildingKernelModules

My linux system is a raring ringtail Ubuntu,
Linux  3.8.0-19-generic #30-Ubuntu SMP Wed May 1 16:35:23 UTC 2013
x86_64  GNU/Linux

my need to use the grabby is not that urgent. Would be nice to use that
camcorder on my main desktop PC, which happens to be the most powerful
computer I have full access to.

Any hints?

Best regards,

Knut Behrends
-- 
____________________________________________________________________________

Knut Behrends                         Phone: +49 (0) 331 288 1688
Potsdam 14473                         KeyID: 0xF22CACEF (PGP Public Key)
____________________________________________________________________________
