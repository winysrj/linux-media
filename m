Return-path: <linux-media-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:46358 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3GNVSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jul 2013 17:18:48 -0400
Date: Sun, 14 Jul 2013 23:18:42 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <749621697.20130714231842@eikelenboom.it>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [media] cx25821 regression from 3.9: BUG: bad unlock balance detected!
In-Reply-To: <51E27239.2080109@xs4all.nl>
References: <1139404719.20130516194142@eikelenboom.it> <201305171025.24166.hverkuil@xs4all.nl> <1756541549.20130517110450@eikelenboom.it> <201305171152.17746.hverkuil@xs4all.nl> <266016445.20130712225644@eikelenboom.it> <51E27239.2080109@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Sunday, July 14, 2013, 11:41:13 AM, you wrote:

> Hi Sander,

> On 07/12/2013 10:56 PM, Sander Eikelenboom wrote:
>> 
>> Friday, May 17, 2013, 11:52:17 AM, you wrote:
>> 
>>> On Fri May 17 2013 11:04:50 Sander Eikelenboom wrote:
>>>>
>>>> Friday, May 17, 2013, 10:25:24 AM, you wrote:
>>>>
>>>>> On Thu May 16 2013 19:41:42 Sander Eikelenboom wrote:
>>>>>> Hi Hans / Mauro,
>>>>>>
>>>>>> With 3.10.0-rc1 (including the cx25821 changes from Hans), I get the bug below which wasn't present with 3.9.
>>>>
>>>>> How do I reproduce this? I've tried to, but I can't make this happen.
>>>>
>>>>> Looking at the code I can't see how it could hit this bug anyway.
>>>>
>>>> I'm using "motion" to grab and process 6 from the video streams of the card i have (card with 8 inputs).
>>>> It seems the cx25821 underwent quite some changes between 3.9 and 3.10.
>> 
>>> It did.
>> 
>>>> And in the past there have been some more locking issues around mmap and media devices, although they seem to appear as circular locking dependencies and with different devices.
>>>>    - http://www.mail-archive.com/linux-media@vger.kernel.org/msg46217.html
>>>>    - Under kvm: http://www.spinics.net/lists/linux-media/msg63322.html
>> 
>>> Neither of those are related to this issue.
>> 
>>>>
>>>> - Perhaps that running in a VM could have to do with it ?
>>>>    - The driver on 3.9 occasionaly gives this, probably latency related (but continues to work):
>>>>      cx25821: cx25821_video_wakeup: 2 buffers handled (should be 1)
>>>>
>>>>      Could it be something double unlocking in that path ?
>>>>
>>>> - Is there any extra debugging i could enable that could pinpoint the issue ?
>> 
>>> Try this patch:
>> 
>>> diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
>>> index b762c5b..8f8d0e0 100644
>>> --- a/drivers/media/pci/cx25821/cx25821-core.c
>>> +++ b/drivers/media/pci/cx25821/cx25821-core.c
>>> @@ -1208,7 +1208,6 @@ void cx25821_free_buffer(struct videobuf_queue *q, struct cx25821_buffer *buf)
>>>         struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
>>>  
>>>         BUG_ON(in_interrupt());
>>> -       videobuf_waiton(q, &buf->vb, 0, 0);
>>>         videobuf_dma_unmap(q->dev, dma);
>>>         videobuf_dma_free(dma);
>>>         btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
>> 
>>> I don't think the waiton is really needed for this driver.
>> 
>>> What really should happen is that videobuf is replaced by videobuf2 in this
>>> driver, but that's a fair amount of work.
>> 
>> Hi Hans,
>> 
>> After being busy for quite some time, i do have some spare time now.
>> 
>> Since i'm still having trouble with this driver, is there a patch series for a similar driver
>> that was converted to videobuf2 ?
>> I don't know if it is entirely in my league, but i could give it a try when i have a example.

> The changes done for usb/em28xx might come close. That said, the cx25821 is already in
> decent shape to convert to vb2. At least the videobuf data structures are already in the
> correct place (they are often stored in a per-filehandle struct, which is wrong).

Found the em28xx port to videobuf2 patch from Devin Heitmueller.
Unfortunately the patch format isn't very neat as a example (due to reusing/renaming function parts)

Apart from that the cx25821 also supports multiple "channels / subdevices".

>From what i see one of the major changes is that the handling of the queue is now internal to and handled by videobuf2 ?

> include/media/videobuf2-core.h gives a reasonable overview of vb2. Like em28xx, you
> should use the vb2 helper functions (vb2_fop_* and vb2_ioctl_*) which takes a lot
> of the work off your hands.

> Converting cx25821-alsa.c may be the most difficult part as it is using some videobuf
> internal functions which probably won't translate to vb2 as is. I think videobuf is
> being abused here, but I don't know off-hand what the correct approach will be with
> vb2.

> I would ignore the alsa part for the time being (also the audio/video-upstream code,
> that's been disabled and without datasheets of the cx25821 I'm not sure it can be
> resurrected).

> If you can get cx25821-video.c to work with vb2, then we can take a look at the alsa
> code.

Will do.

> Regards,

>         Hans

--
Sander

