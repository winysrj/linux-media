Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57110 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750778AbdBKUil (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Feb 2017 15:38:41 -0500
Date: Sat, 11 Feb 2017 21:38:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: metadata node
In-Reply-To: <74450682-4fdc-4561-e853-865bdaa64cfc@linaro.org>
Message-ID: <Pine.LNX.4.64.1702112129330.27729@axis700.grange>
References: <Pine.LNX.4.64.1701111007540.761@axis700.grange>
 <b6c8267d-d18d-419e-bb2c-a21cfcbdd5bc@linaro.org>
 <alpine.DEB.2.00.1702021932150.23282@axis700.grange>
 <74450682-4fdc-4561-e853-865bdaa64cfc@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 10 Feb 2017, Stanimir Varbanov wrote:

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

Would be nice to hear others' opinions.

> On other side I think that sequence field in struct vb2_v4l2_buffer
> should be sufficient to bound image buffer with metadata buffer.

How can that be helpful? Firstly you have to be able to find node pairs 
without streaming. Secondly, you don't want to open all nodes and try to 
dequeue buffers on them to find out which ones begin to stream and have 
equal sequence numbers.

Thanks
Guennadi

> -- 
> regards,
> Stan
