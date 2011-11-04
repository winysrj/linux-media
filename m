Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:15534 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1KDJkB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 05:40:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.2] Compilation fixes
Date: Fri, 4 Nov 2011 10:39:58 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111041039.58290.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

This fixes two compilation problems when using the media_build system.

Both gspca and the solo driver have a header with the same name, and that
clashes when using media_build.

And the solo driver uses an incorrect Makefile construct, which (somewhat
mysteriously) skips the compilation of 90% of all media drivers.

Hopefully this pull request makes it to patchwork as well.

Regards,

        Hans


The following changes since commit bd90649834a322ff70925db9ac37bf7a461add52:

  staging/Makefile: Don't compile a media driver there (2011-11-02 09:17:00 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git fixes

Hans Verkuil (2):
      solo6x10: rename jpeg.h to solo6x10-jpeg.h
      solo6x10: fix broken Makefile

 drivers/staging/media/solo6x10/Makefile            |    2 +-
 .../media/solo6x10/{jpeg.h => solo6x10-jpeg.h}     |    0
 drivers/staging/media/solo6x10/v4l2-enc.c          |    2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/staging/media/solo6x10/{jpeg.h => solo6x10-jpeg.h} (100%)
