Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <md001@gmx.de>) id 1PjVfk-0007bm-9O
	for linux-dvb@linuxtv.org; Sun, 30 Jan 2011 12:42:24 +0100
Received: from mailout-de.gmx.net ([213.165.64.22])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-d) with smtp
	for <linux-dvb@linuxtv.org>
	id 1PjVfj-00012q-2t; Sun, 30 Jan 2011 12:42:24 +0100
To: linux-dvb@linuxtv.org
From: Martin Dauskardt <md001@gmx.de>
Date: Sun, 30 Jan 2011 12:42:21 +0100
MIME-Version: 1.0
Message-Id: <201101301242.21306.md001@gmx.de>
Subject: Re: [linux-dvb] HDPVR woes
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

> From: Rob Davis <rob@davis-family.info>
> 
> I am using a Hauppauge HDPVR unit with vdr and the pvrinput plugin. This
> normally works really well, however every now and then thing stops
> streaming, the big blue light goes off and pvrinput doesn't notice. 

Are there any errors or unusual messages in the pvrinput log (use loglevel 3 
or 4)?
Please load hdpvr with hdpvr_debug=1 to see if there are any special driver 
messages.

> I am trying to diagnose this with Lars Hanisch, one of the authors of
> pvrinput.
> 
> The part of pvrinput it's failing on is:
> 
> else if (FD_ISSET(parent->v4l2_fd, &selSet)) {
> log(pvrDEBUG1, "read");
do you get this log info? If not, it could be a similar problem with FD_ISSET 
I noticed while trying to get a saa7134card working. I removed FD_ISSET and 
changed the code in reader.c (similar to the one in mythtv)

> r = read(parent->v4l2_fd, buffer, bufferSize);
> log(pvrDEBUG1, "done read");
> 
> 
> So, it never returns from r = read(parent->v4l2_fd, buffer, bufferSize);
> 
> If I do a cat /dev/video0 >/tmp/test.ts, and change the resolution of
> the cable box, the cat command never finishes, but the blue light goes
> out and test.ts stops increasing in size. (This simulates the same kind
> of behaviour, so I'm guessing it's a TS error of some sort).

this indicates that a disturbance in the input signal confuses the hdpvr. Can 
you reproduce this by simply turning off and on the cable box?

What is necessary to get hdpvr work again? If you kill the current cat command 
and start a new capturing with cat - does this work? Or do you need to reload 
the driver , or power off/on  the hdpvr?

> 
> I am compiling the latest dev tree of v4l at the moment but don't think
> much development has happened in this driver.
> 
> The problem compounds on VDR as if there is no signal while recording,
> VDR assumes its a driver lockup and restarts itself, breaking any
> concurrent recordings on other input devices.

You can turn off the "emergency exit" in "Setup/Miscellaneous/Emergency exit". 
(At least with vdr 1.7.16)

BTW: the linux-dvb ML is dead. Driver discussion is now in linux-
media@vger.kernel.org 

Greets,
Martin

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
