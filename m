Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4507 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaAFOVf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:35 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id s06ELVJ2029346
	for <linux-media@vger.kernel.org>; Mon, 6 Jan 2014 15:21:33 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.192.168.1.1 (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5BF3F2A009A
	for <linux-media@vger.kernel.org>; Mon,  6 Jan 2014 15:21:27 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 00/27] Add property & configuration store support
Date: Mon,  6 Jan 2014 15:20:59 +0100
Message-Id: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for properties, matrices and configuration
stores to the control framework.

See this RFCv2 for a more detailed discussion:

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/71822

Changes since that RFCv2 are:

- I dropped the 'property' bit in the control ID, instead a new flag is
  added: V4L2_CTRL_FLAG_PROPERTY.
- A V4L2_CTRL_FLAG_IS_PTR flag is added to simplify applications: if set, then
  applications need to use the 'p' field instead of 'val' or 'val64'. This can
  be deduced from various other fields as well, but that leads to ugly code.
  This flag is cheap to set and very helpful in applications.
- Matrix types have been dropped. If cols or rows are > 1, then you have a
  matrix, so there is no need for specific matrix types.
- As a result it is no longer possible to set just a sub-rectangle of a
  matrix. It is however possible to just set the first X elements of
  a matrix/array. It became too complex to deal with the sub-rectangle,
  both in the framework, for drivers and for applications, and there are
  not enough benefits to warrant that effort.

Other than those changes this patch series implements all the ideas described
in RFCv2.

The first 21 patches are pretty definitive and the only thing missing are
the DocBook patches and a v4l2-controls.txt patch.

Before I write those I would like to get feedback for this API enhancement.
The actual API changes are surprisingly small, and most of the work done in
the patches has more to do with data structure changes needed to simplify
handling the more complex control types than with actual new code.

Patch 22 adds a new event that can deal with the new 64-bit ranges and that
adds a config_store field. However, I am not yet convinced that this is
really needed. Feedback would be welcome.

Patches 23-27 add test code for vivi to test matrices and to test the new
selection properties. This code needs more work, particularly with regards
to naming.

A working v4l2-ctl that can handle the new stuff is available here:

http://git.linuxtv.org/hverkuil/v4l-utils.git/shortlog/refs/heads/propapi

Regards,

	Hans

