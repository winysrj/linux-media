Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33804 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbbCMLKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:10:07 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5BFEF2A002F
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2015 12:09:57 +0100 (CET)
Message-ID: <5502C585.7000200@xs4all.nl>
Date: Fri, 13 Mar 2015 12:09:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1j

for you to fetch changes up to 90eda3e053bf9e12490fea19a40d5d19e4f23b09:

  DocBook media: fix PIX_FMT_SGRBR8 example (2015-03-13 12:08:10 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      wl128x-radio really depends on TI_ST

Ezequiel Garcia (2):
      stk1160: Make sure current buffer is released
      MAINTAINERS: Update the maintainer mail address for stk1160

Hans Verkuil (5):
      DocBook v4l: update bytesperline handling
      DocBook media: fix section IDs
      rtl2832: fix compiler warning
      cx231xx: fix compiler warnings
      DocBook media: fix PIX_FMT_SGRBR8 example

Julia Lawall (1):
      media: pci: cx23885: don't export static symbol

 Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml | 16 ++++++++--------
 Documentation/DocBook/media/v4l/pixfmt.xml        | 40 ++++++++++++++++++++--------------------
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml |  4 ++--
 MAINTAINERS                                       |  2 +-
 drivers/media/dvb-frontends/rtl2832.c             |  2 +-
 drivers/media/pci/cx23885/altera-ci.c             |  3 ---
 drivers/media/radio/wl128x/Kconfig                |  2 +-
 drivers/media/usb/cx231xx/cx231xx.h               |  7 +++++--
 drivers/media/usb/stk1160/stk1160-v4l.c           | 17 +++++++++++++++--
 9 files changed, 53 insertions(+), 40 deletions(-)
