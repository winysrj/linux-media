Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1923 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1CKT2k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 14:28:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.39] DocBook validation fixes
Date: Fri, 11 Mar 2011 20:28:26 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103112028.26373.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 97c6bc5e15e60c0c15ff028c03af2cf42ad9a07e:

  [media] altera-ci.h: add missing inline (2011-03-11 14:17:05 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git fixes

Hans Verkuil (2):
      V4L doc fixes
      V4L DocBook: update V4L2 version.

 Documentation/DocBook/v4l/dev-subdev.xml           |   46 +++++++-------
 .../DocBook/v4l/media-ioc-enum-entities.xml        |    6 +-
 Documentation/DocBook/v4l/subdev-formats.xml       |   64 ++++++++++----------
 Documentation/DocBook/v4l/v4l2.xml                 |    2 +-
 4 files changed, 59 insertions(+), 59 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
