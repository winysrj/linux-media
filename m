Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:46140 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055Ab3BDKHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Feb 2013 05:07:23 -0500
Message-ID: <510F8807.2020406@stericsson.com>
Date: Mon, 4 Feb 2013 11:05:59 +0100
From: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1987992.4TmVjQaiLj@amdc1227> <50EC5283.80006@stericsson.com> <3057999.UZLp2j2DkQ@avalon>
In-Reply-To: <3057999.UZLp2j2DkQ@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2013 12:35 AM, Laurent Pinchart wrote:
> Hi Marcus,
>
> On Tuesday 08 January 2013 18:08:19 Marcus Lorentzon wrote:
>> On 01/08/2013 05:36 PM, Tomasz Figa wrote:
>>> On Tuesday 08 of January 2013 11:12:26 Marcus Lorentzon wrote:
[...]
>>>> But it is not perfect. After a couple of products we realized that most
>>>> panel drivers want an easy way to send a bunch of init commands in one
>>>> go. So I think it should be an op for sending an array of commands at
>>>> once. Something like
>>>>
>>>> struct dsi_cmd {
>>>>        enum mipi_pkt_type type; /* MIPI DSI, DCS, SetPacketLen, ... */
>>>>        u8 cmd;
>>>>        int dataLen;
>>>>        u8 *data;
>>>> }
>>>>
>>>> struct dsi_ops {
>>>>        int dsi_write(source, int num_cmds, struct dsi_cmd *cmds);
>>>>        ...
>>>> }
> Do you have DSI IP(s) that can handle a list of commands ? Or would all DSI
> transmitter drivers need to iterate over the commands manually ? In the later
> case a lower-level API might be easier to implement in DSI transmitter
> drivers. Helper functions could provide the higher-level API you proposed.

The HW has a FIFO, so it can handle a few. Currently we use the low 
level type of call with one call per command. But we have found DSI 
command mode panels that don't accept any commands during the "update" 
(write start+continues). And so we must use a mutex/state machine to 
exclude any async calls to send DSI commands during update. But if you 
need to send more than one command per frame this will be hard (like 
CABC and backlight commands). It will be a ping pong between update and 
command calls. One option is to expose the mutex to the caller so it can 
make many calls before the next update grabs the mutex again.
So maybe we could create a helper that handle the op for list of 
commands and another op for single command that you actually have to 
implement.
>>> Yes, this should be flexible enough to cover most of (or even whole) DSI
>>> specification.
>>>
>>> However I'm not sure whether the dsi_write name would be appropriate,
>>> since DSI packet types include also read and special transactions. So,
>>> according to DSI terminology, maybe dsi_transaction would be better?
> Or dsi_transfer or dsi_xfer ? Does the DSI bus have a concept of transactions
> ?

No transactions. And I don't want to mix reads and writes. It should be 
similar to I2C and other stream control busses. So one read and one 
write should be fine. And then a bunch of helpers on top for callers to 
use, like one per major DSI packet type.
>> I think read should still be separate. At least on my HW read and write
>> are quite different. But all "transactions" are very much the same in HW
>> setup. The ... was dsi_write etc ;) Like set_max_packet_size should
>> maybe be an ops. Since only the implementer of the "video source" will
>> know what the max read return packet size for that DSI IP is. The panels
>> don't know that. Maybe another ops to retrieve some info about the caps
>> of the video source would help that. Then a helper could call that and
>> then the dsi_write one.
> If panels (or helper functions) need information about the DSI transmitter
> capabilities, sure, we can add an op.

Yes, a "video source" op for getting caps would be ok too. But so far 
the only limits I have found is the read/write sizes. But if anyone else 
has other limits, please list them so we could add them to this struct 
dsi_host_caps.
>>>> And I think I still prefer the dsi_bus in favor of the abstract video
>>>> source. It just looks like a home made bus with bus-ops ... can't you do
>>>> something similar using the normal driver framework? enable/disable
>>>> looks like suspend/resume, register/unregister_vid_src is like
>>>> bus_(un)register_device, ... the video source anyway seems unattached
>>>> to the panel stuff with the find_video_source call.
> The Linux driver framework is based on control busses. DSI usually handles
> both control and video transfer, but the control and data busses can also be
> separate (think DPI + SPI/I2C for instance). In that case the panel will be a
> child of its control bus master, and will need a separate interface to access
> video data operations. As a separate video interface is thus needed, I think
> we should use it for DSI as well.
>
> My initial proposal included a DBI bus (as I don't have any DSI hardware - DBI
> and DSI can be used interchangeably in this discussions, they both share the
> caracteristic of having a common control + data bus), and panels were children
> of the DBI bus master. The DBI bus API was only used for control, not for data
> transfers. Tomi then removed the DBI bus and moved the control operations to
> the video source, turning the DBI panels into platform devices. I still favor
> my initial approach, but I can agree to drop the DBI bus if there's a
> consensus on that. Video bus operations will be separate in any case.

As discussed at FOSDEM I will give DSI bus with full feature set a try.

BTW. Who got the action to ask Greg about devices with multiple 
parents/buses?

>>> Also, as discussed in previous posts, some panels might use DSI only for
>>> video data and another interface (I2C, SPI) for control data. In such case
>>> it would be impossible to represent such device in a reasonable way using
>>> current driver model.
>> I understand that you need to get hold of both the control and data bus
>> device in the driver. (Toshiba DSI-LVDS bridge is a good example and
>> commonly used "encoder" that can use both DSI and I2C control interface.)
>> But the control bus you get from device probe, and I guess you could call
>> bus_find_device_by_name(dsi_bus, "mydev") and return the "datadev" which
>> will have access to dsi bus ops just as you call
>> find_video_source("mysource") to access the "databus" ops directly with
>> a logical device (display entity).
>> I'm not saying I would refuse to use video sources. I just think the two
>> models are so similar so it would be worth exploring how a device model
>> style API would look like and to compare against.
> I don't think we should use the Linux device model for data busses. It hasn't
> been designed for that use case, and definitely doesn't support devices that
> would be children of two separate masters (control and data). For shared bus
> devices such as DSI, having a DSI bus was my preference to start with, as
> mentioned above :-) However, even in that case, I think it would still make
> sense to use video sources to control the video operations. As usual the devil
> is in the details, so there will probably be some tricky problems we'll need
> to solve, but that will require coding the proposed solution.
>
I will give it a try after asking Greg for guidelines.

/BR
/Marcus

