Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760629AbbEEQ1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 12:27:52 -0400
Date: Tue, 5 May 2015 09:27:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Subject: Re: [RFC] How implement Secure Data Path ?
Message-ID: <20150505162752.GA12132@infradead.org>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 05, 2015 at 05:39:57PM +0200, Benjamin Gaignard wrote:
> Since few months I'm looking for Linaro to how do Secure Data Path (SPD).
> I have tried and implemented multiple thinks but I always facing architecture
> issues so I would like to get your help to solve the problem.
> 
> First what is Secure Data Path ? SDP is a set of hardware features to garanty
> that some memories regions could only be read and/or write by specific hardware
> IPs. You can imagine it as a kind of memory firewall which grant/revoke
> accesses to memory per devices. Firewall configuration must be done in a trusted
> environment: for ARM architecture we plan to use OP-TEE + a trusted
> application to do that.
> 
> One typical use case for SDP in a video playback which involve those elements:
> decrypt -> video decoder -> transform -> display

Sounds like a good enough reason not to implement it ever.
