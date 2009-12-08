Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46430 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755440AbZLHPEt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 10:04:49 -0500
Message-ID: <4B1E6B14.1040802@gmx.ch>
Date: Tue, 08 Dec 2009 16:04:52 +0100
From: Daniel Ritz <daniel.ritz@gmx.ch>
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: add another YUYV format GUID
References: <1259711324.13720.20.camel@MacRitz2>	 <200912032115.30431.laurent.pinchart@ideasonboard.com> <1259892337.2335.34.camel@MacRitz2> <4B189737.1010100@gmail.com>
In-Reply-To: <4B189737.1010100@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.12.2009 05:59, Justin P. Mattock wrote:
> On 12/03/09 18:05, Daniel Ritz wrote:
>> Hi Laurent
>>
>> On Thu, 2009-12-03 at 21:15 +0100, Laurent Pinchart wrote:
>>> Hi Daniel,
>>>
>>> On Wednesday 02 December 2009 00:48:44 Daniel Ritz wrote:
>>>> For some unknown reason, on a MacBookPro5,3 the iSight
>>> Could you please send me the output of lsusb -v both with the correct and
>>> wrong GUID ?
>> sure. i attached three files:
>>    isight-good.txt, isight-bad.txt, isight-good2.txt
>>
>> this is three reboots in a row from like 10 minutes ago. the first
>> boot into linux was actually rebooting from OSX...first cold boot
>> today directly into linux had the right GUID.
>>
>>>> _sometimes_ report a different video format GUID.
>>> Sometimes only ? Now that's weird. Is that completely random ?
>> yes, sometimes only. it seems to be related to reboots, but i don't
>> know what exactly triggers it. rmmod/modprobe doesn't trigger it.
>> also, when the wrong GUID is reported, the only way of fixing it is
>> to reboot. it really is just the GUID. even when the wrong one is
>> reported, the device works just fine.
>>
>> i started with a plain ubuntu 9.10, kernel 2.6.31 which was supposed
>> to fail, so i upgraded to a 2.6.32-rc8 to fix the iSight and some other
>> things, just to see it fail again. a reboot later and it worked, some
>> time and reboot later it failed again...
>>
>> rgds
>> -daniel
>>
>>>> This patch add the other (wrong) GUID to the format table, making the iSight
>>>> work always w/o other problems.
>>>>
>>>> What it should report: 32595559-0000-0010-8000-00aa00389b71
>>>> What it often reports: 32595559-0000-0010-8000-000000389b71
>>>>
>>>> Signed-off-by: Daniel Ritz<daniel.ritz@gmx.ch>
>>> --
>>> Regards,
>>>
>>> Laurent Pinchart
> 
> I get weiredness whenever
> I shutdown the machine and then boot.
> If I boot, then reboot things work.
> 

interesting...does my little patch work for you as well?

thanks
-daniel

> Justin P. Mattock
> 

