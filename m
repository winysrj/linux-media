Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40561 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZDCLYm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 07:24:42 -0400
Received: by fxm2 with SMTP id 2so933212fxm.37
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2009 04:24:39 -0700 (PDT)
Message-ID: <49D5F173.60501@gmail.com>
Date: Fri, 03 Apr 2009 14:22:27 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V3] Add camera (CSI) driver for MX1
References: <20090403080923.3222.80609.stgit@localhost.localdomain> <Pine.LNX.4.64.0904031204280.4729@axis700.grange> <49D5E8A5.1080608@gmail.com> <Pine.LNX.4.64.0904031252210.4729@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0904031252210.4729@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Fri, 3 Apr 2009, Darius Augulis wrote:
> 
>> Guennadi Liakhovetski wrote:
>>> Ok, we're almost there:-) Should be the last iteration.
>>>
>>> On Fri, 3 Apr 2009, Darius Augulis wrote:
>>>
>>>   
>>>> From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
>>>>
>>>> Changelog since V2:
>>>> - My signed-off line added
>>>> - Makefile updated
>>>> - .init and .exit removed from pdata
>>>> - includes sorted
>>>> - Video memory limit added
>>>> - Pointers in free_buffer() fixed
>>>> - Indentation fixed
>>>> - Spinlocks added
>>>> - PM implementation removed
>>>> - Added missed clk_put()
>>>> - pdata test added
>>>> - CSI device renamed
>>>> - Platform flags fixed
>>>> - "i.MX" replaced by "MX1" in debug prints
>>>>     
>>> I usually put such changelogs below the "---" line, so it doesn't appear in
>>> the git commit message, and here you just put a short description of the
>>> patch.

I'm using Stgit and I can't put anything below --- with "stg edit", because Stgit automatically removes everything what is below ---.
I don't want to send patches manually, so I will add changelog in the reply message.

>>>
>>>   
>>>> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
>>>> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
>>>> ---
>>>>     
>>> [snip]
>>>
>>>   
