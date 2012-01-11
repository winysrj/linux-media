Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42177 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab2AKAlt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:41:49 -0500
Message-ID: <4F0CDACA.5070100@iki.fi>
Date: Wed, 11 Jan 2012 02:41:46 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.3 v2] HDIC HD29L2 DMB-TH demodulator driver
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

That is 2nd attempt to PULL that to the Kernel. If possible send that 
still to the 3.3...

As a DTMB support in out API is not ready I decided to move whole driver 
to the staging.

I fixed most of those findings you pointed out and left one bit 
operation without fix (find_first_bit) still because it gave one warning...

drivers/media/dvb/frontends/hd29l2.c: In function ‘hd29l2_rd_reg_mask’:
drivers/media/dvb/frontends/hd29l2.c:139:2: warning: passing argument 1 
of ‘find_first_bit’ from incompatible pointer type
include/asm-generic/bitops/find.h:35:22: note: expected ‘const long 
unsigned int *’ but argument is of type ‘u8 *’



Antti


The following changes since commit 2f78604a433a12571ec3e54054fbfacc7525b307:

   [media] Added model Sveon STV40 (2012-01-07 12:02:20 -0200)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git hdic_v2

Antti Palosaari (8):
       HDIC HD29L2 DMB-TH demodulator driver
       HDIC HD29L2 DMB-TH USB2.0 reference design driver
       hd29l2: synch for latest DVB core changes
       mxl5007t: bugfix DVB-T 7 MHz and 8 MHz bandwidth
       hd29l2: add debug for used IF frequency
       dvb-core: define general callback value for demodulator
       hd29l2: fix review findings
       hd29l2: move to staging

  drivers/media/common/tuners/mxl5007t.c     |    2 +
  drivers/media/dvb/dvb-core/dvb_frontend.h  |    1 +
  drivers/media/dvb/dvb-usb/Kconfig          |    7 +
  drivers/media/dvb/dvb-usb/Makefile         |    3 +
  drivers/media/dvb/dvb-usb/hdic.c           |  365 ++++++++++++
  drivers/media/dvb/dvb-usb/hdic.h           |   45 ++
  drivers/staging/media/Kconfig              |    2 +
  drivers/staging/media/Makefile             |    1 +
  drivers/staging/media/hd29l2/Kconfig       |    7 +
  drivers/staging/media/hd29l2/Makefile      |    4 +
  drivers/staging/media/hd29l2/TODO          |    3 +
  drivers/staging/media/hd29l2/hd29l2.c      |  861 
++++++++++++++++++++++++++++
  drivers/staging/media/hd29l2/hd29l2.h      |   66 +++
  drivers/staging/media/hd29l2/hd29l2_priv.h |  314 ++++++++++
  14 files changed, 1681 insertions(+), 0 deletions(-)
  create mode 100644 drivers/media/dvb/dvb-usb/hdic.c
  create mode 100644 drivers/media/dvb/dvb-usb/hdic.h
  create mode 100644 drivers/staging/media/hd29l2/Kconfig
  create mode 100644 drivers/staging/media/hd29l2/Makefile
  create mode 100644 drivers/staging/media/hd29l2/TODO
  create mode 100644 drivers/staging/media/hd29l2/hd29l2.c
  create mode 100644 drivers/staging/media/hd29l2/hd29l2.h
  create mode 100644 drivers/staging/media/hd29l2/hd29l2_priv.h

-- 
http://palosaari.fi/
