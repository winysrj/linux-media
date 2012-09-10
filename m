Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab2IJSaB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 14:30:01 -0400
Message-ID: <504E31F0.7080804@redhat.com>
Date: Mon, 10 Sep 2012 20:31:12 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pac7302-webcams and libv4lconvert interaction
References: <5048BDA2.7090203@googlemail.com> <504D080C.8020608@redhat.com> <504E0916.8010204@googlemail.com>
In-Reply-To: <504E0916.8010204@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/10/2012 05:36 PM, Frank Schäfer wrote:
> Hi Hans,
>
> Am 09.09.2012 23:20, schrieb Hans de Goede:
>> Hi,
>>
>> On 09/06/2012 05:13 PM, Frank Schäfer wrote:
>>>
>>> Hi,
>>>
>>> I'm currently looking into the gspca_pac7302-driver and how it interacts
>>> with libv4lconvert.
>>> This is how it currently works
>>> - driver announces v4l2_pix_format 640x480 (width x height)
>>> - the frames (jpeg) passed to userspace are encoded as 480x640 and this
>>> complies with the jpeg-header we generate
>>> - libv4lconvert checks width/height in the jpeg-header and compares them
>>> with the image format announced by the kernel:
>>>      a) values are the same:
>>>         1) V4LCONTROL_ROTATED_90_JPEG is NOT set for the device (standard
>>> case):
>>>             => everything is fine, image is decoded
>>>         2) V4LCONTROL_ROTATED_90_JPEG is set for the device:
>>>             => libv4lconvert bails out with -EIO displaying the error
>>> message "unexpected width / height in JPEG header: expected: 640x480,
>>> header: 480x640"
>>>      b) values are different:
>>>         1) V4LCONTROL_ROTATED_90_JPEG is NOT set:
>>>             => libv4lconvert bails out with -EIO displaying the error
>>> message "unexpected width / height in JPEG header: expected: 640x480,
>>> header: 480x640"
>>>         2) V4LCONTROL_ROTATED_90_JPEG is set:
>>>             => image is decoded and rotated correctly
>>>
>>>
>>> Thinking about this for some minutes:
>>>
>>> 1) shouldn't the kernel always announce the real image format (size) of
>>> the data it passes to userspace ?
>>
>> It is passing the real size, the data is just in a vary funky format
>> which
>> needs rotation as part of its "decoding" / decompression.
>
> It is first decoded, then rotated, right ?

Yes, because rotating raw JPEG data is hard, but we believe that the
rotation happening inside the cam is a side-effect (or rather a bug) of how
the hardware encoding works. So that we split the 2 steps in software is just
for convenience. The fact is that these cams have a sensor which has 640x480
pixels, not 480x640. So the correct size to report to userspace is 640x480,
the rotation is a side effect of the special pixart pixel format / encoding.

> Are the frames encoded as 480x640 (that's what the header says) or 640x480 ?
> If the header is wrong, everything is fine. Otherwise we are passing the
> size we finally get AFTER decoding and rotation to userspace, which I
> think would be inconsistent.

They are encoded as 480x640, which is why the header says that (otherwise
even more pixart hacks to the jpeg decoder in tinyjpeg.c would be necessary),
but again the sensor has a resolution of 640x480, not 480x640. So both the
reported resolution and the header are right, they just don't agree because
these (dirt cheap) cameras are really funky.

>
>>
>>> Current behavior seems inconsistent to me...
>>> Announcing the actual image size allows applications which trust the API
>>> value more than the value in the frame header to decode the image
>>> correctly without using libv4lconvert (although the image would still be
>>> rotated).
>>
>> That assumes that the app would know how to decompress the data which it
>> will not know, these cams do not generate standard JPEG data,
>> libv4lconvert's
>> decompression code is the only decompression code for this fsck-ed up
>> JPEG-s,
>> short of the windows drivers code.
>
> Ok, that's true.
> Because of the special format, applications are forced to use
> libv4lconvert, so there is CURRENTLY no need to think about the kernel
> <-> userspace interface.
> But that might change in the future...
>
>>
>>> 2) shouldn't libv4lconvert always rotate the image if
>>> V4LCONTROL_ROTATED_90_JPEG is set for a device ?
>>> It seems like a2) is a bug, because the expected size should be 640x480,
>>> too.
>>
>> rotating by 90 degrees also swaps the width and height, which are usually
>> not the same, so rotating an image which starts at 640x480 will yield
>> a final image of 480x640 which will not be what the app expects.
>
> Well, I can't see why 480x640 should be an invalid format !? Depends on
> the hardware.

What I'm trying to say is that for the image to be 640x480 after rotation
by 90 degrees, it has to be 480x640 before rotation. So since the raw data
needs rotation it reports itself as 480x640, where as the end result
reports itself as 640x480 ...


Regards,

Hans
