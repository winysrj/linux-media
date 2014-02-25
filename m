Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3711 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaBYKQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com
Subject: [RFCv1 PATCH 00/13] core, vivi and mem2mem_testdev fixes
Date: Tue, 25 Feb 2014 11:15:50 +0100
Message-Id: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series builds on the vb2 PART 2 patch series that was just
posted.

It's a bit of a mix:

Patch 1 adds some core sanity checks for CREATE_BUFS.

Patch 2 fixes a bug I found while testing overlay support, and in particular
with the VIDIOC_G_FMT ioctl and struct v4l2_window. Too many fields are
cleared by the core since v4l2_window has some user pointers. This bug
made it impossible to retrieve the clip list and the bitmap (if any).

Patch 3 fixes a bug in a code example in docbook.

Patch 4 fixes a vivi bug in the ENUM_FRAMEINTERVALS handling, which caused
v4l2-compliance to fail.

Patches 5 and 6 are pure RFC: they need some code cleanup in particular, but I
think they are interesting enough to warrant posting them. Patch 5 adds
multiplanar support to vivi (use the multiplanar=1 module option) and patch 6
adds overlay support. I used these new changes for testing these features.

Patches 7-13 fix various bugs in mem2mem_testdev found with v4l2-compliance.

How about renaming mem2mem_testdev to e.g. vim2m or vimem2mem? It's a terrible
name to type...

Regards,

	Hans

