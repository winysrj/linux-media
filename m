Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42577 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbbEFPYv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 11:24:51 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NNX00HU8PHDE4B0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 May 2015 16:24:49 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTPA id <0NNX000R3PHC4420@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 May 2015 16:24:48 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] mem2mem changes for v4.2
Date: Wed, 06 May 2015 17:24:47 +0200
Message-id: <"0d8701d08810$ca4b6f60$5ee24e20$@debski"@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 1555f3bf5cc172e7d23c2b8db10d656d15bec13e:

  [media] saa7164: fix compiler warning (2015-05-01 09:09:58 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-4.2

for you to fetch changes up to 4fd781a3dfeac6b98e8aabfbbab73627ea6c9958:

  s5p-mfc: Set last buffer flag (2015-05-06 17:22:51 +0200)

----------------------------------------------------------------
Krzysztof Kozlowski (4):
      media: platform: exynos-gsc: Constify platform_device_id
      media: platform: exynos4-is: Constify platform_device_id
      media: platform: s3c-camif: Constify platform_device_id
      media: platform: s5p: Constify platform_device_id

Peter Seiderer (1):
      videodev2: Add V4L2_BUF_FLAG_LAST

Philipp Zabel (4):
      DocBook media: document codec draining flow
      videobuf2: return -EPIPE from DQBUF after the last buffer
      coda: Set last buffer flag and fix EOS event
      s5p-mfc: Set last buffer flag

 Documentation/DocBook/media/v4l/io.xml             |   12 +++++++++
 .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |   12 ++++++++-
 .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |   10 +++++++-
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |    8 ++++++
 drivers/media/platform/coda/coda-bit.c             |    4 +--
 drivers/media/platform/coda/coda-common.c          |   27
++++++++------------
 drivers/media/platform/coda/coda.h                 |    3 +++
 drivers/media/platform/exynos-gsc/gsc-core.c       |    2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |    2 +-
 drivers/media/platform/s3c-camif/camif-core.c      |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    3 ++-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |    2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   10 +++++++-
 drivers/media/v4l2-core/videobuf2-core.c           |   19 +++++++++++++-
 include/media/videobuf2-core.h                     |   13 ++++++++++
 include/trace/events/v4l2.h                        |    3 ++-
 include/uapi/linux/videodev2.h                     |    2 ++
 18 files changed, 107 insertions(+), 29 deletions(-)

