Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55118 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751948AbdBBSgV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 13:36:21 -0500
Date: Thu, 2 Feb 2017 19:35:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: metadata node
In-Reply-To: <b6c8267d-d18d-419e-bb2c-a21cfcbdd5bc@linaro.org>
Message-ID: <alpine.DEB.2.00.1702021932150.23282@axis700.grange>
References: <Pine.LNX.4.64.1701111007540.761@axis700.grange> <b6c8267d-d18d-419e-bb2c-a21cfcbdd5bc@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On Mon, 30 Jan 2017, Stanimir Varbanov wrote:

> Hi Guennadi,
> 
> On 01/11/2017 11:42 AM, Guennadi Liakhovetski wrote:

[snip]

> > In any case, _if_ we do keep the current approach of separate /dev/video* 
> > nodes, we need a way to associate video and metadata nodes. Earlier I 
> > proposed using media controller links for that. In your implementation of 
> 
> I don't think that media controller links is a good idea. This metadata
> api could be used by mem2mem drivers which don't have media controller
> links so we will need a generic v4l2 way to bound image buffer and its
> metadata buffer.

Is there anything, that's preventing mem2mem drivers from using the MC 
API? Arguably, if you need metadata, you cross the line of becoming a 
complex enough device to deserve MC support?

Thanks
Guennadi

> -- 
> regards,
> Stan
> 
