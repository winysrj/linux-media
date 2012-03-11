Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:45498 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752967Ab2CKPXM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 11:23:12 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] AF903X driver update, v1.02
Date: Sun, 11 Mar 2012 16:23:04 +0100
References: <201202222321.43972.hfvogt@gmx.net>
In-Reply-To: <201202222321.43972.hfvogt@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203111623.04475.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an update of the patch "Basic AF9035/AF9033 driver" that I send to the mailing list on 22 Feb.
The driver provides support for DVB-T USB 2.0 sticks based on AF9035/AF9033. Currently supported devices:
- Terratec T5 Ver.2 (also known as T6), Tuner FC0012
- Avermedia Volar HD Nano (A867R), Tuner MxL5007t

Ver 1.02 of the driver includes the following changes compared to the initial version:

- significantly reduced number of mutex calls (only remaining protection in low-level af903x_send_cmd)
  this change made some multiply defined function unnecessary (_internal functions and non _internal functions)
  maybe this reduction was a bit too agressive, but I didn't get any problems in several days testing 
- reduced number of iterations in loop for lock detection (should improve response)
- correct errors in initial contribution and add proper entries in dvb-usb-ids.h (thanks to Gianluca Gennari)
- removed unnecessary (loading of rc key table) and commented out code
- minor cleanup (e.g. af903x_fe_is_locked)

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

because of the size of the patch here just a link:
http://home.arcor.de/hfvogt/af903x/af903x-1.02.patch.gz

 drivers/media/dvb/dvb-usb/Kconfig          |    8
 drivers/media/dvb/dvb-usb/Makefile         |    3
 drivers/media/dvb/dvb-usb/af903x-cmd.h     |   61 +
 drivers/media/dvb/dvb-usb/af903x-core.c    |  453 ++++++++++++
 drivers/media/dvb/dvb-usb/af903x-core.h    |   59 +
 drivers/media/dvb/dvb-usb/af903x-devices.c | 1446 ++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/af903x-fe-priv.h |  202 +++++
 drivers/media/dvb/dvb-usb/af903x-fe.c      | 2070 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/af903x-fe.h      |  164 ++++
 drivers/media/dvb/dvb-usb/af903x-reg.h     |  214 +++++
 drivers/media/dvb/dvb-usb/af903x-tuners.c  |  447 +++++++++++
 drivers/media/dvb/dvb-usb/af903x-tuners.h  |   62 +
 drivers/media/dvb/dvb-usb/af903x.h         |   51 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |   16
 14 files changed, 5256 insertions(+)

Please try the driver and give feedback.

Cheers,

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
