Return-path: <linux-media-owner@vger.kernel.org>
Received: from onv-colo01.spothost.nl ([193.189.149.48]:40436 "EHLO
	praag.spothost.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751683Ab0D1Oy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 10:54:28 -0400
Message-ID: <59062.192.87.141.196.1272466066.squirrel@webmail.spothost.nl>
Date: Wed, 28 Apr 2010 16:47:46 +0200 (CEST)
Subject: debugging my Tevii S660 usb 2.0 dvb-s2 device
From: kc@cobradevil.org
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I have bought a new tevii s660 device in december 3 months later
(backorder) when i received my device i was having issues when loading the
driver from the tevii website.
First loading went ok but then i got hundreds of debug messages in dmesg.
Later this device really died so i sent it back for rma.

Now i have received a new device but still have the same issues.
I got the old drivers from Artem: Re: [vdr] System unresponsive and
picture breakup with VDR 1.7.10  and Tevii S660 (USB) (thanks for helping
out)

But still  i have system freezes.
and a channel scan freaks out my system and device.

Does someone have time/ideas how to make this device work and how can i
deliver the right info to make it happen.
I'm no developer so programming is a problem but i'm happy to try patches
if someone can help me out.

So what info would be needed beside a dmesg/uname -a and how can i get the
right information
e.g. lsusb -vvv

With kind regards

William van de Velde



