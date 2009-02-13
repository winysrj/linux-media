Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZBMUtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 15:49:49 -0500
Date: Fri, 13 Feb 2009 18:49:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: v4l2_driver.c status
Message-ID: <20090213184921.222c8823@pedra.chehab.org>
In-Reply-To: <200902131347.11272.hverkuil@xs4all.nl>
References: <200902131347.11272.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Feb 2009 13:47:10 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Mauro,
> 
> What is the status of the v4l2_driver.c in v4l2util? (formerly known as 
> libv4l2, see my pull request).
> 
> While the original v4l2util just contained frequency tables (not much can go 
> wrong there), adding the v4l2_driver.c code in that library makes me 
> uncomfortable because: 1) it is undocumented, 2) it is unreviewed (and I 
> certainly do not agree with several of the choices made here!).
> 
> I propose that v4l2_driver.c is moved to a new library (v4l2driver?) with a 
> README clarifying that this is experimental.
> 
> I'm also willing to do a review of v4l2_driver.c for you.
> 
> When a better and documented API is made, then it can be moved to v4l2util 
> and released officially.
> 
> Documentation should probably go to the V4L2 spec in a separate chapter.

Seems fine for me.

Cheers,
Mauro
