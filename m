Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36524 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3KMTro (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 14:47:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Troy Kisky <troy.kisky@boundarydevices.com>,
	Denis Carikli <denis@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	devicetree@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Pawel Moll <pawel.moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	dri-devel@lists.freedesktop.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	linux-media@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCHv4][ 3/7] staging: imx-drm: Add RGB666 support for parallel display.
Date: Wed, 13 Nov 2013 20:48:20 +0100
Message-ID: <21976620.UIvc2kPlHX@avalon>
In-Reply-To: <20131113191230.GU16735@n2100.arm.linux.org.uk>
References: <1384334603-14208-1-git-send-email-denis@eukrea.com> <5283C860.3020103@boundarydevices.com> <20131113191230.GU16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On Wednesday 13 November 2013 19:12:30 Russell King - ARM Linux wrote:
> On Wed, Nov 13, 2013 at 11:43:44AM -0700, Troy Kisky wrote:
> > On 11/13/2013 2:23 AM, Denis Carikli wrote:
> >>   +	/* rgb666 */
> >> 
> >> +	ipu_dc_map_clear(priv, IPU_DC_MAP_RGB666);
> >> +	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 2, 17, 0xfc); /* red */
> >> +	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 1, 11, 0xfc); /* green */
> >> +	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 0, 5, 0xfc); /* blue */
> >> +
> >>   	return 0;
> >>   }
> > 
> > Since,  rgb24 and bgr24 reverse the byte numbers
> > /* rgb24 */
> >         ipu_dc_map_clear(priv, IPU_DC_MAP_RGB24);
> >         ipu_dc_map_config(priv, IPU_DC_MAP_RGB24, 0, 7, 0xff); /* blue */
> >         ipu_dc_map_config(priv, IPU_DC_MAP_RGB24, 1, 15, 0xff); /* green
> >         */
> >         ipu_dc_map_config(priv, IPU_DC_MAP_RGB24, 2, 23, 0xff); /* red */
> > 
> > /* bgr24 */
> >         ipu_dc_map_clear(priv, IPU_DC_MAP_BGR24);
> >         ipu_dc_map_config(priv, IPU_DC_MAP_BGR24, 2, 7, 0xff); /* red */
> >         ipu_dc_map_config(priv, IPU_DC_MAP_BGR24, 1, 15, 0xff); /* green
> >         */
> >         ipu_dc_map_config(priv, IPU_DC_MAP_BGR24, 0, 23, 0xff); /* blue */
> > 
> > Shouldn't rgb666 and bgr666 do the same?
> > Currently we have,
> > 
> > /* bgr666 */
> >         ipu_dc_map_clear(priv, IPU_DC_MAP_BGR666);
> >         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 5, 0xfc); /* blue */
> >         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 1, 11, 0xfc); /*
> > green */
> >         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 17, 0xfc); /* red */
> 
> Yes, I concur - this doesn't make sense to me.  BGR666 would mean in
> memory:
> 
>         1    11
>         7    21    65    0
>         BBBBBBGGGGGGRRRRRR
> 
> which reflects the same order for "RGB24" above.

Beside component order and number of bits per component, an in-memory RGB 
format also defines the memory endianness and, for formats that don't span an 
interger number of bytes, the left or right alignment.

BGR666 is currently defined in V4L2 as

Byte 0                         1                        2
Bit  7  6  5  4  3  2  1  0    7  6  5  4  3  2  1  0   7  6  5  4  3  2  1  0

     b5 b4 b3 b2 b1 b0 g5 g4  g3 g2 g1 g0 r5 r4 r3 r2  r1 r0  -  -  -  -  -  -

(see the *second* table in http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html)

I would thus expect RGB666 to be

Byte 0                         1                        2
Bit  7  6  5  4  3  2  1  0    7  6  5  4  3  2  1  0   7  6  5  4  3  2  1  0

     r5 r4 r3 r2 r1 r0 g5 g4  g3 g2 g1 g0 b5 b4 b3 b2  b1 b0  -  -  -  -  -  -

We can also define right-aligned formats if needed.

> > Where I'd expect to see
> > /* bgr666 */
> > 
> >         ipu_dc_map_clear(priv, IPU_DC_MAP_BGR666);
> >         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 17, 0xfc); /* blue
> >         */
> >         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 1, 11, 0xfc); /*
> > green */
> >         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 5, 0xfc); /* red */
> 
> So this makes sense to me.

-- 
Regards,

Laurent Pinchart

