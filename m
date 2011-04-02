Return-path: <mchehab@pedra>
Received: from blu0-omc2-s26.blu0.hotmail.com ([65.55.111.101]:43320 "EHLO
	blu0-omc2-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902Ab1DBNp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 09:45:29 -0400
Message-ID: <BLU0-SMTP2588D5C8C024CC3D20EE63D8A10@phx.gbl>
To: linux-media@vger.kernel.org
Subject: dibusb device with lock problems
CC: patrick.boettcher@desy.de, pb@linuxtv.org, grafgrimm77@gmx.de,
	castet.matthieu@free.fr
From: Mr Tux <tuxoholic@hotmail.de>
MIME-Version: 1.0
Date: Sat, 2 Apr 2011 15:45:22 +0200
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi list, hello Patrick,

A locking problem with specific dib3000mb devices is still present in
kernel 2.6.38.

Now people upgrading from lenny to squeeze are also affected - see: [1]

Please have a look at my previous post in [2] for a detailed description and 
links to this bug's history.

I'm sending a cc of this to the people who once where affected by this bug or 
involved with the code change that introduced it.

Anyone can confirm this is fixed/pending for his device and what dib3000mb 
device he is using out of the linuxtv wiki list of 14 dib3000mb devices [3]?

I have 3 devices of the hama usb 1.1 series: [4], that's number 66 in the wiki 
listing - they all are affected by this bug with kernels > 2.6.31

Thanks for some feedback. Can we fix this for good for the pending devices?


[1] http://www.vdr-portal.de/index.php?page=Thread&postID=991041
[2] http://www.spinics.net/lists/linux-media/msg28817.html
[3] http://www.linuxtv.org/wiki/index.php/DVB-T_USB_Devices/Full
[4] http://www.hama.de/bilder/00049/abb/00049021abb.jpg
