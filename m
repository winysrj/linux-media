Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44845 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZHZQAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 12:00:40 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	DaVinci <davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 26 Aug 2009 11:00:22 -0500
Subject: RE: davinci vs. v4l2: lots of conflicts in merge for linux-next
Message-ID: <A69FA2915331DC488A831521EAE36FE40154E2C0E7@dlee06.ent.ti.com>
References: <636c5030908260200t1d2182a8oabf6b61d31b1849b@mail.gmail.com>
In-Reply-To: <636c5030908260200t1d2182a8oabf6b61d31b1849b@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin,

Ok, I see you have merged vpif capture architecture part to master branch
of davinci. 

So what you are suggesting is to remove all vpif/vpfe patches from arch/arm/davinci of v4l linux-next tree (So I guess this is what Mauro should do on linux-next). So architecture part of all future video patches are to be re-created and re-submitted based on davinci-next and will be merged only to davinci tree and Mauro will merge the v4l part.

Kevin & Mauro,

So only concern I have is that these patches may not compile (either architecture part or v4l part) until the counter part becomes available on the tree. Is this fine? 

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
new phone: 301-407-9583
Old Phone : 301-515-3736 (will be deprecated)
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Kevin Hilman [mailto:khilman@deeprootsystems.com]
>Sent: Wednesday, August 26, 2009 5:00 AM
>To: Karicheri, Muralidharan; Mauro Carvalho Chehab
>Cc: linux-media@vger.kernel.org; Hans Verkuil; DaVinci
>Subject: davinci vs. v4l2: lots of conflicts in merge for linux-next
>
>OK, this has gotten a bit out of control, to the point where I cannot
>solve this myself.  This is partially due to me being on the road and
>not keeping a close enough eye on the various video patches.
>
>I've pushed a new 'davinci-next' branch to davinci git[1] which is
>what I would like to make available for linux-next.  This includes all
>the patches from davinci git master which touch
>arch/arm/mach-davinci/*.
>
>I then went to do a test a merge of the master branch of Mauro's
>linux-next tree, and there are lots of conflicts.  Some are trivial to
>resolve (the various I2C_BOARD_INFO() conflicts) but others are more
>difficult, and someone more familar with the video drivers should sort
>them out.
>
>The two patches from davinci master that seem to be causing all the
>problems are:
>
>  ARM: DaVinci: DM646x Video: Platform and board specific setup
>  davinci: video: restructuring to support vpif capture driver
>
>These cause the conflicts with the v4l2 next tree.  So, in
>davinci-next I've dropped these two patches.
>
>I think the way to fix this is for someone to take all the board
>changes from the v4l2 tree and rebase them on top of my davinci-next,
>dropping them from v4l2 next. I'll then merge them into davinci-next,
>and this should make the two trees merge properly in linux-next.
>
>We need to get this sorted out soon so that they can be merged for the
>next merge window.
>
>Going forward, I would prefer that all changes to arch/arm/* stuff go
>through davinci git and all drivers/* stuff goes through V4L2.  This
>will avoid this kind of overlap/conflict in the future since DaVinci
>core code is going through lots of changes.
>
>Kevin
>
>[1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git

