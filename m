Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n70.bullet.mail.sp1.yahoo.com ([98.136.44.38])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <mcleanandrew@yahoo.com>) id 1KEVag-0005Px-N6
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 22:39:48 +0200
Date: Thu, 3 Jul 2008 13:38:46 -0700 (PDT)
From: Andrew McLean <mcleanandrew@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <639576.43086.qm@web43136.mail.sp1.yahoo.com>
Subject: [linux-dvb] New Nova-TD-Stick (USB) with new IDs is making problems
	/ is not running
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

Hi folks,

I recently bought a "Hauppauge Nova-TD USB-Stick" for
DVB-T.
The stick was recommended by another linux-user, so I
thought, it would work.

But now I figured out, that the stick has new
settings, I mean a new ID and it is not recognized by
the recent kernel-versions (2.6.24 and 2.6.25).

The (new) stick comes up with this:
idVendor=2040, idProduct=5200
At the back of the stick, there is a label showing
this:
52009 LF Rev B1F4, Assembled in Indonesia

The old and working Nova-TD version comes up with
this:
idVendor=2040, idProduct=9580
(comes from Taiwan)

I also installed the latest version of v4l to check,
if it is working, but it doesnt.

In this kernel modules, the a.m. ID is not listet
here:
Kernel 2.6.24:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=blob;f=drivers/media/dvb/dvb-usb/dvb-usb-ids.h;h=4fa3e895028a0596c7a792cb5e451aadceddc634;hb=HEAD

Kernel 2.6.25:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=blob;f=drivers/media/dvb/dvb-usb/dvb-usb-ids.h;h=49a44f249ab0e99f4fd96d0ec725d224420ab3fd;hb=HEAD

This is the first time, I'm posting to a mailing list
like that, so please advise me, what more information
you need. Perhaps you can speed up the development
with this information.

I have posted several log-files and tests with the
a.m. kernel versions on the german debian board here:
http://www.debianforum.de/forum/viewtopic.php?f=25&t=100676&start=15&st=0&sk=t&sd=a
(written in German)

So, I would be really happy, if one of you guys up
here can tell me what I can try next to get the new
Nova-TD-stick working.

Thanks in advance,
Andreas


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
