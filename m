Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52056 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750778AbdBKWHq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Feb 2017 17:07:46 -0500
Date: Sun, 12 Feb 2017 00:07:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: metadata node
Message-ID: <20170211220742.nc4owqemvidkv4cc@ihha.localdomain>
References: <Pine.LNX.4.64.1701111007540.761@axis700.grange>
 <b6c8267d-d18d-419e-bb2c-a21cfcbdd5bc@linaro.org>
 <alpine.DEB.2.00.1702021932150.23282@axis700.grange>
 <74450682-4fdc-4561-e853-865bdaa64cfc@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74450682-4fdc-4561-e853-865bdaa64cfc@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stan,

It's been a long time. How are you doing? :-)

On Fri, Feb 10, 2017 at 02:09:42PM +0200, Stanimir Varbanov wrote:
> Hi Guennadi,
> 
> On 02/02/2017 08:35 PM, Guennadi Liakhovetski wrote:
> > Hi Stanimir,
> > 
> > On Mon, 30 Jan 2017, Stanimir Varbanov wrote:
> > 
> >> Hi Guennadi,
> >>
> >> On 01/11/2017 11:42 AM, Guennadi Liakhovetski wrote:
> > 
> > [snip]
> > 
> >>> In any case, _if_ we do keep the current approach of separate /dev/video* 
> >>> nodes, we need a way to associate video and metadata nodes. Earlier I 
> >>> proposed using media controller links for that. In your implementation of 
> >>
> >> I don't think that media controller links is a good idea. This metadata
> >> api could be used by mem2mem drivers which don't have media controller
> >> links so we will need a generic v4l2 way to bound image buffer and its
> >> metadata buffer.
> > 
> > Is there anything, that's preventing mem2mem drivers from using the MC 
> > API? Arguably, if you need metadata, you cross the line of becoming a 
> > complex enough device to deserve MC support?
> 
> Well I don't want to cross that boundary :), and I don't want to use MC
> for such simple entity with one input and one output. The only reason to
> reply to your email was to provoke your attention to the drivers which
> aren't MC based.

Do you have a particular use case in mind?

We'll need to continue to support two cases: existing hardware and use
cases employing the mem2mem interface and more complex hardware that the
mem2mem interface is not enough to support: this requires Media controller
and the request API.

Supposing that we'd extend the mem2mem interface to encompass further
functionality, for instance supporting metadata. That functionality would
only be available on mem2mem devices. Devices that would not fit to that
envelope would have to use MC / request API.

Adding more functionality to mem2mem thus will continue to extend two
incompatible (when it comes to semantics) APIs within V4L2 and MC
interfaces. That forces the driver developer to choose which one to use.
(S)he may not be fully aware of the implications of choosing either
option, possibly leading to not being able to fully support the hardware
with the chosen API. The effect is also similar for applications: they
need to support two different APIs.

Still, the existing mem2mem framework provides a well defined, easy to use
interface within the scope of the functionality it supports. As the MC
combined with request API will be a lot more generic, it is also more
demanding for applications to use it. The applications are required to, if
not know more about the devices, at least be ready to use a number of
interfaces to fully enumerate the device's capabilities.

> 
> On other side I think that sequence field in struct vb2_v4l2_buffer
> should be sufficient to bound image buffer with metadata buffer.

Indeed.

With request API, you'll be able to use the request field as well.  And
that'll work for non-mem2mem devices, too.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
