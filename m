Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63139 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1LOOnB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 09:43:01 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW9009F327MMI@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Dec 2011 14:42:59 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW900MQ827MUU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Dec 2011 14:42:58 +0000 (GMT)
Date: Thu, 15 Dec 2011 15:42:57 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.3] Alpha colour control addition
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4EEA0771.1030205@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

The following changes since commit c8c59cb5c459ff71f0592dc0716cdc2e730b20e5:

  s5p-fimc: Prevent lock up caused by incomplete H/W initialization (2011-12-14
16:02:32 +0100)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-samsung v4l_rgb_alpha

This is a new alpha colour control addition, I've applied it on top of
my s5p-fimc bugfix patches, which are already in linuxtv.org/media-next.git
GIT, except this one:
s5p-fimc: Prevent lock up caused by incomplete H/W initialization


Sylwester Nawrocki (2):
      v4l: Add new alpha component control
      s5p-fimc: Add support for alpha component configuration

 Documentation/DocBook/media/v4l/compat.xml         |   11 ++
 Documentation/DocBook/media/v4l/controls.xml       |   25 +++-
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |    7 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |   11 ++
 drivers/media/video/s5p-fimc/fimc-core.c           |  128 ++++++++++++++++----
 drivers/media/video/s5p-fimc/fimc-core.h           |   30 ++++-
 drivers/media/video/s5p-fimc/fimc-reg.c            |   53 ++++++--
 drivers/media/video/s5p-fimc/regs-fimc.h           |    5 +
 drivers/media/video/v4l2-ctrls.c                   |    1 +
 include/linux/videodev2.h                          |    6 +-
 10 files changed, 224 insertions(+), 53 deletions(-)

Best regards
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
