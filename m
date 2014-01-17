Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1581 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaAQJYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 04:24:37 -0500
Message-ID: <52D8F6BB.5010704@xs4all.nl>
Date: Fri, 17 Jan 2014 10:24:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 3/6] DocBook media: partial rewrite of "Opening and
 Closing Devices"
References: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl> <1389100017-42855-4-git-send-email-hverkuil@xs4all.nl> <20140113132013.06f558a0@samsung.com> <52D4112C.5040902@xs4all.nl> <20140113152350.1ab23491@samsung.com>
In-Reply-To: <20140113152350.1ab23491@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 01/13/2014 06:23 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 13 Jan 2014 17:15:40 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 01/13/2014 04:20 PM, Mauro Carvalho Chehab wrote:
>>> Em Tue,  7 Jan 2014 14:06:54 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> This section was horribly out of date. A lot of references to old and
>>>> obsolete behavior have been dropped.
> 
> Forgot to mention, put patches 1 and 2 are ok. I'll review the patches 4-6
> later this week.
> 
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>  Documentation/DocBook/media/v4l/common.xml | 188 ++++++++++-------------------
>>>>  1 file changed, 67 insertions(+), 121 deletions(-)
>>>>
>>>> diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
>>>> index 1ddf354..da08df9 100644
>>>> --- a/Documentation/DocBook/media/v4l/common.xml
>>>> +++ b/Documentation/DocBook/media/v4l/common.xml

<snip>

>>>> +      <para>Devices can support several functions. For example
>>>> +video capturing, VBI capturing and radio support.</para>
>>>
>>> "function" seems to be a poor choice of word here. Ok, it comes from the
>>> original text, but it is still not clear.
>>>
>>> I would use another word, like "broadcast type", in order to refer to
>>> radio, software defined radio, VBI and video.
>>
>> I agree that it is not the best word, but neither is (IMHO) "broadcast type".
>> This would be something for a follow-up patch.
> 
> I think we should use the right word here on this fix. Other suggestions:
> 	"stream type", "media type".
> 
> In any case, we should enumerate all those types here, maybe even putting
> them into a table, in order to define precisely to what we're referring to.

I'm not going to do this now. I need to think about this some more, and this
might also require changes in a lot of other places in the documentation.

So as far as I am concerned this is something for a future patch.

> 
>>>> +
>>>> +      <para>The V4L2 API creates different nodes for each of these functions.
>>>> +One exception to this rule is the overlay function: this is shared
>>>> +with the video capture node (or video output node for output overlays).</para>
>>>
>>> The mention to overlay here is completely out of context, and proofs
>>> my point that "function" is a very bad choice: overlay is not a
>>> broadcast type. It is just one of the ways to output the data. The same
>>> device node can support multiple "delivery types":
>>> 	- overlay;
>>> 	- dma-buf;
>>> 	- mmap;
>>> 	- read or write.
>>>
>>> Let's not mix those two concepts in the new text.
>>>
>>> Also, the delivery type has nothing to do with "Opening and closing devices".
>>
>> I like the word "delivery type" in this context and I agree with you here.
>> I'll see if I can improve this text.
> 
> Thanks!

I decided to just drop this paragraph. It doesn't belong here and it doesn't
add anything useful.

>  
>>>
>>>> +
>>>> +      <para>The V4L2 API was designed with the idea that one device node could support
>>>> +all functions. However, in practice this never worked: this 'feature'
>>>> +was never used by applications and many drivers did not support it and if
>>>> +they did it was certainly never tested. In addition, switching a device
>>>> +node between different functions only works when using the streaming I/O
>>>> +API, not with the read()/write() API.</para>
>>>> +
>>>> +      <para>Today each device node supports just one function, with the
>>>> +exception of overlay support.</para>
>>>>  
>>>>        <para>Besides video input or output the hardware may also
>>>>  support audio sampling or playback. If so, these functions are
>>>> -implemented as OSS or ALSA PCM devices and eventually OSS or ALSA
>>>> -audio mixer. The V4L2 API makes no provisions yet to find these
>>>> -related devices. If you have an idea please write to the linux-media
>>>> -mailing list: &v4l-ml;.</para>
>>>> +implemented as ALSA PCM devices with optional ALSA audio mixer
>>>> +devices.</para>
>>>> +
>>>> +      <para>One problem with all these devices is that the V4L2 API
>>>> +makes no provisions to find these related devices. Some really
>>>> +complex devices use the Media Controller (see <xref linkend="media_controller" />)
>>>> +which can be used for this purpose. But most drivers do not use it,
>>>> +and while some code exists that uses sysfs to discover related devices,
>>>> +there is no standard library yet. If you want to work on this please write
>>>> +to the linux-media mailing list: &v4l-ml;.</para>
>>>
>>> Not true. It is there at v4l-utils. Ok, patches are always welcome.
>>
>> Well, sort of. That library only handles sysfs, not the mc.
> 
> Yes, but that covers almost all devices, as the ones that use mc (except for
> uvc) have more serious issues, as libv4l still don't work with them. So, they
> demand dedicated applications anyway.
> 
>> I know Laurent
>> has been working on a better replacement, but that's been stalled for ages.
>> In other words, someone needs to spend time on this and create a proper
>> library for this.
> 
> True, but, again, media controller based devices also need the libv4l
> pieces that Sakari is working (also stalled).
> 
> Let's not mix things: associating media devices via sysfs has already
> a library. If you want to mention about that, please point to it.

