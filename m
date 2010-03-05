Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:56559 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267Ab0CER2j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 12:28:39 -0500
Message-ID: <4B913F2E.1080703@arcor.de>
Date: Fri, 05 Mar 2010 18:28:14 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: tm6000 and Hauppauge HVR-900H
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi Mauro, Devin,

I study the tm6000 source and I have any questions.

1. I tested my stick (terratec cinery hybrid) with the windows driver
from the Hauppauge HVR-900H and it's work. So I think that have the
same driver setting. In the board struct is setting tuner reset gpio
with label TM6000_GPIO_2, but is that not a tm6010? Then it must set
to TM6010_GPIO_2. And can I add  the setting from terratec cinery
hybrid for the Hauppauge HVR-900H?
2. In the board struct have not all a tuner reset gpio.
3. Is it better when we implemented the firmware value in the board
struct?


best regards

Stefan Ringel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJLkT8uAAoJEDX/lZlmjdJlz+gH/ioYjVDa9zjw56KKDQ+RXPJl
gqk5N+NsxRMQv+0TVhc2rQCyirQFK+Stn17h+Q8lMcEynPP1Ms1XQm0Qu1Zv+6YO
/0urUck6LpeaEi8sMRmdbpBURmjC3PZ9KbjouL6ZDYwtsoMSUwQBHf+6L7dI64Ch
puVRySAYO7d5tpgfPZx1ahuwuKZ/Qwl25umPWMUu/WQMC2Gt7AlVQkwTS6ozxI7l
JhqNPoqmVq97H3vlQQTUibIdCRNJLBHgV/4ODhF7c+8r2jd5BGOAbPkBbdzmkO6Z
NTtmAKCU62wen4SwZIDZhpBfPvkggwUD17DHe3NtZIaRxhCBei/hXkPZaDNxGQs=
=//Us
-----END PGP SIGNATURE-----

