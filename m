Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KYLcU-0002T7-Ey
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 16:03:35 +0200
Received: from [134.32.30.87] (milan-ofs-a87.milan.oilfield.slb.com
	[134.32.30.87])
	by mail.youplala.net (Postfix) with ESMTP id 13C51D8816B
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 16:02:30 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <412bdbff0808270649t69b07207x92bb9754396ab800@mail.gmail.com>
References: <617be8890808270010j640f4cb7je46e74c7234b978b@mail.gmail.com>
	<alpine.LRH.1.10.0808271021040.18085@pub6.ifh.de>
	<617be8890808270212m192b2951x4d5e8313cd788557@mail.gmail.com>
	<412bdbff0808270649t69b07207x92bb9754396ab800@mail.gmail.com>
Date: Wed, 27 Aug 2008 15:02:28 +0100
Message-Id: <1219845748.7191.61.camel@acropora>
Mime-Version: 1.0
Subject: Re: [linux-dvb] dib0700 new i2c implementation
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

On Wed, 2008-08-27 at 09:49 -0400, Devin Heitmueller wrote:
> Hello Eduard,
> 
> 2008/8/27 Eduard Huguet <eduardhc@gmail.com>:
> > Well, regarding the Nova-T 500 I must say that, using the current HG
> driver
> > code and 1.10 firmware, it's pretty rock solid. I've had no USB
> disconnects
> > nor hangs of any time since a long time ago (since lastest patches
> for this
> > card were merged).
> >
> > That's the reason I'm very reluctant to use the new firmware,
> specially if
> > the effect seems to be a constantly rebooting machine, as Nicolas
> Will
> > described ;-). However, if the above patche solves the problems then
> I'll be
> > very pleased to test it.
> 
> It seems that Nicholas's problems had to do with having random copies
> of 1.10 in /lib/firmware.
> 
> This is about more than "does it fix my problem".  The patch I am
> submitting could cause potential breakage with other devices, so I
> need people who have a stable environment to test the change and make
> sure it doesn't cause breakage.
> 
> Otherwise, it just gets pushed in, you do an "hg update" and all of a
> sudden your environment is broken.
> 
> The patch is known to fix several problems required to get the xc5000
> working with the dib0700, but I want to be sure people with a working
> environment don't start seeing problems.
> 

So people using the following devices should help test:

      * Hauppauge WinTV-NOVA-T-500
      * Hauppauge WinTV-NOVA-T-Stick
      * Hauppauge WinTV-NOVA-TD-Stick
      * TerraTec Cinergy DT USB XS Diversity
      * Emtec S830 
      * Leadtek Winfast DTV Dongle
      * Hauppauge myTV.t

>From 
http://linuxtv.org/wiki/index.php/Special:Whatlinkshere/Template:Making-it-work:dvb-usb-dib0700

A list of less documented devices usinf the dib0700 module is available
here:
http://linuxtv.org/wiki/index.php/DVB-T_USB_Devices#DiB0700_USB2.0_DVB-T_devices

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
