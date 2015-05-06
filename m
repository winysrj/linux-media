Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43192 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbbEFAuS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 20:50:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
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
Date: Wed, 06 May 2015 03:50:13 +0300
Message-ID: <6502790.6UvsMdppjg@avalon>
In-Reply-To: <20150505162752.GA12132@infradead.org>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com> <20150505162752.GA12132@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 05 May 2015 09:27:52 Christoph Hellwig wrote:
> On Tue, May 05, 2015 at 05:39:57PM +0200, Benjamin Gaignard wrote:
> > Since few months I'm looking for Linaro to how do Secure Data Path (SPD).
> > I have tried and implemented multiple thinks but I always facing
> > architecture issues so I would like to get your help to solve the
> > problem.
> > 
> > First what is Secure Data Path ? SDP is a set of hardware features to
> > garanty that some memories regions could only be read and/or write by
> > specific hardware IPs. You can imagine it as a kind of memory firewall
> > which grant/revoke accesses to memory per devices. Firewall configuration
> > must be done in a trusted environment: for ARM architecture we plan to
> > use OP-TEE + a trusted application to do that.
> > 
> > One typical use case for SDP in a video playback which involve those
> > elements: decrypt -> video decoder -> transform -> display
> 
> Sounds like a good enough reason not to implement it ever.

The irony of it is to post an RFC on they day before 
http://www.defectivebydesign.org/dayagainstdrm/ :-)

-- 
Regards,

Laurent Pinchart

