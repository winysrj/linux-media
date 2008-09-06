Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <csutor@gmx.de>) id 1Kc7Zf-0000r6-DJ
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 01:52:17 +0200
Message-ID: <48C3178F.6050704@gmx.de>
Date: Sun, 07 Sep 2008 01:51:43 +0200
From: Clemens Sutor <csutor@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with mantis drivers for Terratec Cinergy C and
 CAM
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello @all!

I have a Terratec Cinergy C with CI under Ubuntu 8.04 running vdr 1.6.
I use the newest mantis drivers from the mercury repository (83e2af36efe7).

 <http://www.jusst.de/hg/mantis/rev/83e2af36efe7>With all free channels everything is running fine but if I insert my CAM into the CI when running vdr, the CAM init fails and even free programs are not viewable anymore.

The dmesg shows:

[   86.389545] dvb_ca adapter 0: CAM tried to send a buffer larger than the link buffer size (49158 > 128)!
[   86.491022] dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount size!
[   86.491027] dvb_ca adapter 0: DVB CAM link initialisation failed :(

Any ideas or fixes for this problem?

Will be a verbose log of the mantis module more helpfull?
 
Bye
Clemens



 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
