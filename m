Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45580 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0IOLtE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 07:49:04 -0400
Message-ID: <4C90B29A.2040602@s5r6.in-berlin.de>
Date: Wed, 15 Sep 2010 13:48:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Tommy Jonsson <quazzie2@gmail.com>
CC: linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] firedtv driver: support for PSK8 for S2 devices. To watch
 HD.
References: <AANLkTin53SY_xaed_tRfWRPOFmc65GmGzXrEt15ZyriW@mail.gmail.com>
In-Reply-To: <AANLkTin53SY_xaed_tRfWRPOFmc65GmGzXrEt15ZyriW@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Tommy Jonsson wrote at linux-media:
> This is the first i have ever developed for linux, cant really wrap my
> head around how to submit this..
> Hope im sending this correctly, diff made with 'hg diff' from latest
> "hg clone http://linuxtv.org/hg/v4l-dvb"
> 
> It adds support for tuning with PSK8 modulation, pilot and rolloff
> with the S2 versions of firedtv.
> 
> Signed-off-by: Tommy Jonsson <quazzie2@gmail.com>
[...]

Excellent!  This has been on the wishlist of FireDTV/FloppyDTV-S2 owners for
quite some time.

The patch was a little bit mangled by the mail user agent, and there appear to
be some whitespace issues in it.  I will have a closer look at it later today
and repost the patch so that Mauro can apply it without manual intervention.
-- 
Stefan Richter
-=====-==-=- =--= -====
http://arcgraph.de/sr/
