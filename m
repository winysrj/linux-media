Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64398 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753283AbdIDIQ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 04:16:57 -0400
Date: Mon, 4 Sep 2017 08:17:04 +0000 (UTC)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Edgar Thier <edgar.thier@theimagingsource.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: UVC property auto update
In-Reply-To: <4ce389e0-f63e-049e-b200-14ada55bb630@theimagingsource.com>
Message-ID: <alpine.DEB.2.20.1709040801550.13291@axis700.grange>
References: <c3f8b20a-65f9-ead3-9ffd-041641254af7@theimagingsource.com> <Pine.LNX.4.64.1709031714570.29016@axis700.grange> <4ce389e0-f63e-049e-b200-14ada55bb630@theimagingsource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

Thanks for the explanation.

On Mon, 4 Sep 2017, Edgar Thier wrote:

> Hi Guennadi,
> 
> The cameras in question are USB-3.0 industrial cameras from The Imaging Source.
> The ones I tested were the DFK UX250 and DFK UX264 models.
> I do not know if there are other devices that have the AUTO_UPDATE flag for various properties.
> 
> Since I received no immediate answer I tried fixing it myself.
> The result can be found here:
> https://patchwork.linuxtv.org/patch/43289/

But that patch only re-reads the flags. What does that give you? Do those 
flags change? In which way? As far as I understand the UVC Autoupdate 
feature, a change in GET_INFO data is only one possibility, (arguably) a 
more important one is changes in GET_CUR data. In either case, this should 
be implemented using the UVC Interrupt endpoint. Here's my latest 
asynchronous control patch:

https://patchwork.linuxtv.org/patch/42800/

As you can see, it only handles the VALUE_CHANGE (GET_CUR) case. I would 
suggest implementing a patch on top of it to add support for INFO_CHANGE 
and you'd be the best person to test it then!

Thanks
Guennadi

> Cheers,
> 
> Edgar
