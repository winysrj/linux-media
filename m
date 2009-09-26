Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:53207 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZIZTTz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 15:19:55 -0400
Subject: Re: Fwd: ATI HDTV Wonder not always recognized
From: Andy Walls <awalls@radix.net>
To: "Dreher, Eric" <eric@dreher-associates.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <781723be0909221440w5969c21ai5e190936a64fd84@mail.gmail.com>
References: <781723be0909221420l7e955a54p9d713d821ba737da@mail.gmail.com>
	 <781723be0909221440w5969c21ai5e190936a64fd84@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 15:22:31 -0400
Message-Id: <1253992951.3156.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-09-22 at 16:40 -0500, Dreher, Eric wrote:
> I am need of opinions on whether this is a driver or motherboard issue
> (or something else).
> 
> I originally had an ATI HDTV Wonder card working perfectly along with
> a PVR-150 in my two PCI slots of a Asus M2NPV-VM motherboard.
> Driver for the HDTV Wonder is cx88_dvb, and the PVR, ivtv
> 
> The PVR-150 recently started to deteriorate with a poor picture
> quality ( I can describe more if relevant).  So I purchased a
> replacement PVR-150 and popped into place.  The new PVR-150 worked
> without a hitch itself.  But...the HDTV Wonder isn't even recognized.
> Does not show up in lspci.  "modprobe cx88_dvb" reports "no such
> device"
> 
> I have tried swapping PCI slots with no luck, replaced the old PVR-150
> with no luck.
> 
> But the HDTV Wonder is recognized in one slot only with the other slot
> empty.  So I can currently run with either card, but not both.
> 
> Motherboard has the most recent firmware.  I've updated Ubuntu to 9.10
> and v4l-dvb drivers to most recent 0.0.7.  (No noticable difference
> from 0.0.6 as far as what I need).
> 
> Is my logic correct in blaming the motherboard?  Any suggestions?


Take out all your PCI cards, blow all the dust out of all the slots,
replace the cards, and try again.

The PCI bus uses refelected waves to get the proper signaling voltage
levels.  Dust in any of ther slots can have an effect on a sensitive
card.  I know the bttv supported cards are sensitive to this; I don't
know about cx88 supported devices.

Regards,
Andy

> Thanks,
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

