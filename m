Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.wa.amnet.net.au ([203.161.124.50]:57139 "EHLO
	smtp1.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0BKMXV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 07:23:21 -0500
Message-ID: <4B73F6AC.5040803@barber-family.id.au>
Date: Thu, 11 Feb 2010 20:23:08 +0800
From: Francis Barber <fedora@barber-family.id.au>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: New Hauppauge HVR-2200 Revision?
References: <4B5B0E12.3090706@barber-family.id.au>	 <83bcf6341001230700h7db6600i89b9092051049612@mail.gmail.com>	 <4B5B837A.6020001@barber-family.id.au>	 <83bcf6341001231529o54f3afb9p29fa955bc93a660e@mail.gmail.com>	 <4B5B8E5B.4020600@barber-family.id.au> <83bcf6341001231618r59f03dc9t1eb746c39e67b5fc@mail.gmail.com> <4B5BF61A.4000605@barber-family.id.au>
In-Reply-To: <4B5BF61A.4000605@barber-family.id.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/01/2010 3:26 PM, Francis Barber wrote:
> Using a03ea24beafc from www.kernellabs.com/hg/saa7164-stable pretty 
> well, thanks very much for working on this quickly!  As an aside, I'm 
> interested as to why I should use the firmware from the older drivers.
>
> The only problem with it now is that when I tune HD channels tzap 
> consistently reports unc, for example:
>
> status 1f | signal fefe | snr 00f6 | ber 0000000f | unc 0000006a | 
> FE_HAS_LOCK
> status 1f | signal fefe | snr 00f6 | ber 0000000e | unc 0000006a | 
> FE_HAS_LOCK
> status 1f | signal fefe | snr 00f6 | ber 00000012 | unc 0000006a | 
> FE_HAS_LOCK
>
> I can't see any problems when watching the channels, however (ie, the 
> picture looks fine).
>
> Thanks again,
> Frank.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello Steven,

I have been using my HVR-2200 for a few weeks now.  Apart from the unc 
anomaly noted above, there has been one other problem.  Twice, the 
following errors appeared in the log:

Feb  6 02:44:28 ent kernel: [1083565.117248] saa7164_api_i2c_read() 
error, ret(2) = 0x13
Feb  6 02:44:28 ent kernel: [1083565.117274] tda18271_read_regs: 
[2-0060|S] ERROR: i2c_transfer returned: -5

When this happened, I couldn't tune anything and I had to reload the dvb 
modules to get it working again.  I wonder if you have any idea what 
could be causing this?

I was also wondering if it might help to use the latest firmware?  I got 
the drivers from here 
http://www.hauppauge.com/site/support/support_hvr2250.html.  Looking at 
your extract script, it is trivial to get the saa7164 firmware but I've 
no idea how you calculated the offsets tda10048 firmware.  Would you 
have any pointers on this?

Anyway, apart from the problems noted above it is fine.  I'm not sure 
what the criteria is for merging support for this card into the main 
repository, but I would view it as worthy of merging even with these 
problems outstanding.

Many thanks,
Frank.
