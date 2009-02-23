Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZBWM1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 07:27:23 -0500
Date: Mon, 23 Feb 2009 09:26:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
Message-ID: <20090223092657.1a2ac2e1@pedra.chehab.org>
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
References: <200902221115.01464.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 22 Feb 2009 11:15:01 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi all,
> 
> There are lot's of discussions, but it can be hard sometimes to actually 
> determine someone's opinion.
> 
> So here is a quick poll, please reply either to the list or directly to me 
> with your yes/no answer and (optional but welcome) a short explanation to 
> your standpoint. It doesn't matter if you are a user or developer, I'd like 
> to see your opinion regardless.
> 
> Please DO NOT reply to the replies, I'll summarize the results in a week's 
> time and then we can discuss it further.
> 
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
> 
> _: Yes
> _: No

No.

> 
> Optional question:
> 
> Why:

For a couple of reasons:

1) This will remove testers from our user database;
2) The current way of backporting is not scaling. Just dropping support for a
random version is just postponing the question that we need to re-think about
the way for backport;
3) This doesn't solve the development issues we have of not using -git. This
causes lots of work when sending patches uptreaming, on when someone changes
something upstream and a backport is needed.

So, in practice, this won't solve any real problem.

I'm right now working on another way of allowing backport that will better
scale, and will allow developers to use -git, without losing backport for users.

Cheers,
Mauro
