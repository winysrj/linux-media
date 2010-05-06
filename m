Return-path: <linux-media-owner@vger.kernel.org>
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:55482 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736Ab0EFTO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 May 2010 15:14:56 -0400
Received: from [217.155.39.57] (helo=proxyplus.universe)
	by smarthost02.mail.zen.net.uk with esmtp (Exim 4.63)
	(envelope-from <paul@whitelands.org.uk>)
	id 1OA6X9-0003KH-A0
	for linux-media@vger.kernel.org; Thu, 06 May 2010 19:14:55 +0000
Received: from 127.0.0.1 [127.0.0.1]
	by Proxy+ with ESMTP
	for <linux-media@vger.kernel.org>; Thu, 06 May 2010 20:14:47 +0100
Message-ID: <4BE31526.6020602@whitelands.org.uk>
Date: Thu, 06 May 2010 20:14:46 +0100
From: Paul Shepherd <paul@whitelands.org.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: Re: setting up a tevii s660
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 06/05/2010 00:07, Tim Coote wrote:
> Hullo
> I've been struggling with this for a couple of days. I have checked
> archives, but missed anything useful.
>
> I've got a tevii s660 (dvbs2 via usb). It works with some limitations on
> windows xp (I cannot get HD signals decoded, but think that's a
> limitation of the software that comes on the CD).

I downloaded version from tevii.com and it worked for me on laptop
running win 7.  Had problems with HD on an XP machine but I assumed it
was because the video card was old/slow.

>
> I'm trying to get this working on Linux. I've tried VMs based on fedora
> 12 and mythbuntu (VMWare Fusion on a MacBookPro, both based on kernel
> 2.6.32), using the drivers from tevii's site
> (www.tevii.com/support.asp). these drivers are slightly modified
> versions of the v4l tip - but don't appear to be modified where I've not
> yet managed to get the drivers working :-(. Mythbuntu seems to be
> closest to working. Goodness knows how tevii tested the code, but it
> doesn't seem to work as far as I can see. My issues could just be down
> to using a VM.

I tried on Ubuntu 9.10 but had problems which I documented here on 16
april. Loading the firmware worked fine but there were problems with
remote control messages being logged continually as well as stability
problems. The card would tune (with scan) and worked with mythtv (for a
day or so)

> I believe that I need to load up the modules ds3000 and dvb-usb-dw2102,
> + add a rule to /etc/udev/rules.d and a script to /etc/udev/scripts.

I didn't touch rules.d

> I think that I must be missing quite a lot of context, tho'. When I look
> at the code in dw2102.c, which seems to support the s660, the bit that
> downloads the firmware looks broken and if I add a default clause to the
> switch that does the download, the s660's missed the download process.
> This could be why when I do get anything out of the device it looks like
> I'm just getting repeated bytes (the same value repeated, different
> values at different times, sometimes nothing). I'm finding it
> non-trivial working out the call sequences of the code or devising
> repeatable tests.

Had no problem with Ubuntu recognising the device and the correct .fw
file being downloaded.

There are various versions of dw2102.c from tevii, etc.  I think I tried
all of them. I did change the timeout on RC messages (dw2102.c?) which
helped but did not cure the problem.

Also tried the s2-liplianin library as well which seemed promising but
also did not cure the problem.

> Can anyone kick me off on getting this working? I'd like to at least get
> to the point where scandvb can tune the device. It does look like some
> folk have had success in the past, but probably with totally different
> codebase (there are posts that refer to the teviis660 module, which I
> cannot find).
>
> Any pointer gratefully accepted. I'll feed back any success if I can be
> pointed at where to drop document it.

I didn't have the knowledge (or time) to decide if the problem was in
the firmware or the v4l drivers or perhaps some strange interaction with
my dvb-t usb box.

Exchanged some emails with tevii guys who had posted here however they
appear to take the view that if it works under windows then the device
is fine and offer no other solution.

In the end I bought a Nova S2 PCI card which works fine but would be
interested in trying to get the S660 working.

paul

