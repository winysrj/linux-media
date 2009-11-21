Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34394 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756536AbZKURZT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 12:25:19 -0500
Date: Sat, 21 Nov 2009 18:25:14 +0100
From: grafgrimm77@gmx.de
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dibusb-common.c FE_HAS_LOCK problem
Message-ID: <20091121182514.61b39d23@x2.grafnetz>
In-Reply-To: <alpine.LRH.2.00.0911191630250.12734@pub2.ifh.de>
References: <20091107105614.7a51f2f5@x2.grafnetz>
	<alpine.LRH.2.00.0911191630250.12734@pub2.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Thu, 19 Nov 2009 16:37:18 +0100 (CET)
schrieb Patrick Boettcher <pboettcher@kernellabs.com>:

> On Sat, 7 Nov 2009, Mario Bachmann wrote:
> 
> > Hi there,
> >
> > I tried linux-2.6.31.5 and tuning still does not work:
> > tuning to 738000000 Hz
> > video pid 0x0131, audio pid 0x0132
> > status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> > status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> > status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> > status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> >
> > With some changes for the following file it works again:
> > /usr/src/linux/drivers/media/dvb/dvb-usb/dibusb-common.c
> >
> > diff -Naur dibusb-common.c-ORIGINAL dibusb-common.c
> >
> > --- dibusb-common.c-ORIGINAL	2009-11-07 10:30:43.705344308 +0100
> > +++ dibusb-common.c	2009-11-07 10:33:49.969345253 +0100
> > @@ -133,17 +133,14 @@
> >
> > 	for (i = 0; i < num; i++) {
> > 		/* write/read request */
> > -		if (i+1 < num && (msg[i].flags & I2C_M_RD) == 0
> > -					  && (msg[i+1].flags & I2C_M_RD)) {
> > +		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
> > 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,
> > 						msg[i+1].buf,msg[i+1].len) < 0)
> > 				break;
> > 			i++;
> > -		} else if ((msg[i].flags & I2C_M_RD) == 0) {
> > +		} else
> > 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
> > 				break;
> > -		} else
> > -			break;
> > 	}
> 
> Doing it is reverting a fix which avoids that uncontrolled i2c-access from 
> userspace is destroying the USB-eeprom.
> 
> I understand that this is breaking the tuning for your board. I'm just not 
> understanding why.
> 
> If you have some time to debug this issue, could you please try the 
> following:
> 
> One of the devices for your board is trying to do an I2c access which is 
> falling into the last 'else'-branch - can you add a printk to find out 
> which one it is? The access must be wrongly constructed and must be fixed 
> in that driver.
> 
> thanks,
> 
> PS: if you don't have time to do it, please tell so.
> 
> --
> 
> Patrick
> http://www.kernellabs.com/

I do not understand exactly. printk what? Could you please give me a 
complete piece of code with the printk command? Would be great! 

My printk-tries ends up in an "Oops". 

Thank you.
Mario
