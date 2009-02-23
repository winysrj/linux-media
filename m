Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:14975 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZBWIc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 03:32:28 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2390738wfa.4
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2009 00:32:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
References: <200902221115.01464.hverkuil@xs4all.nl>
Date: Mon, 23 Feb 2009 00:32:27 -0800
Message-ID: <a3ef07920902230032t22f777d4i3441c809d1bfb129@mail.gmail.com>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
From: VDR User <user.vdr@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 22, 2009 at 2:15 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>
> _: Yes
> _: No

Yes.

> Optional question:
>
> Why:

The reasons already stated, those resources could be better used doing
other things.  Aside of that, of the devs/users how many people
actually _need_ to remain on an old kernel.  I could be wrong in my
assumption that most people using old kernels are doing so simply by
choice and not necessity.  You want to maximize developer productivity
and if that means some people will need to update their kernel, is
that so horrible?
