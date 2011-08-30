Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:64867 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1H3LGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 07:06:12 -0400
Received: from ultra.eu.tandberg.int ([10.47.1.15])
	by ams-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p7UB5vrf028979
	for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 11:05:57 GMT
Received: from cobaltpc1.localnet ([10.54.77.72])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p7UB5tt7006204
	for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 13:05:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.2] Two small fixes and more -ENOTTY fixes
Date: Tue, 30 Aug 2011 13:05:56 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301305.56802.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two small fixes that fix v4l2-compliance errors in vivi and ivtv, and one
larger fix that fixes some remaining v4l2-compliance errors with regards to 
ENOTTY handling.

This has been posted before:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg35415.html

But it received no comments, so it's time to merge this.

Regards,

	Hans

The following changes since commit 69d232ae8e95a229e7544989d6014e875deeb121:

  [media] omap3isp: ccdc: Use generic frame sync event instead of private 
HS_VS event (2011-08-29 12:38:51 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git enottyv2

Hans Verkuil (3):
      vivi: fill in colorspace.
      ivtv: fill in service_set.
      v4l2-ioctl: more -ENOTTY fixes

 drivers/media/video/ivtv/ivtv-ioctl.c |   15 ++-
 drivers/media/video/v4l2-ioctl.c      |  206 
+++++++++++++++++++++++----------
 drivers/media/video/vivi.c            |   10 ++
 3 files changed, 165 insertions(+), 66 deletions(-)
