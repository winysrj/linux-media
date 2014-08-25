Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1099 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaHYLap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 07:30:45 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7PBUdin055867
	for <linux-media@vger.kernel.org>; Mon, 25 Aug 2014 13:30:43 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from test-media.192.168.1.1 (test [192.168.1.27])
	by tschai.lan (Postfix) with ESMTPSA id F25992A2E5A
	for <linux-media@vger.kernel.org>; Mon, 25 Aug 2014 13:30:27 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 00/12] vivid: Virtual Video Test Driver
Date: Mon, 25 Aug 2014 13:30:11 +0200
Message-Id: <1408966223-5221-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In July I posted a 'vivi, the next generation' patch series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg76758.html

However, since that time I realized that rather than building on top of the
old vivi, it would be much better to create a new, much more generic driver.
This vivid test driver no longer emulates just video capture, but also
video output, vbi capture/output, radio receivers/transmitters and SDR capture.
There is even support for testing capture and output overlays.

Up to 64 vivid instances can be created, each with up to 16 inputs and 16 outputs.

Each input can be a webcam, TV capture device, S-Video capture device or an HDMI
capture device. Each output can be an S-Video output device or an HDMI output
device.

These inputs and outputs act exactly as a real hardware device would behave. This
allows you to use this driver as a test input for application development, since
you can test the various features without requiring special hardware.

Some of the features supported by this driver are:

- Support for read()/write(), MMAP, USERPTR and DMABUF streaming I/O.
- A large list of test patterns and variations thereof
- Working brightness, contrast, saturation and hue controls
- Support for the alpha color component
- Full colorspace support, including limited/full RGB range
- All possible control types are present
- Support for various pixel aspect ratios and video aspect ratios
- Error injection to test what happens if errors occur
- Supports crop/compose/scale in any combination for both input and output
- Can emulate up to 4K resolutions
- All Field settings are supported for testing interlaced capturing
- Supports all standard YUV and RGB formats, including two multiplanar YUV formats
- Raw and Sliced VBI capture and output support
- Radio receiver and transmitter support, including RDS support
- Software defined radio (SDR) support
- Capture and output overlay support

This driver is big, but I believe that for the most part I managed to keep
the code clean (I'm biased, though). I've split it up in several parts to
make reviewing easier. The first patch is a vb2 fix I posted earlier, but
patchwork failed to pick it up (probably because it was missing a Signed-of-by
line), so I'm posting it again. The second patch is an extensive document
that describes the features currently implemented. After that the driver code
is posted and in the last patch the driver is hooked into Kconfig/Makefile.

This goal is for this to go in for 3.18, so I expect I'll likely to a v2 at
least since I am still improving the driver and it will be a while before
we can merge code for v3.18.

As far as I am concerned the vivi driver can be removed once this driver is
merged.

Two questions which I am sure will be raised by reviewers:

1) Why add support for capture and output overlays? Isn't that obsolete?

First of all, we have drivers that support it and it is really nice to be
able to test whether it still works. I found several issues, some in the core,
when it comes to overlay support, so at the very least it will help to
prevent regressions until the time comes that we actually remove this API.

Secondly, this driver was created not just to help applications to test their
code, but also to help in understanding and verifying the API. In order to do
that you need to be able to test it. Which is difficult since hardware that
supports this is rare.

I have mentioned in the documentation that the overlay support is there
primarily for API testing and that its use in new drivers is questionable.

2) Why add video loop support, doesn't that make abuse possible?

I think video loop support is a great feature as it allows you to test
video output since without it you have no idea what the video you give to
the driver actually looks like. So just from the perspective of testing your
application I believe this is an essential feature.

There are a few reasons why I think that this is unlikely to lead to abuse:

- the video loop functionality has to be enabled explicitly via a control of
  the video output device.
- the video capture and output resolution and formats have to match exactly
- by default the OSD text will be placed over the looped video. This can be
  turned off via a control of the video capture device.
- the number of resolutions is currently fixed to SDTV and the CEA-861 and
  VESA DMT timings. So 'random' resolutions are not supported. Although to
  be fair, this is something I intend to add. However, if I do that then I
  will require that the configured DV timings of the input and output are
  identical before the video loop is possible.

Taken altogether I do not think this is something that lends itself easily
for abuse since this won't work out-of-the-box.

Regards,

	Hans

Changes since v1:

- Fixed 'sinus/cosinus' typo to sine/cosine.
- Various fixes all over the place.
- Moved all controls relating to test patterns, error injection, etc. to
  the 'Vivid Controls' control class.
- Rebased to v3.17-rc1.

