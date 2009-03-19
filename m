Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:56413 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbZCSHrI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 03:47:08 -0400
Message-ID: <002701c9a866$e23da0b0$0a00a8c0@vorg>
From: "Timothy D. Lenz" <tlenz@vorgon.com>
To: <linux-media@vger.kernel.org>
Cc: <linux-dvb@linuxtv.org>
References: <000701c9a5de$09033e20$0a00a8c0@vorg><49BE5B36.1080901@linuxtv.org> <003a01c9a69a$0de42640$0a00a8c0@vorg><1237252028.3303.41.camel@palomino.walls.org><000401c9a838$c690c0a0$0a00a8c0@vorg> <1237430932.3303.103.camel@palomino.walls.org>
Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
Date: Thu, 19 Mar 2009 00:46:51 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No, changing baud rate to 9600 has no effect. It is simply not sending the log to the serial port.

----- Original Message ----- 
From: "Andy Walls" <awalls@radix.net>
To: <linux-media@vger.kernel.org>
Cc: <linux-dvb@linuxtv.org>
Sent: Wednesday, March 18, 2009 7:48 PM
Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic


> On Wed, 2009-03-18 at 19:16 -0700, Timothy D. Lenz wrote:
> > I've added
> >     console=ttyS0,115200 console=tty0
> > to the kernel command line options and with out the console=tty0 part the dump no longer shows on the monitor, so redirect seems
to
> > work but loging the serial port on a second computer gets nothing. I tested the connection with echo and that worked but the
kernel
> > dump won't go out the port.  The last 2 lines of the screen are:
> >
> > EIP: [<c012a8c6>] queue_work+0x3/0x68 SS:ESP 0068:f778dd24
> > Kernel panic - not syncing: Fatal exception in interrupt
>
> Hmm.  The only thing in the cx23885 driver that tries to schedule work,
> and thus the only thing that could possibly pass in a bad argument, is
> the netup_ci_slot_status() function.  It gets called when an IRQ comes
> in indicating a GPIO[01] event, and the driver thinks the card is a
> NetUp Dual DVB-S2 CI card.
>
> That's consistent with the "fatal exception in interrupt", but without
> the backtrace, one can't be completely sure this call to queue work was
> initiated by the cx23885 driver and a problem with cx23885 data
> structures.  (But it is the most likely scenario, IMO)
> I just can't see how netup_ci_slot_status() get's called for your card.
>
>
> > Any way to get the dump to go out the serial port?
>
> Does 9600 baud help? (Just a guess.)
>
> Regards,
> Andy
>
> > ----- Original Message ----- 
> > From: "Andy Walls" <awalls@radix.net>
> > To: "Timothy D. Lenz" <tlenz@vorgon.com>
> > Cc: <linux-media@vger.kernel.org>
> > Sent: Monday, March 16, 2009 6:07 PM
> > Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
> >
> >
> > > On Mon, 2009-03-16 at 17:46 -0700, Timothy D. Lenz wrote:
> > > > When it panics, there is no log, just a bunch of stuff that that scrolls fast on the main monitor then cold lock.
> > > >  No way to scroll
> > > > back.
> > >
> > > Not even Shift+PageUp ?
> > >
> > >
> > >
> > > >  I looked at the logs and the ones that are text had nothing about it.
> > >
> > > Digital camera or pencil and paper will be least complex way to capture
> > > the ooops data.  Please don't leave out the "Code" bytes at the bottom
> > > and do your best to make sure those are absolutely correct.
> > >
> > > Regards,
> > > Andy
> > >
> > >
> > > > ----- Original Message ----- 
> > > > From: "Steven Toth" <stoth@linuxtv.org>
> > > > To: <linux-media@vger.kernel.org>
> > > > Cc: <linux-dvb@linuxtv.org>
> > > > Sent: Monday, March 16, 2009 6:59 AM
> > > > Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
> > > >
> > > >
> > > > > Timothy D. Lenz wrote:
> > > > > > Using kernel 2.6.26.8 and v4l from a few days ago. When I modprobe cx23885 to load the drivers, I get kernel panic
> > > > >
> > > > > We'll need the oops.
> > > > >
> > > > > - Steve
> > > > >
> > > > > _______________________________________________
> > > > > linux-dvb users mailing list
> > > > > For V4L/DVB development, please use instead linux-media@vger.kernel.org
> > > > > linux-dvb@linuxtv.org
> > > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >
> > >
> >
> >
> > _______________________________________________
> > linux-dvb users mailing list
> > For V4L/DVB development, please use instead linux-media@vger.kernel.org
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

