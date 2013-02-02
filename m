Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4056 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3BBJOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2013 04:14:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] videodev2.h fix and em28xx regression fixes
Date: Sat, 2 Feb 2013 10:14:44 +0100
Cc: Frank =?iso-8859-1?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302021014.44793.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the second version of this git pull request. While digging through
old branches of mine I found another tvaudio fix that I want to include here
as well. In addition, the tvaudio control framework conversion in the original
pull request also did a fix for balance handling and I have split that fix off
into its own patch in this pull request.

So effectively the only new thing is a two liner tvaudio/tea6420 fix.

The first patch moves the DV control IDs from videodev2.h to v4l2-controls.h.
I noticed that they weren't moved when the controls were split off from
videodev2.h, probably because the patch adding the DV controls and the move
to v4l2-controls.h crossed one another.

The second patch converts mt9v011 to the control framework. The third and
fourth patches fix two tvaudio bugs and the final patch converts tvaudio to
the control framework. These patches were part of my original conversion of
em28xx to the control framework (except for the tea6420 fix), but when Devin
based his em28xx work on my tree he forgot to pull them in.

Because of that any controls created by the mt9v011 and tvaudio drivers are
inaccessible from em28xx. By converting those drivers to the control framework
they are seen again.

Frank tested the mt9v011 conversion. I have tested the tvaudio conversion
somewhat with a bttv card that had a tda9850 and tea6420, but if you have
additional tvaudio cards (and especially an em28xx that uses the tvaudio module),
then it would be good to do some additional tests. Other than the bttv card I
have no other hardware to test tvaudio with.

Regards,

        Hans

The following changes since commit 94a93e5f85040114d6a77c085457b3943b6da889:

  [media] dvb_frontend: print a msg if a property doesn't exist (2013-01-23 19:10:57 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git fixes2

for you to fetch changes up to 2e984336e5df76226c7ce977d2eeaecd98d625eb:

  tvaudio: convert to the control framework. (2013-02-02 10:03:36 +0100)

----------------------------------------------------------------
Hans Verkuil (5):
      Move DV-class control IDs from videodev2.h to v4l2-controls.h
      mt9v011: convert to the control framework.
      tvaudio: fix broken volume/balance calculations
      tvaudio: fix two tea6420 errors.
      tvaudio: convert to the control framework.

 drivers/media/i2c/mt9v011.c        |  223 ++++++++++++++++++++---------------------------------------------
 drivers/media/i2c/tvaudio.c        |  238 ++++++++++++++++++++++++++--------------------------------------------
 include/uapi/linux/v4l2-controls.h |   24 +++++++
 include/uapi/linux/videodev2.h     |   22 -------
 4 files changed, 179 insertions(+), 328 deletions(-)
