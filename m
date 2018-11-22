Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:52397 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726958AbeKWIY2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 03:24:28 -0500
Subject: Re: Logitech QuickCam USB detected by Linux, but not user space
 applications
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b9140bbf-1537-1431-1250-da0a21208992@molgen.mpg.de>
 <20181115033813.6ff626d5@silica.lan>
 <53bce637-985e-2c74-1d6b-151ba81550db@molgen.mpg.de>
 <dd498a43-75cd-eec1-415f-f9d4569a302e@xs4all.nl>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <90a7e0e2-ddbb-7762-3eb6-51db0570ffff@molgen.mpg.de>
Date: Thu, 22 Nov 2018 22:43:11 +0100
MIME-Version: 1.0
In-Reply-To: <dd498a43-75cd-eec1-415f-f9d4569a302e@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Hans,


Am 22.11.18 um 13:43 schrieb Hans Verkuil:

> On 11/16/2018 03:39 PM, Paul Menzel wrote:

>> On 11/15/18 12:38, Mauro Carvalho Chehab wrote:
>>> Em Thu, 15 Nov 2018 11:42:32 +0100 Paul Menzel escreveu:
>>
>>>> I tried to get a Logitech QuickCam USB camera working, but unfortunately, it is
>>>> not detected by user space (Cheese, MPlayer).
>>>
>>> Could you please try it with Camorama?
>>>
>>> 	https://github.com/alessio/camorama
>>
>> Thank you for the suggestion. At first, I only saw a black image, but changing the
>> resolution made it work. See the status below.
>>
>> 1.  does *not* work
>>
>>      a)  160x120
>>      b)  176x144
>>
>> 2.  works
>>
>>      a)  320x240
>>      b)  352x288
> 
> Try this patch:
> 
> https://patchwork.linuxtv.org/patch/53043/
> 
> It probably fixes the same problem you are experiencing.

It indeed does. I cherry picked it to Linus’ master branch, and it fixed 
the problem.

Tested-by: Paul Menzel <pmenzel@molgen.mpg.de> (Logitech QuickCam 046d:092e)

[…]


Kind regards,

Paul
