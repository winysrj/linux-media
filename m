Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f185.google.com ([209.85.192.185]:64754 "EHLO
	mail-pd0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaHLIvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 04:51:07 -0400
Received: by mail-pd0-f185.google.com with SMTP id g10so2001533pdj.12
        for <linux-media@vger.kernel.org>; Tue, 12 Aug 2014 01:51:06 -0700 (PDT)
Date: Tue, 12 Aug 2014 01:51:05 -0700 (PDT)
From: anuroop.kamu@gmail.com
To: linux-sunxi@googlegroups.com
Cc: anuroop.kamu@gmail.com, linux-media@vger.kernel.org,
	thomas.schorpp@gmail.com
Message-Id: <b4010238-2ee0-4559-9aed-d5d55687cd28@googlegroups.com>
In-Reply-To: <53E9C88B.7050400@gmail.com>
References: <520BC1EF.9030204@gmail.com> <ed81b21e-44e4-40db-bfaa-6fbad2b5d7cb@googlegroups.com>
 <53E9C88B.7050400@gmail.com>
Subject: Re: [PATCH v4 2/2] [stage/sunxi-3.4] Add support for Allwinner
 (DVB/ATSC) Transport Stream Controller(s) (TSC)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_4506_2102012201.1407833465254"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_Part_4506_2102012201.1407833465254
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Tuesday, August 12, 2014 1:26:01 PM UTC+5:30, Thomas Schorpp wrote:
> Am 12.08.2014 um 08:25 schrieb anuroop.kamu@gmail.com:
> 
> > On Wednesday, August 14, 2013 11:14:15 PM UTC+5:30, Thomas Schorpp wrote:
> 
> >> OK, with the patched fex file and devices.c from
> 
> >>
> 
> >> [linux-sunxi] [PATCH v2 1/1] [sunxi-boards/a20] Add support for Allwinner (DVB/ATSC) Transport Stream Controller(s) (TSC)
> 
> >>
> 
> >> [PATCH v2 1/1] [stage/sunxi-3.4] sw_nand: sunxi devices core using wrong MMIO region range, overlaps TSC/TSI register base address 0x01c04000
> 
> >>
> 
> >> and the driver patches from this topic here
> 
> >>
> 
> >>
> 
> >
> 
> >>
> 
> >> the driver basically loads and inits:
> 
> 
> 
> >
> 
> > please forgive me if my questions are wrong. I am fairly new to android & Allwinner platform.
> 
> 
> 
> 1. The tscdrv.c code (my linux-sunxi port, too) is (c) AW proprietary, You need to contact AW support (+ for a complete TSC Manual).
> 
> 
> 
> 2. I've suspended my TSC project until a complete A20 TSC manual is available or I get the time for register probe rev. engineering.
> 
> 
> 
> 3. https://groups.google.com/forum/#!topic/android-porting/EMAG4RUlOjI
> 
> 
> 
> "Now we are planning to integrate a TV chip with this (DVB-T) . Allwinner has TS control block and a sample driver along with it."
> 
> 
> 
> Who is "we"?
> 
> 
> 
> I don't support Android OS platform, nor do "we" support closed source product developers from hidden proprietary products manufacturers
> 
> usually not releasing derivated works of GPL'd code back to "us" or the android-porting project with their products,
> 
> especially not for free. Please refer to the known consultant companies if Your company needs "help".
> 
> 
> 
> Please, tell Your Boss there's a big difference between "help" and valuable expensive engineering project consulting, thank You.
> 
> Code maybe free under GPL (only the without warranty version) but consulting for it is not, and violating the GPL is breaking the law, worldwide.
> 
> 
> 
> This is the second request directly adressed to me off-list from a commercial company to work for free for them,
> 
> I will drop any further to the JUNK Mail folder without notice.
> 
> 
> 
> >
> 
> > thanks a lot
> 
> > Anuroop
> 
> >
> 
> 
> 
> thanks A LOT :-//
> 
> y
> 
> tom

I am sorry Tom. I was trying to build the AW TSC for SMDT. 
hope you forgive me for my mistakes.

-thanks
Anuroop
------=_Part_4506_2102012201.1407833465254--
