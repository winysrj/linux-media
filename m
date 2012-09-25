Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:37137 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab2IYL46 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 07:56:58 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id q8PBuv7P010017
	for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 11:56:57 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] Add missing vidioc-subdev-g-edid.xml.
Date: Tue, 25 Sep 2012 13:56:34 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251356.34176.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

As requested!

Regards,

	Hans

The following changes since commit 4313902ebe33155209472215c62d2f29d117be29:

  [media] ivtv-alsa, ivtv: Connect ivtv PCM capture stream to ivtv-alsa interface driver (2012-09-18 13:29:07 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git docfix

for you to fetch changes up to 369832c0cb2cd8df37d4854997d31978a286348e:

  DocBook: add missing vidioc-subdev-g-edid.xml. (2012-09-25 13:54:34 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      DocBook: add missing vidioc-subdev-g-edid.xml.

 Documentation/DocBook/media/v4l/v4l2.xml                 |    1 +
 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml |  152 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
