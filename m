Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:13161 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1KCNm5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 09:42:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.2] Compilation fix
Date: Thu, 3 Nov 2011 14:41:59 +0100
Cc: Ben Collins <bcollins@bluecherry.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111031442.00042.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

This fixes a compilation problem when using the media_build system.

Both gspca and the solo driver have a header with the same name, and that
clashes when using media_build.

Regards,

	Hans

The following changes since commit bd90649834a322ff70925db9ac37bf7a461add52:

  staging/Makefile: Don't compile a media driver there (2011-11-02 09:17:00 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git fixes

Hans Verkuil (1):
      solo6x10: rename jpeg.h to solo6x10-jpeg.h

 .../media/solo6x10/{jpeg.h => solo6x10-jpeg.h}     |    0
 drivers/staging/media/solo6x10/v4l2-enc.c          |    2 +-
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/staging/media/solo6x10/{jpeg.h => solo6x10-jpeg.h} (100%)
