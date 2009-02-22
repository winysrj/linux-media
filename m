Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:57169 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZBVSac (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 13:30:32 -0500
Date: Sun, 22 Feb 2009 12:42:04 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
In-Reply-To: <49A13466.5080605@redhat.com>
Message-ID: <alpine.LNX.2.00.0902221225310.10870@banach.math.auburn.edu>
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 22 Feb 2009, Hans de Goede wrote:

>
>
> Hans Verkuil wrote:
>> Hi Adam,
>> 
>> Sorry for the late reply, it's been very busy.
>> 
>
> Same here :)
>
>> On Wednesday 18 February 2009 01:30:52 Adam Baker wrote:
>>> (linux-omap included in distribution as lots of omap systems include
>>> cameras so this could be relevant there.)
>>> 
>>> Background
>>> 
>>> A number of the webcams now supported by v4l have sensors that are
>>> mounted upside down. Up to now this has been handled by having a table in
>>> libv4l of the USB IDs of affected cameras. This approach however fails to
>>> address two known cases (and probably more as yet unknown ones) where the
>>> USB ID is insufficient to determine the sensor orientation.
>>> 
>>> In one of those cases (SQ-905) USB commands must be issued to the camera 
>>> at probe time) to determine what sensor is fitted and in the other case
>>> (Genesys gl860) the camera can be pointed towards or away from the user
>>> and it swaps orientation when it is changed.
>>> 
>>> It is possible that there are cameras that can use gravity sensors or
>>> similar to report how they are being held but such user driven
>>> orientation which may be intended for creative effect should probably be
>>> separated from this hardware related issue.
>> 
>> Yes, I strongly agree with this.
>> 
>
> +1
>
>>> 3) Use an extra couple of bits in V4L2_BUF_FLAGS
>>> Pros: Simple to implement. Can change per frame without needing polling.
>>> Cons: Doesn't work for non libv4l apps that try to use the read()
>>> interface. Can't easily identify drivers that don't support it (does 0
>>> mean not rotated or just not implemented). Can only be read when
>>> streaming (does that matter?)
>> 
>> I think that matters, yes.
>> 
>
> I too can see it being usefull to get the orientation when not streaming.
>
>>> 4) Use some reserved bits from the v4l2_capability structure
>>> Pros: Less overhead than controls.
>>> Cons: Would require polling to support the case of a camera being turned
>>> toward / away from the user while streaming. Can't easily identify
>>> drivers that don't support it.
>>> 
>>> 5) Use some reserved bits from the v4l2_input structure (or possibly the
>>> status word but that is normally only valid for current input)
>>> Pros: Less overhead than controls. Could support multiple sensors in one
>>> camera if such a beast exists.
>> 
>> What does exist is devices with a video input (e.g. composite) and a camera 
>> input: each input will have different flags. Since these vflip/hflip 
>> properties do not change they can be enumerated in advance and you know 
>> what each input supports.
>> 
>>> Cons: Would require polling to support the case of a camera being turned
>>> toward / away from the user while streaming.
>> 
>> Polling applies only to the bits that tell the orientation of the camera. 
>> See below for a discussion of this.
>> 
>
> Didn't we agree to separate orietation (as in sensor mounted upside down) and 
> the user being able to rotate the camera (which i believe we called 
> pivotting).
>
> For the orientation case, which is the case with the sq905X, we do not need 
> to poll, as for pivotting, here is my proposal:
>
> Have both orientation and pivotting flags in the input flags. The pivotting 
> flags will indicate the pivotting state at the moment of doing the ioctl 
> (which may change later), so these indeed may need to be polled, unlike the 
> orientation flags which will never change.
>
>>> Can't easily identify drivers that don't support it.
>> 
>> Not too difficult to add through the use of a capability bit. Either in 
>> v4l2_input or (perhaps) v4l2_capability.
>> 
>
> +1
>
>> Another Pro is that this approach will also work for v4l2_output in the 
>> case of, say, rotated LCD displays. Using camera orientation bits in 
>> v4l2_buffer while capturing will work, but using similar bits for output 
>> will fail since the data is going in the wrong direction.
>> 
>>> The interest in detecting if a driver provides this informnation is to
>>> allow libv4l to know when it should use the driver provided information
>>> and when it should use its internal table (which needs to be retained for
>>> backward compatibility). With no detection capability the driver provided
>>> info should be ignored for USB IDs in the built in table.
>>> 
>>> Thoughts please
>> 
>> Is polling bad in this case? It is not something that needs immediate 
>> attention IMHO.  The overhead for checking once every X seconds is quite
>> low.
>
> Agreed, but it still is something which should be avoided if possible, 
> implementing polling also means adding a lot of IMHO unneeded code on the 
> userspace side.
>
> I would prefer to make the "realtime" pivotting state available to the app by 
> adding flags containing the pivotting state at frame capture to the v4l2_buf 
> flags.
>
> But if people dislike this, libv4l can simple poll the input now and then.
>
>> Furthermore, it is only needed on devices that cannot do v/hflipping in 
>> hardware.
>> 
>
> Erm, no, since we decided we want to differentiate between sensor orientation 
> and camera pivotting, I think the driver should not automagically do 
> v/hflipping in the pivot case, this should be left up to userspace. Maybe the 
> user actually wants to have an upside down picture ?
>
>> An alternative is to put some effort in a proper event interface. There is 
>> one implemented in include/linux/dvb/video.h and used by ivtv for video 
>> decoding. The idea is that the application registers events it wants to 
>> receive, and whenever such an event arrives the select() call will exit 
>> with a high-prio event (exception). The application then checks what 
>> happened.
>> 
>
> No not another event interface please. Once could argue that we should export 
> the pivotting info through the generic linux input system, but not a v4l 
> specific event interface please. Actually I think making the pivotting sensor 
> available through the generic input system in addition to making it available 
> through input flags would be nice to have. Just like we need to make all 
> those take a picture now buttons on webcams available through the generic 
> input system.
>
> Regards,
>
> Hans
>

Hans and Adam,

I am not sure how it fits into the above discussion, but perhaps it is 
relevant to point out that flags can be toggled. Here is what I mean:

Suppose that we have two flags 01 and 10 (i.e. 2), and 01 signifies VFLIP 
and 10 signifies HFLIP.

Then for an "ordinary" camera in ordinary position 
these are initialized as 00. If the "ordinary" camera is turned in some 
funny way (and it is possible to know that) then one or both of these 
flags gets turned off.

But if it is a "funny" camera like some of the SQ905s the initial values 
are 1 and 1, because the sensor is in fact mounted upside down. Now, 
suppose that there is some camera in the future which, just like this, has 
the sensor upside down, and suppose that said hypothetical camera also has 
the ability to "know" that it has been turned over so what was upside down 
is now right side up. Well, all  that one has to do is to flip the two 
bits from whatever they were to have instead the opposite values!

Observe that this would take care of the orientation problem both for 
cameras which had the sensor mounted right in the first place, and for 
cameras which had the sensor mounted wrong in the first place. Just use 
the same two bits to describe the sensor orientation, and if there is any 
reason (based upon some ability to know that the camera orientation is now 
different) that the orientation should change, then just flip the bits as 
appropriate.

Then it would be the job of the support module to provide proper initial 
values only for these bits, and everything else could be done later on, in 
userspace.

Theodore Kilgore
