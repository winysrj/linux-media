Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+fe10d7a3e7858a473be5+1757+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1K7qK4-0007li-8F
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 13:23:05 +0200
Date: Sun, 15 Jun 2008 08:21:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080615082124.08d04a06@gaivota>
In-Reply-To: <4854B8DC.4060705@iinet.net.au>
References: <48498964.10301@iinet.net.au>
	<1212785950.16279.17.camel@pc10.localdom.local>
	<20080606183617.5c2b6398@gaivota> <484A1441.6070400@iinet.net.au>
	<484A1FC7.6070707@iinet.net.au>
	<1212886803.25974.44.camel@pc10.localdom.local>
	<20080608073836.233e801a@gaivota> <484C9E0A.1030909@iinet.net.au>
	<484D19B5.2060201@iinet.net.au> <484D20F3.6030004@iinet.net.au>
	<20080614085834.0d0baf41@gaivota> <4854AF1E.5080105@iinet.net.au>
	<4854B05C.1020601@iinet.net.au> <4854B382.5020509@iinet.net.au>
	<4854B8DC.4060705@iinet.net.au>
Mime-Version: 1.0
Cc: hartmut.hackmann@t-online.de, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problem with latest v4l-dvb hg
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

On Sun, 15 Jun 2008 14:38:20 +0800
timf <timf@iinet.net.au> wrote:

