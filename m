Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UMUUwf018285
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 18:30:30 -0400
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net
	[151.189.21.45])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6UMTsQV024573
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 18:29:54 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: frtzkatz@yahoo.com
In-Reply-To: <902301.97749.qm@web63010.mail.re1.yahoo.com>
References: <902301.97749.qm@web63010.mail.re1.yahoo.com>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 00:23:07 +0200
Message-Id: <1217456587.4433.41.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: What info does V-4-L expect to be in the "Identifier EEprom"?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi everyone,

Am Mittwoch, den 30.07.2008, 13:44 -0700 schrieb Fritz Katz:
> Thank you Hans, 
> 
>   I need to correct my own mis-information.
>   Vendor ID assignments are given out by an industry group PCISIG.
>   Membership costs $3000 and has other benefits:
> 
>     http://www.pcisig.com/membership/join_pci_sig/
> 

Fritz, for what I can see you for sure don't have an eeprom yet on that
card(s).

Since PCI subvendor and subdevice information is stored there,
we for now could only add those cards providing them a card=Number entry
the users must look up.

To blow out all the known cards if an eeprom is not detected, you are
right, is becoming a bit overloaded and confusing, but that started with
some card=5 or 6 IIRC. Documentation/CARDLIST.saa7134 mirrors it.

If there is no eeprom, no subvendor/subdevice information is available
and there is no way around of it for auto detection.

The default Philips, the vendor, as subvendor on it and device 0x0 is
also not legal for detection use. There are some weired faulty solutions
in between, I would like to kick them even out too, since nobody can
guarantee, that they are unique. (the bomb ticks)

Trying all possible card variants is a risky business, so far, no
hardware died on it, as far I can truly tell, but there is some
remaining risk to have components on some card, which can't stand a
shortage.

So, it is not recommended to proceed that way for all cards around, like
you have seen, gpio stuff has impacts, but trying tuners should be safe.

Old can/tin tuners melt down to some very few tuner APIs, else we would
have several hundreds more in the end. How they are broken down
currently, you can see quite well in the Hauppauge tveeprom.

The rule is, if any new old ;) tuner on the markets really requires a
new entry, it is granted, but we don't duplicate stuff without limit we
have already.

We have countless cards without eeprom faking just card=3.

Else we need the dmesg with gpio init reported at least and a complete
description of all chips to start some guessing.

The v4l wiki at linuxtv.org and the bttv.gallery.de might give you some
hints and directions.

Recent saa713x stuff, which can mean triple or quad capabilities, like
multiple analog, DVB-T and DVB-S on it, also LowNoiseAmplifiers, which
must be configured correctly and invisible chips behind i2c bridges,
also all sort of gpio switching coming potentially from everywhere, are
not a simple task anymore.

But a simple saa7130, if not with some remote using an unknown protocol,
should be a fairly simple job. So far Hans is right.

Cheers,
Hermann



______________________________________
> --- On Wed, 7/30/08, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > >
> > > Should those two hex numbers should be the first 32
> > > bytes in the EEPROM?
> > 
> > No, PCI IDs are stored by the PCI hardware (I'm no
> > expert on this). The boards already have PCI IDs since 
> > they are mandated by the PCI standard. You can find them 
> > with 'lspci -vn'.
> > 
> > > Unfortunately, the company I'm consulting for is
> > > not in the list. I suppose we can submit an unused 
> > > vendor ID to the site.
> > 
> > No! The cards already have
> > vendor/device/subvendor/subdevice IDs. Ask 
> > the engineers, they should have all the details on this.
> > 
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
