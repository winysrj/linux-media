Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:54202 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbZDRAbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 20:31:21 -0400
Date: Fri, 17 Apr 2009 19:43:43 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Kyle Guinn <elyk03@gmail.com>
cc: Thomas Kaiser <v4l@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <200904171904.02986.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0904171935290.3331@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200904162333.49502.elyk03@gmail.com> <alpine.LNX.2.00.0904171225120.11123@banach.math.auburn.edu> <200904171904.02986.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 17 Apr 2009, Kyle Guinn wrote:

> On Friday 17 April 2009 12:50:51 Theodore Kilgore wrote:
>> On Thu, 16 Apr 2009, Kyle Guinn wrote:
>>> On Thursday 16 April 2009 13:22:11 Theodore Kilgore wrote:
>>>> On Thu, 16 Apr 2009, Kyle Guinn wrote:

<snip>

>>> ff ff 00 ff 96 64 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 65 50 c1 5c c6 00 00
>>> ff ff 00 ff 96 65 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 66 50 c1 5c c6 00 00
>>> ff ff 00 ff 96 66 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 67 50 c1 5c c6 00 00
>>> ff ff 00 ff 96 67 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 64 50 c1 5c c6 00 00
>>> ff ff 00 ff 96 64 d0 c1 5c c6 00 00
>>> ff ff 00 ff 96 65 50 c1 5c c6 00 00
>>> ...
>>
>> Which camera is this? Is it the Aiptek Pencam VGA+? If so, then I can try
>> it, too, because I also have one of them.
>>
>
> Yes, that's the one.  Try your others if you can and let me know what happens.

OK. I will.

>
>>> Only those 3 bits change, and it looks like a counter to me.  Take a look
>>> at the gspca-mars (MR97113A?) subdriver.  I think it tries to accommodate
>>> the frame sequence number when looking for the SOF.
>>
>> No, I don't see that, sorry. What I see is that it looks for the SOF,
>> which is declared in pac_common.h to be the well-known FF FF 00 FF 96 and
>> no more bytes after that.
>>
>
> I'm talking about this code from gspca/mars.c.  Look in sd_pkt_scan().
>
> if (data[0 + p] == 0xff
> && data[1 + p] == 0xff
> && data[2 + p] == 0x00
> && data[3 + p] == 0xff
> && data[4 + p] == 0x96) {
> 	if (data[5 + p] == 0x64
> 	 || data[5 + p] == 0x65
> 	 || data[5 + p] == 0x66
> 	 || data[5 + p] == 0x67) {

Ah, so: mars.c not mr97310a.c

You lost me, there, for a minute. Yes, this sequence is there.

Thanks,

Theodore Kilgore
