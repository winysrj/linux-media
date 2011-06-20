Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:39306 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751155Ab1FTJUW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 05:20:22 -0400
Message-ID: <4DFF10D1.6000801@gmx.de>
Date: Mon, 20 Jun 2011 11:20:17 +0200
From: Jonas Diemer <diemer@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Reception Troubles with Hauppauge Nova-TD Stick
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I am running the  Hauppauge Nova-TD Stick using the latest git drivers 
(I followed http://wiki.ubuntuusers.de/v4l-dvb) under Ubuntu 11.04.

The stick seems to work fine, it is detected and usable by the software 
(w_scan, VDR, mythtv).

However, the reception is very bad. Only one out of the 5 (or so) 
available MUXes is detected. The reception on this one mux is very bad 
(no stable video). Signal strength (as reported by vdr-femon) is at 
40-50%, STR is less than 10%.

I have tried the force_lna_activation=1 option, but that didn't make any 
difference. I am using the supplied antenna adapter to connect a small 
stick antenna. I noticed that unplugging the Antenna didn't really make 
the reception worse. Unplugging the adapter reduced the signal strength 
significantly.

The stick works just fine under Windows (all MUXes are detected with 
good image quality). I noticed that the LED on the stick has a different 
color under windows (blue) than under Linux (green) - if that makes any 
difference.

So, is there anyone that can help? Any ideas how I can get this to work?

Kind Regards,
Jonas
