Return-path: <mchehab@gaivota>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1594 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0L2Q4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 11:56:39 -0500
Received: from durdane.localnet (marune.xs4all.nl [82.95.89.49])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBTGubY4091701
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 17:56:37 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.38] usbvision BKL removal and cleanup
Date: Wed, 29 Dec 2010 17:56:36 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012291756.37115.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

The first patch converts usbvision to core-assisted locking, the others do
a big coding style cleanup.

I want to clean up this driver in the future, so the first step is to fix all
the coding style violations first. That way I can actually read the source code :-)

Regards,

	Hans

The following changes since commit e017301e47ff356ed52a91259bfe4d200b8a628a:
  Jean-François Moine (1):
        [media] gspca - sonixj: Bad clock for om6802 in 640x480

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git usbvision2

Hans Verkuil (4):
      usbvision: convert to unlocked_ioctl
      usbvision: get rid of camelCase.
      usbvision: convert // to /* */
      usbvision: coding style

 drivers/media/video/usbvision/usbvision-cards.c | 1860 +++++++++++-----------
 drivers/media/video/usbvision/usbvision-core.c  | 1635 ++++++++++-----------
 drivers/media/video/usbvision/usbvision-i2c.c   |   55 +-
 drivers/media/video/usbvision/usbvision-video.c |  622 ++++-----
 drivers/media/video/usbvision/usbvision.h       |  267 ++--
 5 files changed, 2137 insertions(+), 2302 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
