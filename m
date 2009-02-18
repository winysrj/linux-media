Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:39835
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbZBRAbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 19:31:00 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: linux-media@vger.kernel.org
Subject: [RFC] How to pass camera Orientation to userspace
Date: Wed, 18 Feb 2009 00:30:52 +0000
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	kilgota@banach.math.auburn.edu,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902180030.52729.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(linux-omap included in distribution as lots of omap systems include cameras 
so this could be relevant there.)

Background

A number of the webcams now supported by v4l have sensors that are mounted 
upside down. Up to now this has been handled by having a table in libv4l of 
the USB IDs of affected cameras. This approach however fails to address two 
known cases (and probably more as yet unknown ones) where the USB ID is 
insufficient to determine the sensor orientation.

In one of those cases (SQ-905) USB commands must be issued to the camera  at 
probe time) to determine what sensor is fitted and in the other case (Genesys 
gl860) the camera can be pointed towards or away from the user and it swaps 
orientation when it is changed.

It is possible that there are cameras that can use gravity sensors or similar 
to report how they are being held but such user driven orientation which may 
be intended for creative effect should probably be separated from this 
hardware related issue.

Most if not all of the cameras affected by this problem produce video formats 
that are not widely supported by applications. They are therefore all likely 
to be normally used in conjunction with libv4l to perform format conversion 
and so it makes sense to retain the actual flipping operation in libv4l. 
libv4l provides a capability via LD_PRELOAD to attach itself to unmodified 
binaries.

It is likely that whatever solution is chosen there will end up being cases 
that have to be handled in libv4l as external information (such as laptop 
model ID) is the only mechanism to distinguish otherwise identical cameras.

So far libv4l only supports the case of data needing a 180 degree rotation but 
there is known to exist hardware which requires a VFLIP and it is possible 
some hardware requires just HFLIP so all of those cases should be supported.

There have been a number of inconclusive discussions on this subject on the 
v4l / linux-media mailing lists over the last few months offering many 
options for how to pass this information across which I will list below and 
hopefully a preferred solution can be selected from them

1) Reuse the existing HFLIP and VFLIP controls, marking them as read-only
Pros : No change needed to videodev2.h
Cons: It is confusing to have controls that have a subtly different meaning if 
they are read only. Existing apps that support those controls might get 
confused. Would require polling to support the case of a camera being turned 
toward / away from the user while streaming.

2) Introduce a new orientation control (possibly in a new CAMERA_PROPERTIES 
class)
Pros: libv4l can easily tell if the driver supports the control.
Cons: It is really a property, not a control so calling it a control is wrong. 
Controls add lots of overhead in terms of driver code. Would require polling 
to support the case of a camera being turned toward / away from the user 
while streaming.

3) Use an extra couple of bits in V4L2_BUF_FLAGS
Pros: Simple to implement. Can change per frame without needing polling.
Cons: Doesn't work for non libv4l apps that try to use the read() interface. 
Can't easily identify drivers that don't support it (does 0 mean not rotated 
or just not implemented). Can only be read when streaming (does that matter?)

4) Use some reserved bits from the v4l2_capability structure
Pros: Less overhead than controls.
Cons: Would require polling to support the case of a camera being turned 
toward / away from the user while streaming. Can't easily identify drivers 
that don't support it.

5) Use some reserved bits from the v4l2_input structure (or possibly the 
status word but that is normally only valid for current input)
Pros: Less overhead than controls. Could support multiple sensors in one 
camera if such a beast exists.
Cons: Would require polling to support the case of a camera being turned 
toward / away from the user while streaming. Can't easily identify drivers 
that don't support it.

The interest in detecting if a driver provides this informnation is to allow 
libv4l to know when it should use the driver provided information and when it 
should use its internal table (which needs to be retained for backward 
compatibility). With no detection capability the driver provided info should 
be ignored for USB IDs in the built in table.

Thoughts please

Adam Baker
