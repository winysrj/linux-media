Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:43658 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687AbbBEOaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2015 09:30:06 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so7963425wev.12
        for <linux-media@vger.kernel.org>; Thu, 05 Feb 2015 06:30:04 -0800 (PST)
Message-ID: <54D37E67.6030103@movia.biz>
Date: Thu, 05 Feb 2015 15:29:59 +0100
From: Francesco Marletta <francesco.marletta@movia.biz>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Francesco Marletta <fmarletta@movia.biz>
CC: =?windows-1252?Q?Carlos_Sanmart=EDn_Bustos?= <carsanbu@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Help required for TVP5151 on Overo
References: <20141119094656.5459258b@crow> <CAPW4HR0RS3oPRLKRiD-h0e-xbK95ODFur1_VtD2aTFwZ6NEjBQ@mail.gmail.com> <20141119103306.07e52744@crow> <5213550.zrY0P2Gc9u@avalon>
In-Reply-To: <5213550.zrY0P2Gc9u@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
I'm trying to use the kernel of the linuxtv repository, omap3isp/tvp5151 
branch,but the kernel don't starts... can you, please, send me the 
kernel command line that you have used?

Also, have you used device tree ?

Regards
Francesco


Il 02/12/2014 00:41, Laurent Pinchart ha scritto:
> Hi Francesco,
>
> On Wednesday 19 November 2014 10:33:06 Francesco Marletta wrote:
>> Hi Carlos,
>> thanks for your response.
>>
>> I've read your message on permalink.
>>
>> I'm not sure the ISP is broken, or at least it may be broken but it can
>> be fixed.
>>
>> I'm trying to work the tvp5151 board described in [1], the author
>> states (and told me) that it was successfull in using that board, using
>> a patch that he also publish, but my board is not working (using the
>> same patch set). Maybe there is something different in my kernel, even
>> if the version is the same?
> For what it's worth, I've successfully used that tvp5151 board with a Gumstix
> Overo using the mainline kernel. Changes required to the OAMP3 ISP driver have
> been pushed to mainline. Some changes were required to the tvp5151 driver too,
> some have made it upstream, but I haven't had time to clean up and submit the
> rest of the tvp5151 modifications.
>
> I've pushed the patches to
>
> 	git://linuxtv.org/pinchartl/media.git omap3isp/tvp5151
>
>> I'm going to try applying the patch by hand, to check if there is
>> something different respect the source that the patch is made from.
>>
>> It will be useful to me to have a kernel (with modules) that works with
>> that board, this way I could check if the problem is in the hw or in
>> the sw.
>>
>> I'll continue to try.
>>
>> [1] http://www.sleepyrobot.com/?p=253

