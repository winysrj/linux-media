Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:43895 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab0F0UHT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 16:07:19 -0400
Received: by wwi17 with SMTP id 17so2171334wwi.19
        for <linux-media@vger.kernel.org>; Sun, 27 Jun 2010 13:07:18 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 27 Jun 2010 22:07:17 +0200
Message-ID: <AANLkTikojhopHeY2WuHxK_tbCs99_SV7ksWnYv4UXM4W@mail.gmail.com>
Subject: v4l-dvb unsupported device: Conceptronic CTVDIGUSB2 1b80:d393
	(Afatech) - possibly similar to CTVCTVDIGRCU v3.0?
From: matteo sisti sette <matteosistisette@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I hope this is the right place for reporting this; if not, please
forgive and redirect me.

My DVB-T USB stick, a "Conceptronic USB 2.0 Digital TV Receiver"
CTVDIGUSB2 doesn't work after succesfully compiling and installing
v4l-dvb, and it seems it is not supported according to the device
list.

The ID is 1b80:d393

The name "Conceptronic USB 2.0" is very similar to that of CTVDIGRCU,
which _is_ supported and the chipset seems to be indeed an Afatech as
the output of lsusb reports:
Bus 002 Device 007: ID 1b80:d393 Afatech
(or isn't that reliable?)

So I wonder whether this is one of the cases where the following applies:
"The driver has to be aware that it's related to some hardware
(typically through the subsystem ID from the USB ID or PCI ID). If the
driver doesn't recognize/bind to your particular hardware, then the
module will probably load but then proceed to not do anything. In
other words, support for your device would have to be added to the
driver."

If I understand correctly (pleas correct me if I am wrong), IF that is
the case (which may be not), then making it work should be just a
matter of adding the id of the device to the source code of the driver
somewhere and recompiling it and it would work??

If so, is it something I may try following some step-by-step guide?

Thanks
m.

-- 
Matteo Sisti Sette
matteosistisette@gmail.com
http://www.matteosistisette.com
