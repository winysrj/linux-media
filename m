Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1KxO16-0005zO-1T
	for linux-dvb@linuxtv.org; Tue, 04 Nov 2008 16:40:31 +0100
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 5005B1A13F9
	for <linux-dvb@linuxtv.org>; Tue,  4 Nov 2008 10:40:23 -0500 (EST)
Message-Id: <1225813223.7609.1282933233@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: linux-dvb@linuxtv.org
Content-Disposition: inline
MIME-Version: 1.0
References: <200811032211.41760.jareguero@telefonica.net>
	<49104A4D.2040609@iki.fi>
	<1225811663.1701.1282927225@webmail.messagingengine.com>
	<e28a31000811040730qef2d86bsf04cc389c3800c1e@mail.gmail.com>
In-Reply-To: <e28a31000811040730qef2d86bsf04cc389c3800c1e@mail.gmail.com>
Date: Tue, 04 Nov 2008 15:40:23 +0000
Subject: Re: [linux-dvb] Nova-TD and I2C read/write failed
Reply-To: linuxtv@hotair.fastmail.co.uk
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

Thanks for the quick replies. I'll give that a try.

On Tue, 4 Nov 2008 15:30:22 +0000, "Greg Thomas"
<Greg@thethomashome.co.uk> said:
> 2008/11/4 petercarm <linuxtv@hotair.fastmail.co.uk>
> 
> > My build is gentoo with 2.6.25 kernel and mercurial V4L using
> > dvb-usb-dib0700-1.10.fw   The Hauppauge Nova-TD USB stick shows a USB ID
> > of 2040:5200.
> >
> > The card works for a few hours and then floods dmesg with "DiB0070 I2C
> > write failed" messages.
> >
> > I've found plenty of passing references to this problem, but what do I
> > need to do to get this working?
> >
> > Do I need to change to the 1.20 firmware?
> >
> 
> FWIW, I suffered from the same problem, and found that simply blatting
> the
> 1.20 firmware from
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-TD-Stick#Firmwareover
> the 1.10 firmware solved it for me.
> 
> Greg

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
