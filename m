Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:62239 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3ATVPQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 16:15:16 -0500
Received: by mail-ea0-f179.google.com with SMTP id d12so1368460eaa.10
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2013 13:15:15 -0800 (PST)
Message-ID: <50FC5E87.2080902@googlemail.com>
Date: Sun, 20 Jan 2013 22:15:51 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: V4L2 spec / core questions
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I noticed that there's code in the v4l2 core that enables/disables
ioctls and checks some of the parameters depending on the device type.
While reading the code an comparing it to the V4L2 API document, some
more questions came up:

1) Video devices with VBI functionality:
The spec says: "To address the problems of finding related video and VBI
devices VBI capturing and output is also available as device function
under /dev/video".
Is that still valid ? What about VBI "configuration" (e.g.
VIDIOC_G/S/TRY_FMT for VBI formats) ?
Looking into the v4l2 core code, it seems that the VBI buffer types
(field "type" in struct v4l2_format) are only accepted, if the device is
a VBI device.

2) VIDIOC_G/S/TRY_FMT and VBI devices:
The sepc says: "VBI devices must implement both the VIDIOC_G_FMT and
VIDIOC_S_FMT ioctl, even if VIDIOC_S_FMT ignores all requests and always
returns default parameters as VIDIOC_G_FMT does. VIDIOC_TRY_FMT is
optional." What's the reason for this ? Is it still valid ?

3) VIDIOC_S_TUNER: field "type" in struct v4l2_tuner
Are radio tuners accessable through video devices (and the other way
around) ?
Has this field to be set by the application ? If yes: driver overwrites
the value or returns with an error if the type doesn't match the tuner
at the requested index ?
I wonder if it would make sense to check the tuner type inside the v4l
core (like the fmt/buffer type check for G/S_PARM).

4) VIDIOC_DBG_G_CHIP_IDENT:
Is it part of CONFIG_VIDEO_ADV_DEBUG just like VIDIOC_DBG_G/S_REGISTER ?
In determine_valid_ioctls(), it is placed outside the #ifdef
CONFIG_VIDEO_ADV_DEBUG section.
The spec says "Identify the chips on a TV card" but isn't it suitable
for all device types (radio/video/vbi) ? determine_valid_ioctls() in
v4l2-dev.c enables it for all devices.

5) The buffer ioctls (VIDIOC_REQBUFS, VIDIOC_CREATE_BUFS,
VIDIOC_PREPARE_BUF, VIDIOC_QUERYBUF, VIDIOC_QBUF, VIDIOC_DQBUF) are not
applicable to radio devices, right ?
In function determine_valid_ioctls() in v4l2-dev.c they are enabled for
all device types.

6) VIDIOC_G/S_AUDIO: Shouldn't it be disabled in
determine_valid_ioctls() for VBI devices ?

Btw: function determine_valid_ioctls() in v4l2-dev.c is a good summary
that explains which ioctls are suitable for which device types
(radio/video/vbi).
Converting its content into a table would be a great
extension/clarifaction of the V4L2 API spec document !

Thanks for your patience !

Regards,
Frank


