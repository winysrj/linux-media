Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab2LKPOW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 10:14:22 -0500
Date: Tue, 11 Dec 2012 13:13:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: RFC: First draft of guidelines for submitting patches to
 linux-media
Message-ID: <20121211131354.055bd4e9@redhat.com>
In-Reply-To: <3191306.PADCPVeiLd@avalon>
References: <201212101407.09338.hverkuil@xs4all.nl>
	<20121211082930.5f851888@redhat.com>
	<201212111250.21158.hverkuil@xs4all.nl>
	<3191306.PADCPVeiLd@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Dec 2012 13:20:32 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

[snip]
> > - not sure if this is possible: if a v2 patch series is posted, then
> > automatically remove v1. This would require sanity checks: same subject,
> > same author.
> 
> There's a security issue here as it's easy to spoof a sender e-mail address, 
> but I don't think that we need to care about it.

This can be easily detected: if the patch author didn't opt-out, he, 
and the others who signed the v1 patch will receive a notification when it
gets any status change.

Also, when the patch gets merged on my tree, the author will receive 
another email.

So, a fake submission can easily be detected.

Cheers,
Mauro
