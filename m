Return-path: <linux-media-owner@vger.kernel.org>
Received: from zed.grinta.net ([109.74.203.128]:49034 "EHLO zed.grinta.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752223AbcLJVjV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 16:39:21 -0500
Subject: Re: [PATCH 1/4] [media] bt8xx: One function call less in
 bttv_input_init() after error detection
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <d9a0777b-8ea7-3f7d-4fa2-b16468c4a1a4@users.sourceforge.net>
 <e20a6835-a404-e894-d0d0-a408bfcd7fb6@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Daniele Nicolodi <daniele@grinta.net>
Message-ID: <ecf01283-e2eb-ecef-313f-123ba41c0336@grinta.net>
Date: Sat, 10 Dec 2016 14:29:55 -0700
MIME-Version: 1.0
In-Reply-To: <e20a6835-a404-e894-d0d0-a408bfcd7fb6@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/12/16 13:48, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 10 Dec 2016 09:29:24 +0100
> 
> The kfree() function was called in one case by the
> bttv_input_init() function during error handling
> even if the passed variable contained a null pointer.

kfree() is safe to call on a NULL pointer.

Despite that, you have found several instances of similar constructs:

{
	a = kmalloc(...)
	b = kmalloc(...)

	if (!a || !b)
		goto out;

	...

out:
	kfree(a);
	kfree(b);
}

and similar patches you submitted to change those construct to something
different have been rejected because they are seen as unnecessary
changes that make the code harder to read.

Didn't it occur to you that maybe those constructs are fine the way they
are and this is the idiomatic way to write that kind of code? Why are
you submitting patches implementing changes that have already been rejected?

Submitting mechanical patches that fix trivial style issues (existing
and widely acknowledged ones) is a fine way to learn how to work on
kernel development. They constitute additional work load on the
maintainers that need to review and merge them. Thus, hopefully, they
are only a way for new developers to familiarize themselves with the
process and then move to some more constructive contributions.

Judging from your recent submissions, it seems that this process is not
working well for you. I'm probably not the only one that is wonderign
what are you trying to obtain with your patch submissions, other than
having your name in the git log.

Cheers,
Daniele

