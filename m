Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58365 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3DKJ63 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 05:58:29 -0400
Received: by mail-ie0-f181.google.com with SMTP id 17so1732300iea.40
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 02:58:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304111140.48548.hverkuil@xs4all.nl>
References: <201304111140.48548.hverkuil@xs4all.nl>
Date: Thu, 11 Apr 2013 17:58:28 +0800
Message-ID: <CAEvN+1hpE3DE6MWqTqoqrWfygMDhtLjk3ZC_0iApVWsEE-FQHw@mail.gmail.com>
Subject: Re: Exact behavior of the EOS event?
From: Tzu-Jung Lee <roylee17@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Apr 11, 2013 at 5:40 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Kamil, Roy,
>
> When implementing eos support in v4l2-ctl I started wondering about the
> exact timings of that.
>
> There are two cases, polling and non-polling, and I'll explain how I do it
> now in v4l2-ctl.
>
> Polling case:
>
> I select for both read and exceptions. When the select returns I check
> for exceptions and call DQEVENT, which may return EOS.
>
> If there is something to read then I call DQBUF to get the frame, process
> it and afterwards exit the capture loop if the EOS event was seen.
>
> This procedure assumes that setting the event and making the last frame
> available to userspace happen atomically, otherwise you can get a race
> condition.
>
> Non-polling case:
>
> I select for an exception with a timeout of 0 (i.e. returns immediately),
> then I call DQBUF (which may block), process the frame and exit if EOS was
> seen.
>
> I suspect this is wrong, since when I call select the EOS may not be set
> yet, but it is after the DQBUF. So in the next run through the capture loop
> I capture one frame too many.
>
>
> What I think is the correct sequence is to first select for a read(), but not
> exceptions, then do the DQBUF, and finally do a select for exceptions with
> a timeout of 0. If EOS was seen, then that was the last frame.
>
> A potential problem with that might be when you want to select on other
> events as well. Then you would select on both read and exceptions, and we
> end up with a potential race condition again. The only solution I see is to
> open a second filehandle to the video node and subscribe to the EOS event
> only for that filehandle and use that to do the EOS polling.
>
> It all feels rather awkward.
>
> Kamil, Roy, any ideas/suggestions to improve this?

I was thinking to serialize this within the driver, which means no buffers
on capture side will be DQBUF once the EOS is generated.

I'm not sure is this generic enough, but it should make life easier
for applications

Regards,
Roy
