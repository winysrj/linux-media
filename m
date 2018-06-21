Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:53235 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbeFUG0e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 02:26:34 -0400
Received: by mail-it0-f66.google.com with SMTP id m194-v6so3111946itg.2
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2018 23:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3994b9d0-85fe-6495-5528-282f7b46a53f@amd.com>
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <20180601120020.11520-2-christian.koenig@amd.com> <20180618081845.GV3438@phenom.ffwll.local>
 <2bcb34c3-b729-e3ea-fb8c-2471e4ed56d6@amd.com> <CAKMK7uEvhMF92ifA=7xQ=9GR3NofZNExCDTHZTtikmujJTZ89A@mail.gmail.com>
 <c0552d8a-1c64-c99b-6ef8-83e253c49d30@gmail.com> <CAKMK7uHHZn=H6px-yiXy7tVmmQy6GHrwGtG+B7or1ThsrriFDA@mail.gmail.com>
 <5d337ffc-6c4c-dafb-abb2-151d9d4aeaea@gmail.com> <3994b9d0-85fe-6495-5528-282f7b46a53f@amd.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Thu, 21 Jun 2018 08:26:32 +0200
Message-ID: <CAKMK7uFbvuikxSMgzquzXgcyVVonhWu3HNfrOR2s7RGB7k21ow@mail.gmail.com>
Subject: Re: [PATCH 2/5] dma-buf: remove kmap_atomic interface
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 20, 2018 at 4:21 PM, Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
> Am 20.06.2018 um 16:04 schrieb Christian K=C3=B6nig:
>>
>> Am 20.06.2018 um 14:52 schrieb Daniel Vetter:
>>>
>>> On Wed, Jun 20, 2018 at 2:46 PM, Christian K=C3=B6nig
>>> <ckoenig.leichtzumerken@gmail.com> wrote:
>>>>
>>>> [SNIP]
>>>>>
>>>>> Go ahead, that's the point of commit rights. dim might complain if yo=
u
>>>>> cherry picked them and didn't pick them up using dim apply though ...
>>>>
>>>>
>>>> I've fixed up the Link tags, but when I try "dim push-branch
>>>> drm-misc-next"
>>>> I only get the error message "error: dst ref refs/heads/drm-misc-next
>>>> receives from more than one src."
>>>>
>>>> Any idea what is going wrong here?
>>>
>>> Sounds like multiple upstreams for your local drm-misc-next branch,
>>> and git then can't decide which one to pick. If you delete the branch
>>> and create it using dim checkout drm-misc-next this shouldn't happen.
>>> We're trying to fit into existing check-outs and branches, but if you
>>> set things up slightly different than dim would have you're off script
>>> and there's limited support for that.
>>>
>>> Alternative check out your .git/config and remove the other upstreams.
>>> Or attach your git config if this isn't the issue (I'm just doing some
>>> guessing here).
>>
>>
>> I've tried to delete my drm-misc-next branch and recreate it, but that
>> doesn't seem to help.
>>
>> Attached is my .git/config, but at least on first glance it looks ok as
>> well.
>>
>> Any ideas?
>
>
> Ok that seems to be a bug in dim.
>
> "bash -x dim push drm-misc-next" looks like it tries to push the branch
> drm-misc-next twice to the drm-misc remote: git push drm-misc drm-misc-ne=
xt
> drm-misc-next
>
> When I try that manually I get the same result, but "git push drm-misc
> drm-misc-next" just seemed to work fine.
>
> Let's hope that I haven't messed things up totally on the server now.

Tree looks all intact, except for some build fail. For drm-misc please
use the 3 defconfings (for x86, arm and arm64) to check that not too
much broke, they should enable all the gfx relevant stuff. Not full
combinatorials, but at least the most obvious of things.

Wrt the issue, it's indeed a bug in dim. The shorthand for pushing the
current branch works:

$ dim push

But the explicit form somehow gained a bug.

$ dim push drm-misc-next

I'll look into why this is.
-Daniel

>
> Christian.
>
>>
>> Thanks,
>> Christian.
>>
>>> -Daniel
>>>
>>>
>>
>



--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
