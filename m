Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46337 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbDJUkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 16:40:32 -0400
Date: Fri, 10 Apr 2015 15:40:29 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, <hverkuil@xs4all.nl>
CC: <prabhakar.csengg@gmail.com>
Subject: dual-duty capture driver bridge and sub-device
Message-ID: <20150410204029.GD24270@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am wondering if there already example of V4L2 capture drivers which
can be used as either stand-alone bridge driver or as a sub-device to
another bridge driver based on configuration.

I am looking for some example I could use as a starting point.

Given the following entities:

- S  :: CSI2 sensor
- Cs :: CSI2 capture engine
- Cp :: Parallel capture engine

Here is the scenarios I have:

Case #1:
	S => Cs
	Here Cs connect to S. Cs advertises video node.

	Driver Connectivity is established through DT using the
	v4l2-asynchronous registration method.

Case #2:
	S => Cs => Cp
	Here Cs connect to S and Cp connects to Cs.
	Cp advertises a video node.
	In this case Cs appears as a "sensor" to Cp.

	Driver Connectivity is established through DT using the
	v4l2-asynchronous registration method.

I would guess that the difficulty here would be within the Cs driver
to setup the appropriate V4L2 device registration based on how DT
is setup.

If anyone as any example of this type, I would appreciate a few
pointers/ideas or examples.

Regards,
Benoit
