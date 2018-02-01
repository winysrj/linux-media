Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54182 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751960AbeBASmi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Feb 2018 13:42:38 -0500
Subject: Re: Regression in VB2 alloc prepare/finish balancing with
 em28xx/au0828
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CAGoCfixnHv-b3CbjqXLkFuK0J+_ejFnGRyxNJoywxuqQKBr_=Q@mail.gmail.com>
 <20180128222319.wx2fl6pzzezezv5v@kekkonen.localdomain>
 <CAGoCfiwFAPeTMpgKdy99UgXiigot0nwkLKZ2w9COft-nZ8tGkg@mail.gmail.com>
 <CAGoCfiy_r7Xp6O9oRO0Vg4d6dx3Ko4OYOdcveYyebjF-E3cW9w@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9a34e434-7df7-b93b-7c2d-3718307b670c@xs4all.nl>
Date: Thu, 1 Feb 2018 19:42:30 +0100
MIME-Version: 1.0
In-Reply-To: <CAGoCfiy_r7Xp6O9oRO0Vg4d6dx3Ko4OYOdcveYyebjF-E3cW9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2018 07:19 PM, Devin Heitmueller wrote:
> Hi Sakari, Hans,
> 
> Do either of you have any thoughts on whether I'm actually leaking any
> resources, or whether this is just a warning that doesn't have any
> practical implication since I'm tearing down the videobuf2 queue?
> 
> I don't really care about the embedded use case - do you see any
> reason where at least for my local tree I cannot simply revert this
> patch until a real solution is found?

Drivers that use videobuf2-vmalloc are not affected by this since that
doesn't implement the prepare/finish mem_ops.

dma-contig and dma-sg are affected and syncing to/from device/cpu will
be unbalanced, which could lead to corrupt frames. Although I think that
given the situation that triggers this it is unlikely to be a real issue.

In any case, em28xx/au0828 are OK.

Regards,

	Hans

> 
> Cheers,
> 
> Devin
> 
> On Mon, Jan 29, 2018 at 8:44 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> Hello Sakari,
>>
>> Thanks for taking the time to investigate.  See comments inline.
>>
>> On Sun, Jan 28, 2018 at 5:23 PM, Sakari Ailus
>> <sakari.ailus@linux.intel.com> wrote:
>>> Hi Devin,
>>>
>>> On Sun, Jan 28, 2018 at 09:12:44AM -0500, Devin Heitmueller wrote:
>>>> Hello all,
>>>>
>>>> I recently updated to the latest kernel, and I am seeing the following
>>>> dumped to dmesg with both au0828 and em28xx based devices whenever I
>>>> exit tvtime (my kernel is compiled with CONFIG_VIDEO_ADV_DEBUG=y by
>>>> default):
>>>
>>> Thanks for reporting this. Would you be able to provide the full dmesg,
>>> with VB2 debug parameter set to 2?
>>
>> Output can be found at https://pastebin.com/nXS7MTJH
>>
>>> I can't immediately see how you'd get this, well, without triggering a
>>> kernel warning or two. The code is pretty complex though.
>>
>> If this is something I screwed up when I did the VB2 port for em28xx
>> several years ago, point me in the right direction and I'll see what I
>> can do.  However given we're seeing it with multiple drivers, this
>> feels like some subtle issue inside videobuf2.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
> 
> 
> 
