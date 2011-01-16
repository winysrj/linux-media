Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:34933 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1APNGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 08:06:54 -0500
Message-ID: <4D330984.2010307@infradead.org>
Date: Sun, 16 Jan 2011 13:06:44 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] request for 2.6.38-rc1
References: <alpine.LRH.2.00.1101141542460.6649@pub3.ifh.de>
In-Reply-To: <alpine.LRH.2.00.1101141542460.6649@pub3.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-01-2011 12:51, Patrick Boettcher escreveu:
> Hi Mauro,
> 
> if it is not too late, here is a pull request for some new devices from DiBcom. It would be nice to have it in 2.6.38-rc1.
> 
> Pull from
> 
> git://linuxtv.org/pb/media_tree.git staging/for_2.6.38-rc1.dibcom
> 
> for
> 
> DiBxxxx: Codingstype updates


Not sure if this is by purpose, but you're changing all
msleep(10) into msleep(20). This sounds very weird for a
CodingStyle fix:

-	msleep(10);
+	msleep(20);

> DiB0700: add support for several board-layouts

Hmm...

+	if (request_firmware(&state->frontend_firmware, "dib9090.fw", &adap->dev->udev->dev)) {

Where's dib9090.fw firmware is available? The better is to submit a patch to linux-firmware
with the firmware binary, with some license that allows end-users to use it with your device
and distros/distro partners to re-distribute it. While here, please add also the other
dibcom firmwares.

Vendors are free to use their own legal text for it. There are several examples for it
at:

http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob_plain;f=WHENCE;hb=HEAD


Btw, there are two alignment errors (one at dib7000p, for some cases, aligned with 4 chars),
and another at dib8000, where all statements after an if are aligned with 3 tabs plus one space.
I'm fixing those issues, c/c you at the fix patches.

Cheers,
Mauro
