Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3776 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab3HBNKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 09:10:49 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id r72DAkST049329
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 2 Aug 2013 15:10:48 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.164.124] (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 8E2B035E03C3
	for <linux-media@vger.kernel.org>; Fri,  2 Aug 2013 15:10:45 +0200 (CEST)
Message-ID: <51FBAFD3.1080306@xs4all.nl>
Date: Fri, 02 Aug 2013 15:10:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Just one fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note: this patch is already merged in linuxtv/master, but it should also go
to 3.11.

Regards,

	Hans

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11b

for you to fetch changes up to 08efa3ee4aac27407f0651ad781c441367f90308:

  ml86v7667: override default field interlace order (2013-07-29 16:08:52 +0200)

----------------------------------------------------------------
Vladimir Barinov (1):
      ml86v7667: override default field interlace order

 drivers/media/i2c/ml86v7667.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
