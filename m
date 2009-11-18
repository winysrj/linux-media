Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43185 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbZKRJgk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:36:40 -0500
Received: by bwz27 with SMTP id 27so872486bwz.21
        for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 01:36:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4c8e56e69e0b1619dd4e5c32d45b8374.squirrel@webmail.xs4all.nl>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1258504731-8430-8-git-send-email-laurent.pinchart@ideasonboard.com>
	 <200911180801.48950.hverkuil@xs4all.nl>
	 <829197380911180056i5102b87bw2926a7b38608570d@mail.gmail.com>
	 <4c8e56e69e0b1619dd4e5c32d45b8374.squirrel@webmail.xs4all.nl>
Date: Wed, 18 Nov 2009 04:36:45 -0500
Message-ID: <829197380911180136g4d372f2em84cf60bc9be4549c@mail.gmail.com>
Subject: Re: v4l: Use the video_drvdata function in drivers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 18, 2009 at 4:13 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> I agree that it would help to split this patch up. Some cases are trivial,
> so they can be put together in one patch. When things get more complex it
> makes sense to put it in a separate patch for easier reviewing by the
> relevant maintainers.
>
> This is a very nice cleanup and improves the driver code significantly.
> Especially since so many drivers keep copying the same useless code time
> and again :-(
>
> Reducing driver code complexity is a very important goal since that is the
> weakest point of many of the existing drivers. But it should be done
> carefully of course and in such a manner that people can review it easily.

Hello Hans,

Thanks for the comments.

Review is good.  Review *and* actually trying the code is better.  If
it comes down to Laurent's time being the constraint, I would rather
see him spending the time setting up a tree with all his proposed
patches and doing a call for testers than cutting up patches so that
maintainers can review and guess whether it's not going to cause
problems in their particular driver (and I say "guess" here because in
some cases it may fail in non-obvious ways that wouldn't be noticed
without actually trying it).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
