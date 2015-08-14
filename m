Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47521 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752634AbbHNWiQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 18:38:16 -0400
Date: Sat, 15 Aug 2015 01:37:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 0/6] MC preparation patches
Message-ID: <20150814223744.GE28370@valkosipuli.retiisi.org.uk>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1439563682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Aug 14, 2015 at 11:56:37AM -0300, Mauro Carvalho Chehab wrote:
> Those are the initial patches from my previous series of MC changes.
> 
> The first patch removes an unused parameter when creating links.
> 
> The next 5 patches warrant that all object types (entities, pads and
> links) will have an unique ID, as agreed at the MC workshop.
> 
> They prepare for the addition of the media interfaces and interface
> links.

Having looked the set through, I don't think the patches in the set are
strictly necessary for adding media interfaces. Again, I need to stress I'd
very much prefer to keep things simple in order to get support for media
interfaces in soon, as I understand your intention is as well.

We could make things more dynamic later on, and represent associations using
links --- if there's a use case for that.

I don't as such object the patchset, but my question is: where will this all
lead to? I'd like to see that, or at least some more, before finally acking
the patches. I sense these should be closely related to supporting the
property API rather than media interfaces (or DVB), but unfortunately I
won't have time to work on the property API for the following ~ three weeks.

struct media_interface could be pointed to from entities using a statically
allocated array of pointers, a bit like links (except that they're not
pointers). I think we'd get quite far with this already while making much
fewer changes to the framework.

One thing that wasn't discussed at length in the meeting, but which I
understood was generally agreed on, was DMA engines as entities (vs. having
a pad for the sake of the interface in the video node entity, which is
ugly). IMHO a sound foundation is important for the proposed changes.

Just my one euro cent --- got some left from Italy. :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
