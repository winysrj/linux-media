Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:59669 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1HaVUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 17:20:15 -0400
Date: Thu, 1 Sep 2011 00:20:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Bastian Hecht <hechtb@googlemail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] media: Add camera controls for the ov5642 driver
Message-ID: <20110831212010.GS12368@valkosipuli.localdomain>
References: <alpine.DEB.2.02.1108171553540.17550@ipanema>
 <201108282006.09790.laurent.pinchart@ideasonboard.com>
 <CABYn4sx5jQPyLC4d6OfVbX5SSuS4TiNsB_LPoCheaOSbwM9Pzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYn4sx5jQPyLC4d6OfVbX5SSuS4TiNsB_LPoCheaOSbwM9Pzw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 31, 2011 at 03:27:49PM +0000, Bastian Hecht wrote:
> 2011/8/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
[clip]
> > If I'm not mistaken V4L2_CID_PRIVATE_BASE is deprecated.
> 
> I checked at http://v4l2spec.bytesex.org/spec/x542.htm, googled
> "V4L2_CID_PRIVATE_BASE deprecated" and read
> Documentation/feature-removal-schedule.txt. I couldn't find anything.

Hmm. Did you happen to check when that has been written? :)

Please use this one instead:

<URL:http://hverkuil.home.xs4all.nl/spec/media.html>

-- 
Sakari Ailus
sakari.ailus@iki.fi
