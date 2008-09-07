Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1Kc8A7-0002Pc-Ak
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 02:29:57 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	59E2C1800280
	for <linux-dvb@linuxtv.org>; Sun,  7 Sep 2008 00:29:19 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Thomas Goerke" <tom@goeng.com.au>, 'jackden' <jackden@gmail.com>
Date: Sun, 7 Sep 2008 10:29:19 +1000
Message-Id: <20080907002919.38684104F0@ws1-3.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
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
> From: "Thomas Goerke" <tom@goeng.com.au>
> To: stev391@email.com, "'jackden'" <jackden@gmail.com>
> Subject: RE: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog TV/FM capture card
> Date: Sat, 6 Sep 2008 12:56:15 +0800
> 
> 
> >
> > Tom,
> >
> > So the V0.2 patch worked after a cold reboot (No power to the computer
> > then starting up again). Is that what you are saying?
> > (Make sure that the v0.1 modules are not loaded on boot up if you are
> > testing V0.2)
> >
> > I was expecting the DMA timeout errors when using V0.2 from a cold
> > start, it should not have caused it to break for a warm start (i.e.
> > V0.1 modules loaded, then removed and v0.2 modules loaded).
> >
> > Sorry to ask for clarification, as the results were not what I was
> > expecting.
> >
> > Can you try the:
> > modprobe cx23885 i2c_scan=1
> > That Steve Suggested.
> >
> > Thanks
> >
> > Stephen
> Stephen,
> 
> V0.1
> 	Cold Reset (0ff for 10 second):	No errors from dmesg
> 							Can tune and watch
> channels
> 	Warm Reset (ie sudo reboot):		Many errors in dmesg
> 							Can tune and watch
> channels
> V0.2
> 	Cold Reset (0ff for 10 second):	No errors from dmesg
> 							Can tune and watch
> channels
> 	Warm Reset (ie sudo reboot):		Many errors in dmesg
> 							Tuning fails.
> Unable to watch channels
> 
> Wrt sudo modprobe cx23885 i2c_scan=1, where are you expecting the output?
> Given that the module is already loaded do I need to modify the
> modprobe.d/cx23885 file to include the option and then reboot?
> 
> With regard to ensuring V0.1 modules are not loaded when using V0.2, the
> method I have used is to have two completely different v4l_dvb source
> directories and doing a make, sudo make install to use the different
> versions.  I have assumed that this will copy the modules over the top of
> the old modules.  Please let me know if this is not correct.
> 
> If you want me to reboot with new option let me know.
> 
> Thanks
> 
> Tom

Tom & Jackden,

to use the i2c_scan:
sudo rmmod cx23885
sudo modprobe cx24885 i2c_scan=1

dmesg

Now in dmesg you should see something like:
[ 8235.464732] cx23885[0]: i2c bus 0 registered
[ 8235.467566] cx23885[0]: i2c scan: found device @ 0x1e  [???]
[ 8235.476222] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
[ 8235.476698] cx23885[0]: i2c scan: found device @ 0xa4  [???]
[ 8235.477366] cx23885[0]: i2c scan: found device @ 0xa8  [???]
[ 8235.477640] cx23885[0]: i2c scan: found device @ 0xac  [???]
[ 8235.479082] cx23885[0]: i2c scan: found device @ 0xc2  [tuner/mt2131/tda8275/xc5000/xc3028]
[ 8235.480459] cx23885[0]: i2c scan: found device @ 0xd6  [???]
[ 8235.480987] cx23885[0]: i2c scan: found device @ 0xde  [???]
[ 8235.483249] cx23885[0]: i2c bus 1 registered
[ 8235.485687] cx23885[0]: i2c scan: found device @ 0x1e  [???]
[ 8235.496382] cx23885[0]: i2c scan: found device @ 0xc2  [tuner/mt2131/tda8275/xc5000/xc3028]
[ 8235.500428] cx23885[0]: i2c bus 2 registered
[ 8235.502458] cx23885[0]: i2c scan: found device @ 0x66  [???]
[ 8235.503269] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
[ 8235.503774] cx23885[0]: i2c scan: found device @ 0x98  [???]

This will have the cards initialisation before and after it, I just need the i2c scan results.

Then to get the results from the eeprom scan:
sudo modprobe i2c-dev
sudo i2cdetect -l 
(take note which i2c device matches the one above with the eeprom, this example assumes 0)
sudo i2cdump 0 0x50 
(Note the i2c address has to be divided by 2 from what the scan above states, so 0xa0 -> 0x50)

Then you should get an output in the terminal, copy this and send it to me (and the list).

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
