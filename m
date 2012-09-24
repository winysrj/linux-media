Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38410 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab2IXUlv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 16:41:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
Date: Mon, 24 Sep 2012 22:42:27 +0200
Message-ID: <51868809.nWmvjZBbrW@avalon>
In-Reply-To: <20120924200634.GK12025@valkosipuli.retiisi.org.uk>
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com> <20120924200634.GK12025@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 24 September 2012 23:06:34 Sakari Ailus wrote:
> On Sun, Sep 23, 2012 at 04:56:21PM +0530, Prabhakar Lad wrote:
> > Hi All,
> > 
> > The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
> > B/Mg gain values.
> > Since these control can be re-usable I am planning to add the
> > following gain controls as part
> > of the framework:
> > 
> > 1: V4L2_CID_GAIN_RED
> > 2: V4L2_CID_GAIN_GREEN_RED
> > 3: V4L2_CID_GAIN_GREEN_BLUE
> > 4: V4L2_CID_GAIN_BLUE
> 
> One more thing: There's an analogue gain control already in the image source
> class. I think we should explicitly say that the gains are digital (vs.
> analogue).

Some sensors have per-component analog and digital gains :-)

-- 
Regards,

Laurent Pinchart

