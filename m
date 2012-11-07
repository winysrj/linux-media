Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52402 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab2KGXdv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Nov 2012 18:33:51 -0500
Message-ID: <509AEFC3.5020707@iki.fi>
Date: Thu, 08 Nov 2012 01:33:23 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] dvb_usb_v2 bug fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
Send these for the 3.7. Both are relative small bug fixes.


The following changes since commit 1fdead8ad31d3aa833bc37739273fcde89ace93c:

   [media] m5mols: Add missing #include <linux/sizes.h> (2012-10-10 
08:17:16 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git for_v3.7-bugfix-dvb_usb_v2

for you to fetch changes up to 25a080cf1e2150c9a9dafcb813bfb71566abe203:

   dvb_usb_v2: switch interruptible mutex to normal (2012-11-08 01:29:05 
+0200)

----------------------------------------------------------------
Antti Palosaari (2):
       dvb_usb_v2: fix pid_filter callback error logging
       dvb_usb_v2: switch interruptible mutex to normal

  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 11 +++++------
  drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c  |  4 +---
  2 files changed, 6 insertions(+), 9 deletions(-)


-- 
http://palosaari.fi/

