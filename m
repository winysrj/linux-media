Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:46643 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbeBASTU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Feb 2018 13:19:20 -0500
Received: by mail-qt0-f170.google.com with SMTP id o35so27601165qtj.13
        for <linux-media@vger.kernel.org>; Thu, 01 Feb 2018 10:19:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwFAPeTMpgKdy99UgXiigot0nwkLKZ2w9COft-nZ8tGkg@mail.gmail.com>
References: <CAGoCfixnHv-b3CbjqXLkFuK0J+_ejFnGRyxNJoywxuqQKBr_=Q@mail.gmail.com>
 <20180128222319.wx2fl6pzzezezv5v@kekkonen.localdomain> <CAGoCfiwFAPeTMpgKdy99UgXiigot0nwkLKZ2w9COft-nZ8tGkg@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Thu, 1 Feb 2018 13:19:18 -0500
Message-ID: <CAGoCfiy_r7Xp6O9oRO0Vg4d6dx3Ko4OYOdcveYyebjF-E3cW9w@mail.gmail.com>
Subject: Re: Regression in VB2 alloc prepare/finish balancing with em28xx/au0828
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari, Hans,

Do either of you have any thoughts on whether I'm actually leaking any
resources, or whether this is just a warning that doesn't have any
practical implication since I'm tearing down the videobuf2 queue?

I don't really care about the embedded use case - do you see any
reason where at least for my local tree I cannot simply revert this
patch until a real solution is found?

Cheers,

Devin

On Mon, Jan 29, 2018 at 8:44 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> Hello Sakari,
>
> Thanks for taking the time to investigate.  See comments inline.
>
> On Sun, Jan 28, 2018 at 5:23 PM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
>> Hi Devin,
>>
>> On Sun, Jan 28, 2018 at 09:12:44AM -0500, Devin Heitmueller wrote:
>>> Hello all,
>>>
>>> I recently updated to the latest kernel, and I am seeing the following
>>> dumped to dmesg with both au0828 and em28xx based devices whenever I
>>> exit tvtime (my kernel is compiled with CONFIG_VIDEO_ADV_DEBUG=y by
>>> default):
>>
>> Thanks for reporting this. Would you be able to provide the full dmesg,
>> with VB2 debug parameter set to 2?
>
> Output can be found at https://pastebin.com/nXS7MTJH
>
>> I can't immediately see how you'd get this, well, without triggering a
>> kernel warning or two. The code is pretty complex though.
>
> If this is something I screwed up when I did the VB2 port for em28xx
> several years ago, point me in the right direction and I'll see what I
> can do.  However given we're seeing it with multiple drivers, this
> feels like some subtle issue inside videobuf2.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
