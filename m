Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49165 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbcARMO6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:14:58 -0500
Date: Mon, 18 Jan 2016 13:14:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L: add Y12I, Y8I and Z16 pixel format documentation
In-Reply-To: <20160113102453.GJ576@valkosipuli.retiisi.org.uk>
Message-ID: <Pine.LNX.4.64.1601181312340.9140@axis700.grange>
References: <Pine.LNX.4.64.1512151732080.18335@axis700.grange>
 <20160113102453.GJ576@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

to one of your earlier comments:

On Wed, 13 Jan 2016, Sakari Ailus wrote:

[snip]

> > +
> > +    <example>
> > +      <title><constant>V4L2_PIX_FMT_Z16</constant> 4 &times; 4
> > +pixel image</title>
> > +
> > +      <formalpara>
> 
> I'm not sure there are strict rules for indenting DocBook in kernel, but
> this looks a bit funny. Two is being used elsewhere, this is -1.

That's not two instead of -1. That's a TAB instead of 8 spaces, which is 
the same as in other pixel format DocBook files.

Thanks
Guennadi
