Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:56052 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755287AbbBBMs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 07:48:26 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 1A1352A0080
	for <linux-media@vger.kernel.org>; Mon,  2 Feb 2015 13:47:47 +0100 (CET)
Message-ID: <54CF71F2.1060704@xs4all.nl>
Date: Mon, 02 Feb 2015 13:47:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] au0828: fixes and vb2 conversion
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a5f43c18fceb2b96ec9fddb4348f5282a71cf2b0:

  [media] Documentation/video4linux: remove obsolete text files (2015-01-29 19:16:30 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git au0828

for you to fetch changes up to bdf9b69416a114cd8a6eaa96384535b2e0275653:

  media: au0828 - convert to use videobuf2 (2015-02-02 13:08:02 +0100)

----------------------------------------------------------------
Shuah Khan (3):
      media: fix au0828_analog_register() to not free au0828_dev
      media: fix au0828 compile error from au0828_boards initialization
      media: au0828 - convert to use videobuf2

 drivers/media/usb/au0828/Kconfig        |   2 +-
 drivers/media/usb/au0828/au0828-cards.c |   2 +-
 drivers/media/usb/au0828/au0828-vbi.c   | 122 ++++-------
 drivers/media/usb/au0828/au0828-video.c | 964 ++++++++++++++++++++++++++++++++----------------------------------------------------
 drivers/media/usb/au0828/au0828.h       |  61 +++---
 5 files changed, 443 insertions(+), 708 deletions(-)
