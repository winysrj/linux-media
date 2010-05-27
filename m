Return-path: <linux-media-owner@vger.kernel.org>
Received: from amber.ccs.neu.edu ([129.10.116.51]:52774 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0E0OQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 10:16:45 -0400
Received: from alumni-linux.ccs.neu.edu ([129.10.116.115])
	by amber.ccs.neu.edu with esmtps (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <jfaulkne@ccs.neu.edu>)
	id 1OHdM2-0007qN-8K
	for linux-media@vger.kernel.org; Thu, 27 May 2010 09:42:34 -0400
Date: Thu, 27 May 2010 09:42:34 -0400 (EDT)
From: Jim Faulkner <jfaulkne@ccs.neu.edu>
To: linux-media@vger.kernel.org
Subject: em28xx broken when au0828 is also plugged in
Message-ID: <alpine.DEB.2.00.1005270912380.395@alumni-linux.ccs.neu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


My em28xx based Hauppauge HVR-950 does not work when I also have my au0828 
based HVR-950q plugged in.  Both are USB devices.  Depending on which USB 
ports I have them plugged into and which way the wind is blowing, I either 
see kernel oopses when they are both plugged in, or I see an unending 
stream of "Error -22 while loading base firmware" style messages when they 
are both plugged in.  I am running 2.6.34.

I do believe I have the correct firmware for both devices:
rosie firmware # pwd
/lib/firmware
rosie firmware # md5sum dvb-fe-xc5000-1.6.114.fw xc3028-v27.fw
b1ac8f759020523ebaaeff3fdf4789ed  dvb-fe-xc5000-1.6.114.fw
293dc5e915d9a0f74a368f8a2ce3cc10  xc3028-v27.fw
rosie firmware #

Here is my dmesg with the kernel oops:
http://www.ccs.neu.edu/home/jfaulkne/2.6.34-kernel-oops.dmesg.txt

Here is my dmesg with the firmware errors (which continue indefinitely):
http://www.ccs.neu.edu/home/jfaulkne/2.6.34-firmware-errors.dmesg.txt

And here is my dmesg when only the em28xx is plugged in:
http://www.ccs.neu.edu/home/jfaulkne/2.6.34-em28xx-only.dmesg.txt

The em28xx device works fine when it is the only device plugged in, but 
not when the au0828 device is also plugged in.  The au0828 device always 
works, no matter what is plugged in.

Here's my lspci and lsusb:
http://www.ccs.neu.edu/home/jfaulkne/lspci.txt
http://www.ccs.neu.edu/home/jfaulkne/lsusb.txt

Anyone have an idea how I can get the em28xx device working when both 
devices are plugged in?

thanks (and please CC me on any replies),
Jim Faulkner
