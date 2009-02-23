Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:52088 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbZBWOxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 09:53:11 -0500
Received: by qyk4 with SMTP id 4so2827468qyk.13
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2009 06:53:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
References: <200902221115.01464.hverkuil@xs4all.nl>
Date: Mon, 23 Feb 2009 09:53:09 -0500
Message-ID: <30353c3d0902230653w419e10c4u73b7f70f135d6663@mail.gmail.com>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 22, 2009 at 5:15 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
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

YES

>
> Optional question:

Why can't we drop support for all but the latest kernel?

>
> Why:

As others have already pointed out, it is a waste of time for
developers who volunteer their time to work on supporting prior kernel
revisions for use by enterprise distributions. The task of
back-porting driver modifications to earlier kernels lessens the
amount of time developers can focus on improving the quality and
stability of new and existing drivers. Furthermore, it deters driver
development since  there an expectation that they will back-port their
driver to earlier kernel versions. Finally, as a developer, I have
have little interest in what was new yesterday. I usually run the
latest kernel whenever possible and for a number of different reasons.
Some of those reasons include better hardware support, bug detection,
and stability testing. All services greatly valued by other kernel
developers.

Regards,

David Ellingsworth
