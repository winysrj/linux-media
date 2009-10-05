Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52378 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751654AbZJEOuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 10:50:13 -0400
Date: Mon, 5 Oct 2009 16:49:12 +0200
From: Mario Bachmann <grafgrimm77@gmx.de>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dib3000mb dvb-t with kernel 2.6.32-rc3 do not work
Message-ID: <20091005164912.2fc3023e@x2.grafnetz>
In-Reply-To: <alpine.LRH.1.10.0910051547130.29145@pub6.ifh.de>
References: <20091005095144.3551deb3@x2.grafnetz>
	<alpine.LRH.1.10.0910051547130.29145@pub6.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 5 Oct 2009 15:50:13 +0200 (CEST)
schrieb Patrick Boettcher <pboettcher@kernellabs.com>:

> Hi Mario,
> 
> On Mon, 5 Oct 2009, Mario Bachmann wrote:
> > with kernel 2.6.30.8 my "TwinhanDTV USB-Ter USB1.1 / Magic Box I"
> > worked.
> >
> > Now with kernel 2.6.32-rc3 (and 2.6.31.1) the modules seems to be
> > loaded fine, but tzap/kaffeine/mplayer can not tune to a channel:
> >
> > dmesg says:
> > dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA
> > USB1.1 DVB-T device' in warm state. dvb-usb: will use the device's
> > hardware PID filter (table count: 16). DVB: registering new adapter
> > (TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T
> > device) DVB: registering adapter 0 frontend 0 (DiBcom 3000M-B
> > DVB-T)... dibusb: This device has the Thomson Cable onboard. Which
> > is default. input: IR-receiver inside an USB DVB receiver
> > as /devices/pci0000:00/0000:00:04.0/usb4/4-2/input/input5 dvb-usb:
> > schedule remote query interval to 150 msecs. dvb-usb: TwinhanDTV
> > USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device
> > successfully initialized and connected. usbcore: registered new
> > interface driver dvb_usb_dibusb_mb
> >
> > [..]
> > and so on. The signal-values are zero or near zero, but when i boot
> > the old kernel 2.6.30.8, t can tune without problems.
> 
> In a personal email to me you are saying that the differences between 
> dibusb-common.c in 2.6.30.8 and 2.6.32-rc3 are the main cause for the 
> problem.
> 
> Is it possible for you find out which exact change is causing the
> trouble?
> 
> With the v4l-dvb-hg-repository it is possible to get each intemediate 
> version of this file. Afaics, there is only 3 modifications for the 
> timeframe we are talking about.
> 
> best regards,
> 
> --
> 
> Patrick Boettcher - Kernel Labs
> http://www.kernellabs.com/

i think the cause must be here:
/usr/src/linux-2.6.32-rc3/drivers/media/dvb/dvb-usb/dibusb-common.c
line 136 to line 146

i changed this hole section to the version of 2.6.30.8:

		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
			if (dibusb_i2c_msg(d, msg[i].addr,
		msg[i].buf,msg[i].len,
						msg[i+1].buf,msg[i+1].len)
		< 0)
				break;
			i++;
		} else
			if (dibusb_i2c_msg(d, msg[i].addr,
		msg[i].buf,msg[i].len,NULL,0) < 0)
				break;

and it works again. my posted part is inside the 
"for (i = 0; i < num; i++) { ... }" -Section !

Mario
