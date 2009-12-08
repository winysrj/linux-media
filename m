Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <rob@esdelle.co.uk>) id 1NI3y5-0006yS-C6
	for linux-dvb@linuxtv.org; Tue, 08 Dec 2009 18:35:22 +0100
Received: from [172.23.170.142] (helo=anti-virus02-09)
	by smtp-out2.blueyonder.co.uk with smtp (Exim 4.52)
	id 1NI3y1-0002nb-Ad
	for linux-dvb@linuxtv.org; Tue, 08 Dec 2009 17:35:17 +0000
Received: from [62.31.89.131] (helo=esdelle.homelinux.org)
	by asmtp-out3.blueyonder.co.uk with smtp (Exim 4.52)
	id 1NI3xy-0002qP-TB
	for linux-dvb@linuxtv.org; Tue, 08 Dec 2009 17:35:15 +0000
Message-ID: <4B1E8E4D.9010101@esdelle.co.uk>
Date: Tue, 08 Dec 2009 17:35:09 +0000
From: Rob Beard <rob@esdelle.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] WinTV HVR-900 USB (B3C0)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi folks,

I've borrowed a WinTV HVR-900 USB stick from a friend of mine to see if 
I can get any reception in my area before forking out for one however 
I've run in to a couple of problems and wondered if anyone had used one 
of these sticks?

The device appears to support both analogue and DVB-T (Freeview) TV 
however when I plug the device in it only appears to enable the analogue 
side of things (it comes up as /dev/video1 as I have a webcam on my laptop).

I've downloaded and installed the firmware in /lib/firmware as per the 
instructions on the LinuxDVB web site
 and it appears to pick it up and I've even tried compiling the v4l-dvb 
drivers too which didn't appear to make any difference.

Just to check it wasn't me going mad, I tried the dvb-utils scan utility 
and also Kaffene, both of which doesn't work (and I can't find a 
/dev/dvb directory either).

If it helps, the output from /var/log/messages is here: 
http://pastebin.com/m34f1048f

I just wondered if anyone else had one of these sticks actually working 
under Ubuntu 9.10?  (I'm running kernel 2.6.31-16-generic-pae).

Rob






_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
