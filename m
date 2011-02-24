Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:52907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab1BXMSl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 07:18:41 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 5AB50189B7F
	for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 13:18:39 +0100 (CET)
Date: Thu, 24 Feb 2011 13:18:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC] snapshot mode, flash capabilities and control
Message-ID: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Agenda.
=======

In a recent RFC [1] I proposed V4L2 API extensions to support fast switching
between multiple capture modes or data formats. However, this is not sufficient
to efficiently leverage snapshot capabilities of existing hardware - sensors and
SoCs, and to satisfy user-space needs, a few more functions have to be
implemented.

Snapshot and strobe / flash capabilities vary significantly between sensors.
Some of them only capture a single image upon trigger activation, some can
capture several images, readout and exposure capabilities vary too. Not all
sensors support a strobe signal, and those, that support it, also offer very
different options to select strobe beginning and duration. This proposal is
trying to select a minimum API, that can be reasonably supported by many
systems and provide a reasonable functionality set to the user.

Proposed implementation.
========================

1. Switch the interface into the snapshot mode. This is required in addition to
simply configuring the interface with a different format to activate hardware-
specific support for triggered single image capture. It is proposed to use the
VIDIOC_S_PARM ioctl() with a new V4L2_MODE_SNAPSHOT value for the
struct v4l2_captureparm::capturemode and ::capability fields. Further
hardware-specific details can be passed in ::extendedmode, ::readbuffers can be
used to specify the exact number of frames to be captured. Similarly,
VIDIOC_G_PARM shall return supported and current capture modes.

Many sensors provide the ability to trigger snapshot capture either from an
external source or from a control register. Usually, however, there is no
possibility to select the trigger source, either of them can be used at any
time.

2. Specify a flash mode. Define new capture capabilities to be used with
struct v4l2_captureparm::capturemode:

V4L2_MODE_FLASH_SYNC	/* synchronise flash with image capture */
V4L2_MODE_FLASH_ON	/* turn on - "torch-mode" */
V4L2_MODE_FLASH_OFF	/* turn off */

Obviously, the above synchronous operation does not exactly define beginning and
duration of the strobe signal. It is proposed to leave the specific flash timing
configuration to the driver itself and, possibly, to driver-specific extended
mode flags.

3. Add a sensor-subdev operation

	int (*snapshot_trigger)(struct v4l2_subdev *sd)

to start capturing the next frame in the snapshot mode.

References.
===========

[1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/29357

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
