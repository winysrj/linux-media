Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34858 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbEFIfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 04:35:12 -0400
Received: by wgyo15 with SMTP id o15so3453700wgy.2
        for <linux-media@vger.kernel.org>; Wed, 06 May 2015 01:35:11 -0700 (PDT)
Date: Wed, 6 May 2015 10:37:30 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Subject: Re: [RFC] How implement Secure Data Path ?
Message-ID: <20150506083730.GG30184@phenom.ffwll.local>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
 <20150505162752.GA12132@infradead.org>
 <6502790.6UvsMdppjg@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6502790.6UvsMdppjg@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 06, 2015 at 03:50:13AM +0300, Laurent Pinchart wrote:
> On Tuesday 05 May 2015 09:27:52 Christoph Hellwig wrote:
> > On Tue, May 05, 2015 at 05:39:57PM +0200, Benjamin Gaignard wrote:
> > > Since few months I'm looking for Linaro to how do Secure Data Path (SPD).
> > > I have tried and implemented multiple thinks but I always facing
> > > architecture issues so I would like to get your help to solve the
> > > problem.
> > > 
> > > First what is Secure Data Path ? SDP is a set of hardware features to
> > > garanty that some memories regions could only be read and/or write by
> > > specific hardware IPs. You can imagine it as a kind of memory firewall
> > > which grant/revoke accesses to memory per devices. Firewall configuration
> > > must be done in a trusted environment: for ARM architecture we plan to
> > > use OP-TEE + a trusted application to do that.
> > > 
> > > One typical use case for SDP in a video playback which involve those
> > > elements: decrypt -> video decoder -> transform -> display
> > 
> > Sounds like a good enough reason not to implement it ever.
> 
> The irony of it is to post an RFC on they day before 
> http://www.defectivebydesign.org/dayagainstdrm/ :-)

Just for the record: Even though I disagree with the design&threat model
for secure memory I don't think we should outright refuse to merge
patches. Assuming it comes with a sane design and no blob bits I'd be very
much willing to merge support for i915. Unfortunately Intel isn't willing
to publish the specs for any of the content protection stuff, at least
right now.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
