Return-path: <linux-media-owner@vger.kernel.org>
Received: from n2-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.154]:43346 "HELO
	n2-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752101AbZK3Wga (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 17:36:30 -0500
Message-ID: <234254.68438.qm@web110604.mail.gq1.yahoo.com>
References: <754577.88092.qm@web110614.mail.gq1.yahoo.com>  <1259025174.5511.24.camel@pc07.localdom.local>  <990417.69725.qm@web110607.mail.gq1.yahoo.com>  <1259107698.2535.10.camel@localhost>  <623705.13034.qm@web110608.mail.gq1.yahoo.com>  <1259172867.3335.7.camel@pc07.localdom.local>  <214960.24182.qm@web110609.mail.gq1.yahoo.com>  <1259360050.6061.22.camel@pc07.localdom.local>  <8049.95935.qm@web110610.mail.gq1.yahoo.com>  <1259363687.6061.45.camel@pc07.localdom.local>  <721764.95451.qm@web110610.mail.gq1.yahoo.com> <1259544565.4436.27.camel@pc07.localdom.local>
Date: Mon, 30 Nov 2009 14:35:06 -0800 (PST)
From: Dominic Fernandes <dalf198@yahoo.com>
Subject: Re: Compile error saa7134 - compro videomate S350
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1259544565.4436.27.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

There is a sign of life coming from the card (I connected my SAT finder and got a loud tone from it).

> You might want to set dvb_powerdown_on_sleep=0 for dvb_core.

How do you specify this and which file (saa7134-dvb.c or saa7134-core.c or some other file)?

I tried Kaffeine, to scan Astra 19.2 but no luck, at first I can see the signal meters light up and then stop.  The output from dmesg at this point shows:
 
[   72.944834] DVB: registering adapter 0 frontend 0 (Zarlink ZL10313 DVB-S)...
[ 2183.208025] DVB: adapter 0 frontend 0 frequency 7401500 out of range (950000..2150000)
[ 2191.756534] DVB: adapter 0 frontend 0 frequency 7401500 out of range (950000..2150000)
[ 2195.908528] DVB: adapter 0 frontend 0 frequency 7401500 out of range (950000..2150000)


Not sure what this means.

Thanks,
Dominic





----- Original Message ----
From: hermann pitton <hermann-pitton@arcor.de>
To: Dominic Fernandes <dalf198@yahoo.com>
Cc: linux-media@vger.kernel.org
Sent: Mon, November 30, 2009 1:29:25 AM
Subject: Re: Compile error saa7134 - compro videomate S350

Hi Dominic,

Am Samstag, den 28.11.2009, 17:30 -0800 schrieb Dominic Fernandes: 
> Hi Hermann,
> 
> I'm getting closer!!! 
> 
> I'm using ubuntu 9.10, unloading saa7134 alsa wasn't working for me so I put it into the blacklist which prevented it from loading and then I was able to do the "modprobe -vr saa7134-alsa saa7134-dvb" and "modprobe -v saa7134 card=16". 
> 
> And now the card recongnised correctly as the S350 and the dvb frontend loads.  
> 
> So, now I've plugged in the cable to the SAT dish which is pointing to Astra 19.2 and want to tune into some channels.
> I installed dvb-apps and use the command below to create a channels.conf to use later:-
> 
> scan -x0 /usr/share/dvb/dvb-s/Astra-19.2E | tee channels.conf
> 
> but this soon concludes with tunning finished with no channels found.  I get a warning >>> tuning failed.
> 
> So, I tried both the modification of the GPIO address of xc0000 and what it 
> was originally x8000 which gave the same tuning failed message.
> 
> Are there some other commands to test the DVB Frontend?

if Astra-19.2E is unchanged in dvb-apps, it has not much.

# Astra 19.2E SDT info service transponder
# freq pol sr fec
S 12551500 V 22000000 5/6

We don't even know if 13 and 18 Volts to the LNB work both for sure with
that variant, IIRC. The report says just somehow works.

I think I would try with some peace of copper from a LNB cable into the
RF connector and a Voltmeter, if there is any sign of life first, either
using kaffeine with better files for scanning or the "setvoltage" tool
in /test.

You might want to set dvb_powerdown_on_sleep=0 for dvb_core.

For the other saa7134 driver cards currently is hacked on,

For Dominic with the Leadtek on the saa7134 driver, Terry, me or anyone
else interested should provide some test patches.

Why that AverMedia analog only in the Ukraine doesn't have sound even on
PAL around there, is beyond my imagination, except it would not have
ever been tested for TV sound, also beyond what I can imagine.

Any log for obviously failing sound carrier detection is still missing.

Cheers,
Hermann


--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      

