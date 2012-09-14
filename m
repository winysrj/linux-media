Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:43207 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2INK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:57:54 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBV013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:52 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 00/31] Full series of API fixes from the 2012 Media Workshop
Date: Fri, 14 Sep 2012 12:57:15 +0200
Message-Id: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the full patch series containing API fixes as discussed during the
2012 Media Workshop.

Regarding the 'make ioctl const' patches: I've only done the easy ones in
this patch series. The remaining write-only ioctls are used much more widely,
so changing those will happen later.

The last few patches that enhance the core code with more stringent tests
against what ioctls can be called for which types of device node will need
reviewing. I have tested it exhaustively with ivtv (which is one of the
most complex drivers, and the only one that has exotic devices like VBI
out).

To use v4l2-compliance with ivtv I also needed to make a few other fixes
elsewhere. The tree with both this patch series and the addition ivtv fixes
can be found here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/ivtv

I have also tested this patch series (actually a slightly older version)
with em28xx. That driver needed a lot of changes to get it to pass the
v4l2-compliance tests. Those can be found here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/em28xx

Changes since RFCv2:

- Rebased to the latest v3.7.
- Fixed some reported typos
- bus_info now requires platform: as prefix for platform devices.
  (patch 05/31)
- Updated vivi and mem2mem_testdev accordingly. (06/31)
- Add feature removal for V4L2_(IN|OUT)_CAP_CUSTOM_TIMINGS. (13/31)
- More improvements to common.xml (patch 14/31): there was a lot there
  that made no sense. I'm sure there is a lot more that can be cleaned up
  in the text, but that's a project in itself.
- Improved the core handling of ENUMSTD and G_PARM for devices where some
  inputs are SDTV and others HDTV (tvnorms will be 0 if the HDTV input is
  the current input). (11/31)
- Extended patch 10/31 to the ENUM functions: those too can return -ENODATA.
- Needed to adapt radio-tea5777.c to the new vidioc_s_freq_hw_seek const
  argument (patch 21/31).

I had hoped to make a pull request, but there are too many changes since RFCv2.
Any patches not referenced above did not have significant changes.

Comments are welcome.

Regards,

        Hans

