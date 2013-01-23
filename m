Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1899 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3AWJE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 04:04:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers which use videobuf2
Date: Wed, 23 Jan 2013 10:03:47 +0100
Cc: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, arun.kk@samsung.com,
	mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, kyungmin.park@samsung.com
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com> <20130122184442.GB18639@valkosipuli.retiisi.org.uk> <040701cdf946$3a18c060$ae4a4120$%debski@samsung.com>
In-Reply-To: <040701cdf946$3a18c060$ae4a4120$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301231003.47396.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 23 January 2013 09:47:06 Kamil Debski wrote:
> Hi,
> 
> > From: 'Sakari Ailus' [mailto:sakari.ailus@iki.fi]
> > Sent: Tuesday, January 22, 2013 7:45 PM
> > 
> > Hi Kamil,
> > 
> > On Tue, Jan 22, 2013 at 06:58:09PM +0100, Kamil Debski wrote:
> > ...
> > > > OTOH I'm not certain what's the main purpose of such copied
> > > > timestamps, is it to identify which CAPTURE buffer comes from which
> > OUTPUT buffer ?
> > > >
> > >
> > > Yes, indeed. This is especially useful when the CAPTURE buffers can
> > be
> > > returned in an order different than the order of corresponding OUTPUT
> > > buffers.
> > 
> > How about sequence numbers then? Shouldn't that be also copied?
> > 
> > If you're interested in the order alone, comparing the sequence numbers
> > is a better way to figure out the order. That does require strict one-
> > to-one mapping between the output and capture buffers, though, and that
> > does not help in knowing when it might be a good time to display a
> > frame, for instance.
> > 
> 
> The idea behind copying the timestamp was that it can propagate the
> timestamp
> from the video stream. If this info is absent application can generate them
> and
> still be able to connect OUTPUT and CAPTURE frames. 
> 
> While decoding MPEG4 it is possible to get a compressed frame saying
> "nothing
> to do here, move along" (which basically means that the last frame should be
> repeated).
> This is where increasing sequence number comes in handy. Even if no
> timestamp
> is set the application can detect such empty frames and display the decoded
> video
> correctly.
> 
> Copying sequence numbers was already discussed in January 2012 IIRC. The
> recommendation
> was that the device keeps an internal sequence counter and assigns it to
> both OUTPUT and
> CAPTURE buffers, so they can be associated.
> 
> I think that we're diverting from the main topic of this discussion. My
> patches fix a
> problem and the only thing that, we cannot agree about is what the default
> timestamp type
> should be.

Right. And in my view there should be no default timestamp. Drivers should
always select MONOTONIC or COPY, and never UNKNOWN. The vb2 code should
check for that and issue a WARN_ON if no proper timestamp type was provided.

v4l2-compliance already checks for that as well.

Regards,

	Hans
