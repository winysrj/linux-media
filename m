Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:57798 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZBVXPO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 18:15:14 -0500
Date: Sun, 22 Feb 2009 17:27:35 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
Message-ID: <alpine.LNX.2.00.0902221717380.10870@banach.math.auburn.edu>
References: <200902221115.01464.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 22 Feb 2009, Hans Verkuil wrote:

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
X _: Yes
> _: No
>
> Optional question:
>
> Why:

After a certain point it becomes in practical terms impossible to support 
old versions of anything. There are too many dependencies on too many 
things that have to be changed all at once. The resulting problems do not 
pertain only to kernel-related development but to all development, as I 
have tried to make clear in other posts. I do not know the gory details of 
just what has become too difficult, as I am new to this area of kernel 
development, but I am quite willing, based upon a general description, and 
based upon other experience, to believe that there are problems.

I think it is obvious that a version cutoff has to be made somewhere, and 
seven minor versions behind the kernel which is about to come out does not 
at all appear to me to be an unreasonable restriction.

