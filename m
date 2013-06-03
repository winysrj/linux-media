Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41285 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755323Ab3FCB0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 21:26:06 -0400
Date: Mon, 3 Jun 2013 04:25:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC] Motion Detection API
Message-ID: <20130603012559.GA2075@valkosipuli.retiisi.org.uk>
References: <201304121736.16542.hverkuil@xs4all.nl>
 <201305061541.41204.hverkuil@xs4all.nl>
 <2428502.07isB1rKTR@avalon>
 <201305071435.30062.hverkuil@xs4all.nl>
 <518909DA.8000407@samsung.com>
 <20130508162648.GG1075@valkosipuli.retiisi.org.uk>
 <518ACDDA.3080908@gmail.com>
 <20130521173037.GD2041@valkosipuli.retiisi.org.uk>
 <519D3B9E.4090800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519D3B9E.4090800@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, May 22, 2013 at 11:41:50PM +0200, Sylwester Nawrocki wrote:
> [...]
> >>>I'm in favour of using a separate video buffer queue for passing
> >>>low-level
> >>>metadata to user space.
> >>
> >>Sure. I certainly see a need for such an interface. I wouldn't like to
> >>see it
> >>as the only option, however. One of the main reasons of introducing
> >>MPLANE
> >>API was to allow capture of meta-data. We are going to finally prepare
> >>some
> >>RFC regarding usage of a separate plane for meta-data capture. I'm not
> >>sure
> >>yet how it would look exactly in detail, we've just discussed this topic
> >>roughly with Andrzej.
> >
> >I'm fine that being not the only option; however it's unbeatable when it
> >comes to latencies. So perhaps we should allow using multi-plane buffers
> >for the same purpose as well.
> >
> >But how to choose between the two?
> 
> I think we need some example implementation for metadata capture over
> multi-plane interface and with a separate video node. Without such
> implementation/API draft it is a bit difficult to discuss this further.

Yes, that'd be quite nice.

There are actually a number of things that I think would be needed to
support what's discussed above. Extended frame descriptors (I'm preparing
RFC v2 --- yes, really!) are one.

Also creating video nodes based on how many different content streams there
are doesn't make much sense to me. A quick and dirty solution would be to
create a low level metadata queue type to avoid having to create more video
nodes. I think I'd prefer a more generic solution though.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
