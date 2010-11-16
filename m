Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:5358 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840Ab0KPWqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 17:46:23 -0500
Subject: Re: An article on the media controller
From: Andy Walls <awalls@md.metrocast.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
In-Reply-To: <20101116151802.0ccdcd53@bike.lwn.net>
References: <20101116151802.0ccdcd53@bike.lwn.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 17:46:27 -0500
Message-ID: <1289947587.9534.26.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2010-11-16 at 15:18 -0700, Jonathan Corbet wrote:
> I've just spent a fair while looking through the September posting of
> the media controller code (is there a more recent version?).  The
> result is a high-level review which interested people can read here:
> 
> 	http://lwn.net/SubscriberLink/415714/1e837f01b8579eb7/

As I understand it, the current code patches are a subset of the
ultimate desired/planned  functionality. 

So I would need to think about this statement:

"Given that the configuration interface changes a single bit at a time,
there is no need for the sort of transactional functionality that can
make ioctl() preferable to sysfs."

It may very well apply to the current patches, but I'd have to think
about if multiple items would need to be set or queried at one time.

You might just want to add the qualifier "current" when referring to the
interface changes.

Regards,
Andy

> Most people will not see it for another 24 hours or so; if there's
> something I got radically wrong, I'd appreciate hearing about it.
> 
> The executive summary is that I think this code really needs some
> exposure outside of the V4L2 list; I'd encourage posting it to
> linux-kernel.  That could be hard on plans for a 2.6.38 merge (or, at
> least, plans for any spare time between now and then), but the end
> result might be better for everybody.
> 
> I have some low-level comments too which were not suitable for the
> article.  I'll be posting them here, but I have to get some other
> things done first.
> 
> Thanks,
> 
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


