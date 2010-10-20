Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:63822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab0JTSlF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 14:41:05 -0400
Date: Wed, 20 Oct 2010 14:40:47 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Remaining patches in my queue for IR
Message-ID: <20101020184047.GC15314@redhat.com>
References: <1287269790-17605-1-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287269790-17605-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Oct 17, 2010 at 12:56:27AM +0200, Maxim Levitsky wrote:
> Hi,
> 
> This series is rebased on top of media_tree/staging/v2.6.37 only.
> Really this time, sorry for cheating, last time :-)
> 
> The first patch like we agreed extends the raw packets.
> It touches all drivers (except imon as it isn't a raw IR driver).
> Code is compile tested with all drivers, 
> and run tested with ENE and all receiver protocols
> (except the streamzap rc5 flavour)
> Since it also moves timeouts to lirc bridge, at least streazap driver
> should have its timeout gap support removed. I am afraid to break the code
> if I do so.

I've tested both mceusb and streamzap with this patchset included, don't
see any ill side-effects. Only issue I really saw was that the raw event
init call was added somewhat superfluously to a number of drivers -- the
rawir struct its initializing was already kzalloc'd, so we're just
needlessly re-zero'ing it out again. Its not bad for clarity's sake, but
does add some unnecessary inefficiency.

-- 
Jarod Wilson
jarod@redhat.com

