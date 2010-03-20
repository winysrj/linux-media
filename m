Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2853 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0CTJVV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 05:21:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: Phase 2/3: Move the compat code into v4l1-compat. Convert apps.
Date: Sat, 20 Mar 2010 10:21:05 +0100
Cc: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003201021.05426.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

The second phase that needs to be done to remove the v4l1 support from the
kernel is that libv4l1 should replace the v4l1-compat code from the kernel.

I do not know how complete the libv4l1 code is right now. I would like to
know in particular whether the VIDIOCGMBUF/mmap behavior can be faked in
libv4l1 if drivers do not support the cgmbuf vidioc call.

In principle libv4l1 should allow V4L1 apps to run fine with V4L2 drivers.
That will also solve the problem of embedded device vendors running new
kernels with old V4L1 applications. They just need to use libv4l1.

The third phase that can be done in parallel is to convert V4L1-only apps.
I strongly suspect that any apps that are V4L1-only are also unmaintained.
We have discussed before that we should set up git repositories for such
tools (xawtv being one of the more prominent apps since it contains several
v4l1-only console apps). Once we have maintainership, then we can convert
these tools to v4l2 and distros and other interested parties have a place
to send patches to.

I'm afraid that it is unlikely that anyone will do that work for us, so it's
probably best just to bite the bullet and do it ourselves.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
