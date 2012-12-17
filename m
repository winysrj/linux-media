Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36819 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab2LQP0C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 10:26:02 -0500
Date: Mon, 17 Dec 2012 08:28:32 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2
 parts for soc_camera support
Message-ID: <20121217082832.7f363d05@lwn.net>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D13C8CCE4@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-11-git-send-email-twang13@marvell.com>
	<20121216093717.4be8feff@hpe.lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8CCE4@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 16 Dec 2012 14:12:11 -0800
Albert Wang <twang13@marvell.com> wrote:

> > - Is the soc_camera mode necessary?  Is there something you're trying
> >   to do that can't be done without it?  Or, at least, does it add
> >   sufficient benefit to be worth this work?  It would be nice if the
> >   reasoning behind this change were put into the changelog.
> >  
> [Albert Wang] We just want to add one more option for user. :)
> And we split it to 2 parts because we want to keep the original mode.
> 
> > - If the soc_camera change is deemed to be worthwhile, is there
> >   anything preventing you from doing it 100% so it's the only mode
> >   used?
> >  
> [Albert Wang] No, but current all Marvell platform have used the soc_camera in camera driver. :)
> So we just hope the marvell-ccic can have this option. :)

OK, so this, I think, is the one remaining point of disagreement here;
unfortunately it's a biggish one.

Users, I believe, don't really care which underlying framework the driver
is using; they just want a camera implementing the V4L2 spec.  So, this
particular option does not have any real value for them.  But it has a
real cost in terms of duplicated code, added complexity, and namespace
pollution.  If you believe I'm wrong, please tell me why, but I think that
this option is not worth the cost.

The reason for the soc_camera conversion is because that's how your
drivers do it — not necessarily the strongest of reasons.  Of course, the
reason for keeping things as they are is because that's how the in-tree
drivers does it; not necessarily a whole lot stronger.

I'm not sold on the soc_camera conversion, but neither am I implacably
opposed to it.  But I *really* dislike the idea of having both, I don't
see that leading to good things in the long run.  So can I ask one more
time: if soc_camera is important to you, could you please just convert the
driver over 100% and drop the other mode entirely?  It seems that should
be easier than trying to support both, and it should certainly be easier
to maintain in the future.

I'm sorry to be obnoxious about this.

Meanwhile, the bulk of this last patch series seems good; most of them
have my acks, and I saw acks from Guennadi on some as well.  I would
recommend that you separate those out into a different series and submit
them for merging, presumably for 3.9.  That will give you a bit less code
to carry going forward as this last part gets worked out.

Thanks again for doing this work and persevering with it!

jon
