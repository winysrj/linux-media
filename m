Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+78812c0465fa576c722c+1958+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LImbw-0005iC-B1
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 17:10:56 +0100
Date: Fri, 2 Jan 2009 14:10:42 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Elio Voci <elio.voci@gmail.com>
Message-ID: <20090102141042.19b98341@pedra.chehab.org>
In-Reply-To: <1230901740.14839.15.camel@localhost>
References: <1230901740.14839.15.camel@localhost>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] em28xx frontend does not attach
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

On Fri, 02 Jan 2009 14:09:00 +0100
Elio Voci <elio.voci@gmail.com> wrote:

> Hello.
> 
> I have recently upgraded my Debian Lenny from kernel 2.6.25 to 2.6.26.
> After this, I couldn't use my Cinergy Hybrid T USB XS (0ccd:0042).
> Up to now I used the mcentral.de driver, now I would like to switch to
> linuxtv driver.
> 
> Following the wiki "How to install DVB device drivers, and "How to build
> drivers from Mercurial", I have cloned v4l-dvb. Make and install ran
> smoothly.
> I have generated the firmware from
> http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip, Driver85/hcw85bda.sys
> 
> em28xx installed correctly, dvb frontend did not: zl10353_read_register
> returned -19
> Below the relevant dmesg section (em28xx modprobed with core_debug=1
> 

It is probably not that complicated for you to fix the Cinergy Hybrid entry at
v4l-dvb.

You'll need to use usbsnoop tool to capture what the original driver is doing
[1]. 

After that, you can parse the log and fix the initialization values for
GPIO and GPO registers. You can also load em28xx with reg_dump=1 and parse the
dmesg output with the em28xx parser, comparing to what the windows driver did.

[1] http://www.linuxtv.org/wiki/index.php/Bus_snooping/sniffing#Snooping_Procedures:


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
