Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZGVSNv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 14:13:51 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional again
Date: Wed, 22 Jul 2009 14:12:42 -0400
Cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
References: <200907201020.47581.jarod@redhat.com> <Pine.LNX.4.58.0907212343130.11911@shell2.speakeasy.net> <200907221359.00892.jarod@redhat.com>
In-Reply-To: <200907221359.00892.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221412.42871.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 22 July 2009 13:59:00 Jarod Wilson wrote:
> On Wednesday 22 July 2009 02:51:12 Trent Piepho wrote:
> > On Tue, 21 Jul 2009, Jarod Wilson wrote:
...
> > > So its either I have *two* machines with bad, but only slightly bad,
> > > and in the same way, PCI slots which seem to work fine with any other
> > > card I have (uh, unlikely), or my HD-3000 has gone belly up on me in
> > > some subtle way. The cx8802 part never shows up under lspci on either
> > > machine I've tried it in. Suck.
> > 
> > Check your eeprom, it could be set incorrectly.
> > 
> > "i2cdump -f 0 0x50" will show the contents if the HD-3000 has i2c bus 0.
> > i2cdump with no arguments will tell you what each bus is.
> > 
> > The first 12 bytes should look something like this:
> > 00: 06 ff ff ff 63 70 00 30 e0 01 40 ff 00 00 00 00    ?...cp.0??@.....
> > 
> > 
> > The first byte should have bit 0x04 set to enable mpeg.
> 
> So here's what was in my eeprom:
> 
> 00: 00 00 00 00 63 70 00 30 e0 01 40 ff 00 00 00 00    ....cp.0??@.....
> 
> Sooo... For funsies, I figured out how to use i2cset, and made it match
> your example. After rebooting, I have the cx8802 device showing up
> again. Cool! Now to see if it actually *works*... :)

Yup, seems to work, just did an OTA scan w/o a problem, azap gets a
lock, signal and snr, dvbtraffic, and video coming off it look sane.

Now the question I have is how the hell did the eeprom get hosed over
in the first place?...

In any case, thanks much! Happy to have it back in working order.

-- 
Jarod Wilson
jarod@redhat.com
