Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:57580 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3EWIZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 04:25:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Woodhouse <dwmw2@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [GIT PULL] go7007 firmware updates
Date: Thu, 23 May 2013 10:25:31 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Pete Eberlein <pete@sensoray.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231025.31812.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben, David,

The go7007 staging driver has been substantially overhauled for kernel 3.10.
As part of that process the firmware situation has been improved as well.

While Micronas allowed the firmware to be redistributed, it was never made
part of linux-firmware. Only the firmwares for the Sensoray S2250 were added
in the past, but those need the go7007*.bin firmwares as well to work.

This pull request collects all the firmwares necessary to support all the
go7007 devices into the go7007 directory. With this change the go7007 driver
will work out-of-the-box starting with kernel 3.10.

Regards,

	Hans

The following changes since commit 07ea598af5b9dde3acdf279846b062fa1b2987b8:

  Merge branch 'linux-firmware' of git://github.com/TI-OpenLink/firmwares (2013-05-06 14:21:49 +0100)

are available in the git repository at:


  git://linuxtv.org/hverkuil/linux-firmware.git go7007

for you to fetch changes up to 88512c918b5f7fd7f41ced07dbc59251c9215c8f:

  Add go7007 firmware. (2013-05-23 10:04:25 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      Add go7007 firmware.

 LICENCE.go7007                       |  457 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 WHENCE                               |   25 +++-
 go7007/go7007fw.bin                  |  Bin 0 -> 30800 bytes
 go7007/go7007tv.bin                  |  Bin 0 -> 124668 bytes
 go7007/lr192.fw                      |  Bin 0 -> 5793 bytes
 go7007/px-m402u.fw                   |  Bin 0 -> 5838 bytes
 go7007/px-tv402u.fw                  |  Bin 0 -> 6581 bytes
 s2250_loader.fw => go7007/s2250-1.fw |  Bin 1092 -> 1092 bytes
 s2250.fw => go7007/s2250-2.fw        |  Bin 9508 -> 9508 bytes
 go7007/wis-startrek.fw               |  Bin 0 -> 6381 bytes
 10 files changed, 480 insertions(+), 2 deletions(-)
 create mode 100644 LICENCE.go7007
 create mode 100644 go7007/go7007fw.bin
 create mode 100644 go7007/go7007tv.bin
 create mode 100644 go7007/lr192.fw
 create mode 100644 go7007/px-m402u.fw
 create mode 100644 go7007/px-tv402u.fw
 rename s2250_loader.fw => go7007/s2250-1.fw (100%)
 rename s2250.fw => go7007/s2250-2.fw (100%)
 create mode 100644 go7007/wis-startrek.fw
