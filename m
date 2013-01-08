Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:36044 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395Ab3AHKNT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jan 2013 05:13:19 -0500
Message-ID: <50EBF10A.7080906@stericsson.com>
Date: Tue, 8 Jan 2013 11:12:26 +0100
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
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <3445117.L94DmxEvrl@avalon> <2529718.glQX8guWfJ@amdc1227> <3584709.mPLC5exzRY@avalon>
In-Reply-To: <3584709.mPLC5exzRY@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/08/2013 09:18 AM, Laurent Pinchart wrote:
> On Thursday 27 December 2012 15:43:34 Tomasz Figa wrote:
>> >  On Monday 24 of December 2012 15:12:28 Laurent Pinchart wrote:
>>> >  >  On Friday 21 December 2012 11:00:52 Tomasz Figa wrote:
>>>> >  >  >  On Tuesday 18 of December 2012 08:31:30 Vikas Sajjan wrote:
>>>>> >  >  >  >  On 17 December 2012 20:55, Laurent Pinchart wrote:
>>>>>> >  >  >  >  >  Hi Vikas,
>>>>>> >  >  >  >  >  
>>>>>> >  >  >  >  >  Sorry for the late reply. I now have more time to work on CDF, so
>>>>>> >  >  >  >  >  delays should be much shorter.
>>>>>> >  >  >  >  >  
>>>>>> >  >  >  >  >  On Thursday 06 December 2012 10:51:15 Vikas Sajjan wrote:
>>>>>>> >  >  >  >  >  >  Hi Laurent,
>>>>>>> >  >  >  >  >  >  
>>>>>>> >  >  >  >  >  >  I was thinking of porting CDF to samsung EXYNOS 5250 platform,
>>>>>>> >  >  >  >  >  >  what I found is that, the exynos display controller is MIPI DSI
>>>>>>> >  >  >  >  >  >  based controller.
>>>>>>> >  >  >  >  >  >  
>>>>>>> >  >  >  >  >  >  But if I look at CDF patches, it has only support for MIPI DBI
>>>>>>> >  >  >  >  >  >  based Display controller.
>>>>>>> >  >  >  >  >  >  
>>>>>>> >  >  >  >  >  >  So my question is, do we have any generic framework for MIPI DSI
>>>>>>> >  >  >  >  >  >  based display controller? basically I wanted to know, how to go
>>>>>>> >  >  >  >  >  >  about porting CDF for such kind of display controller.
>>>>>> >  >  >  >  >  
>>>>>> >  >  >  >  >  MIPI DSI support is not available yet. The only reason for that is
>>>>>> >  >  >  >  >  that I don't have any MIPI DSI hardware to write and test the code
>>>>>> >  >  >  >  >  with:-)
>>>>>> >  >  >  >  >  
>>>>>> >  >  >  >  >  The common display framework should definitely support MIPI DSI. I
>>>>>> >  >  >  >  >  think the existing MIPI DBI code could be used as a base, so the
>>>>>> >  >  >  >  >  implementation shouldn't be too high.
>>>>>> >  >  >  >  >  
>>>>>> >  >  >  >  >  Yeah, i was also thinking in similar lines, below is my though for
>>>>>> >  >  >  >  >  MIPI DSI support in CDF.
>>>>> >  >  >  >  
>>>>> >  >  >  >  o   MIPI DSI support as part of CDF framework will expose
>>>>> >  >  >  >  �  mipi_dsi_register_device(mpi_device) (will be called mach-xxx-dt.c
>>>>> >  >  >  >  file )
>>>>> >  >  >  >  �  mipi_dsi_register_driver(mipi_driver, bus ops) (will be called
>>>>> >  >  >  >  from platform specific init driver call )
>>>>> >  >  >  >  �    bus ops will be
>>>>> >  >  >  >  o   read data
>>>>> >  >  >  >  o   write data
>>>>> >  >  >  >  o   write command
>>>>> >  >  >  >  �  MIPI DSI will be registered as bus_register()
>>>>> >  >  >  >  
>>>>> >  >  >  >  When MIPI DSI probe is called, it (e.g., Exynos or OMAP MIPI DSI)
>>>>> >  >  >  >  will initialize the MIPI DSI HW IP.
>>>>> >  >  >  >  
>>>>> >  >  >  >  This probe will also parse the DT file for MIPI DSI based panel, add
>>>>> >  >  >  >  the panel device (device_add() ) to kernel and register the display
>>>>> >  >  >  >  entity with its control and  video ops with CDF.
>>>>> >  >  >  >  
>>>>> >  >  >  >  I can give this a try.
>>>> >  >  >  
>>>> >  >  >  I am currently in progress of reworking Exynos MIPI DSIM code and
>>>> >  >  >  s6e8ax0 LCD driver to use the v2 RFC of Common Display Framework. I
>>>> >  >  >  have most of the work done, I have just to solve several remaining
>>>> >  >  >  problems.
>>> >  >  
>>> >  >  Do you already have code that you can publish ? I'm particularly
>>> >  >  interested (and I think Tomi Valkeinen would be as well) in looking at
>>> >  >  the DSI operations you expose to DSI sinks (panels, transceivers, ...).
>> >  
>> >  Well, I'm afraid this might be little below your expectations, but here's
>> >  an initial RFC of the part defining just the DSI bus. I need a bit more
>> >  time for patches for Exynos MIPI DSI master and s6e8ax0 LCD.
> No worries. I was particularly interested in the DSI operations you needed to
> export, they seem pretty simple. Thank you for sharing the code.
>
FYI,
here is STE "DSI API":
http://www.igloocommunity.org/gitweb/?p=kernel/igloo-kernel.git;a=blob;f=include/video/mcde.h;h=499ce5cfecc9ad77593e761cdcc1624502f28432;hb=HEAD#l361

But it is not perfect. After a couple of products we realized that most 
panel drivers want an easy way to send a bunch of init commands in one 
go. So I think it should be an op for sending an array of commands at 
once. Something like

struct dsi_cmd {
     enum mipi_pkt_type type; /* MIPI DSI, DCS, SetPacketLen, ... */
     u8 cmd;
     int dataLen;
     u8 *data;
}
struct dsi_ops {
     int dsi_write(source, int num_cmds, struct dsi_cmd *cmds);
     ...
}

The rest of "DSI write API" could be made helpers on top of this one op. 
This grouping also allows driver to describe intent to send a bunch of 
commands together which might be of interest with mode set (if you need 
to synchronize a bunch of commands with a mode set, like setting smart 
panel rotation in synch with new framebuffer in dsi video mode).

I also looked at the video source in Tomi's git tree 
(http://gitorious.org/linux-omap-dss2/linux/blobs/work/dss-dev-model-cdf/include/video/display.h). 
I think I would prefer a single "setup" op taking a "struct dsi_config" 
as argument. Then each DSI formatter/encoder driver could decide best 
way to set that up. We have something similar at 
http://www.igloocommunity.org/gitweb/?p=kernel/igloo-kernel.git;a=blob;f=include/video/mcde.h;h=499ce5cfecc9ad77593e761cdcc1624502f28432;hb=HEAD#l118

And I think I still prefer the dsi_bus in favor of the abstract video 
source. It just looks like a home made bus with bus-ops ... can't you do 
something similar using the normal driver framework? enable/disable 
looks like suspend/resume, register/unregister_vid_src is like 
bus_(un)register_device, ... the video source anyway seems unattached to 
the panel stuff with the find_video_source call.

/BR
/Marcus

