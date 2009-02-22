Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbZBVLTz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 06:19:55 -0500
Message-ID: <49A13466.5080605@redhat.com>
Date: Sun, 22 Feb 2009 12:17:58 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl>
In-Reply-To: <200902211253.58061.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hans Verkuil wrote:
> Hi Adam,
> 
> Sorry for the late reply, it's been very busy.
> 

Same here :)

> On Wednesday 18 February 2009 01:30:52 Adam Baker wrote:
>> (linux-omap included in distribution as lots of omap systems include
>> cameras so this could be relevant there.)
>>
>> Background
>>
>> A number of the webcams now supported by v4l have sensors that are
>> mounted upside down. Up to now this has been handled by having a table in
>> libv4l of the USB IDs of affected cameras. This approach however fails to
>> address two known cases (and probably more as yet unknown ones) where the
>> USB ID is insufficient to determine the sensor orientation.
>>
>> In one of those cases (SQ-905) USB commands must be issued to the camera 
>> at probe time) to determine what sensor is fitted and in the other case
>> (Genesys gl860) the camera can be pointed towards or away from the user
>> and it swaps orientation when it is changed.
>>
>> It is possible that there are cameras that can use gravity sensors or
>> similar to report how they are being held but such user driven
>> orientation which may be intended for creative effect should probably be
>> separated from this hardware related issue.
> 
> Yes, I strongly agree with this.
> 

+1

>> 3) Use an extra couple of bits in V4L2_BUF_FLAGS
>> Pros: Simple to implement. Can change per frame without needing polling.
>> Cons: Doesn't work for non libv4l apps that try to use the read()
>> interface. Can't easily identify drivers that don't support it (does 0
>> mean not rotated or just not implemented). Can only be read when
>> streaming (does that matter?)
> 
> I think that matters, yes.
> 

I too can see it being usefull to get the orientation when not streaming.

>> 4) Use some reserved bits from the v4l2_capability structure
>> Pros: Less overhead than controls.
>> Cons: Would require polling to support the case of a camera being turned
>> toward / away from the user while streaming. Can't easily identify
>> drivers that don't support it.
>>
>> 5) Use some reserved bits from the v4l2_input structure (or possibly the
>> status word but that is normally only valid for current input)
>> Pros: Less overhead than controls. Could support multiple sensors in one
>> camera if such a beast exists.
> 
> What does exist is devices with a video input (e.g. composite) and a camera 
> input: each input will have different flags. Since these vflip/hflip 
> properties do not change they can be enumerated in advance and you know 
> what each input supports.
> 
>> Cons: Would require polling to support the case of a camera being turned
>> toward / away from the user while streaming.
> 
> Polling applies only to the bits that tell the orientation of the camera. 
> See below for a discussion of this.
> 

Didn't we agree to separate orietation (as in sensor mounted upside down) and 
the user being able to rotate the camera (which i believe we called pivotting).

For the orientation case, which is the case with the sq905X, we do not need to 
poll, as for pivotting, here is my proposal:

Have both orientation and pivotting flags in the input flags. The pivotting 
flags will indicate the pivotting state at the moment of doing the ioctl (which 
may change later), so these indeed may need to be polled, unlike the 
orientation flags which will never change.

>> Can't easily identify drivers that don't support it.
> 
> Not too difficult to add through the use of a capability bit. Either in 
> v4l2_input or (perhaps) v4l2_capability.
> 

+1

> Another Pro is that this approach will also work for v4l2_output in the case 
> of, say, rotated LCD displays. Using camera orientation bits in v4l2_buffer 
> while capturing will work, but using similar bits for output will fail 
> since the data is going in the wrong direction.
> 
>> The interest in detecting if a driver provides this informnation is to
>> allow libv4l to know when it should use the driver provided information
>> and when it should use its internal table (which needs to be retained for
>> backward compatibility). With no detection capability the driver provided
>> info should be ignored for USB IDs in the built in table.
>>
>> Thoughts please
> 
> Is polling bad in this case? It is not something that needs immediate 
> attention IMHO.  The overhead for checking once every X seconds is quite
 > low.

Agreed, but it still is something which should be avoided if possible, 
implementing polling also means adding a lot of IMHO unneeded code on the 
userspace side.

I would prefer to make the "realtime" pivotting state available to the app by 
adding flags containing the pivotting state at frame capture to the v4l2_buf flags.

But if people dislike this, libv4l can simple poll the input now and then.

> Furthermore, it is only needed on devices that cannot do v/hflipping 
> in hardware.
> 

Erm, no, since we decided we want to differentiate between sensor orientation 
and camera pivotting, I think the driver should not automagically do 
v/hflipping in the pivot case, this should be left up to userspace. Maybe the 
user actually wants to have an upside down picture ?

> An alternative is to put some effort in a proper event interface. There is 
> one implemented in include/linux/dvb/video.h and used by ivtv for video 
> decoding. The idea is that the application registers events it wants to 
> receive, and whenever such an event arrives the select() call will exit 
> with a high-prio event (exception). The application then checks what 
> happened.
> 

No not another event interface please. Once could argue that we should export 
the pivotting info through the generic linux input system, but not a v4l 
specific event interface please. Actually I think making the pivotting sensor 
available through the generic input system in addition to making it available 
through input flags would be nice to have. Just like we need to make all those 
take a picture now buttons on webcams available through the generic input system.

Regards,

Hans
