Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37960 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZBPLMc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 06:12:32 -0500
Date: Mon, 16 Feb 2009 08:11:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Trent Piepho <xyzzy@speakeasy.org>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
Message-ID: <20090216081143.05dafb14@pedra.chehab.org>
In-Reply-To: <49993563.80607@redhat.com>
References: <53216.62.70.2.252.1234775259.squirrel@webmail.xs4all.nl>
	<49993563.80607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Feb 2009 10:44:03 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> I've discussed this with Laurent Pinchart (and other webcam driver authors) and 
> the conclusion was that having a table of USB-ID's + DMI strings in the driver, 
> and design an API to tell userspace to sensor is upside down and have code for 
> all this both in the driver and in userspace makes no sense. Esp since such a 
> table will probably be more easy to update in userspace too. So the conclusion 
> was to just put the entire table of cams with known upside down mounted sensors 
> in userspace. This is currently in libv4l and making many philips webcam users 
> happy (philips has a tendency to mount the sensor upside down).

Are you saying that you have a table at libv4l for what cameras have sensors
flipped? This is really ugly and proofs that the api is broken. No userspace
application or library should need to do any special hack based on usb id,
driver name or querycap names. All needed info should be provided via the
kernel to userspace API. Is there any other case where you need to do such
hacks at userspace?

In the case of flipping, kernel should provide this info for userspace, at
least for the cameras it knows it is flipped (based on USB ID or any other
method). In the case of DMI, it seems ok to let userspace to use the kernel DMI
support to read this info and detect if the sensor were mounted flipped on a
notebook, but for those cams where such info is known based on USB ID, we need
to have an interface to read this information. I can see some ways for doing it:

1) via VIDIOC_QUERYCAP capabilities flag;
2) via VIDIOC_*CNTL read-only interfaces;
3) another ioctl for querying the webcam capabilities;
4) some info via sysfs interface;

IMO, the easier and more adequate way for this case is creating an enumbered
control. Something like:

#define V4L2_CID_MOUNTED_ANGLE    (V4L2_CID_CAMERA_CLASS_BASE+17)

enum v4l2_mounted_angle {
	V4L2_CID_MOUNTED_ANGLE_0_DEGREES = 0,
	V4L2_CID_MOUNTED_ANGLE_90_DEGREES = 1,
	V4L2_CID_MOUNTED_ANGLE_180_DEGREES = 2,
	V4L2_CID_MOUNTED_ANGLE_270_DEGREES = 3,
	V4L2_CID_MOUNTED_ANGLE_VIA_DMI = 4,
};

Of curse, the mounted angle is read-only.

This solves the static case.

We need to discuss more the dynamic case, if this is needed by some device.

Cheers,
Mauro
