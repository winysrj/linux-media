Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36864 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2ILOgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 10:36:11 -0400
Received: by eekc1 with SMTP id c1so1369404eek.19
        for <linux-media@vger.kernel.org>; Wed, 12 Sep 2012 07:36:10 -0700 (PDT)
Message-ID: <50509DDB.6030305@googlemail.com>
Date: Wed, 12 Sep 2012 16:36:11 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: pac7302-webcams and libv4lconvert interaction
References: <5048BDA2.7090203@googlemail.com> <504D080C.8020608@redhat.com> <504E0916.8010204@googlemail.com> <504E31F0.7080804@redhat.com> <504E4C96.8000207@googlemail.com> <504EE83C.5040503@redhat.com>
In-Reply-To: <504EE83C.5040503@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 11.09.2012 09:29, schrieb Hans de Goede:
> Hi,
>
> On 09/10/2012 10:24 PM, Frank Schäfer wrote:
>
> <snip>

Ok, I understand what that means...

>
>>
>> libv4lconvert should be modifed to do the rotation regardless of what
>> comes out of the kernel whenever V4LCONTROL_ROTATED flag is set.
>> This way it becomes just a normal software control (like software
>> h/v-flip).
>> At the moment, it can only handle (jpeg) data where the kernel and
>> header sizes are different.
>
> And that cannot be done, because what if the app enumerates frame
> sizes, sees
> 640x480 there, then the rotate 90 degrees option gets toggled on, and it
> starts streaming and gets 480x640 frames all of a sudden, or what if
> the rotation
> changes during streaming ?
>
> Which is exavtly the reason why rotated-90 is being handled the way it
> is, which
> is I must admit a bit hacky, but that is what it is, just a hack for
> pac7302
> cameras.
>
> Doing general rotation support is hard, if not impossible, at the v4l2
> level since
> it changes not only the contents but also the dimensions of the image.

Ok, you're right, general rotation / toggling rotation while streaming
is indeed a problem.
Anyway, I can't see how this affects the frame size reported by the
kernel. The data format coming out the kernel is always the same, it
doesn,'t matter if we rotate or not rotate the image (either statically
or dynamically) in userspace.

The only advantage with the current solution is, that we can pass the
frame size information from the kernel to userspace directly.
But with the cost of an inconsistent API.

And a negative side effect is, that unknown pac7302 devices (with no
V4LCONTROL_ROTATED_90_JPEG entry in libv4lconvert) do not work.
With a consistent API behavior, they would work fine (output a rotated
image). Users would at least know that their device is working and most
of them know what to do next.
For image rotation, we still need to add an entry to libv4lconvert and
to modify it to invert the width and height values in v4l2_pix_format in
this case.

The device I have here is a good example: many people reported this
device as not working years ago, one of them even got a hint in a forum
that this could be a pac7302 device 2 years ago.
But with the gpsca-pac7302 driver, he got no picture and gave up.
And if I had not started q4vl2 from the terminal and had noticed the
error message from libv4lconvert, I would have needed much more time to
find out what's wrong...

Regards,
Frank

>
> Regards,
>
> Hans


