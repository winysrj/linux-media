Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:21359 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaAQKyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 05:54:39 -0500
Received: from [10.61.88.211] (ams3-vpn-dhcp6356.cisco.com [10.61.88.211])
	(authenticated bits=0)
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id s0HAsa5H029468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 17 Jan 2014 10:54:37 GMT
Message-ID: <52D90BE6.1010501@cisco.com>
Date: Fri, 17 Jan 2014 11:54:30 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14/3.15] usbtv: add audio support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 587d1b06e07b4a079453c74ba9edf17d21931049:

  [media] rc-core: reuse device numbers (2014-01-15 11:46:37 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.14d

for you to fetch changes up to 6e44e5938e3e964748e0d4b76f476c3215e32aab:

  usbtv: add audio support (2014-01-17 10:55:39 +0100)

----------------------------------------------------------------
Federico Simoncelli (2):
      usbtv: split core and video implementation
      usbtv: add audio support

 drivers/media/usb/usbtv/Makefile                   |   4 +
 drivers/media/usb/usbtv/usbtv-audio.c              | 384 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/usb/usbtv/usbtv-core.c               | 144 ++++++++++++++++++++++++++++
 drivers/media/usb/usbtv/{usbtv.c => usbtv-video.c} | 172 +++------------------------------
 drivers/media/usb/usbtv/usbtv.h                    | 117 ++++++++++++++++++++++
 5 files changed, 663 insertions(+), 158 deletions(-)
 create mode 100644 drivers/media/usb/usbtv/usbtv-audio.c
 create mode 100644 drivers/media/usb/usbtv/usbtv-core.c
 rename drivers/media/usb/usbtv/{usbtv.c => usbtv-video.c} (82%)
 create mode 100644 drivers/media/usb/usbtv/usbtv.h
