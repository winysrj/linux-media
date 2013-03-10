Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58869 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab3CJCQT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:16:19 -0500
Received: from dyn3-82-128-191-178.psoas.suomi.net ([82.128.191.178] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1UEVo9-0003GE-FH
	for linux-media@vger.kernel.org; Sun, 10 Mar 2013 04:16:17 +0200
Message-ID: <513BECCC.7060809@iki.fi>
Date: Sun, 10 Mar 2013 04:15:40 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] dvb_usb_v2: do not use USB buffers from stack
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:

   [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) 
(2013-02-13 18:05:29 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git dvb_usb_v2_stack

for you to fetch changes up to b14e9121a75432796155d42c31602cd1ce724250:

   anysee: coding style changes (2013-02-26 19:18:13 +0200)

----------------------------------------------------------------
Antti Palosaari (5):
       dvb_usb_v2: locked versions of USB bulk IO functions
       af9015: do not use buffers from stack for usb_bulk_msg()
       af9035: do not use buffers from stack for usb_bulk_msg()
       anysee: do not use buffers from stack for usb_bulk_msg()
       anysee: coding style changes

  drivers/media/usb/dvb-usb-v2/af9015.c      | 39 
+++++++++++++++++++++------------------
  drivers/media/usb/dvb-usb-v2/af9015.h      |  2 ++
  drivers/media/usb/dvb-usb-v2/af9035.c      | 44 
++++++++++++++++++++++----------------------
  drivers/media/usb/dvb-usb-v2/af9035.h      |  2 ++
  drivers/media/usb/dvb-usb-v2/anysee.c      | 46 
+++++++++++++++++++++-------------------------
  drivers/media/usb/dvb-usb-v2/anysee.h      |  3 ++-
  drivers/media/usb/dvb-usb-v2/dvb_usb.h     |  4 ++++
  drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c | 38 
+++++++++++++++++++++++++++++++++-----
  8 files changed, 107 insertions(+), 71 deletions(-)



-- 
http://palosaari.fi/
