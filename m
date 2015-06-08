Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36547 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbbFHJyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 05:54:54 -0400
Received: by pabqy3 with SMTP id qy3so93758709pab.3
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2015 02:54:54 -0700 (PDT)
Message-ID: <5575666E.90508@igel.co.jp>
Date: Mon, 08 Jun 2015 18:54:54 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] V4L2 codecs in user space
References: <em1e648821-484a-48b8-afe4-beed2241343a@damian-pc> <55751D44.6010102@igel.co.jp> <55755168.40108@xs4all.nl>
In-Reply-To: <55755168.40108@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for your comments,
On 2015-06-08 5:25 PM, Hans Verkuil wrote:
> Hi Damian,
> 
> On 06/08/2015 06:42 AM, Damian Hobson-Garcia wrote:
>> Hello again,
>>
>> On 2015-06-02 10:40 AM, Damian Hobson-Garcia wrote:
>>> Hello All,
>>>
>>> I would like to ask for some comments about a plan to use user space
>>> video codecs through the V4L interface.  I am thinking of a situation
>>> similar to the one described on the linuxtv.org wiki at
>>> http://www.linuxtv.org/wiki/index.php/V4L2_Userspace_Library
>>>
>>> The basic premise is to use a FUSE-like driver to connect the standard
>>> V4L2 api to a user space daemon that will work as an mem-to-mem driver
>>> for decoding/encoding, compression/decompression and the like.  This
>>> allows for codecs that are either partially or wholly implemented in
>>> user space to be exposed through the standard kernel interface.
>>>
>>> Before I dive in to implementing this I was hoping to get some comments
>>> regarding the following:
>>>
>>> 1. I haven't been able to find any implementation of the design
>>> described in the wiki page.  Would anyone know if I have missed it? 
>>> Does this exist somewhere, even in part? It seems like that might be a
>>> good place to start if possible.
>>>
>>> 2. I think that this could be implemented as either an extension to FUSE
>>> (like CUSE) or as a V4L2 device driver (that forwards requests through
>>> the FUSE API).  I think that the V4L2  device driver would be
>>> sufficient, but would the fact that there is no specific hardware tied
>>> to it be an issue?  Should it instead be presented as a more generic
>>> device?
>>>
>>> 3. And of course anything else that comes to mind.
>>
>> I've been advised that implementing kernel APIs is userspace is probably
>> not the most linux-friendly way to go about things and would most likely
>> not be accepted into the kernel.  I can see the logic of
>> that statement, but I was wondering if I could confirm that here. Is
>> this type of design a bad idea?
> 
> Writing userspace drivers for hardware components is certainly not something
> we want to see. The kernel is the gateway between userspace and hardware, so
> the kernel is the one that controls the hardware. There are some exceptions
> (printers and scanners come to mind), but by and large this rule holds.
> 
I see, thank you.

> But you want to do something different if I understand correctly: you want to
> make a V4L2 API to interface to userspace codecs. That does not affect the kernel
> at all, and I see no reason why this can't be done.
> 
> Basically libv4l2 allows the concept of plugins where all open/close/ioctl/etc.
> operations go through the plugin. Today plugins interface with a kernel V4L2
> driver, but it is also possible to make a plugin that is completely in userspace.
> 
> Nobody ever did it, but we discussed it in the past. The only problem is that
> since there is no actual /dev/videoX device, what do you specify here? Perhaps
> a predefined /dev/video-<codecname>X 'device name'?

I suppose that I would also need to do something for mmap buffers as
well, since mmap() is not part of the plugin API.  I guess I could try
to abuse the fake mmap used by the libv4lconvert, but that might get
messy if an application requests a different pixel format from what the
codec delivers.

Thank you,
Damian

> 
> There is currently only one plugin that is part of v4l-utils:
> v4l-utils/lib/libv4l-mplane
> 
> That might be a good starting point.
> 
> Hope this helps,
> 
> Regards,
> 
> 	Hans
> 
>> Also, if this method is not recommended, should there be a 1-2 line
>> disclaimer on the "V4L2_Userspace_Library" wiki page that mentions this?
>>
>> Thank you,
>> Damian
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