I clarified the situation and added a pointer to the library in v4l-utils.

> 
> A more generic work that will make libv4l and that library to also work
> with media controllers is a work to be done/finished.
> 
>>
>>>
>>>>      </section>
>>>>  
>>>>      <section>
>>>> @@ -176,19 +124,22 @@ mailing list: &v4l-ml;.</para>
>>>>  When this is supported by the driver, users can for example start a
>>>>  "panel" application to change controls like brightness or audio
>>>>  volume, while another application captures video and audio. In other words, panel
>>>> -applications are comparable to an OSS or ALSA audio mixer application.
>>>> -When a device supports multiple functions like capturing and overlay
>>>> -<emphasis>simultaneously</emphasis>, multiple opens allow concurrent
>>>> -use of the device by forked processes or specialized applications.</para>
>>>> -
>>>> -      <para>Multiple opens are optional, although drivers should
>>>> -permit at least concurrent accesses without data exchange, &ie; panel
>>>> -applications. This implies &func-open; can return an &EBUSY; when the
>>>> -device is already in use, as well as &func-ioctl; functions initiating
>>>> -data exchange (namely the &VIDIOC-S-FMT; ioctl), and the &func-read;
>>>> -and &func-write; functions.</para>
>>>> -
>>>> -      <para>Mere opening a V4L2 device does not grant exclusive
>>>> +applications are comparable to an ALSA audio mixer application.
>>>> +Just opening a V4L2 device should not change the state of the device.
>>>> +Unfortunately, opening a radio device often switches the state of the
>>>> +device to radio mode in many drivers.</para>
>>>
>>> This is an API spec document. It should say what is the expected behavior,
>>> and not mention non-compliant stuff.
>>
>> How about putting this in a footnote? I do agree with you, but the fact is
>> that most if not all drivers that support both radio and video behave this
>> way. So one could argue that it is the spec that is non-compliant :-)
> 
> If so, let's then fix the API to reflect that opening a radio device will
> change the behavior.

I've put this in a footnote together with a mention that this situation needs
to be fixed.

>>
>> That said, at some point this should be fixed.
> 
> Yes. one way or the other.
> 
>>>
>>>> +
>>>> +      <para>Almost all drivers allow multiple opens although there are
>>>> +still some old drivers that have not been updated to allow this.
>>>> +This implies &func-open; can return an &EBUSY; when the
>>>> +device is already in use.</para>
>>>
>>> What drivers? We should fix the driver, not the API doc.
>>
>> vino.c (I do have fixes for this in an old branch), timblogiw.c, fsl-viu.c.
>> There are probably a few more. Generally such drivers are old and/or obscure.
> 
> Maybe in this specific case, a footnote could be added, although the better
> would be to simply fix or remove/move to staging those drivers.

I moved this to a footnote.

> 
>> Since I am still working (slowly) on converting drivers to the modern frameworks
>> I'll come across these eventually.
>>
>>> Also, we need more discussions. It could make sense to return EBUSY
>>> even on new drivers, for example, if they're already in usage by some
>>> other broadcast type?
>>
>> You are not using it until you actually start streaming (or allocating buffers,
>> or whatever). There is no reason within the current framework to return EBUSY
>> for just opening a device node.
>>
>> Not being able to open a device node a second time makes it impossible to
>> create e.g. monitoring applications that do something when an event happens.
> 
> Agreed.
> 
>>>
>>>> +
>>>> +      <para>It is never possible to start streaming when
>>>> +streaming is already in progress. So &func-ioctl; functions initiating
>>>> +data exchange (e.g. the &VIDIOC-STREAMON; ioctl), and the &func-read;
>>>> +and &func-write; functions can return an &EBUSY;.</para>
>>>
>>> Here, the Overlay is a somewhat an exception, not in the sense that 
>>> they'll call streamon latter, but in the sense that overlay ioctls
>>> can happen after streaming.
>>
>> I'll make a note of that.
>>
>>> I don't remember well how DMA buf works,
>>> but I think you can also start to use a mmaped copy of the dma buffers
>>> after start streaming.
>>
>> Possibly, but that has nothing to do with this paragraph. Once a file
>> handle calls STREAMON, then no other file handle of the same device node
>> can call STREAMON, unless the owner stops streaming and releases all
>> resources (REQBUFS(0)).
> 
> Well, then the paragraph text is not quite right, as it mentions 
> "initiating data exchange".
> 
> If one mmaps memory latter to use it on an already started DMA buffer,
> it is initiating the "memory copy" data exchange with the mmap.
> 
> STREAMON is just one of the ways to initiate a data exchange.

I completely reworked this paragraph.

I'll post the revised version of this patch next.

Regards,

	Hans
