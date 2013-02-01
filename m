Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44579 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3BAXfw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 18:35:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	sunil joshi <joshi@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Sat, 02 Feb 2013 00:35:58 +0100
Message-ID: <3057999.UZLp2j2DkQ@avalon>
In-Reply-To: <50EC5283.80006@stericsson.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1987992.4TmVjQaiLj@amdc1227> <50EC5283.80006@stericsson.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marcus,

On Tuesday 08 January 2013 18:08:19 Marcus Lorentzon wrote:
> On 01/08/2013 05:36 PM, Tomasz Figa wrote:
> > On Tuesday 08 of January 2013 11:12:26 Marcus Lorentzon wrote:

[snip]

> >> FYI,
> >> here is STE "DSI API":
> >> http://www.igloocommunity.org/gitweb/?p=kernel/igloo-kernel.git;a=blob;f
> >> =include/video/mcde.h;h=499ce5cfecc9ad77593e761cdcc1624502f28432;hb=HEAD
> >> #l361

Thank you.

> >> But it is not perfect. After a couple of products we realized that most
> >> panel drivers want an easy way to send a bunch of init commands in one
> >> go. So I think it should be an op for sending an array of commands at
> >> once. Something like
> >> 
> >> struct dsi_cmd {
> >>       enum mipi_pkt_type type; /* MIPI DSI, DCS, SetPacketLen, ... */
> >>       u8 cmd;
> >>       int dataLen;
> >>       u8 *data;
> >> }
> >>
> >> struct dsi_ops {
> >>       int dsi_write(source, int num_cmds, struct dsi_cmd *cmds);
> >>       ...
> >> }

Do you have DSI IP(s) that can handle a list of commands ? Or would all DSI 
transmitter drivers need to iterate over the commands manually ? In the later 
case a lower-level API might be easier to implement in DSI transmitter 
drivers. Helper functions could provide the higher-level API you proposed.

> > Yes, this should be flexible enough to cover most of (or even whole) DSI
> > specification.
> > 
> > However I'm not sure whether the dsi_write name would be appropriate,
> > since DSI packet types include also read and special transactions. So,
> > according to DSI terminology, maybe dsi_transaction would be better?

Or dsi_transfer or dsi_xfer ? Does the DSI bus have a concept of transactions 
?

> I think read should still be separate. At least on my HW read and write
> are quite different. But all "transactions" are very much the same in HW
> setup. The ... was dsi_write etc ;) Like set_max_packet_size should
> maybe be an ops. Since only the implementer of the "video source" will
> know what the max read return packet size for that DSI IP is. The panels
> don't know that. Maybe another ops to retrieve some info about the caps
> of the video source would help that. Then a helper could call that and
> then the dsi_write one.

If panels (or helper functions) need information about the DSI transmitter 
capabilities, sure, we can add an op.

> >> And I think I still prefer the dsi_bus in favor of the abstract video
> >> source. It just looks like a home made bus with bus-ops ... can't you do
> >> something similar using the normal driver framework? enable/disable
> >> looks like suspend/resume, register/unregister_vid_src is like
> >> bus_(un)register_device, ... the video source anyway seems unattached
> >> to the panel stuff with the find_video_source call.

The Linux driver framework is based on control busses. DSI usually handles 
both control and video transfer, but the control and data busses can also be 
separate (think DPI + SPI/I2C for instance). In that case the panel will be a 
child of its control bus master, and will need a separate interface to access 
video data operations. As a separate video interface is thus needed, I think 
we should use it for DSI as well.

My initial proposal included a DBI bus (as I don't have any DSI hardware - DBI 
and DSI can be used interchangeably in this discussions, they both share the 
caracteristic of having a common control + data bus), and panels were children 
of the DBI bus master. The DBI bus API was only used for control, not for data 
transfers. Tomi then removed the DBI bus and moved the control operations to 
the video source, turning the DBI panels into platform devices. I still favor 
my initial approach, but I can agree to drop the DBI bus if there's a 
consensus on that. Video bus operations will be separate in any case.

> > DSI needs specific power management. It's necessary to power up the panel
> > first to make it wait for Tinit event and then enable DSI master to
> > trigger such event. Only then rest of panel initialization can be
> > completed.
> 
> I know, we have a very complex sequence for our HDMI encoder which uses
> sort of continuous DSI cmmand mode. And power/clock on sequences are
> tricky to get right in our current "CDF" API (mcde_display). But I fail
> to see how the current video source API is different from just using the
> bus/device APIs.

As mentioned above, the video source API handles video transfers, while the 
bus/device API handles control transfers. Operations such as "start the video 
stream" will thus be video source APIs. Operations such as "enable the DSI 
master", used to trigger the Tinit event (whatever that is :-)) at power up 
time would probably be DSI bus operations.

> > Also, as discussed in previous posts, some panels might use DSI only for
> > video data and another interface (I2C, SPI) for control data. In such case
> > it would be impossible to represent such device in a reasonable way using
> > current driver model.
> 
> I understand that you need to get hold of both the control and data bus
> device in the driver. (Toshiba DSI-LVDS bridge is a good example and
> commonly used "encoder" that can use both DSI and I2C control interface.)
> But the control bus you get from device probe, and I guess you could call
> bus_find_device_by_name(dsi_bus, "mydev") and return the "datadev" which
> will have access to dsi bus ops just as you call
> find_video_source("mysource") to access the "databus" ops directly with
> a logical device (display entity).
> I'm not saying I would refuse to use video sources. I just think the two
> models are so similar so it would be worth exploring how a device model
> style API would look like and to compare against.

I don't think we should use the Linux device model for data busses. It hasn't 
been designed for that use case, and definitely doesn't support devices that 
would be children of two separate masters (control and data). For shared bus 
devices such as DSI, having a DSI bus was my preference to start with, as 
mentioned above :-) However, even in that case, I think it would still make 
sense to use video sources to control the video operations. As usual the devil 
is in the details, so there will probably be some tricky problems we'll need 
to solve, but that will require coding the proposed solution.

-- 
Regards,

Laurent Pinchart

