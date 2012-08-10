Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:28691 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2HJLVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 07:21:31 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	dri-devel@lists.freedesktop.org
Subject: [RFCv3 PATCH 0/8] V4L2: add missing pieces to support HDMI et al and add adv7604/ad9389b drivers
Date: Fri, 10 Aug 2012 13:21:16 +0200
Message-Id: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the third version of this patch series. The second version can be
found here: http://www.spinics.net/lists/linux-media/msg50413.html

I made a pull request based on that and got some feedback:

http://patchwork.linuxtv.org/patch/13442/

The feedback has been incorporated in this third version.

One suggestion I got was to run this by the video devs as well so that they
can take a look at the V4L2 EDID API, just in case I missed something, so
that's why this is being cross-posted to the dri-devel mailinglist.

Note that the EDID API at the moment is only meant to pass the EDID to userspace
and vice versa. There is no parsing at the moment. If we ever need parsing in
V4L2 (and I'm sure we will) then we will of course use shared EDID parsing code.

The second patch documents the new V4L2 API additions. So that's a good one
to review when it comes to the API.

Regards,

	Hans

