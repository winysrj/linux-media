Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34508 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754370AbdCFTU1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 14:20:27 -0500
Received: by mail-qk0-f180.google.com with SMTP id p64so51926319qke.1
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 11:20:26 -0800 (PST)
Subject: Re: [RFC PATCH 06/12] staging: android: ion: Remove crufty cache
 support
To: Emil Velikov <emil.l.velikov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        devel@driverdev.osuosl.org, romlem@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Riley Andrews <riandrews@android.com>,
        Mark Brown <broonie@kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <1488491084-17252-7-git-send-email-labbott@redhat.com>
 <20170303095654.zbcqkcojo3vf6y4y@phenom.ffwll.local>
 <2273106.Hjr80nPvcZ@avalon> <87fe5d0a-19d2-b6c7-391f-687aa5ff8571@redhat.com>
 <20170306102959.5iixtstrl7ktwxdp@phenom.ffwll.local>
 <CACvgo52Q-HvChU7_q65GFqOaVY7Z7EaDoRfELup0D_N_ge9poQ@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <aa4a0307-62d0-7aed-80bc-bc569d49ffcd@redhat.com>
Date: Mon, 6 Mar 2017 11:20:20 -0800
MIME-Version: 1.0
In-Reply-To: <CACvgo52Q-HvChU7_q65GFqOaVY7Z7EaDoRfELup0D_N_ge9poQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2017 09:00 AM, Emil Velikov wrote:
> On 6 March 2017 at 10:29, Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Fri, Mar 03, 2017 at 10:46:03AM -0800, Laura Abbott wrote:
>>> On 03/03/2017 08:39 AM, Laurent Pinchart wrote:
>>>> Hi Daniel,
>>>>
>>>> On Friday 03 Mar 2017 10:56:54 Daniel Vetter wrote:
>>>>> On Thu, Mar 02, 2017 at 01:44:38PM -0800, Laura Abbott wrote:
>>>>>> Now that we call dma_map in the dma_buf API callbacks there is no need
>>>>>> to use the existing cache APIs. Remove the sync ioctl and the existing
>>>>>> bad dma_sync calls. Explicit caching can be handled with the dma_buf
>>>>>> sync API.
>>>>>>
>>>>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>>>>> ---
>>>>>>
>>>>>>  drivers/staging/android/ion/ion-ioctl.c         |  5 ----
>>>>>>  drivers/staging/android/ion/ion.c               | 40 --------------------
>>>>>>  drivers/staging/android/ion/ion_carveout_heap.c |  6 ----
>>>>>>  drivers/staging/android/ion/ion_chunk_heap.c    |  6 ----
>>>>>>  drivers/staging/android/ion/ion_page_pool.c     |  3 --
>>>>>>  drivers/staging/android/ion/ion_system_heap.c   |  5 ----
>>>>>>  6 files changed, 65 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/staging/android/ion/ion-ioctl.c
>>>>>> b/drivers/staging/android/ion/ion-ioctl.c index 5b2e93f..f820d77 100644
>>>>>> --- a/drivers/staging/android/ion/ion-ioctl.c
>>>>>> +++ b/drivers/staging/android/ion/ion-ioctl.c
>>>>>> @@ -146,11 +146,6 @@ long ion_ioctl(struct file *filp, unsigned int cmd,
>>>>>> unsigned long arg)>
>>>>>>                   data.handle.handle = handle->id;
>>>>>>
>>>>>>           break;
>>>>>>
>>>>>>   }
>>>>>>
>>>>>> - case ION_IOC_SYNC:
>>>>>> - {
>>>>>> -         ret = ion_sync_for_device(client, data.fd.fd);
>>>>>> -         break;
>>>>>> - }
>>>>>
>>>>> You missed the case ION_IOC_SYNC: in compat_ion.c.
>>>>>
>>>>> While at it: Should we also remove the entire custom_ioctl infrastructure?
>>>>> It's entirely unused afaict, and for a pure buffer allocator I don't see
>>>>> any need to have custom ioctl.
>>>>
>>>> I second that, if you want to make ion a standard API, then we certainly don't
>>>> want any custom ioctl.
>>>>
>>>>> More code to remove potentially:
>>>>> - The entire compat ioctl stuff - would be an abi break, but I guess if we
>>>>>   pick the 32bit abi and clean up the uapi headers we'll be mostly fine.
>>>>>   would allow us to remove compat_ion.c entirely.
>>>>>
>>>>> - ION_IOC_IMPORT: With this ion is purely an allocator, so not sure we
>>>>>   still need to be able to import anything. All the cache flushing/mapping
>>>>>   is done through dma-buf ops/ioctls.
>>>>>
>>>>>
>>>
>>> Good point to all of the above. I was considering keeping the import around
>>> for backwards compatibility reasons but given how much other stuff is being
>>> potentially broken, everything should just get ripped out.
>>
>> If you're ok with breaking the world, then I strongly suggest we go
>> through the uapi header and replace all types with the standard
>> fixed-width ones (__s32, __s64 and __u32, __u64). Allows us to remove all
>> the compat ioctl code :-)
> 
> I think the other comments from your "botching-up ioctls" [1] also apply ;-)
> Namely - align structs to multiple of 64bit, add "flags" and properly
> verity user input returning -EINVAL.
> 
> -Emil
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/ioctl/botching-up-ioctls.txt

I'm more torn on this. There's a difference between dropping an old
ioctl/implicit caching vs. changing an actual ioctl ABI.
Maybe having obvious breakage is better than subtle though,
plus nobody has come begging me not to break the ABI yet.
I might leave this for right before we do the actual move
out of staging.

Thanks,
Laura

 
