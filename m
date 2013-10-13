Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:39283 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3JMMzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 08:55:54 -0400
Received: by mail-ea0-f181.google.com with SMTP id d10so2851779eaj.12
        for <linux-media@vger.kernel.org>; Sun, 13 Oct 2013 05:55:53 -0700 (PDT)
Message-ID: <525A9855.7050701@gmail.com>
Date: Sun, 13 Oct 2013 14:55:49 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media/i2c: ths8200: fix build failure with gcc 4.5.4
References: <20131013101333.GA25034@n2100.arm.linux.org.uk> <525A7797.6000605@gmail.com> <20131013111613.GC25034@n2100.arm.linux.org.uk>
In-Reply-To: <20131013111613.GC25034@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 13/10/2013 13:16, Russell King - ARM Linux ha scritto:
> On Sun, Oct 13, 2013 at 12:36:07PM +0200, Gianluca Gennari wrote:
>> Il 13/10/2013 12:13, Russell King - ARM Linux ha scritto:
>>> v3.12-rc fails to build with this error:
>>>
>>> drivers/media/i2c/ths8200.c:49:2: error: unknown field 'bt' specified in initializer
>>> drivers/media/i2c/ths8200.c:50:3: error: field name not in record or union initializer
>>> drivers/media/i2c/ths8200.c:50:3: error: (near initialization for 'ths8200_timings_cap.reserved')
>>> drivers/media/i2c/ths8200.c:51:3: error: field name not in record or union initializer
>>> drivers/media/i2c/ths8200.c:51:3: error: (near initialization for 'ths8200_timings_cap.reserved')
>>> ...
>>>
>>> with gcc 4.5.4.  This error was not detected in builds prior to v3.12-rc.
>>> This patch fixes this.
>>
>> Hi Russel,
>> this error is already fixed by this patch:
>>
>> https://patchwork.linuxtv.org/patch/20002/
>>
>> that has been already accepted and is queued for kernel 3.12.
> 
> It would be a good idea to have the comment updated - given that gcc 4.5.4
> also has a problem, it's not only a problem for gcc < 4.4.6 as that patch
> claims.
> 

Yep, the fact is that there are 2 different compatibility problems:
- gcc < 4.4.6 requires additional curly brackets to initialize anonymous
structs (see v4l2-dv-timings.h);
- some gcc version requires that structure members are initialized in
the same order they are defined, even if you specify the member name;

The second issue is the one you are facing, but I don't know how to
track it down to a specific gcc version. If you can get the exact
version number and provide a patch, you're welcome!

Regards,
Gianluca
