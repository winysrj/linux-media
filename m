Return-path: <mchehab@pedra>
Received: from fep32.mx.upcmail.net ([62.179.121.50]:33052 "EHLO
	fep32.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0KOQ7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 11:59:42 -0500
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep11-int.chello.at
          (InterMail vM.8.01.02.02 201-2260-120-106-20100312) with ESMTP
          id <20101115164335.KFSY9177.viefep11-int.chello.at@edge04.upcmail.net>
          for <linux-media@vger.kernel.org>;
          Mon, 15 Nov 2010 17:43:35 +0100
Message-ID: <4CE16335.10109@vanhetland.nl>
Date: Mon, 15 Nov 2010 17:43:33 +0100
From: Biologisch Tuinbouwbedrijf 'Van het Land' <info@vanhetland.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: af9015 and nxp tda182128 support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello everybody,

I own a brandless hdtv usb dvb-t stick.

lsusb identifies it as:
Bus 001 Device 005: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T
USB2.0 stick

I'm using debian with kernel 2.6.32. This kernel doesn't have support
for the nxp tda18218 tuner on the stick.
I compiled the latest v4l-dvb source tree from mercural. Now i get the
following error message when i plugin the stick:
af9015: tuner NXP TDA18218 not supported yet

Searching the archives of this list i found some messages concerning nxp
tda18218 support. It seems to me that there is support for the nxp
tda18218 in the current source tree, but support for the new tuner
driver is lacking from the af9015 driver.

Now is my question: are there any plans to support the nxp tda18218
tuner in the af9015 driver?

Regards, Joost Hoeks
