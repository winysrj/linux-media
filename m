Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:45759 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab1CTJbh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 05:31:37 -0400
Message-ID: <4D85C976.80901@iki.fi>
Date: Sun, 20 Mar 2011 11:31:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
CC: Andrea Merello <andrea.merello@gmail.com>,
	Ian Armstrong <ian@iarmst.demon.co.uk>,
	=?ISO-8859-1?Q?martin_gro=DFhauser?= <mgroszhauser@gmail.com>
Subject: [GIT PULL FOR 2.6.39] af9015 and af9013 changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Morjens Mauro,

PULL following patches for the 2.6.39

t. Antti


The following changes since commit 88a763df226facb74fdb254563e30e9efb64275c:

   [media] dw2102: prof 1100 corrected (2011-03-02 16:56:54 -0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git af9015

Antti Palosaari (6):
       af9015: small RC change
       add TerraTec remote
       af9015: map remote for TerraTec Cinergy T Stick RC
       af9015: reimplement firmware download
       af9013: download FW earlier in attach()
       af9013: reimplement firmware download

Ian Armstrong (1):
       af9015: enhance RC

  drivers/media/dvb/dvb-usb/af9015.c            |   67 
+++++++++++++++--------
  drivers/media/dvb/dvb-usb/af9015.h            |    1 +
  drivers/media/dvb/frontends/af9013.c          |   55 +++++++++----------
  drivers/media/rc/keymaps/Makefile             |    1 +
  drivers/media/rc/keymaps/rc-terratec-slim-2.c |   72 
+++++++++++++++++++++++++
  include/media/rc-map.h                        |    1 +
  6 files changed, 144 insertions(+), 53 deletions(-)
  create mode 100644 drivers/media/rc/keymaps/rc-terratec-slim-2.c


-- 
http://palosaari.fi/
