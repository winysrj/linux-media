Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49336 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755194AbeCSN3j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 09:29:39 -0400
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
To: Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
 <20170516124519.GA25650@amd> <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
 <20180316205512.GA6069@amd> <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
 <20180319102354.GA12557@amd> <20180319074715.5b700405@vento.lan>
 <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl> <20180319120043.GA20451@amd>
 <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl> <20180319124855.GA18886@amd>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a1acc1c7-69df-3b74-16c0-8e7868786559@xs4all.nl>
Date: Mon, 19 Mar 2018 14:29:34 +0100
MIME-Version: 1.0
In-Reply-To: <20180319124855.GA18886@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2018 01:48 PM, Pavel Machek wrote:
> Hi!
> 
>>>> I really want to work with you on this, but I am not looking for partial
>>>> solutions.
>>>
>>> Well, expecting design to be done for opensource development is a bit
>>> unusual :-).
>>
>> Why? We have done that quite often in the past. Media is complex and you need
>> to decide on a design up front.
> 
> 
> 
>>> I really see two separate tasks
>>>
>>> 1) support for configuring pipeline. I believe this is best done out
>>> of libv4l2. It outputs description file, format below. Currently I
>>> have implemented this is in Python. File format is below.
>>
>> You do need this, but why outside of libv4l2? I'm not saying I disagree
>> with you, but you need to give reasons for that.
> 
> I'd prefer to do this in Python. There's a lot to configure there, and
> I'm not sure if libv4l2 is is right place for it. Anyway, design of 2)
> does not depend on this.
> 
>>> 2) support for running libv4l2 on mc-based devices. I'd like to do
>>> that.
>>>
>>> Description file would look like. (# comments would not be not part of file).
>>>
>>> V4L2MEDIADESC
>>> 3 # number of files to open
>>> /dev/video2
>>> /dev/video6
>>> /dev/video3
>>
>> This won't work. The video nodes numbers (or even names) can change.
>> Instead these should be entity names from the media controller.
> 
> Yes, it will work. 1) will configure the pipeline, and prepare
> V4L2MEDIADESC file. The device names/numbers are stable after the
> system is booted.

No, they are not. Drivers can be unloaded and reloaded, thus changing
the device nodes. The media device will give you the right major/minor
numbers and with libudev you can find the corresponding device node.
That's the right approach.

> 
> If these were entity names, v4l2_open() would have to go to /sys and
> search for corresponding files... which would be rather complex and
> slow.
> 
>>> 3 # number of controls to map. Controls not mentioned here go to
>>>   # device 0 automatically. Sorted by control id.
>>>   # Device 0 
>>> 00980913 1
>>> 009a0003 1
>>> 009a000a 2
>>
>> You really don't need to specify the files to open. All you need is to
>> specify the entity ID and the list of controls that you need.
>>
>> Then libv4l can just figure out which device node(s) to open for
>> that.
> 
> Yes, but that would slow down v4l2_open() needlessly. I'd prefer to
> avoid that.

It should be quite fast. BTW, v4l2-ctl has code to find the media device
node for a given video node.

> 
>>> We can parse that easily without requiring external libraries. Sorted
>>> data allow us to do binary search.
>>
>> But none of this addresses setting up the initial video pipeline or
>> changing formats. We probably want to support that as well.
> 
> Well, maybe one day. But I don't believe we should attempt to support
> that today.

But this should at least be thought about in the design. What is needed
in the configuration file to support this? What are the consequences for
how everything is set up? Otherwise we'd implement something only to
discover later that it doesn't work for the more advanced scenarios.

> Currently, there's no way to test that camera works on N900 with
> mainline v4l2... which is rather sad. Advanced use cases can come later.
> 
>> For that matter: what is it exactly that we want to support? I.e. where do
>> we draw the line?
> 
> I'd start with fixed format first. Python prepares pipeline, and
> provides V4L2MEDIADESC file libv4l2 can use. You can have that this
> week.

I'm not sure I want python. An embedded system might not have python
installed. Also, if we need to parse the configuration file in libv4l
(and I am 90% certain that that is what we need to do), then you don't
want to call a python script from there.

> 
> I guess it would make sense to support "application says preffered
> resolution, libv4l2 attempts to set up some kind of pipeline to get
> that resolution", but yes, interface there will likely be quite
> complex.
> 
> Media control is more than 5 years old now. libv4l2 is still
> completely uses on media control-based devices, and people are asking
> for controls propagation in the kernel to fix that. My proposol
> implements simple controls propagation in the userland. I believe we
> should do that.

Your proposal implements one specific use-case. One piece of a larger puzzle.

We first need a proper design proposal and we can go from there.

Now, I admit, all this takes time. And that's why this still hasn't been done
after all those years.

> 
>> A good test platform for this (outside the N900) is the i.MX6 platform.
> 
> Do you have one?

Yes. Although I would need to set it up, I still haven't done that.

But Steve Longerbeam is probably the right person to test this for you.

What I have been thinking of (although never in any real detail) is that we
probably want to have an application that is run from udev when a media device
is created and that reads a config file and does an initial pipeline configuration.

So once that's setup you should be able to do: 'v4l2-ctl --stream-mmap' and
get video.

Next, libv4l will also read the same configuration file and use it to provide
a compatibility layer so applications that use libv4l will work better with
MC devices. Part of that is indeed control handling.

Regards,

	Hans
