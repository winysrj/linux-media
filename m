Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63644 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbaCMPNT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 11:13:19 -0400
Message-id: <5321CB04.6090700@samsung.com>
Date: Thu, 13 Mar 2014 16:13:08 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Grant Likely <grant.likely@linaro.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Rob Herring <robh+dt@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
 <20140307182330.75168C40AE3@trevor.secretlab.ca>
 <20140310102630.3cb1bcd7@samsung.com>
 <20140310143758.3734FC405FA@trevor.secretlab.ca>
 <1394708896.3577.21.camel@paszta.hi.pengutronix.de>
 <20140313113527.GM21483@n2100.arm.linux.org.uk>
In-reply-to: <20140313113527.GM21483@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/03/14 12:35, Russell King - ARM Linux wrote:
[...]
> Grant and myself have exchanged emails in private on this discussing what
> should happen - essentially Grant's position is that he's happy to leave
> this stuff queued provided a resolution to his concerns are forthcoming.
> 
> However, what I find incredibly unfair is that we're taking the rap for
> these bad bindings.  From what I can see, these bad bindings were merged
> into the V4L2 code with _zero_ review by DT maintainers.  It's quite
> clear that DT maintainers would have objected to them had they seen them,

Russell, it's just unfair what you're trying to impute here.  These 
bindings were floating on the mailing list for _several_ months before 
getting merged.
They were finally acked by Rob and Grant [1], [2], however it cannot be 
seen from the commits as the Ack come late, after I sent a pull request.

> but they didn't.  And the lack of documentation of the bindings which
> has been something that's been insisted on is also disgusting.
>
> And now we're now taking the pain for that oversight.
> 
> So... frankly, I've walked away from this dysfunctional situation.  I
> don't see imx-drm moving out of drivers/staging due to this debacle for
> many months - possibly never now given that no one can agree on this
> stuff.  This just goes to show what a fscking joke mainline kernels are,
> and why people just give up and go to vendor kernels which offer /much/
> better support all round.
> 
> As far as I can see, it's proved impossible to define a set of bindings
> for display devices which satisfy everyone.  So, rather than doing
> /something/ so we can move forward, we end up doing /nothing/.
> 
> It's times like this where I start believing that /board files/ were the
> best solution for ARM, because DT just carries soo many thorny issues
> (such as these) and is a continual blocker.

My experience and feelings are similar, I started to treat mainline
kernel much less seriously after similar DT related blocking issues.
An example is a simple patch series for couple drivers that was first 
posted in July 2013 and is still not merged, because the subsystem 
maintainer requires a DT binding maintainer Ack for everything and you
can wait to death to get one, specially if there are multiple iterations,
each needing attention of a DT binding maintainer. I remember opinions, 
when the process was being defined during one of the last kernel summits, 
that things may get longer to merge upstream, due to DT binding reviews. 
And that we must live with that. But these latencies are getting so 
ridiculously large that there is nothing left but to move to an 
alternative process.

Regarding moving forward doing /something/, rather than ending up
doing nothing - IMO it's the worst thing to rush DT binding being
merged upstream. I don't think an agreement can't be achieved soon, 
if not for this release then hopefully for next one.
