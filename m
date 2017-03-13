Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51557 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750983AbdCMJZv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 05:25:51 -0400
Date: Mon, 13 Mar 2017 10:25:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] v4l: soc-camera: Remove videobuf1 support
In-Reply-To: <fcf1bcf3-12ca-262b-c161-3783ce8fc282@cisco.com>
Message-ID: <Pine.LNX.4.64.1703131024350.31520@axis700.grange>
References: <20170308153327.23954-1-laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1703121300040.22698@axis700.grange>
 <fcf1bcf3-12ca-262b-c161-3783ce8fc282@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 13 Mar 2017, Hans Verkuil wrote:

> On 03/12/2017 01:06 PM, Guennadi Liakhovetski wrote:
> > Hi Laurent,
> > 
> > Thanks for the patch. I just checked in the current media/master, there
> > are still 2 users of vb1: sh_mobile_ceu_camera.c and atmel-isi.c. I
> > understand, that they are about to be removed either completely or out of
> > soc-camera, maybe patches for that have already beed submitted, but they
> > haven't been committed yet. Shall we wait until then with this patch?
> > Would be easier to handle dependencies, there isn't any hurry with it,
> > right?
> 
> ????
> 
> Both drivers use vb2.

Uhm, ok, I stand corrected. I just grepped for symbols, that get deleted 
by the patch and my grep was too generous.

Thanks
Guennadi

> I've already added this patch to a pull request of mine.
> 
> Regards,
> 
> 	Hans
> 
