Return-path: <linux-media-owner@vger.kernel.org>
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:22325 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752961AbZK2B37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 20:29:59 -0500
Message-ID: <721764.95451.qm@web110610.mail.gq1.yahoo.com>
References: <754577.88092.qm@web110614.mail.gq1.yahoo.com>  <1259025174.5511.24.camel@pc07.localdom.local>  <990417.69725.qm@web110607.mail.gq1.yahoo.com>  <1259107698.2535.10.camel@localhost>  <623705.13034.qm@web110608.mail.gq1.yahoo.com>  <1259172867.3335.7.camel@pc07.localdom.local>  <214960.24182.qm@web110609.mail.gq1.yahoo.com>  <1259360050.6061.22.camel@pc07.localdom.local>  <8049.95935.qm@web110610.mail.gq1.yahoo.com> <1259363687.6061.45.camel@pc07.localdom.local>
Date: Sat, 28 Nov 2009 17:30:04 -0800 (PST)
From: Dominic Fernandes <dalf198@yahoo.com>
Subject: Re: Compile error saa7134 - compro videomate S350
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1259363687.6061.45.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

I'm getting closer!!! 

I'm using ubuntu 9.10, unloading saa7134 alsa wasn't working for me so I put it into the blacklist which prevented it from loading and then I was able to do the "modprobe -vr saa7134-alsa saa7134-dvb" and "modprobe -v saa7134 card=16". 

And now the card recongnised correctly as the S350 and the dvb frontend loads.  

So, now I've plugged in the cable to the SAT dish which is pointing to Astra 19.2 and want to tune into some channels.
I installed dvb-apps and use the command below to create a channels.conf to use later:-

scan -x0 /usr/share/dvb/dvb-s/Astra-19.2E | tee channels.conf

but this soon concludes with tunning finished with no channels found.  I get a warning >>> tuning failed.

So, I tried both the modification of the GPIO address of xc0000 and what it 
was originally x8000 which gave the same tuning failed message.

Are there some other commands to test the DVB Frontend?

Thanks,
Dominic









----- Original Message ----
From: hermann pitton <hermann-pitton@arcor.de>
To: Dominic Fernandes <dalf198@yahoo.com>
Cc: linux-media@vger.kernel.org
Sent: Fri, November 27, 2009 11:14:47 PM
Subject: Re: Compile error saa7134 - compro videomate S350

Hi Dominic,

Am Freitag, den 27.11.2009, 14:59 -0800 schrieb Dominic Fernandes:
> hi,
> 
> where does  "options saa7134 alsa=0" need to be declared?  Is it in /etc/modprobe.d/options.conf ?  If so, it didn't work - "FATAL: saa7134-alsa is in use"

yes, you can only unload saa7134-alsa after you close all apps using it.

It is very distribution depending and I'm not aware of all, where to put
options.

If it doesn't work for options.conf, it should still work with a
recently deprecated declared /etc/modprobe.conf file you have to create
as a work around for all distros.

You must issue a "depmod -a" after that and reboot, if you don't know
how to unload saa7134-alsa by closing all apps using it.

A "modprobe -vr saa7134-alsa saa7134-dvb" and then load it with
"modprobe -v saa7134 card=169 gpio_tracking=1" should still reveal
something configured in the system overriding your command line with
card=169.

I'm not on latest here ...

Cheers,
Hermann


--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      

