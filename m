Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45889 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758134AbdJMOnY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 10:43:24 -0400
Subject: Re: [ANN] Call for topics for the media mini-summit on Friday Oct 27
 in Prague
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkhan@gmail.com>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
References: <4c24c976-2ae3-b0f3-d16a-ec31a9b2ea50@xs4all.nl>
 <CAFsbExLdADpSK84b4--z5PZ8kUA7R4+Ppmt2NqzO4y-WfdZ7Fg@mail.gmail.com>
 <CAKocOOO5SaLD2FqyXusHaEds+sT-YrvRuqJrEmBaJ-dPYBR1wQ@mail.gmail.com>
 <0b0dbec2-0524-2da9-a888-9336a7ad57be@xs4all.nl>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <e52e4914-42bb-2783-3a91-8ad3609ab4fc@osg.samsung.com>
Date: Fri, 13 Oct 2017 08:43:17 -0600
MIME-Version: 1.0
In-Reply-To: <0b0dbec2-0524-2da9-a888-9336a7ad57be@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 10/13/2017 01:36 AM, Hans Verkuil wrote:
> Hi Shuah,
> 
> On 10/05/2017 03:53 PM, Shuah Khan wrote:
>> Hi Hans/Gustavo.
>>
>> On Wed, Oct 4, 2017 at 1:34 PM, Gustavo Padovan <gustavo@padovan.org> wrote:
>>> Hi Hans,
>>>
>>>
>>>
>>> On Fri, Sep 1, 2017 at 6:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> Hi all,
>>>>
>>>> We are organizing a media mini-summit on Friday October 27 in Prague, co-located
>>>> with the ELCE conference:
>>>>
>>>> http://events.linuxfoundation.org/events/embedded-linux-conference-europe
>>>>
>>>> This is a call for topics to discuss during that mini-summit.
>>>>
>>>> Also, if you plan to attend, please let me know. It is open for all, but it is
>>>> nice if we know beforehand who we can expect.
>>>>
>>>> So if you have a topic that you want to discuss there, then just reply to this
>>>> post. If possible, please add a rough idea of how much time you think you will
>>>> need.
>>>>
>>>> I plan to make the agenda based on the received topics around mid-October.
>>>>
>>>
>>> I"m attending and I want to propose a discussion:
>>>
>>> Topic: V4L2 Explicit Syncronization
>>> Purpose: quick overview and discuss of the API/direction we are going
>>> with fences
>>> Duration: 20-30min
>>
>> I would have loved to attend the Media mini-summit. Unfortunately I
>> already made plans to leave Friday. In addition participating in the
>> V4L2 Explicit Syncronization discussion, it would have been good to
>> discuss:
>>
>> the my pending Media/Audio resource sharing patch series that is
>> dependent on Sakari's lifetime managemnet patch series.
> 
> I heard you were trying to extend your stay to include the Friday. Let me
> know if you'll be able to attend this summit and I can add this topic to
> the list. If you can't join us on Friday, then we can discuss this on the
> Thursday: we should have enough time for that.

It is turning out to be tough and way too expensive to change travel dates.
Thanks for putting this topic on the agenda for Thursday.

> 
>> I have been unable to get any discussion going on this topic on the
>> mailing list.
> 
> I suspect that as long as the core life-time issues aren't solved nothing
> much will happen with this. It's like building a house on quicksand.

Yes. We have to decide on going forward path to address these life-time
issues.

> 
> It wasn't obvious that the foundation was quicksand when you started, but
> the realization slowly dawned on us that there were more problems than we
> thought. Or at least, this is my understanding.

Right. Not a surprise as we poke around more it became clear that the framework
is fragile.

If I could add one more item for discussion for Thursday if time permits.

Proposing lock contention in mmap and v4l2 ioctl paths

I also have one more item for discussion. I am debugging a deadlock problem
while running gstreamer pipeline involving s5p_mfc and exynos-gsc drivers with
CONFIG_DEBUG_ATOMIC_SLEEP and CONFIG_PROVE_LOCKING are enabled.

Lock contention (race condition) between v4l2_ioctl and drivers fops:mmap interface.

v4l2_ioctl -> video_ioctl2 -> video_usercopy
vm_mmap_pgoff -> v4l2_mmap -> s5p_mfc_mmap

driver mmap routine tries to hold the video device lock it already holds
and in the debug path mm->mmap_sem gets held

I think this might be an issue with m2m drivers that hold the video device
lock from the mmap routines. This could be a manifestation of remove
V4L2_FL_LOCK_ALL_FOPS work at least in the case of s5p_mfc.

It isn't consistent in the way drivers call v4l2_m2m_mmap(). Some drivers
hold a lock and others don't.

I am working on a couple of patches to fix this contention and we could
either discuss this on the mailing list and/or on Thursday.

thanks,
-- Shuah
