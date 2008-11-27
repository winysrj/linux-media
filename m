Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from harpoon.unitedhosting.co.uk ([83.223.124.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert@watkin5.net>) id 1L5nNW-0003D2-7e
	for linux-dvb@linuxtv.org; Thu, 27 Nov 2008 21:22:24 +0100
From: Robert Watkins <robert@watkin5.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811251229m7e36ed33jade32457a4c37185@mail.gmail.com>
References: <RCbI1iFQ0HKJFw8A@onasticksoftware.net>
	<492A8A43.4060001@rusch.name> <u0lnYVBoGwKJFwJg@onasticksoftware.net>
	<1227556939.16187.0.camel@youkaida>
	<100c0ba70811241329s594e3112h467e1deff9d3c1ac@mail.gmail.com>
	<1227644366.6949.18.camel@watkins-desktop>
	<412bdbff0811251229m7e36ed33jade32457a4c37185@mail.gmail.com>
Date: Thu, 27 Nov 2008 20:21:48 +0000
Message-Id: <1227817308.7014.41.camel@watkins-desktop>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova/dib0700/i2C write failed
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

On Tue, 2008-11-25 at 15:29 -0500, Devin Heitmueller wrote:
> On Tue, Nov 25, 2008 at 3:19 PM, Robert Watkins <robert@watkin5.net> wrote:
> > On Mon, 2008-11-24 at 21:29 +0000, Richard Palmer wrote:
> >> Hi,
> >>
> >> On Mon, Nov 24, 2008 at 8:02 PM, Nicolas Will <nico@youplala.net> wrote:
> >> > On Mon, 2008-11-24 at 19:34 +0000, jon bird wrote:
> >> >> could be although on perusing the mailing list archives this seemed
> >> >> to
> >> >> be a recurring problem of which various attempts have been made to
> >> >> investigate/fix but there didn't seem to be a conclusion to it all.
> >> >> Hence I just thought I'd see what the latest state of play was and
> >> >> report back anything potentially useful.....
> >> >
> >> > Well, this has normally been solved. Your report is the first one in a
> >> > long time.
> >>
> >> I'll second the report. Also with a VIA motherboard, so the USB ports
> >> could be the
> >> culprit. Running Mythbuntu with kernel 2.6.24 and using the new
> >> firmware still gives
> >> i2c errors.
> >>
> >
> > I've found Unbuntu 2.6.24-21-386 worked reasonable well with errors
> > requiring a shut down and cold start once or twice a week.
> >
> > After an upgrade, I found 2.6.27-7-generic fails within seconds of
> > starting to record on two tuners.
> >  dvb-usb: error while enabling fifo.
> >
> > The current v4l-dvb drivers have the same issue.
> >
> > I also occasionally get
> >  dib0700: firmware download failed at 17248 with -110
> >
> > My PC's got ATI's IXP SB400 USB2 Host Controllers.
> >
> > Rob Watkins
> 
> Hello Robert,
> 
> Are you running dib0700 firmware version 1.10 or 1.20?

Hello Devin,

I switched to 1.10 after having problems with the 1.20 firmware. I
swapped the files back yesterday, and tried running with the current
drivers and the 1.20 firmware after a cold boot. You are right. The 1.20
firmware is significantly better than 1.10. 

A one point the 1.20 firmware ran for almost 2 hours before I noticed
problems. I shut down and restarted a couple of times after that, and
got errors within minutes.

The number the firmware download fails at changed each time but the
"with -110" was the same.

Best Wishes,
Rob

<snip>
[   23.538141] dib0700: loaded with support for 8 different device-types
[   23.539042] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in
cold state, will try to load a firmware
[   23.539051] firmware: requesting dvb-usb-dib0700-1.20.fw
[   24.890408] lirc_dev: IR Remote Control driver registered, major 61 
[   25.090680] Linux video capture interface: v2.00
[   25.214298] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[   26.368174] dib0700: firmware download failed at 20146 with -110
[   26.368380] usbcore: registered new interface driver dvb_usb_dib0700

<snip>

[   76.840589] usbcore: deregistering interface driver dvb_usb_dib0700
[   76.949087] dib0700: loaded with support for 8 different device-types
[   76.951065] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in
cold state, will try to load a firmware
[   76.951079] firmware: requesting dvb-usb-dib0700-1.20.fw
[   76.955490] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[   77.166854] dib0700: firmware started successfully.
[   77.668057] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in
warm state.
[   77.668149] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   77.668495] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   77.800034] DVB: registering adapter 0 frontend 0 (DiBcom
3000MC/P)...
[   77.888529] MT2060: successfully identified (IF1 = 1229)
[   78.383196] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   78.383469] DVB: registering new adapter (Hauppauge Nova-T 500 Dual
DVB-T)
[   78.390786] DVB: registering adapter 1 frontend 0 (DiBcom
3000MC/P)...
[   78.417569] MT2060: successfully identified (IF1 = 1217)
[   78.974397] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
initialized and connected.
[   78.977954] usbcore: registered new interface driver dvb_usb_dib0700
[  230.456120] dvb-usb: error while enabling fifo.
[ 1958.525133] dvb-usb: error while stopping stream.
[ 1976.092180] mt2060 I2C write failed
[ 2281.908116] mt2060 I2C write failed
[ 2676.912186] mt2060 I2C write failed
[ 2806.924148] mt2060 I2C write failed (len=2)
[ 2811.924179] mt2060 I2C write failed (len=6)
[ 2816.924849] mt2060 I2C read failed
[ 2821.932136] mt2060 I2C read failed
[ 2826.940180] mt2060 I2C read failed
[ 2831.949212] mt2060 I2C read failed
[ 2836.957124] mt2060 I2C read failed
[ 2841.968042] mt2060 I2C read failed
[ 2846.976207] mt2060 I2C read failed
[ 2851.985868] mt2060 I2C read failed
[ 2856.993026] mt2060 I2C read failed
[ 2862.000703] mt2060 I2C read failed



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
