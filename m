Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1027 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1LOOPu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 09:15:50 -0500
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id pBFEFl2j010393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 15:15:49 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 304F211C043D
	for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 15:15:41 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 0/8] Add decoder API to V4L2
Date: Thu, 15 Dec 2011 15:15:29 +0100
Message-Id: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the third version of the new decoder API.

The second version is here:

http://www.spinics.net/lists/linux-media/msg40474.html

The main changes are:

- The DVB API is left untouched. So this series only makes changes to the
  V4L2 subsystem. DVB is just too depressing to propose any changes there.

- The V4L2_CID_MPEG_STREAM_DEC_PTS control has been renamed to
  V4L2_CID_MPEG_VIDEO_DEC_PTS since it is the PTS from the video elementary
  stream. The documentation of this control has been improved as well.

- Note that the 'old' VIDEO_GET_PTS ioctl was also used in ivtv to return
  the PTS of the encoded video/audio. For an MPEG stream that was unnecessary
  (since the stream itself already contains those time stamps), but for the
  YUV and PCM streams that was useful in the past to do A/V synchronization.

  However, the current firmware seems to sync the YUV and PCM streams correctly
  (as far as I can remember), so I decided not to create V4L2 counterparts for
  this. I'm not aware of any application that uses this anyway.

Regards,

	Hans

