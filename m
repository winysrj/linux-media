Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47940 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753000Ab2IZHmr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 03:42:47 -0400
Date: Wed, 26 Sep 2012 10:42:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
Message-ID: <20120926074240.GM12025@valkosipuli.retiisi.org.uk>
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
 <CA+V-a8v=_2vkuaYCAJNuyrqBX2bjU11KGASh7vkEQ4Qt2bFCGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8v=_2vkuaYCAJNuyrqBX2bjU11KGASh7vkEQ4Qt2bFCGA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 26, 2012 at 12:14:36PM +0530, Prabhakar Lad wrote:
> Hi All,
> 
> On Sun, Sep 23, 2012 at 4:56 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
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
> > 5: V4L2_CID_GAIN_OFFSET
> >
> > I need your opinion's to get moving to add them.
> >
> 
> I am listing out the gain controls which is the outcome of above discussion:-
> 
> 1: V4L2_CID_GAIN_RED
> 2: V4L2_CID_GAIN_GREEN_RED
> 3: V4L2_CID_GAIN_GREEN_BLUE
> 4: V4L2_CID_GAIN_BLUE
> 5: V4L2_CID_GAIN_OFFSET
> 6: V4L2_CID_BLUE_OFFSET
> 7: V4L2_CID_RED_OFFSET
> 8: V4L2_CID_GREEN_OFFSET

Hi Prabhakar,

As these are low level controls, I wonder whether it would make sense to
make a difference between digital and analogue gain. I admit I'm not quite
as certain whether there's such a large difference as there is for global
gains for the camera control algorithms.

Which ones do you need now?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
