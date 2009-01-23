Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from lists.iskon.hr ([213.191.128.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <m.rovis@inet.hr>) id 1LQRbH-0005G1-U9
	for linux-dvb@linuxtv.org; Fri, 23 Jan 2009 20:21:57 +0100
Received: from [192.168.1.7] (12-208.dsl.iskon.hr [89.164.12.208])
	by lists.iskon.hr (Postfix) with ESMTP id 6004698EAB
	for <linux-dvb@linuxtv.org>; Fri, 23 Jan 2009 20:21:52 +0100 (CET)
Message-ID: <497A18D0.70009@inet.hr>
Date: Fri, 23 Jan 2009 20:21:52 +0100
From: Miroslav Rovis <m.rovis@inet.hr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1232708401.9307.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1232708401.9307.linux-dvb@linuxtv.org>
Subject: [linux-dvb] [PATCH] cx88-dvb: Fix order of frontend allocations
 (Re: current v4l-dvb - cannot access /dev/dvb/: No such file or directory
Reply-To: linux-media@vger.kernel.org
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

I pasted the subject line from:
http://www.linuxtv.org/pipermail/linux-dvb/2009-January/thread.html#31463
the last message of the thread on the problem that I still have (there
is the patch in there in some post on the thread that should fix my
problem).
Tha card is a Hauppauge HVR-3000 that works fine on M$ Windoze Vista.
Arch is 64bit Athlon based...
With the kernel ("uname -r" output):
2.6.28-gentoo-r1
In fact, cx88-dvb sometimes loads and then I have the populated
/dev/dvb... (very choppy but I got anything I tried after dvbscan and
szap etc.)
And sometimes it doesn't load at all and there is no /dev/dvb directory
at all.
The error when issuing "modprobe cx88-dvb" is:
FATAL: Error inserting cx88_dvb
(/lib/modules/2.6.28-gentoo-r1/v4l-dvb/video/cx88/cx88-dvb.ko): Unknown
symbol in module, or unknown parameter (see dmesg)
dmesg on its part only has:
cx88_dvb: Unknown parameter `frontend'
The kernel (2.6.28-gentoo-r1) does have the aforementioned Andy's patch
applied...
Firmare is as suggested here:
http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000#Firmware_v1.23.86.1
I am at a loss where to turn, what to try...
Cheers!
Miro Rovis
www.exDeo.com
www.CroatiaFidelis.hr


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
