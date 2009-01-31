Return-path: <linux-media-owner@vger.kernel.org>
Received: from 78-86-168-217.zone2.bethere.co.uk ([78.86.168.217]:45322 "EHLO
	homer.jasonline.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZBAAJ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jan 2009 19:09:57 -0500
Received: from quad.jasonline.co.uk (quad.jasonline.co.uk [192.168.0.13])
	by homer.jasonline.co.uk (Postfix) with ESMTP id 4B2D9B682AB
	for <linux-media@vger.kernel.org>; Sat, 31 Jan 2009 23:55:57 +0000 (GMT)
Message-ID: <4984E50D.8000506@jasonline.co.uk>
Date: Sat, 31 Jan 2009 23:55:57 +0000
From: Jason Harvey <softdevice@jasonline.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: CinergyT2 not working with newer alternative driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have been successfully using VDR with two CinergyT2s for 18 months.
After adding a Hauppage NOVA-S2-HD I updated my v4l-dvb drivers hoping 
to get S2 capability and test a newer VDR for HD reception.

The CinergyT2s stopped working. The kernel module loads, the blue leds 
flash as expected but they don't lock on to a signal for long.
Signal strength shown in femon is erratic and a lock only rarely achieved.

I checked through the mercurial tree to see what had changed.
It looks like the following change is the one that stops the CinergyT2s 
working on my system.
http://git.kernel.org/?p=linux/kernel/git/mchehab/devel.git;a=commit;h=986bd1e58b18c09b753f797df19251804bfe3e84

I deleted the newer version of the module and replace it with the 
previous deleted code.
Make'd and installed the old version works as expected.

Machine they're plugged into is running Fedora 10, 
2.6.27.12-170.2.5.fc10.i686
I downloaded the current v4l-dvb today (31Jan2009) and tried it all 
again before posting this message.

Not sure where to look next, I did start to capture the USB traffic to 
see if I could spot the difference...

Thanks,
Jason
