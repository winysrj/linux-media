Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3873 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab2K3KTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Nov 2012 05:19:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.8] Update MAINTAINERS file
Date: Fri, 30 Nov 2012 11:18:29 +0100
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	Michael Hunold <michael@mihu.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201211301118.30035.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This updates the MAINTAINERS file with all the drivers I'm supporting/maintaining
or do odd fixes for.

Regards,

	Hans

The following changes since commit d8658bca2e5696df2b6c69bc5538f8fe54e4a01e:

  [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check (2012-11-28 10:54:46 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git maintainers

for you to fetch changes up to 2541f79d3d149e0a520e98285c4062216348e121:

  MAINTAINERS: add si470x-usb+common and si470x-i2c entries. (2012-11-30 11:15:18 +0100)

----------------------------------------------------------------
Hans Verkuil (18):
      MAINTAINERS: add adv7604/ad9389b entries.
      MAINTAINERS: add cx2341x entry.
      MAINTAINERS: add entry for the quickcam parallel port webcams.
      MAINTAINERS: add radio-keene entry.
      MAINTAINERS: add radio-cadet entry.
      MAINTAINERS: add radio-isa entry.
      MAINTAINERS: add radio-aztech entry.
      MAINTAINERS: add radio-aimslab entry.
      MAINTAINERS: add radio-gemtek entry.
      MAINTAINERS: add radio-maxiradio entry.
      MAINTAINERS: add radio-miropcm20 entry.
      MAINTAINERS: add pms entry.
      MAINTAINERS: add saa6588 entry.
      MAINTAINERS: add usbvision entry.
      MAINTAINERS: add vivi entry.
      MAINTAINERS: Taking over saa7146 maintainership from Michael Hunold.
      MAINTAINERS: add tda9840, tea6415c and tea6420 entries.
      MAINTAINERS: add si470x-usb+common and si470x-i2c entries.

 MAINTAINERS |  170 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 168 insertions(+), 2 deletions(-)
