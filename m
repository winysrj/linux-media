Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1386 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2FHLGt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 07:06:49 -0400
Received: from alastor.dyndns.org (189.80-203-102.nextgentel.com [80.203.102.189] (may be forged))
	(authenticated bits=0)
	by smtp-vbr19.xs4all.nl (8.13.8/8.13.8) with ESMTP id q58B6ka1036858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 8 Jun 2012 13:06:47 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id B5568CDE0005
	for <linux-media@vger.kernel.org>; Fri,  8 Jun 2012 13:06:45 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] Clean up and improve zr364xx
Date: Fri, 8 Jun 2012 13:06:44 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206081306.44487.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update zr364xx to the latest frameworks (except for vb2) and add
suspend/resume support.

Tested with actual hardware on both little and big endian hosts.

Regards,

	Hans

The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24 09:27:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git zr364xx

for you to fetch changes up to d08f93c5d6b195f0c85683703c737a2b1714d9a5:

  zr364xx: add suspend/resume support. (2012-06-08 13:04:55 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      zr364xx: embed video_device and register it at the end of probe.
      zr364xx: introduce v4l2_device.
      zr364xx: convert to the control framework.
      zr364xx: fix querycap and fill in colorspace.
      zr364xx: add support for control events.
      zr364xx: allow multiple opens.
      zr364xx: add suspend/resume support.

 drivers/media/video/zr364xx.c |  484 +++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------
 1 file changed, 213 insertions(+), 271 deletions(-)
