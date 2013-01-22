Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39779 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752883Ab3AVSor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 13:44:47 -0500
Date: Tue, 22 Jan 2013 20:44:43 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, arun.kk@samsung.com,
	mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers
 which use videobuf2
Message-ID: <20130122184442.GB18639@valkosipuli.retiisi.org.uk>
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
 <1358156164-11382-4-git-send-email-k.debski@samsung.com>
 <20130119174329.GL13641@valkosipuli.retiisi.org.uk>
 <029c01cdf7e0$b64ce4c0$22e6ae40$%debski@samsung.com>
 <50FE6BFB.3090102@samsung.com>
 <03ad01cdf8ca$0dfcb580$29f62080$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ad01cdf8ca$0dfcb580$29f62080$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Tue, Jan 22, 2013 at 06:58:09PM +0100, Kamil Debski wrote:
...
> > OTOH I'm not certain what's the main purpose of such copied timestamps,
> > is it to identify which CAPTURE buffer comes from which OUTPUT buffer ?
> > 
> 
> Yes, indeed. This is especially useful when the CAPTURE buffers can be
> returned in an order different than the order of corresponding OUTPUT
> buffers.

How about sequence numbers then? Shouldn't that be also copied?

If you're interested in the order alone, comparing the sequence numbers is a
better way to figure out the order. That does require strict one-to-one
mapping between the output and capture buffers, though, and that does not
help in knowing when it might be a good time to display a frame, for
instance.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
