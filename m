Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45880 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633AbcCUIsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 04:48:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 0/2] v4l2-ioctl: cropcap improvements
Date: Mon, 21 Mar 2016 09:47:58 +0100
Message-Id: <1458550080-42743-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The first patch just simplifies the logic in the code and makes no
functional changes.

The second patch improves the vidioc_cropcap handling with respect to
obtaining the pixel aspect ratio.

It was a bit buggy which I realized after reviewing the new rcar-vin driver.

Regards,

	Hans

Changes for v2:

- Added a sanity check for ops->vidioc_cropcap. While it shouldn't be NULL
  (determine_valid_ioctls() guards against that), it is not obvious from the
  code and since determine_valid_ioctls() is in a different source as well
  there is too much chance for someone to mess this up. I feel happier with
  a check in place.

Hans Verkuil (2):
  v4l2-ioctl: simplify code
  v4l2-ioctl: improve cropcap handling

 drivers/media/v4l2-core/v4l2-ioctl.c | 78 ++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 26 deletions(-)

-- 
2.7.0

