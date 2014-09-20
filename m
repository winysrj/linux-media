Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52500 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaITG70 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 02:59:26 -0400
Date: Sat, 20 Sep 2014 08:59:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian.molton@codethink.co.uk>
cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	m.chehab@samsung.com, vladimir.barinov@cogentembedded.com,
	magnus.damm@gmail.com, horms@verge.net.au, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/4] media: rcar_vin: Ensure all in-flight buffers are
 returned to error state before stopping.
In-Reply-To: <20140813183055.dbc44b7fa03f39aaa8b149c6@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1409200858460.21175@axis700.grange>
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>
 <1404812474-7627-3-git-send-email-ian.molton@codethink.co.uk>
 <53DFEF99.7040503@cogentembedded.com> <20140813183055.dbc44b7fa03f39aaa8b149c6@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ian,

On Wed, 13 Aug 2014, Ian Molton wrote:

> 
> >     Fixed kernel WARNINGs for me! \o/
> >     Ian, perhaps it makes sense for me to take these patches into my hands?
> 
> I'm planning to respin these tomorrow - is that OK? I have test hardware with two different frontends here.

Any progress on this?

Thanks
Guennadi

> -Ian
