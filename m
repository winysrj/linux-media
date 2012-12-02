Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45317 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753884Ab2LBUx4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Dec 2012 15:53:56 -0500
Date: Sun, 2 Dec 2012 22:53:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v1.2 1/4] v4l: Define video buffer flags for timestamp
 types
Message-ID: <20121202205351.GK31879@valkosipuli.retiisi.org.uk>
References: <1353098995-1319-1-git-send-email-sakari.ailus@iki.fi>
 <201211212353.02256.hverkuil@xs4all.nl>
 <20121121235859.GB31442@valkosipuli.retiisi.org.uk>
 <5788992.si3u8AaYMi@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5788992.si3u8AaYMi@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the comments.

On Tue, Nov 27, 2012 at 05:04:29PM +0100, Laurent Pinchart wrote:
> On Thursday 22 November 2012 01:59:00 Sakari Ailus wrote:
> > On Wed, Nov 21, 2012 at 11:53:02PM +0100, Hans Verkuil wrote:
,,,
> > > What do you think?
> > 
> > Fine for me. Sylwester also brought memory-to-memory devices (and
> > memory-to-memory processing whether the device is classified as such in API
> > or not) to my attention. For those devices it likely wouldn't matter at all
> > what's the system time when the frame is processed since the frame wasn't
> > captured at that time anyway.
> > 
> > In those cases it might makes sense to use timestamp that e.g. comes from
> > the compressed stream, or pass encoder timestamps that are going to be part
> > of the compressed stream. I think MPEG-related use cases were briefly
> > mentioned in the timestamp discussion earlier.
> 
> When uncompressing a stream you will get the MPEG embedded timestamp on the 
> capture side. The timestamp returned to userspace at QBUF time on the output 
> side will still be unused. I don't really see a use case for returning the 
> timestamp at which the frame is expected to be processed by the codec, so we 
> could just make the field reserved for future use in that case.

Is the timestamp embedded in the compressed data itself in that case, or
where? Could this be codec-dependent?

> > > > The driver stores the time at which
> > > > +	    the first data byte was actually sent out in the
> > > > +	    <structfield>timestamp</structfield> field.
> > > 
> > > Same problem as with the capture time: does the timestamp refer to the
> > > first or last byte that's sent out? I think all output drivers set it to
> > > the time of the last byte (== when the DMA of the frame is finished).
> > 
> > I haven't actually even seen a capture driver that would do otherwise, but
> > that could be just me not knowing many enough. :-) Would we actually break
> > something if we changed the definition to say that this is the timestamp
> > taken when the frame is done?
> 
> For software timestamps we could do that, but for hardware timestamps the 
> exact timestamping time may vary.

Should we then do this for the timestamps that are obtained from the system
clock? We also haven't defined other kinds of tiemstamps yet.

For timestamp types that are hardware-dependent we could have exceptions.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
