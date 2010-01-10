Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1045 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab0AJTEM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 14:04:12 -0500
Subject: Re: [PATCH 1/1] MAINTAINERS: ivtv-devel is moderated
From: Joe Perches <joe@perches.com>
To: Andy Walls <awalls@radix.net>
Cc: Jiri Slaby <jslaby@suse.cz>, mchehab@infradead.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	jirislaby@gmail.com, linux-media@vger.kernel.org
In-Reply-To: <1263130149.4061.7.camel@palomino.walls.org>
References: <1263114197-8476-1-git-send-email-jslaby@suse.cz>
	 <1263130149.4061.7.camel@palomino.walls.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jan 2010 11:04:10 -0800
Message-ID: <1263150250.1907.22.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-01-10 at 08:29 -0500, Andy Walls wrote:
> On Sun, 2010-01-10 at 10:03 +0100, Jiri Slaby wrote:
> > Mark ivtv-devel@ivtvdriver.org as 'moderated for non-subscribers'.
> Yes, that is true.
> I don't know why it matters after years of not being marked as such,
> especially since the moderator will push through on-topic posts.
> I don't know the implications that such an annotation will have on
> scripts that try to parse MAINTAINERS for e-mail addresses.

I think it's just for people that use MAINTAINERS
by hand.

As far as I know, scripts/get_maintainer.pl is the
only script that parses MAINTAINERS.

This annotation doesn't change what lists are returned
by the script.

The script does filter lists with a "subscribers-only"
annotation from other lists and only includes them when
the command line argument "--s" is set.


