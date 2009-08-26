Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:48588 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbZHZJHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 05:07:51 -0400
Received: by gxk1 with SMTP id 1so5009385gxk.17
        for <linux-media@vger.kernel.org>; Wed, 26 Aug 2009 02:07:52 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 12:00:11 +0300
Message-ID: <636c5030908260200t1d2182a8oabf6b61d31b1849b@mail.gmail.com>
Subject: davinci vs. v4l2: lots of conflicts in merge for linux-next
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	DaVinci <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, this has gotten a bit out of control, to the point where I cannot
solve this myself.  This is partially due to me being on the road and
not keeping a close enough eye on the various video patches.

I've pushed a new 'davinci-next' branch to davinci git[1] which is
what I would like to make available for linux-next.  This includes all
the patches from davinci git master which touch
arch/arm/mach-davinci/*.

I then went to do a test a merge of the master branch of Mauro's
linux-next tree, and there are lots of conflicts.  Some are trivial to
resolve (the various I2C_BOARD_INFO() conflicts) but others are more
difficult, and someone more familar with the video drivers should sort
them out.

The two patches from davinci master that seem to be causing all the
problems are:

  ARM: DaVinci: DM646x Video: Platform and board specific setup
  davinci: video: restructuring to support vpif capture driver

These cause the conflicts with the v4l2 next tree.  So, in
davinci-next I've dropped these two patches.

I think the way to fix this is for someone to take all the board
changes from the v4l2 tree and rebase them on top of my davinci-next,
dropping them from v4l2 next. I'll then merge them into davinci-next,
and this should make the two trees merge properly in linux-next.

We need to get this sorted out soon so that they can be merged for the
next merge window.

Going forward, I would prefer that all changes to arch/arm/* stuff go
through davinci git and all drivers/* stuff goes through V4L2.  This
will avoid this kind of overlap/conflict in the future since DaVinci
core code is going through lots of changes.

Kevin

[1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
