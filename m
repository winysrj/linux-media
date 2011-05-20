Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934367Ab1ETSjC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 14:39:02 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4KId25G008494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 20 May 2011 14:39:02 -0400
Message-ID: <4DD6B54E.9000801@redhat.com>
Date: Fri, 20 May 2011 14:39:10 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL REQ] Initial IR updates for 2.6.40
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Here's what I've got that's been stewing in my IR tree for a bit. 
There's more I'm working on and/or planning to work on for 2.6.40, but 
these should be good to go right now. The new redrat3 driver still has 
some quirks, at least when used with lirc userspace decoding, but I'm 
working with the folks at RedRat to sort them out.

The following changes since commit 7225a1dcc38f28fcc6178258b2072d12742f68d9:

   [media] uvcvideo: Add M420 format support (2011-05-20 12:18:24 -0300)

are available in the git repository at:
 
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-ir.git/ 
for-2.6.40

Devin Heitmueller (1):
       [media] saa7134: enable IR support for Hauppauge HVR-1150/1120

Jarod Wilson (9):
       [media] nuvoton-cir: minor tweaks to rc dev init
       [media] imon: clean up disconnect routine
       [media] ite-cir: make IR receive work after resume
       [media] ite-cir: clean up odd spacing in ite8709 bits
       [media] ite-cir: finish tx before suspending
       [media] rc-winfast: fix inverted left/right key mappings
       [media] mceusb: passing ep to request_packet is redundant
       [media] rc: add locking to fix register/show race
       [media] redrat3: new rc-core IR transceiver device driver

Julia Lawall (1):
       [media] imon: Correct call to input_free_device

  drivers/media/rc/Kconfig                    |   11 +
  drivers/media/rc/Makefile                   |    1 +
  drivers/media/rc/imon.c                     |   36 +-
  drivers/media/rc/ite-cir.c                  |   60 +-
  drivers/media/rc/keymaps/rc-winfast.c       |    4 +-
  drivers/media/rc/mceusb.c                   |   18 +-
  drivers/media/rc/nuvoton-cir.c              |   13 +-
  drivers/media/rc/rc-main.c                  |   47 +-
  drivers/media/rc/redrat3.c                  | 1344 +++++++++++++++++++
  drivers/media/video/saa7134/saa7134-cards.c |    1 +
  drivers/media/video/saa7134/saa7134-input.c |    8 +
  include/media/rc-core.h                     |    7 +-
  12 files changed, 1462 insertions(+), 88 deletions(-)
  create mode 100644 drivers/media/rc/redrat3.c

-- 
Jarod Wilson
jarod@redhat.com