> timf wrote:
> > timf wrote:
> >   
> >> timf wrote:
> >>   
> >>     
> >>> Mauro Carvalho Chehab wrote:
> >>>   
> >>>     
> >>>       
> >>>> Hi Tim,
> >>>>
> >>>> I'm not sure if it is the same bug, but, on a device I have with tda10046, I
> >>>> need to slow firmware load, otherwise, it will fail. This happens on an AMD 64
> >>>> dual core notebook @1.8GHz. The same board, on an Intel single core @1.1GHz
> >>>> works without troubles.
> >>>>
> >>>> Please test the enclosed patch.
> >>>>
> >>>> On Mon, 09 Jun 2008 20:24:19 +0800
> >>>> timf <timf@iinet.net.au> wrote:
> >>>>
> >>>>   
> >>>>     
> >>>>       
> >>>>         
> >>>>>> [   38.194402] tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> >>>>>> [   38.286214] tda829x 2-004b: setting tuner address to 61
> >>>>>> [   38.370076] tda829x 2-004b: type set to tda8290+75a
> >>>>>> [   42.195417] saa7133[0]: registered device video0 [v4l2]
> >>>>>> [   42.195437] saa7133[0]: registered device vbi0
> >>>>>> [   42.195461] saa7133[0]: registered device radio0
> >>>>>> [   42.355808] DVB: registering new adapter (saa7133[0])
> >>>>>> [   42.355815] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> >>>>>> [   42.427655] tda1004x: setting up plls for 48MHz sampling clock
> >>>>>> [   44.678388] tda1004x: timeout waiting for DSP ready
> >>>>>> [   44.718322] tda1004x: found firmware revision 0 -- invalid
> >>>>>> [   44.718326] tda1004x: trying to boot from eeprom
> >>>>>>       
> >>>>>>         
> >>>>>>           
> >>>>>>             
> >>>> diff -r 000ffc33cb89 linux/drivers/media/dvb/frontends/tda1004x.c
> >>>> --- a/linux/drivers/media/dvb/frontends/tda1004x.c	Sat Jun 14 08:27:34 2008 -0300
> >>>> +++ b/linux/drivers/media/dvb/frontends/tda1004x.c	Sat Jun 14 08:53:01 2008 -0300
> >>>> @@ -135,6 +135,9 @@
> >>>>  
> >>>>  	msg.addr = state->config->demod_address;
> >>>>  	ret = i2c_transfer(state->i2c, &msg, 1);
> >>>> +
> >>>> +	if (state->config->xtal_freq == TDA10046_XTAL_16M)
> >>>> +		msleep(1);
> >>>>  
> >>>>  	if (ret != 1)
> >>>>  		dprintk("%s: error reg=0x%x, data=0x%x, ret=%i\n",
> >>>>
> >>>>
> >>>>
> >>>> Cheers,
> >>>> Mauro
> >>>>
> >>>>   
> >>>>     
> >>>>       
> >>>>         
> >>> Hi Mauro,
> >>> Patch applied, hard to tell if improved.
> >>>
> >>> Prior to patch:
> >>> Strange thing, maybe useful info, seems if boot from shutdown overnight, 
> >>> never loads firmware, always "revision ff"
> >>> Always have to restart, sometimes a few times, for firmware to load.
> >>>
> >>> dmesg after patch, reboot:
> >>>
> >>> [   41.504805] saa7133[0]: registered device vbi0
> >>> [   41.504836] saa7133[0]: registered device radio0
> >>> [   41.504913] tuner' 2-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
> >>> [   41.673243] DVB: registering new adapter (saa7133[0])
> >>> [   41.673249] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> >>> [   41.784037] tda1004x: setting up plls for 48MHz sampling clock
> >>> [   44.123523] tda1004x: timeout waiting for DSP ready
> >>> [   44.179434] tda1004x: found firmware revision 0 -- invalid
> >>> [   44.179436] tda1004x: trying to boot from eeprom
> >>> <snip>
> >>> [   46.511807] tda1004x: timeout waiting for DSP ready
> >>> [   46.567659] tda1004x: found firmware revision 0 -- invalid
> >>> [   46.567665] tda1004x: waiting for firmware upload...
> >>> [   47.166298] tuner' 2-004b: Cmd AUDC_SET_RADIO accepted for radio
> >>> [   47.166307] tuner' 2-004b: radio freq set to 87.50
> >>> [   59.147648] tda1004x: found firmware revision 29 -- ok
> >>> [   59.675203] tda827x_probe_version: could not read from tuner at addr: 
> >>> 0xc2
> >>> [   60.099525] tuner' 2-004b: Cmd TUNER_SET_STANDBY accepted for radio
> >>>
> >>> sysinfo:
> >>> AMD Athlon(tm) 64 X2 Dual Core Processor 3600+
> >>>
> >>> Regards,
> >>> Timf
> >>>
> >>> _______________________________________________
> >>> linux-dvb mailing list
> >>> linux-dvb@linuxtv.org
> >>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>>
> >>>   
> >>>     
> >>>       
> >> Woops!
> >> Just tried dvb - not good!
> >>
> >> dmesg:
> >> [   76.110517] eth0: no IPv6 routers present
> >> [ 1122.615680] tda1004x: setting up plls for 48MHz sampling clock
> >> [ 1122.810922] tda1004x: found firmware revision ff -- invalid
> >> [ 1122.810926] tda1004x: trying to boot from eeprom
> >> [ 1123.122401] tda1004x: found firmware revision ff -- invalid
> >> [ 1123.122405] tda1004x: waiting for firmware upload...
> >> [ 1123.131383] tda1004x: Error during firmware upload
> >> [ 1123.139410] tda1004x: found firmware revision ff -- invalid
> >> [ 1123.139414] tda1004x: firmware upload failed
> >> [ 1123.161822] tda827x_probe_version: could not read from tuner at addr: 
> >> 0xc2
> >> [ 1125.135952] tda827xo_set_params: could not write to tuner at addr: 0xc2
> >> [ 1126.005563] tda827xo_set_params: could not write to tuner at addr: 0xc2
> >> [ 1126.876173] tda827xo_set_params: could not write to tuner at addr: 0xc2
> >> [
> >>
> >> Regards,
> >> Timf
> >>
> >> _______________________________________________
> >> linux-dvb mailing list
> >> linux-dvb@linuxtv.org
> >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>
> >>   
> >>     
> > Tried power cycle, no, then restart, no
> > dmesg now:
> > [   38.427001] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
> > ff ff ff ff ff ff
> > [   38.427976] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
> > [   38.427979] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APC7] -> GSI 
> > 16 (level, low) -> IRQ 16
> > [   38.427986] PCI: Setting latency timer of device 0000:00:05.0 to 64
> > [   38.542753] saa7133[0]: registered device video0 [v4l2]
> > [   38.542775] saa7133[0]: registered device vbi0
> > [   38.542797] saa7133[0]: registered device radio0
> > [   38.575763] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  169.12  
> > Thu Feb 14 17:51:09 PST 2008
> > [   38.718512] tda10046: chip is not answering. Giving up.
> > [
> >
> > Regards,
> > Timf
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> >   
> OK, I re-installed a v4l-dvb I downloaded 12-june-2008, and now dvb 
> works fine!

It seems that sometimes tda10046 firmware loading doesn't work. I've tried here
other approaches, but still not working fine. Sometimes, firmware loads,
sometimes don't. If you enable debug for tda1004x, you'll see that, sometimes,
you get return -5 from write subroutine. Before the last patches I've merged,
you'll "get invalid ff", since tda1004x weren't handling errors on most write
or read ops.

Now, it will print a better message: "chip is not answering. Giving up."

Yet, firmware won't load always. I didn't go to datasheet yet, but maybe it has
something to do with XTAL frequency.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
