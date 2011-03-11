Return-path: <mchehab@pedra>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2484 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1CKVUm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 16:20:42 -0500
Received: from tschai.localnet (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id p2BLKfsA037831
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 22:20:41 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.39] One more docbook fix
Date: Fri, 11 Mar 2011 22:20:41 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103112220.41037.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With this fix the spec compiles without any errors.

Regards,

	Hans

The following changes since commit 41f3becb7bef489f9e8c35284dd88a1ff59b190c:

  [media] V4L DocBook: update V4L2 version (2011-03-11 18:09:02 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git fixes

Hans Verkuil (1):
      Fix 'ID nv12mt already defined' error

 Documentation/DocBook/v4l/pixfmt-nv12mt.xml |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
