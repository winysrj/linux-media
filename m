Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58584 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2IJPgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 11:36:53 -0400
Received: by eaac11 with SMTP id c11so973790eaa.19
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2012 08:36:52 -0700 (PDT)
Message-ID: <504E0916.8010204@googlemail.com>
Date: Mon, 10 Sep 2012 17:36:54 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: pac7302-webcams and libv4lconvert interaction
References: <5048BDA2.7090203@googlemail.com> <504D080C.8020608@redhat.com>
In-Reply-To: <504D080C.8020608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am 09.09.2012 23:20, schrieb Hans de Goede:
> Hi,
>
> On 09/06/2012 05:13 PM, Frank Schäfer wrote:
>>
>> Hi,
>>
>> I'm currently looking into the gspca_pac7302-driver and how it interacts
>> with libv4lconvert.
>> This is how it currently works
>> - driver announces v4l2_pix_format 640x480 (width x height)
>> - the frames (jpeg) passed to userspace are encoded as 480x640 and this
>> complies with the jpeg-header we generate
>> - libv4lconvert checks width/height in the jpeg-header and compares them
>> with the image format announced by the kernel:
>>     a) values are the same:
>>        1) V4LCONTROL_ROTATED_90_JPEG is NOT set for the device (standard
>> case):
>>            => everything is fine, image is decoded
>>        2) V4LCONTROL_ROTATED_90_JPEG is set for the device:
>>            => libv4lconvert bails out with -EIO displaying the error
>> message "unexpected width / height in JPEG header: expected: 640x480,
>> header: 480x640"
>>     b) values are different:
>>        1) V4LCONTROL_ROTATED_90_JPEG is NOT set:
>>            => libv4lconvert bails out with -EIO displaying the error
>> message "unexpected width / height in JPEG header: expected: 640x480,
>> header: 480x640"
>>        2) V4LCONTROL_ROTATED_90_JPEG is set:
>>            => image is decoded and rotated correctly
>>
>>
>> Thinking about this for some minutes:
>>
>> 1) shouldn't the kernel always announce the real image format (size) of
>> the data it passes to userspace ?
>
> It is passing the real size, the data is just in a vary funky format
> which
> needs rotation as part of its "decoding" / decompression.

It is first decoded, then rotated, right ?
Are the frames encoded as 480x640 (that's what the header says) or 640x480 ?
If the header is wrong, everything is fine. Otherwise we are passing the
size we finally get AFTER decoding and rotation to userspace, which I
think would be inconsistent.

>
>> Current behavior seems inconsistent to me...
>> Announcing the actual image size allows applications which trust the API
>> value more than the value in the frame header to decode the image
>> correctly without using libv4lconvert (although the image would still be
>> rotated).
>
> That assumes that the app would know how to decompress the data which it
> will not know, these cams do not generate standard JPEG data,
> libv4lconvert's
> decompression code is the only decompression code for this fsck-ed up
> JPEG-s,
> short of the windows drivers code.

Ok, that's true.
Because of the special format, applications are forced to use
libv4lconvert, so there is CURRENTLY no need to think about the kernel
<-> userspace interface.
But that might change in the future...

>
>> 2) shouldn't libv4lconvert always rotate the image if
>> V4LCONTROL_ROTATED_90_JPEG is set for a device ?
>> It seems like a2) is a bug, because the expected size should be 640x480,
>> too.
>
> rotating by 90 degrees also swaps the width and height, which are usually
> not the same, so rotating an image which starts at 640x480 will yield
> a final image of 480x640 which will not be what the app expects.

Well, I can't see why 480x640 should be an invalid format !? Depends on
the hardware.
Applications really shouldn't rely on width beeing always larger then
height. Otherwise I would call them buggy.

Regards,
Frank


>
>> 3) because all pac7302 devices are sending rotated image data, we should
>> add them ALL to libv4lconvert. Currently only 4 of the 14 devices are on
>> the list.
>> Do you want me to send a patch ?
>
> I see you've send a patch in the mean time, I'll reply in more detail to
> this to the patch mail.
>
> Regards,
>
> Hans

