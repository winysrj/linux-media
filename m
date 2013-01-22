Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:53767 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3AVStz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 13:49:55 -0500
Received: by mail-bk0-f43.google.com with SMTP id jf20so3953633bkc.2
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 10:49:54 -0800 (PST)
Message-ID: <50FEDF77.50102@googlemail.com>
Date: Tue, 22 Jan 2013 19:50:31 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: V4L2 spec / core questions
References: <50FC5E87.2080902@googlemail.com> <201301210959.49780.hverkuil@xs4all.nl> <50FDB251.6030501@googlemail.com> <201301212239.58876.hverkuil@xs4all.nl>
In-Reply-To: <201301212239.58876.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.01.2013 22:39, schrieb Hans Verkuil:
> On Mon January 21 2013 22:25:37 Frank Schäfer wrote:
>> Hi Hans,
>>
>> Am 21.01.2013 09:59, schrieb Hans Verkuil:
>>> On Sun January 20 2013 22:15:51 Frank Schäfer wrote:
>>>> Hi Hans,
>>>>
>>>> I noticed that there's code in the v4l2 core that enables/disables
>>>> ioctls and checks some of the parameters depending on the device type.
>>>> While reading the code an comparing it to the V4L2 API document, some
>>>> more questions came up:
>>>>
>>>> 1) Video devices with VBI functionality:
>>>> The spec says: "To address the problems of finding related video and VBI
>>>> devices VBI capturing and output is also available as device function
>>>> under /dev/video".
>>>> Is that still valid ?
>>> No, that's not valid. It really was never valid: most drivers didn't implement
>>> this, and those that did likely didn't work. During one of the media summits
>>> we decided not to allow this. Allowing VBI functionality in video node has a
>>> number of problems:
>>>
>>> 1) it's confusing: why have a vbi node at all if you can do it with a video
>>> node as well? 
>> Yeah, although I think the problem described in the spec document is real.
>> No idea how good applications are in finding the correct VBI device
>> belonging to a specific video device node...
>>
>> Hmm... yeah... why have separate device nodes at all ? We could provide
>> the same functionality with a single device node (e.g. /dev/multimediaX).
>> I assume separation into radio / video / vbi device nodes gears towards
>> typical feature sets of applications.
>> Probably something to think about for V4L3... ;)
> This is an ongoing issue for many years. Laurent and Sakari are working
> on a library that apps can call that tries to find these related devices.
> For drivers that implement the media controller API the MC device can be
> used to obtain this information.

Ok, thanks. I'll keep that in mind.

[snip]
>>>> Btw: function determine_valid_ioctls() in v4l2-dev.c is a good summary
>>>> that explains which ioctls are suitable for which device types
>>>> (radio/video/vbi).
>>>> Converting its content into a table would be a great
>>>> extension/clarifaction of the V4L2 API spec document !
>>> We played around with the idea of 'profiles' where for each type of device
>>> you have a table listing what can and cannot be done. The problem is time...
>>>
>>> If you are interesting in pursuing this, then I am happy to help with advice
>>> and pointers (v4l2-compliance is also a great source of information).
>> I could create a simple html table with X = device type, Y = ioctl.
> That would be a good start!

I've put it on my ToDo list.

>> One last question:
>> I'm looking for a possibility to disable all ioctls when the device is
>> unplugged.
>> I think this is a common problem/task of all drivers for hotpluggable
>> devices, because the disconnect callbacks can't unregister the device
>> until it get's closed by the application.
>> What's the best way to do this ? v4l2_disable_ioctl() has no effect
>> after video_register_device() is called...
> Call video_unregister_device() on disconnect. After that any file operation
> call will be handled by the core and do the right thing on disconnect.

Great, that means we can remove many code lines from the em28xx driver.

Thanks for you help,
Frank

