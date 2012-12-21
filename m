Return-path: <linux-media-owner@vger.kernel.org>
Received: from relaygateway02.edpnet.net ([212.71.1.211]:7936 "EHLO
	relaygateway02.edpnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LUIkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 03:40:33 -0500
Message-ID: <50D41EEA.4000607@edpnet.be>
Date: Fri, 21 Dec 2012 09:33:46 +0100
From: Herman Viaene <herman.viaene@edpnet.be>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Build of media_build in Mandriva 2011
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo,

I tried to build these drivers in order to get my Hauppauge PVR-500 card 
to work
Note: I had the card working on previous releases thanks to the info in 
ivtvdrivers.org, but this site is empty now.

The packages needed have the same name as for Redhat, and I have been 
able to build apparently successfully.

BUT

When I booted the next day, the boot process blocked. By rebooting and 
using the verbose mode, I saw some message passing by mentioning ivtv, 
plus 10 (or more) lines of codes (the ivtv message scrolled off the 
screen) and at last "Fixing recursive fault, but this requires reboot".
So I rebooted two more times, and then I could start the PC, but I did 
not check the video device, I had not enough time for that.

The next day, I had the same booting problem again, and I gave up after 
10 reboots, and re-installed Mandriva. After that, I could not find 
anything on the events in the logs (I have /var on a separate partition, 
so it does not get completely wiped out by a re-installation).

I will check the Mandriva User group on this, and keep you informed if 
anything comes out of it.

Regards

Herman Viaene

-- 
Veel mensen danken hun goed geweten aan hun slecht geheugen. (G. Bomans)

Lots of people owe their good conscience to their bad memory (G. Bomans)

