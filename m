Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:36117 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbcB2KQr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 05:16:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund+renesas@ragnatech.se
Subject: [PATCH 0/2] v4l2-ioctl: cropcap improvements
Date: Mon, 29 Feb 2016 11:16:38 +0100
Message-Id: <1456741000-39069-1-git-send-email-hverkuil@xs4all.nl>
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

Hans Verkuil (2):
  v4l2-ioctl: simplify code
  v4l2-ioctl: improve cropcap handling

 drivers/media/v4l2-core/v4l2-ioctl.c | 71 +++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 26 deletions(-)

-- 
2.7.0

