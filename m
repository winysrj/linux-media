Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:45664 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbZBWBL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 20:11:57 -0500
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
References: <200902221115.01464.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 02:13:01 +0100
Message-Id: <1235351581.2840.18.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 22.02.2009, 11:15 +0100 schrieb Hans Verkuil:
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

Yes.

> Optional question:
> 
> Why:

Keeping too old kernels supported makes others lazy and in worst case
they ask you to support v4l2 version one. (happened)

Our user base for new devices is covered with down to 2.6.22 for now, we
likely never got anything from those on old commercial distribution
kernels, same for Debian and stuff derived from there.

Since new drivers actually prefer to avoid the compat work and are happy
to make it just into the latest rc1 during the merge window and further
from there, there is no loss either.

Some new devices we likely get on already established drivers should not
be hard to add to a v4l-dvb tar ball we leave with support for the even
older kernels.

Cheers,
Hermann
 

