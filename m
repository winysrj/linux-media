Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:55720 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab3A2I45 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 03:56:57 -0500
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id r0T8utEd006764
	for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 08:56:55 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.9] Move cx2341x from media/i2c to media/common
Date: Tue, 29 Jan 2013 09:56:20 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301290956.20849.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The cx2341x module is a helper module for conexant-based MPEG encoders.
It isn't an i2c module at all, instead it should be in common since it is
used by 7 pci and usb drivers to handle the MPEG setup.
    
It also shouldn't be visible in the config menu as it is always
selected automatically by those drivers that need it.

This pull request moves it to the right directory.

Regards,

	Hans

The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

  Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git cx2341x

for you to fetch changes up to 15ee97480694257081933f3f78666de1c88eec5e:

  cx2341x: move from media/i2c to media/common (2013-01-29 09:47:49 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      cx2341x: move from media/i2c to media/common

 drivers/media/common/Kconfig                    |    1 +
 drivers/media/common/Makefile                   |    2 +-
 drivers/media/common/cx2341x/Kconfig            |    2 ++
 drivers/media/common/cx2341x/Makefile           |    1 +
 drivers/media/{i2c => common/cx2341x}/cx2341x.c |    0
 drivers/media/i2c/Kconfig                       |   14 --------------
 drivers/media/i2c/Makefile                      |    1 -
 7 files changed, 5 insertions(+), 16 deletions(-)
 create mode 100644 drivers/media/common/cx2341x/Kconfig
 create mode 100644 drivers/media/common/cx2341x/Makefile
 rename drivers/media/{i2c => common/cx2341x}/cx2341x.c (100%)
