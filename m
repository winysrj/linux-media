Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:58010 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaC3QsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 12:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <533807FC.5050008@xs4all.nl>
References: <532442E2.7050206@xs4all.nl>
	<532443AB.9080105@xs4all.nl>
	<533553E6.3060508@xs4all.nl>
	<CANeU7Qksj-tq0fjsZya1otX75sV4JOsAdXHr5Kxu-WyvYrksSw@mail.gmail.com>
	<533807FC.5050008@xs4all.nl>
Date: Sun, 30 Mar 2014 09:48:24 -0700
Message-ID: <CA+55aFy8y6ctXcc8qcqVkRDAL=ZWU0DAfuZ4zQcP6uqzPmb-AA@mail.gmail.com>
Subject: Re: sparse: ARRAY_SIZE and sparse array initialization
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Christopher Li <sparse@chrisli.org>,
	Linux-Sparse <linux-sparse@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 30, 2014 at 5:03 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> which is clearly a sparse bug somewhere.

Yes. What is going on is that we create separate symbols for each
declaration, and we tie them all together (and warn if they have
conflicting types).

But then when we look up a symbol, we only look at the latest one, so
when we size the array, we look at that "extern" declaration, and
don't see the size that was created with the initializer.

I'll think about how to fix it cleanly. Expect a patch shortly.

              Linus
