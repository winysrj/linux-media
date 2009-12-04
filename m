Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:47024 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZLDE7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 23:59:25 -0500
Message-ID: <4B189737.1010100@gmail.com>
Date: Thu, 03 Dec 2009 20:59:35 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Daniel Ritz <daniel.ritz@gmx.ch>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: add another YUYV format GUID
References: <1259711324.13720.20.camel@MacRitz2>	 <200912032115.30431.laurent.pinchart@ideasonboard.com> <1259892337.2335.34.camel@MacRitz2>
In-Reply-To: <1259892337.2335.34.camel@MacRitz2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/09 18:05, Daniel Ritz wrote:
> Hi Laurent
>
> On Thu, 2009-12-03 at 21:15 +0100, Laurent Pinchart wrote:
>> Hi Daniel,
>>
>> On Wednesday 02 December 2009 00:48:44 Daniel Ritz wrote:
>>> For some unknown reason, on a MacBookPro5,3 the iSight
>>
>> Could you please send me the output of lsusb -v both with the correct and
>> wrong GUID ?
>
> sure. i attached three files:
>    isight-good.txt, isight-bad.txt, isight-good2.txt
>
> this is three reboots in a row from like 10 minutes ago. the first
> boot into linux was actually rebooting from OSX...first cold boot
> today directly into linux had the right GUID.
>
>>
>>> _sometimes_ report a different video format GUID.
>>
>> Sometimes only ? Now that's weird. Is that completely random ?
>
> yes, sometimes only. it seems to be related to reboots, but i don't
> know what exactly triggers it. rmmod/modprobe doesn't trigger it.
> also, when the wrong GUID is reported, the only way of fixing it is
> to reboot. it really is just the GUID. even when the wrong one is
> reported, the device works just fine.
>
> i started with a plain ubuntu 9.10, kernel 2.6.31 which was supposed
> to fail, so i upgraded to a 2.6.32-rc8 to fix the iSight and some other
> things, just to see it fail again. a reboot later and it worked, some
> time and reboot later it failed again...
>
> rgds
> -daniel
>
>>> This patch add the other (wrong) GUID to the format table, making the iSight
>>> work always w/o other problems.
>>>
>>> What it should report: 32595559-0000-0010-8000-00aa00389b71
>>> What it often reports: 32595559-0000-0010-8000-000000389b71
>>>
>>> Signed-off-by: Daniel Ritz<daniel.ritz@gmx.ch>
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>

I get weiredness whenever
I shutdown the machine and then boot.
If I boot, then reboot things work.

Justin P. Mattock
