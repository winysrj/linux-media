Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55618 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2IZPWh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 11:22:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Chris MacGregor <chris@cybermato.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
Date: Wed, 26 Sep 2012 17:23:13 +0200
Message-ID: <1703218.fEdZSF7M3x@avalon>
In-Reply-To: <50631461.7080903@cybermato.com>
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com> <20120926074240.GM12025@valkosipuli.retiisi.org.uk> <50631461.7080903@cybermato.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Wednesday 26 September 2012 07:42:41 Chris MacGregor wrote:
> On 09/26/2012 12:42 AM, Sakari Ailus wrote:
> > On Wed, Sep 26, 2012 at 12:14:36PM +0530, Prabhakar Lad wrote:
> >> On Sun, Sep 23, 2012 at 4:56 PM, Prabhakar Lad wrote:
> >>> Hi All,
> >>> 
> >>> The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
> >>> B/Mg gain values.
> >>> Since these control can be re-usable I am planning to add the
> >>> following gain controls as part
> >>> of the framework:
> >>> 
> >>> 1: V4L2_CID_GAIN_RED
> >>> 2: V4L2_CID_GAIN_GREEN_RED
> >>> 3: V4L2_CID_GAIN_GREEN_BLUE
> >>> 4: V4L2_CID_GAIN_BLUE
> >>> 5: V4L2_CID_GAIN_OFFSET
> >>> 
> >>> I need your opinion's to get moving to add them.
> >> 
> >> I am listing out the gain controls which is the outcome of above
> >> discussion:-
> >> 
> >> 1: V4L2_CID_GAIN_RED
> >> 2: V4L2_CID_GAIN_GREEN_RED
> >> 3: V4L2_CID_GAIN_GREEN_BLUE
> >> 4: V4L2_CID_GAIN_BLUE
> >> 5: V4L2_CID_GAIN_OFFSET
> >> 6: V4L2_CID_BLUE_OFFSET
> >> 7: V4L2_CID_RED_OFFSET
> >> 8: V4L2_CID_GREEN_OFFSET
> > 
> > Hi Prabhakar,
> > 
> > As these are low level controls, I wonder whether it would make sense to
> > make a difference between digital and analogue gain. I admit I'm not quite
> > as certain whether there's such a large difference as there is for global
> > gains for the camera control algorithms.
> 
> Sorry to make this more complicated, but the Aptina MT9P031, for
> instance (datasheet at
> http://www.aptina.com/assets/downloadDocument.do?id=865 - see page 35),
> has Digital Gain, an Analog Multiplier, and Analog Gain (for each of R,
> Gr, Gb, and B). For each color channel, there is one register, with the
> bits divided up into the three gain types. Furthermore, the different
> gain types have different units (increments).
> 
> Currently (at least in the last version I've used), the driver hides all
> this and provides a single gain control, and prioritizes which gain
> types are adjusted at different user-level gain settings in accordance
> with the datasheet recommendations (e.g. keep the analog gain between 1
> and 4 for best noise performance, and use the multiplier for gains
> between 4 and 8). This seems very sensible.

I think it should be fine for now. If we later find out that a user space 
application really needs to control the analog and digital gains individually 
and precisely we can always split the controls then. For now I think a single 
gain control (per channel) that groups analog and digital gains should be 
enough.

> If we try to distinguish between analog and digital gains in the control
> definitions, what should this driver do? And what about the multiplier? I
> suppose it could be "hidden" by the driver as part of the analog gain, as
> the driver currently does for the entire gain...

-- 
Regards,

Laurent Pinchart

