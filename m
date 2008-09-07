Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1Kc91a-0004ym-Hu
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 03:25:12 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	86C28180029C
	for <linux-dvb@linuxtv.org>; Sun,  7 Sep 2008 01:24:35 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: jackden <jackden@gmail.com>
Date: Sun, 7 Sep 2008 11:24:35 +1000
Message-Id: <20080907012435.7E0C932675A@ws1-8.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
 TV/FM capture card
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


> ----- Original Message -----
> From: jackden <jackden@gmail.com>
> To: stev391@email.com
> Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog TV/FM capture card
> Date: Sun, 7 Sep 2008 08:46:20 +0800
> 
> 
> 2008/9/7  <stev391@email.com>:
> >
> >> ----- Original Message -----
> >> From: "Thomas Goerke" <tom@goeng.com.au>
> >> To: stev391@email.com, "'jackden'" <jackden@gmail.com>
> >> Subject: RE: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog TV/FM capture card
> >> Date: Sat, 6 Sep 2008 12:56:15 +0800
> >>
> >>
> >> >
> >> > Tom,
> >> >
> >> > So the V0.2 patch worked after a cold reboot (No power to the computer
> >> > then starting up again). Is that what you are saying?
> >> > (Make sure that the v0.1 modules are not loaded on boot up if you are
> >> > testing V0.2)
> >> >
> >> > I was expecting the DMA timeout errors when using V0.2 from a cold
> >> > start, it should not have caused it to break for a warm start (i.e.
> >> > V0.1 modules loaded, then removed and v0.2 modules loaded).
> >> >
> >> > Sorry to ask for clarification, as the results were not what I was
> >> > expecting.
> >> >
> >> > Can you try the:
> >> > modprobe cx23885 i2c_scan=1
> >> > That Steve Suggested.
> >> >
> >> > Thanks
> >> >
> >> > Stephen
> >> Stephen,
> >>
> >> V0.1
> >>       Cold Reset (0ff for 10 second): No errors from dmesg
> >>                                                       Can tune and watch
> >> channels
> >>       Warm Reset (ie sudo reboot):            Many errors in dmesg
> >>                                                       Can tune and watch
> >> channels
> >> V0.2
> >>       Cold Reset (0ff for 10 second): No errors from dmesg
> >>                                                       Can tune and watch
> >> channels
> >>       Warm Reset (ie sudo reboot):            Many errors in dmesg
> >>                                                       Tuning fails.
> >> Unable to watch channels
> >>
> >> Wrt sudo modprobe cx23885 i2c_scan=1, where are you expecting the output?
> >> Given that the module is already loaded do I need to modify the
> >> modprobe.d/cx23885 file to include the option and then reboot?
> >>
> >> With regard to ensuring V0.1 modules are not loaded when using V0.2, the
> >> method I have used is to have two completely different v4l_dvb source
> >> directories and doing a make, sudo make install to use the different
> >> versions.  I have assumed that this will copy the modules over the top of
> >> the old modules.  Please let me know if this is not correct.
> >>
> >> If you want me to reboot with new option let me know.
> >>
> >> Thanks
> >>
> >> Tom
> >
> > Tom & Jackden,
> >
> > to use the i2c_scan:
> > sudo rmmod cx23885
> > sudo modprobe cx24885 i2c_scan=1
> >
> > dmesg
> >
> > Now in dmesg you should see something like:
> > [ 8235.464732] cx23885[0]: i2c bus 0 registered
> > [ 8235.467566] cx23885[0]: i2c scan: found device @ 0x1e  [???]
> > [ 8235.476222] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
> > [ 8235.476698] cx23885[0]: i2c scan: found device @ 0xa4  [???]
> > [ 8235.477366] cx23885[0]: i2c scan: found device @ 0xa8  [???]
> > [ 8235.477640] cx23885[0]: i2c scan: found device @ 0xac  [???]
> > [ 8235.479082] cx23885[0]: i2c scan: found device @ 0xc2  [tuner/mt2131/tda8275/xc5000/xc3028]
> > [ 8235.480459] cx23885[0]: i2c scan: found device @ 0xd6  [???]
> > [ 8235.480987] cx23885[0]: i2c scan: found device @ 0xde  [???]
> > [ 8235.483249] cx23885[0]: i2c bus 1 registered
> > [ 8235.485687] cx23885[0]: i2c scan: found device @ 0x1e  [???]
> > [ 8235.496382] cx23885[0]: i2c scan: found device @ 0xc2  [tuner/mt2131/tda8275/xc5000/xc3028]
> > [ 8235.500428] cx23885[0]: i2c bus 2 registered
> > [ 8235.502458] cx23885[0]: i2c scan: found device @ 0x66  [???]
> > [ 8235.503269] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
> > [ 8235.503774] cx23885[0]: i2c scan: found device @ 0x98  [???]
> >
> > This will have the cards initialisation before and after it, I just need the i2c scan results.
> >
> > Then to get the results from the eeprom scan:
> > sudo modprobe i2c-dev
> > sudo i2cdetect -l
> > (take note which i2c device matches the one above with the eeprom, this example assumes 0)
> > sudo i2cdump 0 0x50
> > (Note the i2c address has to be divided by 2 from what the scan above states, so 0xa0 -> 0x50)
> >
> > Then you should get an output in the terminal, copy this and send it to me (and the list).
> >
> > Regards,
> >
> > Stephen.
> >
> >
> Stephen,
> 
> that is output in my computer.
> 
> sudo rmmod cx23885
> sudo modprobe cx24885 i2c_scan=1
> dmesg
> --
> [131266.163729] cx23885[0]: i2c bus 0 registered
> [131266.166447] cx23885[0]: i2c scan: found device @ 0x1e  [???]
> [131266.175808] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
> [131266.179689] cx23885[0]: i2c scan: found device @ 0xd0  [???]
> [131266.185552] cx23885[0]: i2c bus 1 registered
> [131266.199921] cx23885[0]: i2c scan: found device @ 0xc2
---Snip---
> sudo modprobe i2c-dev
> --
> [131474.253584] i2c /dev entries driver
> 
> sudo i2cdetect -l
> --
> i2c-0	smbus     	SMBus nForce2 adapter at 4c00   	SMBus adapter
> i2c-1	smbus     	SMBus nForce2 adapter at 4c40   	SMBus adapter
> i2c-5	i2c       	NVIDIA i2c adapter              	I2C adapter
> i2c-6	i2c       	NVIDIA i2c adapter              	I2C adapter
> i2c-7	i2c       	NVIDIA i2c adapter              	I2C adapter
> i2c-2	i2c       	cx23885[0]                      	I2C adapter
> i2c-3	i2c       	cx23885[0]                      	I2C adapter
> i2c-4	i2c       	cx23885[0]                      	I2C adapter
> 
> 
> sudo i2cdump 0 0x50 (because E650 card's eeprom in 0xa0, 0xa0/2=0x50)
---Snip---
> ----=Jackden in Google=----
> --=Jackden@Gmail.com=--

Jackden,

in the i2cdump command you have queried the wrong i2c bus, from the results above you should have issued this command:
sudo i2cdump 2 0x50
Can you please try again (The 2 comes from the i2c device listed in i2cdetect -l that corresponds to the first bus of the cx23885)

Sorry if I was unclear in my previous email.

Regards,
Stephen.


-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
