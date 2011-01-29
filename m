Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <rob@davis-family.info>) id 1PjCfi-0005qh-MO
	for linux-dvb@linuxtv.org; Sat, 29 Jan 2011 16:25:07 +0100
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1PjCfi-0004eg-3v; Sat, 29 Jan 2011 16:25:06 +0100
Received: from [192.168.2.10] (oac.oaci.org [192.168.2.10])
	by oac.localdomain (Postfix) with ESMTP id CDD5A2123DC
	for <linux-dvb@linuxtv.org>; Sat, 29 Jan 2011 09:25:02 -0600 (CST)
Message-ID: <4D44314E.5080908@davis-family.info>
Date: Sat, 29 Jan 2011 09:25:02 -0600
From: Rob Davis <rob@davis-family.info>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] HDPVR woes
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

I am using a Hauppauge HDPVR unit with vdr and the pvrinput plugin. This 
normally works really well, however every now and then thing stops 
streaming, the big blue light goes off and pvrinput doesn't notice.  I 
am trying to diagnose this with Lars Hanisch, one of the authors of 
pvrinput.

The part of pvrinput it's failing on is:

else if (FD_ISSET(parent->v4l2_fd, &selSet)) {
log(pvrDEBUG1, "read");
r = read(parent->v4l2_fd, buffer, bufferSize);
log(pvrDEBUG1, "done read");


So, it never returns from r = read(parent->v4l2_fd, buffer, bufferSize);

If I do a cat /dev/video0 >/tmp/test.ts, and change the resolution of 
the cable box, the cat command never finishes, but the blue light goes 
out and test.ts stops increasing in size. (This simulates the same kind 
of behaviour, so I'm guessing it's a TS error of some sort).

I am compiling the latest dev tree of v4l at the moment but don't think 
much development has happened in this driver.

The problem compounds on VDR as if there is no signal while recording, 
VDR assumes its a driver lockup and restarts itself, breaking any 
concurrent recordings on other input devices.
-- 

Rob Davis

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
