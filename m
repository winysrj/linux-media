Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36565 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaIRMz0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 08:55:26 -0400
Date: Thu, 18 Sep 2014 09:55:22 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] vb2/saa7134 regression/documentation fixes
Message-ID: <20140918095522.17ac0dc7@recife.lan>
In-Reply-To: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
References: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Sep 2014 11:14:28 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> This fixes the VBI regression seen in saa7134 when it was converted
> to vb2. Tested with my saa7134 board.
> 
> It also updates the poll documentation and fixes a saa7134 bug where
> the WSS signal was never captured.
> 
> The first patch should go to 3.17. It won't apply to older kernels,
> so I guess once this is merged we should post a patch to stable for
> those older kernels, certainly 3.16.
> 
> I would expect this to be an issue for em28xx as well, but I will
> need to test that. If that driver is affected as well, then this
> fix needs to go into 3.9 and up.

For now:

Nacked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>


Changing the V4L2 API is *not* the right way to fix a regression.

Also, this changes a behavior that it is there since 2.6.24.
We can't do that, except if you're sure that no userspace applications
rely on the old behavior, with seems unlikely.

> 
> Regards,
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
