Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab2IQJiQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 05:38:16 -0400
Message-ID: <5056EFD3.9010002@redhat.com>
Date: Mon, 17 Sep 2012 11:39:31 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pac7302-webcams and libv4lconvert interaction
References: <5048BDA2.7090203@googlemail.com> <504D080C.8020608@redhat.com> <504E0916.8010204@googlemail.com> <504E31F0.7080804@redhat.com> <504E4C96.8000207@googlemail.com> <504EE83C.5040503@redhat.com> <50509DDB.6030305@googlemail.com> <5051CBFB.9030200@redhat.com> <5055C436.8060407@googlemail.com>
In-Reply-To: <5055C436.8060407@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/16/2012 02:21 PM, Frank Schäfer wrote:
> Hi,
>
> Am 13.09.2012 14:05, schrieb Hans de Goede:
>> Hi,
>>
>> On 09/12/2012 04:36 PM, Frank Schäfer wrote:
>>
>> <snip>
>>
>>>
>>> And a negative side effect is, that unknown pac7302 devices (with no
>>> V4LCONTROL_ROTATED_90_JPEG entry in libv4lconvert) do not work.
>>> With a consistent API behavior, they would work fine (output a rotated
>>> image). Users would at least know that their device is working and most
>>> of them know what to do next.
>>> For image rotation, we still need to add an entry to libv4lconvert and
>>> to modify it to invert the width and height values in v4l2_pix_format in
>>> this case.
>>
>> That is a good point, unfortunately we are stuck with how we are doing
>> things now, since changing things would break the kernel ABI.
>
> Yeah, we can't break things. But I think this would be ABI fixing not
> breaking. ;)
> Actually...I'm not sure if this would be really an ABI change, because
> the interface itself wouldn't change.
> We would only fix a driver which passes a wrong value to userspace.
> Its a question of interpretation...

Well userspace will no longer work after the change, unless it gets updated
in sync, so its an ABI break clear and simple.

>
>>
>> Also ...
>>
>>>
>>> The device I have here is a good example: many people reported this
>>> device as not working years ago, one of them even got a hint in a forum
>>> that this could be a pac7302 device 2 years ago.
>>> But with the gpsca-pac7302 driver, he got no picture and gave up.
>>> And if I had not started q4vl2 from the terminal and had noticed the
>>> error message from libv4lconvert, I would have needed much more time to
>>> find out what's wrong...
>>
>> True, OTOH just having this fixed won't help a regular user, as he/she
>> would still need to first add the new usb-id to the pac7302 driver...
>
> Regular users, sure. But it would be a big step forward.
> Adding new device IDs for testing is one of the easier things in the
> Unix world.
>
> Hans, I have a bunch of smaller things on my ToDo list which I want to
> do first.
> For now: maybe we can improve things by trusting the jpeg-header ?
> That would mean removing the following section from
> v4lconvert_decode_jpeg_tinyjpeg() :
>
>      if (data->control_flags & V4LCONTROL_ROTATED_90_JPEG) {
>          unsigned int tmp = width;
>          width = height;
>          height = tmp;
>      }
>
>      if (header_width != width || header_height != height) {
>          V4LCONVERT_ERR("unexpected width / height in JPEG header: "
>                     "expected: %ux%u, header: %ux%u\n",
>                     width, height, header_width, header_height);
>          errno = EIO;
>          return -1;
>      }
>
>
> V4LCONTROL_ROTATED_90_JPEG is only used for the pac7302 devices and we
> know that their header is correct.
> And even in cases where the header is wrong, I think it would we better
> to get a garbeled picture instead of -EIO.

We're not just getting EIO, we're also logging the error to stderr, and
getting that error message in a bug report is a lot more useful then
getting a bug report about a "garbled picture" the end result for the
user is the same: "his / her cam is not usable", and either they file
a bug report or they don't.

Also a garbled picture is the *best* outcome, chances are that if things
don't match they get a crash instead of the error to stderr, which is
much much harder to debug.

Regards,

Hans
