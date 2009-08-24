Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.freemail.gr ([81.171.104.45])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <scoop_yo@freemail.gr>) id 1MfSZr-0001vh-EQ
	for linux-dvb@linuxtv.org; Mon, 24 Aug 2009 07:58:48 +0200
From: scoop_yo@freemail.gr
To: linux-dvb@linuxtv.org
Date: Mon, 24 Aug 2009 08:58:43 +0300
Message-Id: <4a922c13705bb1.13585078@freemail.gr>
References: <1251066447.3244.5.camel@pc07.localdom.local>
MIME-version: 1.0
Subject: Re: [linux-dvb] Lifeview hybrid saa7134 driver not working anymore
Reply-To: linux-media@vger.kernel.org, scoop_yo@freemail.gr
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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


Considering your reply, I started today by changing the card to all PCI slots and powering on and off the machine each time, until when I put the card to the bottom PCI it worked again ! Then I tried all other slots again and it was working this time. That is some weird card behaviour !

Thanks for the tip.

> Hi scoop,
> 
> Am Sonntag, den 23.08.2009, 17:52 +0300 schrieb scoop_yo@freemail.gr:
> > Hi, for a couple of days now, my lifeview PCI hybrid card that worked flawlessly for the last 2 years doesn't work. The problem is with the driver from what I understand from the logs.
> >
> > Today 23/8/2009 I tried the drivers within vanilla kernel 2.6.30.5 (i386 and amd64) and then separately latest mercurial snapshot. I always use latest mercurial snapshot updating every time a new kernel is released.
> > This card works within Windows XP. I also switched the PCI slot but that didn't help.
> >
> > For the driver, I issued the command:
> >
> > modprobe saa7134 i2c_debug=1 i2c_scan=1 disable_ir=1
> >
> > I attached the log because it's kinda big for posting it on the message.
> > For any ideas or suggestions I am here available for testing them. :)
> >
> 
> the report is at least fine.
> 
> An i2c device, working over years on 0x10, vanished mysteriously.
> 
> I guess you don't have much better options here than to try, if it comes
> back with any combination of either most triggering it or not at all ...
> 
> Cheers,
> Hermann



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
