Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbaBSN0C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 08:26:02 -0500
Message-ID: <5304B0E7.4000802@canonical.com>
Date: Wed, 19 Feb 2014 14:25:59 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
	Rob Clark <robdclark@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-arch@vger.kernel.org,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Colin Cross <ccross@google.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/6] seqno-fence: Hardware dma-buf implementation of fencing
 (v4)
References: <20140217155056.20337.25254.stgit@patser>	<20140217155556.20337.37589.stgit@patser>	<53023F3E.3080107@vodafone.de>	<CAF6AEGtHSg=qESbGE8LZsQPrRfHnrSQOjpEAVKeZ5o9k07ZNcA@mail.gmail.com>	<530248B1.2090405@vodafone.de> <CAF6AEGtk1dGdFg2wk-ofRQmaxEnnEOQBOg=JNaPRVapQqsML+w@mail.gmail.com> <530257E3.2060508@vodafone.de>
In-Reply-To: <530257E3.2060508@vodafone.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

op 17-02-14 19:41, Christian K�nig schreef:
> Am 17.02.2014 19:24, schrieb Rob Clark:
>> On Mon, Feb 17, 2014 at 12:36 PM, Christian K�nig
>> <deathsimple@vodafone.de> wrote:
>>> Am 17.02.2014 18:27, schrieb Rob Clark:
>>>
>>>> On Mon, Feb 17, 2014 at 11:56 AM, Christian K�nig
>>>> <deathsimple@vodafone.de> wrote:
>>>>> Am 17.02.2014 16:56, schrieb Maarten Lankhorst:
>>>>>
>>>>>> This type of fence can be used with hardware synchronization for simple
>>>>>> hardware that can block execution until the condition
>>>>>> (dma_buf[offset] - value) >= 0 has been met.
>>>>>
>>>>> Can't we make that just "dma_buf[offset] != 0" instead? As far as I know
>>>>> this way it would match the definition M$ uses in their WDDM
>>>>> specification
>>>>> and so make it much more likely that hardware supports it.
>>>> well 'buf[offset] >= value' at least means the same slot can be used
>>>> for multiple operations (with increasing values of 'value').. not sure
>>>> if that is something people care about.
>>>>
>>>>> =value seems to be possible with adreno and radeon.  I'm not really sure
>>>>> about others (although I presume it as least supported for nv desktop
>>>>> stuff).  For hw that cannot do >=value, we can either have a different fence
>>>>> implementation which uses the !=0 approach.  Or change seqno-fence
>>>>> implementation later if needed.  But if someone has hw that can do !=0 but
>>>>> not >=value, speak up now ;-)
>>>
>>> Here! Radeon can only do >=value on the DMA and 3D engine, but not with UVD
>>> or VCE. And for the 3D engine it means draining the pipe, which isn't really
>>> a good idea.
>> hmm, ok.. forgot you have a few extra rings compared to me.  Is UVD
>> re-ordering from decode-order to display-order for you in hw? If not,
>> I guess you need sw intervention anyways when a frame is done for
>> frame re-ordering, so maybe hw->hw sync doesn't really matter as much
>> as compared to gpu/3d->display.  For dma<->3d interactions, seems like
>> you would care more about hw<->hw sync, but I guess you aren't likely
>> to use GPU A to do a resolve blit for GPU B..
>
> No UVD isn't reordering, but since frame reordering is predictable you usually end up with pipelining everything to the hardware. E.g. you send the decode commands in decode order to the UVD block and if you have overlay active one of the frames are going to be the first to display and then you want to wait for it on the display side.
>
>> For 3D ring, I assume you probably want a CP_WAIT_FOR_IDLE before a
>> CP_MEM_WRITE to update fence value in memory (for the one signalling
>> the fence).  But why would you need that before a CP_WAIT_REG_MEM (for
>> the one waiting for the fence)?  I don't exactly have documentation
>> for adreno version of CP_WAIT_REG_{MEM,EQ,GTE}..  but PFP and ME
>> appear to be same instruction set as r600, so I'm pretty sure they
>> should have similar capabilities.. CP_WAIT_REG_MEM appears to be same
>> but with 32bit gpu addresses vs 64b.
>
> You shouldn't use any of the CP commands for engine synchronization (neither for wait nor for signal). The PFP and ME are just the top of a quite deep pipeline and when you use any of the CP_WAIT functions you block them for something and that's draining the pipeline.
>
> With the semaphore and fence commands the values are just attached as prerequisite to the draw command, e.g. the CP setups the draw environment and issues the command, but the actual execution of it is delayed until the "!= 0" condition hits. And in the meantime the CP already prepares the next draw operation.
>
> But at least for compute queues wait semaphore aren't the perfect solution either. What you need then is a GPU scheduler that uses a kernel task for setting up the command submission for you when all prerequisites are meet.
nouveau has sort of a scheduler in hardware. It can yield when waiting on a semaphore. And each process gets their own context and the timeslices can be adjusted. ;-) But I don't mind changing this patch when an actual user pops up. Nouveau can do a  wait for (*sema & mask) != 0 only on nvc0 and newer, where mask can be chosen. But it can do == somevalue and >= somevalue on older relevant optimus hardware, so if we know that it was zero before and we know the sign of the new value that could work too.

Adding ops and a separate mask later on when users pop up is fine with me, the original design here was chosen so I could map the intel status page read-only into the process specific nvidia vm.

~Maarten

