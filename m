Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0081.outbound.protection.outlook.com ([104.47.36.81]:27904
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932855AbeFUK7l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 06:59:41 -0400
Subject: Re: [PATCH 2/5] dma-buf: remove kmap_atomic interface
To: Daniel Vetter <daniel@ffwll.ch>
Cc: "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <20180601120020.11520-2-christian.koenig@amd.com>
 <20180618081845.GV3438@phenom.ffwll.local>
 <2bcb34c3-b729-e3ea-fb8c-2471e4ed56d6@amd.com>
 <CAKMK7uEvhMF92ifA=7xQ=9GR3NofZNExCDTHZTtikmujJTZ89A@mail.gmail.com>
 <c0552d8a-1c64-c99b-6ef8-83e253c49d30@gmail.com>
 <CAKMK7uHHZn=H6px-yiXy7tVmmQy6GHrwGtG+B7or1ThsrriFDA@mail.gmail.com>
 <5d337ffc-6c4c-dafb-abb2-151d9d4aeaea@gmail.com>
 <3994b9d0-85fe-6495-5528-282f7b46a53f@amd.com>
 <CAKMK7uFbvuikxSMgzquzXgcyVVonhWu3HNfrOR2s7RGB7k21ow@mail.gmail.com>
 <CAKMK7uG7dtj136GAg6E9rVHm4dAg0a-A6EA=911fBi8YpVDbcA@mail.gmail.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <8e43453b-1102-41ac-a416-5673718ef84e@amd.com>
Date: Thu, 21 Jun 2018 12:59:28 +0200
MIME-Version: 1.0
In-Reply-To: <CAKMK7uG7dtj136GAg6E9rVHm4dAg0a-A6EA=911fBi8YpVDbcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.06.2018 um 08:30 schrieb Daniel Vetter:
> On Thu, Jun 21, 2018 at 8:26 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Wed, Jun 20, 2018 at 4:21 PM, Christian König
>> <christian.koenig@amd.com> wrote:
>>> Am 20.06.2018 um 16:04 schrieb Christian König:
>>>> Am 20.06.2018 um 14:52 schrieb Daniel Vetter:
>>>>> On Wed, Jun 20, 2018 at 2:46 PM, Christian König
>>>>> <ckoenig.leichtzumerken@gmail.com> wrote:
>>>>>> [SNIP]
>>>>>>> Go ahead, that's the point of commit rights. dim might complain if you
>>>>>>> cherry picked them and didn't pick them up using dim apply though ...
>>>>>>
>>>>>> I've fixed up the Link tags, but when I try "dim push-branch
>>>>>> drm-misc-next"
>>>>>> I only get the error message "error: dst ref refs/heads/drm-misc-next
>>>>>> receives from more than one src."
>>>>>>
>>>>>> Any idea what is going wrong here?
>>>>> Sounds like multiple upstreams for your local drm-misc-next branch,
>>>>> and git then can't decide which one to pick. If you delete the branch
>>>>> and create it using dim checkout drm-misc-next this shouldn't happen.
>>>>> We're trying to fit into existing check-outs and branches, but if you
>>>>> set things up slightly different than dim would have you're off script
>>>>> and there's limited support for that.
>>>>>
>>>>> Alternative check out your .git/config and remove the other upstreams.
>>>>> Or attach your git config if this isn't the issue (I'm just doing some
>>>>> guessing here).
>>>>
>>>> I've tried to delete my drm-misc-next branch and recreate it, but that
>>>> doesn't seem to help.
>>>>
>>>> Attached is my .git/config, but at least on first glance it looks ok as
>>>> well.
>>>>
>>>> Any ideas?
>>>
>>> Ok that seems to be a bug in dim.
>>>
>>> "bash -x dim push drm-misc-next" looks like it tries to push the branch
>>> drm-misc-next twice to the drm-misc remote: git push drm-misc drm-misc-next
>>> drm-misc-next
>>>
>>> When I try that manually I get the same result, but "git push drm-misc
>>> drm-misc-next" just seemed to work fine.
>>>
>>> Let's hope that I haven't messed things up totally on the server now.
>> Tree looks all intact, except for some build fail. For drm-misc please
>> use the 3 defconfings (for x86, arm and arm64) to check that not too
>> much broke, they should enable all the gfx relevant stuff. Not full
>> combinatorials, but at least the most obvious of things.
>>
>> Wrt the issue, it's indeed a bug in dim. The shorthand for pushing the
>> current branch works:
>>
>> $ dim push
>>
>> But the explicit form somehow gained a bug.
>>
>> $ dim push drm-misc-next
>>
>> I'll look into why this is.
> Should have waited for coffee to kick in. This is a feature :-)
>
> $ dim push [git push arguments]
>
> is the short-hand. If you want to specify the branch explicitly, you need to use
>
> $ dim push-branch drm-misc-next [git push arguments]
>
> Usually the only thing is adding an -f for a non-fast-forward push
> (when maintainers have rebased the -fixes tree, shouldn't be done
> anywhere else). Docs seem accurate, so not sure where you copypasted
> this from? And not sure we should catch this in the script, since it's
> kinda ambiguous.

Ah! Ok that actually makes some sense. Might be a good idea to mention 
the difference between "dim push" and "dim push-branch" in the quick 
start guide somewhere.

Thanks for the explanation,
Christian.

> -Daniel
>
>
>> -Daniel
>>
>>> Christian.
>>>
>>>> Thanks,
>>>> Christian.
>>>>
>>>>> -Daniel
>>>>>
>>>>>
>>
>>
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
>
