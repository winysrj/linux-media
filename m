Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1573 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2ERLn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 07:43:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.5] Fix gspca compile error if CONFIG_PM is not set
Date: Fri, 18 May 2012 13:43:46 +0200
Cc: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205181343.46414.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field 'frozen' is only there if CONFIG_PM is set, so don't use it
directly, always check for CONFIG_PM first.

Regards,

	Hans

The following changes since commit 61282daf505f3c8def09332ca337ac257b792029:

  [media] V4L2: mt9t112: fixup JPEG initialization workaround (2012-05-15 16:15:35 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git frozenfix

for you to fetch changes up to 4ba342204948e9df49dc1f639ffdbfe49579e626:

  gspca: the field 'frozen' is under CONFIG_PM (2012-05-18 13:40:42 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      gspca: the field 'frozen' is under CONFIG_PM

 drivers/media/video/gspca/finepix.c   |   20 +++++++++++++++-----
 drivers/media/video/gspca/jl2005bcd.c |    6 +++++-
 drivers/media/video/gspca/sq905.c     |    6 +++++-
 drivers/media/video/gspca/sq905c.c    |    6 +++++-
 drivers/media/video/gspca/vicam.c     |    6 +++++-
 drivers/media/video/gspca/zc3xx.c     |    7 +++++--
 6 files changed, 40 insertions(+), 11 deletions(-)
