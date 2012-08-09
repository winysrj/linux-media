Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3536 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2HILOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 07:14:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] DocBook fixes for 3.6
Date: Thu, 9 Aug 2012 13:13:40 +0200
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208091313.40659.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch fixes a long standing invalid doc chunk first fixed by
Sylwester here:

http://patchwork.linuxtv.org/patch/11271/

I've taken that patch as is and only rebased it so it applies cleanly.

It is in state 'Changes requested' but nobody ever actually requested any
changes, and it is an obviously wrong piece of documentation that refers to
something that doesn't exist.

The second patch updates various copyright years and version numbers and
updates a few other odds 'n ends that were never properly updated.

Regards,

	Hans

The following changes since commit c3707357c6c651652a87a044445eabd7582f90a4:

  [media] az6007: Update copyright (2012-08-06 09:25:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git docfixes

for you to fetch changes up to 1bb7364ed7f469186f5c1cc96dda399062097946:

  DocBook: various version/copyright year updates. (2012-08-09 13:00:58 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      Remove documentation chunk of non-existent V4L2_CID_AUTO_FOCUS_AREA
      DocBook: various version/copyright year updates.

 Documentation/DocBook/media/dvb/dvbapi.xml |    2 +-
 Documentation/DocBook/media/v4l/compat.xml |   16 ----------------
 Documentation/DocBook/media/v4l/v4l2.xml   |   14 +++++++-------
 Documentation/DocBook/media_api.tmpl       |    9 +++++----
 4 files changed, 13 insertions(+), 28 deletions(-)
