Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fortimail.matc.edu ([148.8.129.21] helo=matc.edu)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <johnsonn@matc.edu>) id 1Kqcew-0005UT-Fx
	for linux-dvb@linuxtv.org; Fri, 17 Oct 2008 01:53:41 +0200
Received: from GWISE1.matc.edu (gwise1.matc.edu [148.8.29.22])
	by Fortimail2000-1.fortimail.matc.edu  with ESMTP id m9GNr2GW025839
	for <linux-dvb@linuxtv.org>; Thu, 16 Oct 2008 18:53:02 -0500
Message-Id: <48F78D8A020000560001A654@GWISE1.matc.edu>
Date: Thu, 16 Oct 2008 18:52:58 -0500
From: "Jonathan Johnson" <johnsonn@matc.edu>
To: <linux-dvb@linuxtv.org>
Mime-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Fusion HDTV 7 Dual Express
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

Hello linux-dvb members,

I know another person posted a message similar to mine, but offered no diagnostic info, so I am.

DViCO device d618 using driver cx23885
Conexant Device 8852 (rev 02)
Base OS: SuSE 11.0
kernel manually upgraded to 2.6.27
checked dmesg, and all firmware(s) load.

 I have a FusionHDTV Dual 7 tuner, and it gets no signal at all, and some times no channels appear
when I scan from with in mythtv, and sometimes some of the channels appear.

1. First I tried hooking a ATI 650 to Vista and got 100% strength all the time, so it wasn't the antenna.
2. I then hooked up the FusionHDTV card to Vista and it also reported 100% signal strength.
Therefore the card is not broken.
3. I have 2 ATI HDTV Wonder that have always worked perfectly, so signal strength is good.


When trying to record w/ MythTV I get
---------
This occurs a couple times.
DVBSM(/dev/dvb/adapter1/frontend0), Warning can not measuer S/N
The following occurs many times:
DVBChan(3:/dev/dvb/adapter1/frontend0) Error:  Tune(): Setting Frontend using tuning parameters failed.
"eno: Invalid argument (22)"
-----------

Spent 1/2 hour looking thru google results.
I decided despite how horrible luck I have with compiling certain things, I would give it a go anyway.
The kernel always compiles for me at least.  I went to linuxtv.org and followed the instructions.
I did the make and make install and got the invalid symbols mentioned on the website, and it said
reboot.  So I did, and I recompiled again, for the heck of it, and still have invalid symbols. Read the
INSTALL text file, and tried a bunch of options.    I tried make kernel-(something), and recompile the
kernel(completely), and reboot,and still no go.  I tried re-compiling v4l-dvb and still nothing.
I eventually tried "make all" and the compile failed with errors.  Could not get it to compile, and now
v4l-dvb was un-usable.

I then installed and did a full compile of kernel 2.6.27.1 (released last night), and at least everything
now works.

I would like to try the development version to see if that fixes things, but I am not skilled enough to
resolved the unresolved symbol problem.  insmod and modprobe failed with the same error.


Later,
Jonathan


------------------------------------------- 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
