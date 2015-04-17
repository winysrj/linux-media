Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34638 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbDQLrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2015 07:47:53 -0400
Received: by widjs5 with SMTP id js5so32111146wid.1
        for <linux-media@vger.kernel.org>; Fri, 17 Apr 2015 04:47:52 -0700 (PDT)
Message-ID: <5530F2E6.3070301@gmail.com>
Date: Fri, 17 Apr 2015 12:47:50 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@posteo.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for TechniSat Skystar S2
References: <201504122132.t3CLW6fQ018555@jemma-pc.denson.org.uk>	<552B62EF.8050705@gmail.com> <20150417110630.554290f5@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <20150417110630.554290f5@dibcom294.coe.adi.dibcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/04/15 10:06, Patrick Boettcher wrote:
> I have my Skystar S2 pointed to 19.2E.
That would be great if you could test on that, 28.2E can be a bit 
conservative. The parts that I consider need testing are FEC and Pilot 
on DVBS2 - I didn't have that much variety in FEC values, and as far as 
I could tell everything is Pilot=ON on 28.2.

If it's not obvious from the code and comments, the values used for 
tuning are in the modfec_table, and the pattern *seems* to match with 
the modfec_lookup_table - for DVBS2, anyway. With DVBS the values for 
setting and getting are different, and not just a straight +=0x2d 
unfortunately.
I did have a plan to merge these two tables together, and it would need 
a seperate u8 val for setting and getting due to DVBS being odd.

Pilot was admittedly a bit of guesswork - it seems to be able to do the 
same thing as the cx24117 driver, in that ON is |= 0x40 and AUTO is 
|=0x80. To work out the fec values needed I had some code that looped 
through from 0x01 to 0xff and found that, for example, 8PSK 2/3 worked 
on 0x4d, 0x8d and 0xcd and failed to tune on 0x0d which made me realise 
that the top two bits were infact pilot.
It really does need testing with a S2 transponder which needs pilot off 
- to check firstly that the tuning mask is correct, and also that 
get_fec is doing the right thing with retrieving the value. I'm not 100% 
sure that bit 8 signifies pilot in that register, but it seems to fit in 
that that clock ratios needed are different which would be due to the 
data rate being slightly lower when pilot is in use.

> To prepare an integration into 4.2 (or at least 4.3) I suggest using my
> media_tree on linuxtv.org .
>
> http://git.linuxtv.org/cgit.cgi/pb/media_tree.git/ cx24120-v2
>
> I added a checkpatch-patch on top of it. If you can, please base any
> future work of yours on this tree until is has been integrated.
Will do! If I can work out the SNR scale I have got plans to have this 
work in the new way of doing this. Did you ever manage to obtain a 
datasheet for this demod? I have tried contacting NXP but haven't 
received anything back.

> Please also tell me, whether you are OK with the comment I added around
> your commit or not.
Yes, that's OK.

