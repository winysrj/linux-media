Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:35931 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab3BFJwx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Feb 2013 04:52:53 -0500
Message-ID: <511227C2.8060808@ti.com>
Date: Wed, 6 Feb 2013 15:22:02 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Rob Clark <rob.clark@linaro.org>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	sunil joshi <joshi@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1987992.4TmVjQaiLj@amdc1227> <50EC5283.80006@stericsson.com> <3057999.UZLp2j2DkQ@avalon> <510F8807.2020406@stericsson.com>
In-Reply-To: <510F8807.2020406@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 04 February 2013 03:35 PM, Marcus Lorentzon wrote:
> On 02/02/2013 12:35 AM, Laurent Pinchart wrote:
>> Hi Marcus,
>>
>> On Tuesday 08 January 2013 18:08:19 Marcus Lorentzon wrote:
>>> On 01/08/2013 05:36 PM, Tomasz Figa wrote:
>>>> On Tuesday 08 of January 2013 11:12:26 Marcus Lorentzon wrote:
> [...]
>>>>> But it is not perfect. After a couple of products we realized that
>>>>> most
>>>>> panel drivers want an easy way to send a bunch of init commands in one
>>>>> go. So I think it should be an op for sending an array of commands at
>>>>> once. Something like
>>>>>
>>>>> struct dsi_cmd {
>>>>>        enum mipi_pkt_type type; /* MIPI DSI, DCS, SetPacketLen, ... */
>>>>>        u8 cmd;
>>>>>        int dataLen;
>>>>>        u8 *data;
>>>>> }
>>>>>
>>>>> struct dsi_ops {
>>>>>        int dsi_write(source, int num_cmds, struct dsi_cmd *cmds);
>>>>>        ...
>>>>> }
>> Do you have DSI IP(s) that can handle a list of commands ? Or would
>> all DSI
>> transmitter drivers need to iterate over the commands manually ? In
>> the later
>> case a lower-level API might be easier to implement in DSI transmitter
>> drivers. Helper functions could provide the higher-level API you
>> proposed.
>
> The HW has a FIFO, so it can handle a few. Currently we use the low
> level type of call with one call per command. But we have found DSI
> command mode panels that don't accept any commands during the "update"
> (write start+continues). And so we must use a mutex/state machine to
> exclude any async calls to send DSI commands during update. But if you
> need to send more than one command per frame this will be hard (like
> CABC and backlight commands). It will be a ping pong between update and
> command calls. One option is to expose the mutex to the caller so it can
> make many calls before the next update grabs the mutex again.
> So maybe we could create a helper that handle the op for list of
> commands and another op for single command that you actually have to
> implement.

fyi, the DSI IP on OMAP3+ SoCs also has a FIFO. It can provide 
interrupts after each command is pushed out, and also when the FIFO gets 
empty(all commands are pushed). The only thing to take care is to not 
overflow FIFO.

DSI video mode panels generally have a few dozen internal registers 
which need to be configured via DSI commands. It's more fast(and 
convenient) to configure a handful of internal registers in one shot, 
and then perform a single BTA to know from the panel whether the 
commands were received correctly.

Regards,
Archit

