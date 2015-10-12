Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44943 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751713AbbJLP4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 11:56:42 -0400
Date: Mon, 12 Oct 2015 18:56:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Current status of MC patches?
Message-ID: <20151012155638.GM26916@valkosipuli.retiisi.org.uk>
References: <561BB0D1.1030102@xs4all.nl>
 <20151012121153.75691744@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151012121153.75691744@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Hans,

On Mon, Oct 12, 2015 at 12:11:53PM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 12 Oct 2015 15:08:33 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > Hi Mauro,
> > 
> > Can you give an update of the current status of the MC work? To be honest,
> > I've lost track.
> > 
> > In particular, is there anything I and/or others need to review before you
> > can start merging patches?
> 
> Basically, we're still waiting for Laurent and Sakari's review.

Could you resend what you have to the list, please? Currently it's a number
of sets some of which contain updates only on particular patches. It'd be
easier to review that way.

I've been working on top of the set to add support for unlimited number of
entities, so unfortunately I've had less time for reviews. These patches are
still required before the rest can be applied so I've priorised them.

> > This is also relevant for the workshop agenda. I plan to put any MC topics
> > at the end of the workshop. As you mentioned in a mail exchange with Shuah,
> > as long as these patches aren't merged there is not all that much point in
> > discussing future work.
> 
> Yep. There's no sense to even discuss MC at the workshop while the
> current work is not reviewed, as the other MC topic for discussion
> is related to dynamic support, to be added after the MC next gen
> support for G_TOPOLOGY.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
