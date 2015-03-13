Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:55707 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbbCMV2E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 17:28:04 -0400
Date: Fri, 13 Mar 2015 17:28:01 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 00/21] marvell-ccic: drop and fix formats
Message-ID: <20150313172801.6bc4bf75@lwn.net>
In-Reply-To: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl>
References: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Mar 2015 09:10:24 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> After some more testing I realized that the 422P format produced
> wrong colors and I couldn't get it to work. Since it never worked and
> nobody complained about it (and it is a fairly obscure format as well)
> I've dropped it.

I'm not sure how that format came in anymore; I didn't add it.  No
objections to its removal.

> I also tested RGB444 format for the first time, and that had wrong colors
> as well, but that was easy to fix. Finally there was a Bayer format
> reported, but it was never implemented. So that too was dropped.

The RGB444 change worries me somewhat; that was the default format on the
XO1 and worked for years.  I vaguely remember some discussions about the
ordering of the colors there, but that was a while ago.  Did you test it
with any of the Sugar apps?

In the end, correctness is probably the right way to go (it usually is!),
but I'd hate to get a regression report from somebody who is crazy enough
to put current kernels on those machines.  Fortunately, such people
should be rare.

Bayer sort-of worked once, honest.  I added it for some academic who
wanted to do stuff, and was never really able to close the loop on
getting it working correctly.  It might be worth removing the alleged
support from ov7670 as well.

In any case, for all of them:

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
