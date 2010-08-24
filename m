Return-path: <mchehab@pedra>
Received: from mail.mlh-server.de ([188.40.95.206]:54517 "EHLO
	mail.mlh-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0HXHP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 03:15:59 -0400
Received: from [172.16.12.167] (188-193-154-144-dynip.superkabel.de [188.193.154.144])
	(Authenticated sender: mail@matthias-larisch.de)
	by mail.mlh-server.de (Postfix) with ESMTPSA id 35ABF3D40F1
	for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 08:56:21 +0200 (CEST)
Message-ID: <4C736D15.9000000@matthias-larisch.de>
Date: Tue, 24 Aug 2010 08:56:21 +0200
From: Matthias Larisch <mail@matthias-larisch.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: MSI DigiVox Trio (Analog, DVB-C, DVB-T)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello!

I recently bought a DigiVox Trio by MSI. This card contains the
following chips:

nxp tda18271hdc2 (tuner)
micronas drx 3926ka3 (demodulator, 3in1)
em2884
atmlh946 64c (eeprom)
micronas avf 4910ba1

so it is comparable to the Terratec Cinergy HTC USB XS HD and the
TerraTec H5.

There is basically everything missing:
-EM2884 Support
-DRX 3926 Support
-AVF 4910 Support

Is anyone working on any of them? I would really like to help to get
some of this stuff working! I know how to code and have much interest in
hardware/technology but no know how in linux-driver programming or
tv-card programming. If there is anything I could do just tell me.

So far I'm using this card in a Windows VM and it works (more or less
good...)

Best regards,

Matthias
