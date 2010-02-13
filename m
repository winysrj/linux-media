Return-path: <linux-media-owner@vger.kernel.org>
Received: from cooker.cnx.rice.edu ([168.7.5.70]:40720 "EHLO
	cooker.cnx.rice.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0BMVdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 16:33:50 -0500
Date: Sat, 13 Feb 2010 14:52:29 -0600
From: "Ross J. Reedstrom" <reedstrm@rice.edu>
To: Francis Barber <fedora@barber-family.id.au>
Cc: Steven Toth <steven.toth@mac.com>, linux-media@vger.kernel.org
Subject: Re: New Hauppauge HVR-2200 Revision?
Message-ID: <20100213205228.GA31345@rice.edu>
References: <83bcf6341001230700h7db6600i89b9092051049612@mail.gmail.com> <4B5B837A.6020001@barber-family.id.au> <83bcf6341001231529o54f3afb9p29fa955bc93a660e@mail.gmail.com> <4B5B8E5B.4020600@barber-family.id.au> <83bcf6341001231618r59f03dc9t1eb746c39e67b5fc@mail.gmail.com> <4B5BF61A.4000605@barber-family.id.au> <4B73F6AC.5040803@barber-family.id.au> <4B7412CC.6010003@barber-family.id.au> <4B99D44B-A91C-4145-9317-EFA5AF9BD553@mac.com> <4B76B895.9090305@barber-family.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B76B895.9090305@barber-family.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 13, 2010 at 10:35:01PM +0800, Francis Barber wrote:
> On 12/02/2010 9:44 PM, Steven Toth wrote:
> >>>Anyway, apart from the problems noted above it is fine.  I'm not sure 
> >>>what the criteria is for merging support for this card into the main 
> >>>repository, but I would view it as worthy of merging even with these 
> >>>problems outstanding.
> >>>
> >>>Many thanks,
> >>>Frank.
> >>>
> >>>       
> >>Interestingly, so far it only seems to affect the second adapter.  The 
> >>first one is still working.
> >>
> >>     
> >
> >Odd.
> >
> >Francis,
> >
> >I find the whole ber/unc values puzzling, essentially they shouldn't 
> >happen assuming a good clean DVB-T signal. I'm going to look into this 
> >very shortly, along with a broad locking feature I want to change in the 
> >demod.
> >
> >I've had one or two other people comment on the -stable tree and in 
> >general they're pretty happy, including myself, which means that I'll be 
> >generating a pull request to have these changes merged very shortly (1-2 
> >weeks).
> >
> >Regards,
> >
> >- Steve
> >
> >--
> >Steven Toth - Kernel Labs
> >http://www.kernellabs.com
> >
> >
> >   
> Hi Steve,
> 
> The unc is clearly wrong because when I watch the picture is fine.
> 
> Today I had the i2c error using the other adapter, and nothing seemed to 
> be working until I reloaded the modules.
> 
> Feb 13 19:39:10 ent kernel: [1748208.155364] saa7164_api_i2c_read() 
> error, ret(2) = 0x13
> Feb 13 19:39:10 ent kernel: [1748208.155389] tda18271_read_regs: 
> [1-0060|M] ERROR: i2c_transfer returned: -5
> 
> I think the reason I was only seeing it on the slave was because I was 
> mainly using that adapter1.
> 
> Thanks again for your efforts,
> Francis.
> --

Hi Francis, Steve -
I was one of the other early commenters on stable. I have an HVR-2250,
which reports itself as so:

[   44.108079] CORE saa7164[0]: subsystem: 0070:8891, board: Hauppauge
WinTV-HVR2250 [card=7,autodetected]
[   44.108086] saa7164[0]/0: found at 0000:02:00.0, rev: 129, irq: 17,
latency: 0, mmio: 0xf9c00000

I updated from http://kernellabs.com/hg/saa7164-stable/ on 2010-02-09
and rebuilt for kernel 2.6.24.

I too am mostly happy, but see the exact same behavior as Francis -
after running fine (but lightly used) for several days, I'll start to
get that same error:

Feb 11 13:35:06 MediaPC kernel: [215813.216541] saa7164_api_i2c_read()
error, ret(2) = 0x13
Feb 11 13:35:06 MediaPC kernel: [215813.216549] tda18271_read_regs:
[2-0060|S] ERROR: i2c_transfer returned: -5

Though the tuner does not yet lock up at that point. Eventually I will
get a stream of other errors, and both tuners lock up. I'm suspicious
that it might have something to do with using both tuners at once, but
have no direct evidence. Anyone have a better method than switching
inputs in mythtv for loading the tuners? If we could make this
reproducable, I'm sure it'll be much easier to track down.

Ross
-- 
Ross Reedstrom, Ph.D.                                 reedstrm@rice.edu
Systems Engineer & Admin, Research Scientist        phone: 713-348-6166
The Connexions Project      http://cnx.org            fax: 713-348-3665
Rice University MS-375, Houston, TX 77005
GPG Key fingerprint = F023 82C8 9B0E 2CC6 0D8E  F888 D3AE 810E 88F0 BEDE
