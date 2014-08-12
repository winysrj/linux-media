Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:33704 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaHLHz7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 03:55:59 -0400
Received: by mail-qg0-f52.google.com with SMTP id f51so9107763qge.39
        for <linux-media@vger.kernel.org>; Tue, 12 Aug 2014 00:55:59 -0700 (PDT)
Message-ID: <53E9C88B.7050400@gmail.com>
Date: Tue, 12 Aug 2014 09:55:55 +0200
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: anuroop.kamu@gmail.com, linux-sunxi@googlegroups.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 2/2] [stage/sunxi-3.4] Add support for Allwinner (DVB/ATSC)
 Transport Stream Controller(s) (TSC)
References: <520BC1EF.9030204@gmail.com> <ed81b21e-44e4-40db-bfaa-6fbad2b5d7cb@googlegroups.com>
In-Reply-To: <ed81b21e-44e4-40db-bfaa-6fbad2b5d7cb@googlegroups.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 12.08.2014 um 08:25 schrieb anuroop.kamu@gmail.com:
> On Wednesday, August 14, 2013 11:14:15 PM UTC+5:30, Thomas Schorpp wrote:
>> OK, with the patched fex file and devices.c from
>>
>> [linux-sunxi] [PATCH v2 1/1] [sunxi-boards/a20] Add support for Allwinner (DVB/ATSC) Transport Stream Controller(s) (TSC)
>>
>> [PATCH v2 1/1] [stage/sunxi-3.4] sw_nand: sunxi devices core using wrong MMIO region range, overlaps TSC/TSI register base address 0x01c04000
>>
>> and the driver patches from this topic here
>>
>>
>
>>
>> the driver basically loads and inits:

>
> please forgive me if my questions are wrong. I am fairly new to android & Allwinner platform.

1. The tscdrv.c code (my linux-sunxi port, too) is (c) AW proprietary, You need to contact AW support (+ for a complete TSC Manual).

2. I've suspended my TSC project until a complete A20 TSC manual is available or I get the time for register probe rev. engineering.

3. https://groups.google.com/forum/#!topic/android-porting/EMAG4RUlOjI

"Now we are planning to integrate a TV chip with this (DVB-T) . Allwinner has TS control block and a sample driver along with it."

Who is "we"?

I don't support Android OS platform, nor do "we" support closed source product developers from hidden proprietary products manufacturers
usually not releasing derivated works of GPL'd code back to "us" or the android-porting project with their products,
especially not for free. Please refer to the known consultant companies if Your company needs "help".

Please, tell Your Boss there's a big difference between "help" and valuable expensive engineering project consulting, thank You.
Code maybe free under GPL (only the without warranty version) but consulting for it is not, and violating the GPL is breaking the law, worldwide.

This is the second request directly adressed to me off-list from a commercial company to work for free for them,
I will drop any further to the JUNK Mail folder without notice.

>
> thanks a lot
> Anuroop
>

thanks A LOT :-//
y
tom

