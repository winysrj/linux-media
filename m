Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36895 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbaITJvu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 05:51:50 -0400
Date: Sat, 20 Sep 2014 06:51:44 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 0/3] vb2: fix VBI/poll regression
Message-ID: <20140920065144.0c69e575@recife.lan>
In-Reply-To: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
References: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 20 Sep 2014 10:56:12 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> OK, this is the final (?) patch series to resolve the vb2 VBI poll regression
> where alevt and mtt fail on drivers using vb2.
> 
> These applications call REQBUFS, queue the buffers and then poll() without
> calling STREAMON first. They rely on poll() to return POLLERR in that case
> and they do the STREAMON at that time. This is correct according to the spec,
> but this was never implemented in vb2.
> 
> This is fixed together with an other vb2 regression: calling REQBUFS, then
> STREAMON, then poll() without doing a QBUF first should return POLLERR as
> well according to the spec. This has been fixed as well and the spec has
> been clarified that this is only done for capture queues. Output queues in
> the same situation will return as well, but with POLLOUT|POLLWRNORM set
> instead of POLLERR.
> 
> The final patch adds missing documentation to poll() regarding event handling
> and improves the documentation regarding stream I/O and output queues.

Didn't test yet, but the patch series look ok on my eyes.

I'll do some tests today.

Regards,
Mauro
