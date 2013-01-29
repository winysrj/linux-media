Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:42934 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3A2Jfa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 04:35:30 -0500
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r0T9ZSKS006821
	for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 09:35:28 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] tuner-core: map audmode to STEREO for radio devices.
Date: Tue, 29 Jan 2013 10:34:54 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301291034.54174.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

While cleaning up my outstanding git branches I came across this fix.

We discussed this here:

https://patchwork.kernel.org/patch/1457221/

And then I posted an RFCv2:

https://patchwork.kernel.org/patch/1518751/

Unfortunately, I forgot about it and never posted a pull request. So I've
rebased it and I am posting it now. The patch is unchanged from the RFCv2
patch.

Regards,

	Hans

The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

  Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git audmodefix

for you to fetch changes up to d5241f34f323a81c9fe5c23fa2b8436adfe1a716:

  tuner-core: map audmode to STEREO for radio devices. (2013-01-29 10:28:32 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      tuner-core: map audmode to STEREO for radio devices.

 drivers/media/v4l2-core/tuner-core.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)
