Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:48209 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3LRLgH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 06:36:07 -0500
Received: from [10.54.92.107] (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	(authenticated bits=0)
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id rBIBa5Gq000825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 18 Dec 2013 11:36:06 GMT
Message-ID: <52B18831.7010509@cisco.com>
Date: Wed, 18 Dec 2013 12:34:09 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] Add support for 'Thanko's Raremono' FM/AM/SW
 radio receiver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3e6e3b3d3d6877e5b9fe0c2cd9788127a4974a3d:

  [media] staging: media: davinci_vpfe: Rewrite return statement in vpfe_video.c (2013-12-18 06:28:13 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git thanko

for you to fetch changes up to 68318397d8fdb521ddbd00548bb1394a0ce98bef:

  MAINTAINERS: add entry for new radio-raremono radio driver. (2013-12-18 12:33:59 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      si470x: don't use buffer on the stack for USB transfers.
      si470x: add check to test if this is really a si470x.
      radio-raremono: add support for 'Thanko's Raremono' AM/FM/SW USB device.
      MAINTAINERS: add entry for new radio-raremono radio driver.

 MAINTAINERS                                   |   8 ++
 drivers/media/radio/Kconfig                   |  14 +++
 drivers/media/radio/Makefile                  |   1 +
 drivers/media/radio/radio-raremono.c          | 387 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/radio/si470x/radio-si470x-usb.c |  81 ++++++++++-----
 drivers/media/radio/si470x/radio-si470x.h     |   1 +
 6 files changed, 466 insertions(+), 26 deletions(-)
 create mode 100644 drivers/media/radio/radio-raremono.c
