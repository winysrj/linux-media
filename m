Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:44166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1ETXVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 19:21:24 -0400
Message-ID: <4DD6F76B.5010906@infradead.org>
Date: Fri, 20 May 2011 20:21:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
CC: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx18: Move spinlock and vb_type initialisation into stream_init
References: <4DC2A8FD.4010902@infradead.org> <1305035390-31439-1-git-send-email-simon.farnsworth@onelan.co.uk>
In-Reply-To: <1305035390-31439-1-git-send-email-simon.farnsworth@onelan.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-05-2011 10:49, Simon Farnsworth escreveu:
> The initialisation of vb_type in serialized_open was preventing
> REQBUFS from working reliably. Remove it, and move the spinlock into
> stream_init for good measure - it's only used when we have a stream
> that supports videobuf anyway.
> 
> Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> ---
> Mauro,
> 
> This fixes a bug I introduced, and noticed while trying to work out
> how videobuf works and interacts with the rest of the driver, in
> preparation for working out how to port this code to videobuf2.
> 
> Briefly, if you open a device node at the wrong time, you lose
> videobuf support forever.
> 
> Please consider this for 2.6.40,

/me is assuming that Andy is ok with it.

Ok, I'm adding this to my series, as it is part of the code you added.


Thanks,
Mauro.
