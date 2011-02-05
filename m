Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47231 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1BEOVh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 09:21:37 -0500
Date: Sat, 5 Feb 2011 15:21:22 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: firedtv and removal of old IEEE1394 stack
Message-ID: <20110205152122.3b566ef0@stein>
In-Reply-To: <201102031706.12714.hverkuil@xs4all.nl>
References: <201102031706.12714.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 03 Hans Verkuil wrote:
> Hi Stefan,
> 
> I discovered (somewhat to my surprise) that the IEEE1394 stack was removed
> from the kernel in 2.6.37. Your commit 66fa12c571d35e3cd62574c65f1785a460105397
> indicates that the ieee1394 firedtv code can be removed in an indepedent commit.
> 
> It seems that this was forgotten since the firedtv-1394.c source is still
> present.

It is not forgotten, just delayed. :-)

> Is it OK if I remove it? I assume that anything that depends on DVB_FIREDTV_IEEE1394
> can be deleted.

This stuff can be removed indeed, and will be.  After that, some further
simplifications are possible since the backend abstraction is no longer
necessary.

> It would be nice to remove this since building the firedtv driver for older kernels
> always gives problems on ubuntu due to some missing ieee1394 headers.

How so?  Then there is something wrong with the backported sources.  If
CONFIG_IEEE1394 is not defined, neither make nor gcc ever see anything
that includes ieee1394 headers.  Vice versa regarding CONFIG_FIREWIRE and
the newer firewire headers.
-- 
Stefan Richter
-=====-==-== --=- --=-=
http://arcgraph.de/sr/
