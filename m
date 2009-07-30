Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:33654 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZG3Q0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 12:26:13 -0400
Received: by ewy10 with SMTP id 10so882247ewy.37
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2009 09:26:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A719F60.7020205@kernellabs.com>
References: <e3538fbd0907292246k2c75a950u38c2c91d5190f4f7@mail.gmail.com>
	 <4A719F60.7020205@kernellabs.com>
Date: Thu, 30 Jul 2009 12:26:12 -0400
Message-ID: <37219a840907300926x49b6a84bx7591c4a4036d7641@mail.gmail.com>
Subject: Re: [PATCH] cx23885-417: fix setting tvnorms
From: Michael Krufky <mkrufky@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Joseph Yasi <joe.yasi@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 30, 2009 at 9:25 AM, Steven Toth<stoth@kernellabs.com> wrote:
> On 7/30/09 1:46 AM, Joseph Yasi wrote:
>>
>> Currently, the VIDIOC_S_STD ioctl just returns -EINVAL regardless of
>> the norm passed.  This patch sets cx23885_mpeg_template.tvnorms and
>> cx23885_mpeg_template.current_norm so that the VIDIOC_S_STD will work.
>>
>> Signed-off-by: Joseph A. Yasi<joe.yasi@gmail.com>
>
> Joseph, thank you for raising this.
>
> We have this change and a few others already stacked up in this tree:
>
> http://www.kernellabs.com/hg/~mkrufky/cx23885-api/rev/0391fb200be2
>
> The end result is to get MythTV using the HVR1800 analog encoder correctly.
>
> The tree itself is considered experimental but during testing we had noticed
> the same issue, so, again, thank you for raising the same issue. Two people
> reporting the same issue is always better than none.
>
> - Steve

I will break out this patch from the huge patch-mess in my cx23885-api
tree so that it can be merged separately from the other less-obvious
fixes.

Thanks again for pointing it out -- I'll see this fix gets merged
sooner than later ;-)

Cheers,

Mike
