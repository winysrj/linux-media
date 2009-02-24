Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:41210 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZBXVCl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 16:02:41 -0500
Received: by fxm11 with SMTP id 11so3160949fxm.13
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 13:02:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
References: <200902221115.01464.hverkuil@xs4all.nl>
Date: Tue, 24 Feb 2009 16:02:37 -0500
Message-ID: <37219a840902241302u5b9d79bex9eb3b0e55462e3a@mail.gmail.com>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: Michael Krufky <mkrufky@linuxtv.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 22, 2009 at 5:15 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>
> _: Yes
> _: No


NO.


> Optional question:
>
> Why:


Dropping support for older kernels means dropping support for MOST testers.

Sure, it's an inconvenience for the maintainers.  This does *not* have
to cause a hindrance for new drivers.  At first, new drivers can be
added to the repository, and set to require only the latest kernels,
via versions.txt .  When somebody has time to fix backwards compat for
that driver, simply update versions.txt with the new kernel version
dependency for the driver in question.


Additionally, we all know what upstream kernel development is like --
new kernel does *not* mean new stability.  More likely, new kernels
bring new bugs.  (this isnt always the case, but it's good to be
skeptical when it comes to production systems)

If I build an embedded system to use as a dedicated TV streaming box,
I will not want to update my kernel JUST so that I can use the new
driver required for my new TV tuner device.

Being able to build the v4l-dvb development repository against a
reasonable set of stable kernels, including kernels as old as 2.6.16,
is a critical feature for users of the v4l-dvb driver repository.

Regards,

Mike Krufky
