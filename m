Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40152 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab1G3VNH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2011 17:13:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QnGqF-000833-DG
	for linux-media@vger.kernel.org; Sat, 30 Jul 2011 23:13:03 +0200
Received: from p54af3560.dip.t-dialin.net ([84.175.53.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 30 Jul 2011 23:13:03 +0200
Received: from o.freyermuth by p54af3560.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 30 Jul 2011 23:13:03 +0200
To: linux-media@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: Re: [PATCH] Add support for PCTV452E.
Date: Sat, 30 Jul 2011 23:12:50 +0200
Message-ID: <j11s4i$9g4$1@dough.gmane.org>
References: <201105242151.22826.hselasky@c2i.net> <20110723132437.7b8add2c@grobi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <20110723132437.7b8add2c@grobi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.07.2011 13:24, schrieb Steffen Barszus:
> > On Tue, 24 May 2011 21:51:22 +0200
> > Hans Petter Selasky <hselasky@c2i.net> wrote:
> >
>> >> NOTES:
>> >>
>> >> Sources were taken from the following repositorium as of today:
>> >> http://mercurial.intuxication.org/hg/s2-liplianin/
>> >>
>> >> And depend on the zig-zag fix posted today.
> >
> > Did a first test on the patch.
> > [   96.780040] usb 1-8: new high speed USB device using ehci_hcd and
address 5
> > [   97.376058] dvb_usb_pctv452e: Unknown symbol
ttpci_eeprom_decode_mac (err 0)
> >
Same here.

> > Looks like this patch didn't make it into patchwork - Mauro can you
> > check that ?
> >
> >
> > I think the patch for ttpci-eeprom.c is missing this:
> >
> > --- linux/drivers/media/dvb/ttpci/ttpci-eeprom.c.orig	2011-07-23
11:00:49.000000000 +0000
> > +++ linux/drivers/media/dvb/ttpci/ttpci-eeprom.c	2011-07-23
11:04:00.000000000 +0000
> > @@ -165,6 +165,7 @@ int ttpci_eeprom_parse_mac(struct i2c_ad
> >  }
> >
> >  EXPORT_SYMBOL(ttpci_eeprom_parse_mac);
> > +EXPORT_SYMBOL(ttpci_eeprom_decode_mac);
> >
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Ralph Metzler, Marcus Metzler, others");
This patch indeed fixed it for me.
Module now loads, detects the card and appears to be successful.

However, when I try to tune, syslog shows:
Jul 29 02:46:00 sandy kernel: [  122.986314] pctv452e_power_ctrl: 1
Jul 29 02:46:01 sandy kernel: [  124.041037] pctv452e: I2C error -121;
AA 31  CC 00 01 -> 55 31  CC 00 00.
Jul 29 02:46:01 sandy kernel: [  124.056408] pctv452e: I2C error -121;
AA 48  CC 00 01 -> 55 48  CC 00 00.
Jul 29 02:46:01 sandy kernel: [  124.100998] pctv452e: I2C error -121;
AA 63  CC 00 01 -> 55 63  CC 00 00.
[...cut...]
Jul 29 02:46:30 sandy kernel: [  153.265552] pctv452e: I2C error -121;
AA 95  CC 00 01 -> 55 95  CC 00 00.
Jul 29 02:46:31 sandy kernel: [  153.812108] pctv452e_power_ctrl: 0

Tuning is not possible here (Kernel 3.0 in use).
Anybody with the same issue?

Reference for the 'normal' users who just want to use their card:
I have now downgraded to 2.6.38 again on my Sandy Bridge board
(sacrificing working reboot...) for s2liplianin does not like
bkl-removal in 2.6.39 and definitely no 3.0-tree.

s2liplianin on 2.6.38 works perfectly with this card. It also has much
better support for my other az6027 than the in-tree-modules (still, no
signal for any DVB-S2 with the az6027).

