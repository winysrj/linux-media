Return-path: <mchehab@pedra>
Received: from smtp3-g21.free.fr ([212.27.42.3]:32897 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab0JRHwL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 03:52:11 -0400
Received: from [192.168.0.1] (unknown [83.158.255.42])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 49E7DA62A9
	for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 09:52:04 +0200 (CEST)
Message-ID: <4CBBFCBA.2010707@free.fr>
Date: Mon, 18 Oct 2010 09:52:26 +0200
From: =?ISO-8859-1?Q?Herv=E9_Cauwelier?= <herve.cauwelier@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: support for AF9035 (not tuner)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I got a USB video grabber, which is a dumb analog video converter.

Installing it under Windows with the given drivers reveals it as "AF9035 
Analog Capture Filter", when capturing from VLC for example.

I couldn't find any direct support for Linux but only when coupled with 
a DVB tuner or something:
http://strobe.anti.nu/af9035_fc0011.html

I could successfully build the given driver from Terratec on a 2.6.35 
kernel but loading it doesn't bring any support. Yet it contains source 
files for AF903x but without license headers.

When plugged in:

Oct 18 09:47:56 xiong kernel: usb 2-1: new high speed USB device using 
ehci_hcd and address 6
Oct 18 09:47:56 xiong load-modules.sh: 
'usb:v1D19p6105d0200dc00dsc00dp00icFFisc00ip00' is not a valid module or 
alias name

And "lsusb -v": http://bpaste.net/show/10197/

So I request help for bringing support for this chipset. Anything from 
obscure experimental repository to compile, to free beers and even 
financial contribution.

Regards,

Hervé
