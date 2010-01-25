Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback.powerhosting.dk ([81.19.252.22]:2579 "EHLO
	fallback.powerhosting.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0AYCpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 21:45:32 -0500
Received: from mailscanner.powerhosting.dk (mailscanner6.powerhosting.dk [81.7.189.38])
	by fallback.powerhosting.dk (Postfix) with ESMTP id 622ED71C94
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 03:12:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mailscanner.powerhosting.dk (Postfix) with ESMTP id 2041DDE720
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 02:11:23 +0000 (UTC)
Received: from mailscanner.powerhosting.dk ([127.0.0.1])
	by localhost (mailscanner6.powerhosting.dk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Epm1uzqDNTAd for <linux-media@vger.kernel.org>;
	Mon, 25 Jan 2010 02:11:20 +0000 (UTC)
Received: from jbj2.i.jbohm.dk (0x4dd72e11.adsl.cybercity.dk [77.215.46.17])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: saotowjokkoujuxlot@jbohm.dk)
	by mailscanner.powerhosting.dk (Postfix) with ESMTPSA id 5E369DE71D
	for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 02:11:20 +0000 (UTC)
Received: from linuxtv by jbj2.i.jbohm.dk with local (Exim 4.69)
	(envelope-from <saotowjokkoujuxlot@jbohm.dk>)
	id 1NZEQA-0002He-NO
	for linux-media@vger.kernel.org; Mon, 25 Jan 2010 03:11:18 +0100
Date: Mon, 25 Jan 2010 03:11:18 +0100
From: Jakob Bohm <saotowjokkoujuxlot@jbohm.dk>
To: linux-media@vger.kernel.org
Subject: More details on Hauppauge 930C
Message-ID: <20100125021118.GA8756@i.jbohm.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So far all the posts I have been able to find about this device on
wiki.linuxtv.org and in the archives of the linux-tv, linux-dvb
and linux-media mailing lists have been unconfirmed guesswork of
the form "I think", "Isn't that" etc.  I actually have this device
(it was the first DVB-C device to hit the market in Denmark after
our biggest cable TV provider offered unencrypted access to their
basic packages in DVB-C format for anyone with a paid physical
connection to their network).

Ok, first the bad news:

When looking inside the device I see two Micronas chips,
thus *apparantly* confirming the rumors about this device being
based on the Micronas chips for which Micronas lawyers blocked
release of an already written FOSS driver back in 2008.
But to be sure these are the "banned" chips, someone in the know
should look closely at the photos I have taken of the actual chips
in the 930C.

Second bad news: When asking Hauppauge all the response I got was
"You need to post on the www.linuxtv.org site, that's where the
devlopers are" (and thats all the e-mail said, including the
spelling mistake in "devlopers").

Now the observable facts:

1. Product name is Hauppauge 930C, model 16009 LF Rev B1F0, USB ID
2040:1605 .  Retail package includes device, a short video cable
adapter for the minisocket on the device, an IR remote, a small
table-top retractable antenna and a CD with MS-Windows software
and drivers.

2. Device is a combined DVB-C/DVB-T receiver with additional
inputs for raw analog video as S-VHS or composite (either with
separate analog stereo sound).  I do not recall if the device has
support for analog TV reception too.

3. Device is not yet listed in the device tables at linuxtv.org
with any status (not even "doesn't work").

4. Device is a large (= wide body) USB stick, with a standard size
coaxial antenna input at the back, two indicator LEDs and an IR
receiver on the right and a proprietary mini-socket for analog
video/audio input on the left.  The underside has a sticker with
bar code, model number and MAC address.

4. I have taken close up photos of the device with and without the
covers off.  The inside of the device holds two circuit boards
with some components hidden between them, I have taken photos
or the outward facing sides of the two boards.

I have posted the photos at these URLs:

<http://www.jbohm.org/930C/frontAndCable.jpg>
<http://www.jbohm.org/930C/back.jpg>
<http://www.jbohm.org/930C/boardFront.jpg>
<http://www.jbohm.org/930C/boardBack.jpg>

(Please copy the photos to your own archives, these are temporary
URLs).

And finally something worth investigating:

Some time has passed since Micronas Lawyers blocked the release of
the FOSS driver for their chipset, maybe they have cooled down now
and someone from the linuxtv project could approach Hauppauge or
Pinacle (who seem FOSS-friendly) to put business pressure on their
chipset supplier Micronas to reverse their decision and permit the
release of the FOSS driver that was previously developped in
cooperation between Pinacle, Micronas techs and Devin Heitmueller
(one of the linuxtv developers).


Sincerely, and hoping this helps things move forward in at least
some direction

Jakob Bohm

-- 
This message is hastily written, please ignore any unpleasant wordings,
do not consider it a binding commitment, even if its phrasing may
indicate so. Its contents may be deliberately or accidentally untrue.
Trademarks and other things belong to their owners, if any.
