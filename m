Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46748 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab0BVA7L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 19:59:11 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1NjLiW-000847-BY
	for linux-media@vger.kernel.org; Mon, 22 Feb 2010 01:00:04 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 01:00:04 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 01:00:04 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Possible memory corruption in bttv driver ?
Date: Wed, 03 Feb 2010 18:10:59 +0100
Message-ID: <hkcan2$72f$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

We use embedded devices running debian lenny (kernel 2.6.31.4 with bttv 
driver 0.9.18) to monitor an incoming video signal digitized via a video 
grabber. The /dev/video0 device is opened and closed several hundred times a 
day.

We used to use an em28xx USB based grabber but now switched to an Mini-PCI 
bttv card (Commel MP-878) due to USB issues.

With the bttv card we experience different crashes, usually after a couple 
of days, while the systems using the em28xx show none even after an extended 
time frame.

The crashes differ strongly. We saw system freezes and also a very 
interesting problem, where libasound.so.2 couldn't find some symbol. We 
debugged the latter case, finding that all applications using libasound.so.2 
no longer worked, giving the same error of a symbol not found. The problem 
could be remedied by flushing the kernel cashes (echo 1 > 
/proc/sys/vm/drop_caches).

So it might be possible that the systems using the bttv Mini-PCI card 
corrupt memory after a couple of days, resulting into different failures.

To examine the crashes I wrote a small test program, which simply opens and 
closes the bttv video device repeatedly:

#!/bin/bash

count=0
while [ 1 == 1 ]
do
        ((count++))
        date; echo "COUNT = " $count
        mplayer -frames 10 -fs -vo xv tv:// -tv norm=pal:input=1 > /dev/null
        sleep 0.1
done

With this program I experienced full hard crashes after 85 counts, 760 
counts and 3870 counts today, comprising between a couple of minutes and 
hours. In all cases the hardware watchdog timer resetted the system.

The exact same system using an USB ex28xx based grabber instead of the bttv 
does not crash.

1.) Is there a way to diagnose memory corruption in order to ensure that it 
is really a corruption problem and to locate the possible bug?

2.) Do newer kernel versions have improved bttv drivers (maybe even with
patched memory corruption issues)?

3.) As a last resort: Do you know of other Mini-PCI video grabber cards that
are based on other chipsets that are supported by the kernel?

Thanks a lot for any help

Michael

