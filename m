Return-path: <mchehab@localhost>
Received: from mailout0.thls.bbc.co.uk ([132.185.240.35]:48248 "EHLO
	mailout0.thls.bbc.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab1GKMCL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 08:02:11 -0400
Received: from gateh.kw.bbc.co.uk (gateh.kw.bbc.co.uk [132.185.132.17])
	by mailout0.thls.bbc.co.uk (8.14.4/8.14.3) with ESMTP id p6BBNTPK021133
	for <linux-media@vger.kernel.org>; Mon, 11 Jul 2011 12:23:29 +0100 (BST)
Received: from mailhub.rd.bbc.co.uk ([172.29.120.130])
	by gateh.kw.bbc.co.uk (8.13.6/8.13.6) with ESMTP id p6BBNSBR026245
	for <linux-media@vger.kernel.org>; Mon, 11 Jul 2011 12:23:28 +0100 (BST)
Received: from goliath.rd.bbc.co.uk ([172.29.90.42]:43448 helo=goliath.sid.rd.bbc.co.uk)
	by mailhub.rd.bbc.co.uk with esmtp (Exim 4.72)
	(envelope-from <david.waring@rd.bbc.co.uk>)
	id 1QgEaG-0001cs-DI
	for linux-media@vger.kernel.org; Mon, 11 Jul 2011 12:23:28 +0100
Message-ID: <4E1ADD30.6090502@rd.bbc.co.uk>
Date: Mon, 11 Jul 2011 12:23:28 +0100
From: David Waring <david.waring@rd.bbc.co.uk>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Problems with Hauppauge Nova-TD (dib0070/dib7000PC)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

I'm currently using 3 of these USB sticks on a PC with the videolan.org
dvblast program to multicast the UK Freeview DVB-T muxes on our local
network. I'm also using a PCTV nanostick 290e to multicast the DVB-T2
mux too.

I'm having a problem with the Nova-TD sticks (52009) using recent builds
from the media_build git repository (to get the 290e drivers) on Debian
squeeze using 2.6.38-bpo.2-686. The problem is that only one half of
each Nova-TD stick will tune and give data. Which half seems to be
random and changes with each reboot. Occasionally I'll get a whole stick
working or one of the sticks will not work at all. If I try to use a
non-working half of a stick it will knock out the working half until I
stop using trying to use the non-working half. So I'm seeing
interference of one logical dvb adapter from another that are both on
the same physical hardware.

Also after a few days the sticks stop working completely and need to be
powered down before they work again, but this may be a different issue.

I'm getting a few "dib0700: tx buffer length is larger than 4. Not
supported." in dmesg during first tune. Maybe coincidence, but I've
noticed that on the last reboot 4 tuners (out of the 6 total Nova-TD
tuners) are not working and I have 4 of the above message in dmesg, so
there could be a link.

I've tried turning on the debugging for both the dvb_usb_dib0700 and
dvb_usb modules but there was no indication of the problem.

Any suggestions for what I could try next to find the cause and fix this?

David
-- 
David Waring, Software Engineer, BBC Research & Development
5th Floor, Dock House, MediaCity:UK, Salford, M50 2LH
----------------------------------------------------------------------
This e-mail, and any attachment, is confidential. If you have received
it in error, please delete it from your system, do not use or disclose
the information in any way, and notify me immediately. The contents of
this message may contain personal views which are not the views of the
BBC, unless specifically stated.
