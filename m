Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:5759 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZDEPVU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 11:21:20 -0400
Received: by fg-out-1718.google.com with SMTP id e12so688477fga.17
        for <linux-media@vger.kernel.org>; Sun, 05 Apr 2009 08:21:17 -0700 (PDT)
Message-ID: <49D8CC1B.5070104@gmail.com>
Date: Sun, 05 Apr 2009 08:19:55 -0700
From: Alan Nisota <alannisota@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Patrick Boettcher <patrick.boettcher@desy.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Remove support for Genpix-CW3K (damages hardware)
References: <49D2338C.7040703@gmail.com>	<alpine.LRH.1.10.0904010934590.21921@pub4.ifh.de>	<49D3C815.6000004@gmail.com> <20090405115539.61d7b600@pedra.chehab.org>
In-Reply-To: <20090405115539.61d7b600@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> We shouldn't drop support for a device just because the manufacturer doesn't
> want it to be supported. If it really damages the hardware or violates the
> warranty, then we can print a warning message clearly stating that the vendor
> refuses to collaborate, briefly explaining the issues and recommending the user
> to replace the device to some other from a vendor-friendly at dmesg, but keep
> allowing they to use it, with some force option for people that wants to take
> the risk.
>   
I'm not going to go through the entire soap-opera as I know it, but 
basically the manufacturer has 2 tiers of devices, those that were 
designed to work only with a specific piece of hardware, and those that 
are supported in Windows and Linux, but come with a significant price 
premium.  The latter devices are supported by the kernel and should be 
continued to be.  The former is what we're talking about and what my 
patch removes support for.  The patch was in response to real users with 
real problems.

I am in no way associated with the manufacturer other than that he 
provided me with initial help writing the Linux drivers several years 
ago.  I no longer have a use for the drivers myself, and any support I 
do is just to help the community out.  I have provided a patch which 
makes the driver safe to use.  If you prefer an alternate method of 
achieving the same goal, or wish to just ignore it altogether, that is 
ok, but I don't have the time to develop and test a patch that is more 
complicated then what I've already posted.  If you are going to take any 
action, I would prefer it get pushed into the current kernel development 
tree to minimize the potential harm to users.


