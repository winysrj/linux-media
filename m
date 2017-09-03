Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49194 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752878AbdICPT2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 11:19:28 -0400
Date: Sun, 3 Sep 2017 17:19:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Edgar Thier <edgar.thier@theimagingsource.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: UVC property auto update
In-Reply-To: <c3f8b20a-65f9-ead3-9ffd-041641254af7@theimagingsource.com>
Message-ID: <Pine.LNX.4.64.1709031714570.29016@axis700.grange>
References: <c3f8b20a-65f9-ead3-9ffd-041641254af7@theimagingsource.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

I'm adding UVC maintainer to CC, he might have missed this email. Could 
you also tell us what cameras have those features? A recent patch from me 
extends the UVC driver use of the Interrupt endpoint for asynchronous 
control completion notifications. This would be another extension for the 
same interface. I guess the way to implement it would be using V4L events.

Thanks
Guennadi

On Mon, 7 Aug 2017, Edgar Thier wrote:

> Hi all,
> 
> I have some USB-3.0 cameras that use UVC.
> These cameras offer auto updates for various properties.
> An example of such a property would be gain, that will be adjusted when activating the auto-gain
> property. These property changes are not queried by the UVC driver, unless it already has the
> property marked as auto update via UVC_CTRL_FLAG_AUTO_UPDATE.
> >From what I have seen, it seems that this flag is not checked when indexing the camera controls.
> However it is checked when using extension units, so all properties loaded through such a unit are
> being updates as one would hope.
> 
> My questions:
> 
> Is it intended that properties cannot mark themselves as autoupdate?
> If yes:
> 	Is there a recommended way of working around this?
> 	Do all autoupdate properties have to be in an extension unit?
> If no:
> 	What should a fix look like?
> 
> Regards,
> 
> Edgar
> 
