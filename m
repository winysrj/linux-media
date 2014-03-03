Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3705 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbaCCOoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 09:44:00 -0500
Message-ID: <53149518.3060609@xs4all.nl>
Date: Mon, 03 Mar 2014 15:43:36 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: V4L2 and frames vs fields
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've been testing and looking at how V4L2 should handle fields. The spec is awfully
vague when it comes to the V4L2_FIELD_TOP/BOTTOM/ALTERNATE field settings, so I'm
writing this down as a clarification, also for Devin who asked me about this a few
days ago and since I gave him the wrong answer I'd better get it right this time :-)

The relevant section on fields in the spec is here:

http://hverkuil.home.xs4all.nl/spec/media.html#field-order

For field formats where both fields are used the spec is reasonably clear. The
v4l2_format height field refers to the full frame height (combining both fields).

For the TOP/BOTTOM/ALTERNATE setting the format's height refers to that of the
field, not the frame. So the resulting buffer size is still height * bytesperline.

Drivers can use several strategies on how to handle this:

Some support only one field setting: INTERLACED if height > frameheight / 2 and
TOP if height <= frameheight / 2. In this case the application cannot change the
field, it is set by the driver based on the height chosen by the application.

The reverse is also possible: the driver allows you to change the field but not
the height. So INTERLACED will give a height of 576 and TOP a height of 288.

If there is a hardware scaler as well, then changing the field setting must not
change the format's height, instead the scaler is adjusted. So if the height
is 576 and the field is TOP, then the image will be scaled up by a factor of 2.

If there are limitations in what the scaler can do (say it can only downscale)
then it depends on the height which field values are honored. So attempts to
set FIELD_TOP if the height is 576 and only a downscaler is available should
result in FIELD_INTERLACE and an unchanged height. Only at heights <= 288 will
the FIELD_TOP setting work.

When implementing FIELD_ANY drivers can choose to select FIELD_TOP (or BOTTOM)
if the height <= frameheight / 2 instead of FIELD_INTERLACED.

The description of FIELD_ALTERNATE in the spec has this phrase: "Image sizes
refer to the frame, not fields." That seems nonsense to me and none of the
drivers that support FIELD_ALTERNATE does that. If any of FIELD_TOP, BOTTOM
or ALTERNATE is selected the width, height and sizeimage fields all relate
to the size of a (possibly scaled) field.

I plan on updating the spec, but I'd like to run this by you all to see if
I missed anything or got it wrong after all.

Regards,

	Hans
