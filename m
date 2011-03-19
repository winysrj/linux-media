Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:45764 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756880Ab1CSSkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2011 14:40:23 -0400
From: Jochen Reinwand <Jochen.Reinwand@gmx.de>
To: linux-media@vger.kernel.org
Subject: Remote control TechnoTrend TT-connect S2-3650 CI
Date: Sat, 19 Mar 2011 19:40:20 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103191940.20876.Jochen.Reinwand@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everyone,

I've searched the archive and Google for this, but haven't found anything 
useful...

I'm using a TechnoTrend TT-connect S2-3650 CI. The S2API support is great! I 
do not have any problems watching DVB-S and DVB-S2 content. Tuning is quite 
fast! It's working much better than my Hauppauge WinTV Nova-TD, but that's a 
different story...

The only severe problem I have with the TechnoTrend is related to the remote 
control. Around 30% of the key presses produce two key events. It's not 
related to any lirc or X11 configuration issue. I verified it using the tool 
input-events on the device. There are really two separate events coming from 
the device.

Is this due to a hardware problem, or is it a driver issue? My C and Kernel 
knowledge is not really the best. But there is some code in dvb-usb-remote.c 
that seems to be related to key repeats. Are the dvb remote input devices 
doing something special here? I'm also not able to modify behaviour of the 
device via "xset r rate" when using it as X11 input device. It's only 
affecting the real keyboard that is also attached.

The system is a recent yaVDR. So it's more or less an Ubuntu 10.4. Kernel is 
2.6.32. S2API should be a recent check out.

Any ideas?

Thanks in advance,
Jochen
