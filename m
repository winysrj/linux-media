Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3625 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbaCKMoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 08:44:17 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id s2BCiE2A008507
	for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 13:44:16 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 74D632A1889
	for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 13:44:12 +0100 (CET)
Message-ID: <531F04FA.2060907@xs4all.nl>
Date: Tue, 11 Mar 2014 13:43:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] DocBook fixes and a new pci skeleton driver
 template
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series adds a bunch of docbook fixes, posted here earlier:

http://www.spinics.net/lists/linux-media/msg74059.html

and it adds a pci skeleton driver originally written for FOSDEM 2014 and
posted earlier here:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/75338

No existing drivers are changed, just docbook modifications and a new template
driver.

For the ELC this year I hope to create a USB skeleton driver.

Regards,

	Hans

The following changes since commit 4a1df5e8f6712df3b5f8aeb09771a1169ddd8e8c:

  [media] s2255drv: memory leak fix (2014-03-11 09:28:31 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git docbook

for you to fetch changes up to baedfa602a02b0935a15fcdbef6ac9a65e957bb2:

  v4l2-pci-skeleton: add a V4L2 PCI skeleton driver (2014-03-11 13:38:02 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
      DocBook media: update STREAMON/OFF documentation.
      DocBook: fix incorrect code example
      DocBook media: clarify v4l2_buffer/plane fields.
      DocBook media: fix broken FIELD_ALTERNATE description.
      DocBook media: clarify v4l2_pix_format and v4l2_pix_format_mplane fields
      v4l2-pci-skeleton: add a V4L2 PCI skeleton driver

 Documentation/DocBook/media/v4l/dev-osd.xml         |  22 +-
 Documentation/DocBook/media/v4l/io.xml              |  61 +++--
 Documentation/DocBook/media/v4l/pixfmt.xml          |  33 ++-
 Documentation/DocBook/media/v4l/vidioc-streamon.xml |  28 +-
 drivers/media/pci/Kconfig                           |   1 +
 drivers/media/pci/Makefile                          |   2 +
 drivers/media/pci/skeleton/Kconfig                  |  11 +
 drivers/media/pci/skeleton/Makefile                 |   1 +
 drivers/media/pci/skeleton/v4l2-pci-skeleton.c      | 912 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 1025 insertions(+), 46 deletions(-)
 create mode 100644 drivers/media/pci/skeleton/Kconfig
 create mode 100644 drivers/media/pci/skeleton/Makefile
 create mode 100644 drivers/media/pci/skeleton/v4l2-pci-skeleton.c
