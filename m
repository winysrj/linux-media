Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3642 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZBULyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 06:54:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Adam Baker <linux@baker-net.org.uk>
Subject: Re: [RFC] How to pass camera Orientation to userspace
Date: Sat, 21 Feb 2009 12:53:57 +0100
Cc: linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	kilgota@banach.math.auburn.edu,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
References: <200902180030.52729.linux@baker-net.org.uk>
In-Reply-To: <200902180030.52729.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902211253.58061.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adam,

Sorry for the late reply, it's been very busy.

On Wednesday 18 February 2009 01:30:52 Adam Baker wrote:
> (linux-omap included in distribution as lots of omap systems include
> cameras so this could be relevant there.)
>
> Background
>
> A number of the webcams now supported by v4l have sensors that are
> mounted upside down. Up to now this has been handled by having a table in
> libv4l of the USB IDs of affected cameras. This approach however fails to
> address two known cases (and probably more as yet unknown ones) where the
> USB ID is insufficient to determine the sensor orientation.
>
> In one of those cases (SQ-905) USB commands must be issued to the camera 
> at probe time) to determine what sensor is fitted and in the other case
> (Genesys gl860) the camera can be pointed towards or away from the user
> and it swaps orientation when it is changed.
>
> It is possible that there are cameras that can use gravity sensors or
> similar to report how they are being held but such user driven
> orientation which may be intended for creative effect should probably be
> separated from this hardware related issue.

Yes, I strongly agree with this.

> Most if not all of the cameras affected by this problem produce video
> formats that are not widely supported by applications. They are therefore
> all likely to be normally used in conjunction with libv4l to perform
> format conversion and so it makes sense to retain the actual flipping
> operation in libv4l. libv4l provides a capability via LD_PRELOAD to
> attach itself to unmodified binaries.
>
> It is likely that whatever solution is chosen there will end up being
> cases that have to be handled in libv4l as external information (such as
> laptop model ID) is the only mechanism to distinguish otherwise identical
> cameras.
>
> So far libv4l only supports the case of data needing a 180 degree
> rotation but there is known to exist hardware which requires a VFLIP and
> it is possible some hardware requires just HFLIP so all of those cases
> should be supported.

While libv4l will be the main user of this information, it should not matter 
for the chosen API whether it is libv4l or another application, possibly a 
custom application running on an embedded system.

> There have been a number of inconclusive discussions on this subject on
> the v4l / linux-media mailing lists over the last few months offering
> many options for how to pass this information across which I will list
> below and hopefully a preferred solution can be selected from them
>
> 1) Reuse the existing HFLIP and VFLIP controls, marking them as read-only
> Pros : No change needed to videodev2.h
> Cons: It is confusing to have controls that have a subtly different
> meaning if they are read only. Existing apps that support those controls
> might get confused. Would require polling to support the case of a camera
> being turned toward / away from the user while streaming.
>
> 2) Introduce a new orientation control (possibly in a new
> CAMERA_PROPERTIES class)
> Pros: libv4l can easily tell if the driver supports the control.
> Cons: It is really a property, not a control so calling it a control is
> wrong. Controls add lots of overhead in terms of driver code. Would
> require polling to support the case of a camera being turned toward /
> away from the user while streaming.
>
> 3) Use an extra couple of bits in V4L2_BUF_FLAGS
> Pros: Simple to implement. Can change per frame without needing polling.
> Cons: Doesn't work for non libv4l apps that try to use the read()
> interface. Can't easily identify drivers that don't support it (does 0
> mean not rotated or just not implemented). Can only be read when
> streaming (does that matter?)

I think that matters, yes.

> 4) Use some reserved bits from the v4l2_capability structure
> Pros: Less overhead than controls.
> Cons: Would require polling to support the case of a camera being turned
> toward / away from the user while streaming. Can't easily identify
> drivers that don't support it.
>
> 5) Use some reserved bits from the v4l2_input structure (or possibly the
> status word but that is normally only valid for current input)
> Pros: Less overhead than controls. Could support multiple sensors in one
> camera if such a beast exists.

What does exist is devices with a video input (e.g. composite) and a camera 
input: each input will have different flags. Since these vflip/hflip 
properties do not change they can be enumerated in advance and you know 
what each input supports.

> Cons: Would require polling to support the case of a camera being turned
> toward / away from the user while streaming.

Polling applies only to the bits that tell the orientation of the camera. 
See below for a discussion of this.

> Can't easily identify drivers that don't support it.

Not too difficult to add through the use of a capability bit. Either in 
v4l2_input or (perhaps) v4l2_capability.

Another Pro is that this approach will also work for v4l2_output in the case 
of, say, rotated LCD displays. Using camera orientation bits in v4l2_buffer 
while capturing will work, but using similar bits for output will fail 
since the data is going in the wrong direction.

> The interest in detecting if a driver provides this informnation is to
> allow libv4l to know when it should use the driver provided information
> and when it should use its internal table (which needs to be retained for
> backward compatibility). With no detection capability the driver provided
> info should be ignored for USB IDs in the built in table.
>
> Thoughts please

Is polling bad in this case? It is not something that needs immediate 
attention IMHO. The overhead for checking once every X seconds is quite 
low. Furthermore, it is only needed on devices that cannot do v/hflipping 
in hardware.

An alternative is to put some effort in a proper event interface. There is 
one implemented in include/linux/dvb/video.h and used by ivtv for video 
decoding. The idea is that the application registers events it wants to 
receive, and whenever such an event arrives the select() call will exit 
with a high-prio event (exception). The application then checks what 
happened.

The video.h implementation is pretty crappy, but we can make something more 
useful. Alternatively, I believe there are other event mechanisms as well 
in the kernel. I know some work was done on that, but I don't know what the 
end result was.

Note that this does not apply to sensor mount information. I think that 
v4l2_input is the perfect place for that. It is after all an input-specific 
property and static property, and it maps 1-on-1 to the output case as 
well, should we need it there as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
