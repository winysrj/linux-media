Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35602 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753893AbdBGOLi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 09:11:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarit.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        sakari.ailus@linux.intel.com
Subject: Re: [PATCH v3 13/24] platform: add video-multiplexer subdevice driver
Date: Tue, 07 Feb 2017 16:11:58 +0200
Message-ID: <1697893.vOtUuelROR@avalon>
In-Reply-To: <1486464090.2277.60.camel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com> <3823958.XNLmIv7GEv@avalon> <1486464090.2277.60.camel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tuesday 07 Feb 2017 11:41:30 Philipp Zabel wrote:
> On Tue, 2017-02-07 at 12:26 +0200, Laurent Pinchart wrote:
> > On Monday 06 Feb 2017 15:10:46 Steve Longerbeam wrote:
> >> On 02/06/2017 02:33 PM, Laurent Pinchart wrote:
> >>> On Monday 06 Feb 2017 10:50:22 Hans Verkuil wrote:
> >>>> On 02/05/2017 04:48 PM, Laurent Pinchart wrote:
> >>>>> On Tuesday 24 Jan 2017 18:07:55 Steve Longerbeam wrote:
> >>>>>> On 01/24/2017 04:02 AM, Philipp Zabel wrote:
> >>>>>>> On Fri, 2017-01-20 at 15:03 +0100, Hans Verkuil wrote:
> >>>>>>>>> +
> >>>>>>>>> +int vidsw_g_mbus_config(struct v4l2_subdev *sd, struct
> >>>>>>>>> v4l2_mbus_config *cfg)
> > 
> > [snip]
> > 
> >>>>>>>> I am not certain this op is needed at all. In the current kernel
> >>>>>>>> this op is only used by soc_camera, pxa_camera and omap3isp
> >>>>>>>> (somewhat dubious). Normally this information should come from the
> >>>>>>>> device tree and there should be no need for this op.
> >>>>>>>> 
> >>>>>>>> My (tentative) long-term plan was to get rid of this op.
> >>>>>>>> 
> >>>>>>>> If you don't need it, then I recommend it is removed.
> >>>>>> 
> >>>>>> Hi Hans, the imx-media driver was only calling g_mbus_config to the
> >>>>>> camera sensor, and it was doing that to determine the sensor's bus
> >>>>>> type. This info was already available from parsing a
> >>>>>> v4l2_of_endpoint from the sensor node. So it was simple to remove the
> >>>>>> g_mbus_config calls, and instead rely on the parsed sensor
> >>>>>> v4l2_of_endpoint.
> >>>>> 
> >>>>> That's not a good point.
> >>> 
> >>> (mea culpa, s/point/idea/)
> >>> 
> >>>>> The imx-media driver must not parse the sensor DT node as it is not
> >>>>> aware of what bindings the sensor is compatible with.
> >> 
> >> Hi Laurent,
> >> 
> >> I don't really understand this argument. The sensor node has been found
> >> by parsing the OF graph, so it is known to be a camera sensor node at
> >> that point.
> > 
> > All you know in the i.MX6 driver is that the remote node is a video
> > source. You can rely on the fact that it implements the OF graph bindings
> > to locate other ports in that DT node, but that's more or less it.
> > 
> > DT properties are defined by DT bindings and thus qualified by a
> > compatible string. Unless you match on sensor compat strings in the i.MX6
> > driver (which you shouldn't do, to keep the driver generic) you can't know
> > for certain how to parse the sensor node DT properties. For all you know,
> > the video source could be a bridge such as an HDMI to CSI-2 converter for
> > instance, so you can't even rely on the fact that it's a sensor.
> > 
> >>>>> Information must instead be queried from the sensor subdev at
> >>>>> runtime, through the g_mbus_config() operation.
> >>>>> 
> >>>>> Of course, if you can get the information from the imx-media DT
> >>>>> node, that's certainly an option. It's only information provided by
> >>>>> the sensor driver that you have no choice but query using a subdev
> >>>>> operation.
> >>>> 
> >>>> Shouldn't this come from the imx-media DT node? BTW, why is omap3isp
> >>>> using this?
> >>> 
> >>> It all depends on what type of information needs to be retrieved, and
> >>> whether it can change at runtime or is fixed. Adding properties to the
> >>> imx-media DT node is certainly fine as long as those properties
> >>> describe the i.MX side.
> >> 
> >> In this case the info needed is the media bus type. That info is most
> >> easily available by calling v4l2_of_parse_endpoint() on the sensor's
> >> endpoint node.
> > 
> > I haven't had time to check the code in details yet, so I can't really
> > comment on what you need and how it should be implemented exactly.
> > 
> >> The media bus type is not something that can be added to the
> >> imx-media node since it contains no endpoint nodes.
> > 
> > Agreed. You have endpoints in the CSI nodes though.
> > 
> >>> In the omap3isp case, we use the operation to query whether parallel
> >>> data contains embedded sync (BT.656) or uses separate h/v sync signals.
> >>> 
> >>>> The reason I am suspicious about this op is that it came from
> >>>> soc-camera and predates the DT. The contents of v4l2_mbus_config seems
> >>>> very much like a HW description to me, i.e. something that belongs in
> >>>> the DT.
> >>> 
> >>> Part of it is possibly outdated, but for buses that support multiple
> >>> modes of operation (such as the parallel bus case described above) we
> >>> need to make that information discoverable at runtime. Maybe this should
> >>> be considered as related to Sakari's efforts to support VC/DT for CSI-2,
> >>> and supported through the API he is working on.
> >>
> >> That sounds interesting, can you point me to some info on this effort?
> > 
> > Sure.
> > 
> > http://git.retiisi.org.uk/?p=~sailus/linux.git;a=shortlog;h=refs/heads/vc
> > 
> >> I've been thinking the DT should contain virtual channel info for CSI-2
> >> buses.
> > 
> > I don't think it should. CSI-2 virtual channels and data types should be
> > handled as a software concept, and thus supported through driver code
> > without involving DT.
> 
> I agree. The CSI2IPU gasket is a bit special in that it distributes its
> input data to four different parallel buses depending on the input's VC,
> but upstream of the MIPI CSI-2 receiver, any virtual channel information
> is purely a matter of the data sent over the CSI-2 link, and not board
> specific hardware description.

If the CSI2IPU gasket has four physical output buses then it can be modelled 
as an entity with four source pads. Only when VC/DT are multiplexed on the 
same physical bus do I think they should be handled without involving the 
device tree and the media controller graph.

-- 
Regards,

Laurent Pinchart

