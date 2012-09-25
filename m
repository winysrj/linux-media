Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:51964 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2IYMQA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 08:16:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] In non-blocking mode return EAGAIN in hwseek
Date: Tue, 25 Sep 2012 14:15:31 +0200
Cc: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251415.31929.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When trying to do hardware seek in non-blocking mode just return EAGAIN
instead of blocking while the seek is in progress.

The following changes since commit 4313902ebe33155209472215c62d2f29d117be29:

  [media] ivtv-alsa, ivtv: Connect ivtv PCM capture stream to ivtv-alsa interface driver (2012-09-18 13:29:07 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git hwseek

for you to fetch changes up to e4d14800264cd6c8a95c58818757e55698feef75:

  radio drivers: in non-blocking mode return EAGAIN in hwseek (2012-09-21 14:33:35 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      DocBook: EAGAIN == EWOULDBLOCK
      DocBook: in non-blocking mode return EAGAIN in hwseek
      radio drivers: in non-blocking mode return EAGAIN in hwseek

 Documentation/DocBook/media/v4l/gen-errors.xml            |    9 +++------
 Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml |   10 ++++++++++
 drivers/media/radio/radio-mr800.c                         |    3 +++
 drivers/media/radio/radio-tea5777.c                       |    3 +++
 drivers/media/radio/radio-wl1273.c                        |    3 +++
 drivers/media/radio/si470x/radio-si470x-common.c          |    3 +++
 drivers/media/radio/wl128x/fmdrv_v4l2.c                   |    3 +++
 sound/i2c/other/tea575x-tuner.c                           |    3 +++
 8 files changed, 31 insertions(+), 6 deletions(-)
