Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:25933 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab3GZNdz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 09:33:55 -0400
Received: from [10.61.214.134] ([10.61.214.134])
	(authenticated bits=0)
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r6QDXoAD027018
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 13:33:52 GMT
Message-ID: <51F27ABE.9060309@cisco.com>
Date: Fri, 26 Jul 2013 15:33:50 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Various fixes for 3.11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a list of fixes for 3.11. Compared to the pull request from yesterday
I added the em28xx fix for a nasty bug introduced in 3.10 (I added a CC to
linux-stable for that one).

Regards,

	Hans

The following changes since commit c859e6ef33ac0c9a5e9e934fe11a2232752b4e96:

  [media] dib0700: add support for PCTV 2002e & PCTV 2002e SE (2013-07-22 07:48:11 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to 18fc04d74da48f42d51a5db30f58249462dc5474:

  em28xx: fix assignment of the eeprom data. (2013-07-26 15:30:46 +0200)

----------------------------------------------------------------
Alban Browaeys (1):
      em28xx: fix assignment of the eeprom data.

Alexey Khoroshilov (1):
      hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Andrzej Hajda (2):
      DocBook: upgrade media_api DocBook version to 4.2
      v4l2: added missing mutex.h include to v4l2-ctrls.h

Hans Verkuil (2):
      ml86v7667: fix compile warning: 'ret' set but not used
      usbtv: fix dependency

Lubomir Rintel (2):
      usbtv: Fix deinterlacing
      usbtv: Throw corrupted frames away

 Documentation/DocBook/media_api.tmpl  |  4 ++--
 drivers/media/i2c/ml86v7667.c         |  4 ++--
 drivers/media/usb/em28xx/em28xx-i2c.c |  2 +-
 drivers/media/usb/hdpvr/hdpvr-core.c  | 11 ++++++-----
 drivers/media/usb/usbtv/Kconfig       |  2 +-
 drivers/media/usb/usbtv/usbtv.c       | 51 ++++++++++++++++++++++++++++++++++++++-------------
 include/media/v4l2-ctrls.h            |  1 +
 7 files changed, 51 insertions(+), 24 deletions(-)
