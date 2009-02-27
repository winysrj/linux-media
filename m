Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:48002 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZB0CZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 21:25:26 -0500
Received: by yx-out-2324.google.com with SMTP id 8so653853yxm.1
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 18:25:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
References: <200902221115.01464.hverkuil@xs4all.nl>
Date: Fri, 27 Feb 2009 11:25:23 +0900
Message-ID: <aec7e5c30902261825x3ea7ba5g1e7f11d9a4114693@mail.gmail.com>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: Magnus Damm <magnus.damm@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 22, 2009 at 7:15 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>
> _: Yes
> _: No

Yes.

> Optional question:
>
> Why:

Focus on moving forward instead of looking backwards. Keeping user
space compatibilty is of course a good idea, but I see no reason why
V4L needs to be special compared to the rest of the kernel.

I don't have the full picture though and I'm not the one who spend
energy and time on keeping backwards compatibility. If the cost is
small enough then it may of course be worth it. But my gut feeling is
that there is no point in being special with these things, just do
like the rest of the kernel subsystems and you will be fine.

/ magnus
