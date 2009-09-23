Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f203.google.com ([209.85.212.203]:60611 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZIWRzq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 13:55:46 -0400
Received: by vws41 with SMTP id 41so604557vws.4
        for <linux-media@vger.kernel.org>; Wed, 23 Sep 2009 10:55:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 10:55:50 -0700
Message-ID: <a3ef07920909231055o53c93bean6894fa536cdaa5dc@mail.gmail.com>
Subject: Genpix driver is broken (no 8psk lock). Here's why & how to fix.
From: VDR User <user.vdr@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Alan Nisota <alannisota@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Over a month ago I reported a problem with a change that was made to
the Genpix driver which broke 8PSK.  The change limited DVB-S streams
to QPSK and 8PSK to DVB-S2.  There are a couple problems with this.
First of all, Genpix devices do NOT support DVB-S2 but pretends to for
access to 8PSK.  Secondly, the 8PSK the Genpix provides is modified,
aka 8PSK turbo-fec.  Two of the biggest North American DVB-S providers
use 8PSK turbo-fec for a lot of their content.  Therefore, limiting
DVB-S to QPSK only is crippling reception of all those providers
transponders which use it.

Ideally 8PSK should be allowed for DVB-S in v4l so that a device like
the Genpix doesn't have to pretend to be something it's not to use it.
 While I seriously doubt that will be fixed, this problem can still be
resolved by simply reverting back to the drivers original behavior
with the following patch:

diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c
v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c
2009-08-14 19:17:43.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c 2009-08-14
19:19:18.000000000 -0700
@@ -146,8 +146,8 @@ static int gp8psk_fe_set_frontend(struct

        switch (c->delivery_system) {
        case SYS_DVBS:
-               /* Only QPSK is supported for DVB-S */
-               if (c->modulation != QPSK) {
+               /* Allow QPSK and 8PSK */
+               if (c->modulation != QPSK && c->modulation != PSK_8) {
                        deb_fe("%s: unsupported modulation selected (%d)\n",
                                __func__, c->modulation);
                        return -EOPNOTSUPP;
