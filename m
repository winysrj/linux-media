Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52854 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbcAMVJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 16:09:39 -0500
Date: Wed, 13 Jan 2016 22:09:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sebastien LEDUC <sebastien.leduc@st.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: V4L2 encoder APIs
In-Reply-To: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F53E0@SAFEX1MAIL1.st.com>
Message-ID: <Pine.LNX.4.64.1601132156280.13265@axis700.grange>
References: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F53E0@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastien,

On Wed, 13 Jan 2016, Sebastien LEDUC wrote:

> Hi all I have seen on the linuxTV web site that there were some on-going 
> discussions related to the Codec API.
> 
> In our SoCs, it is the HW encoder that is outputting both the slice data 
> and the headers/metadata, but it does it using separate buffers.
> 
> So we are looking at how to expose that using V4L2 APIs.
> 
> We were thinking that we could use the MPLANE apis to achieve that, 
> where one plane would contain the header/metadata and another one for 
> the slice data.
> 
> Any opinion on this ? 

I think this should be handled in the same way as the output direction. We 
are currently discussing this with several V4L developers. For output we 
have to capture different data types to different buffers, running 
multiplexed on the bus, e.g. over CSI-2. Using the MPLANE API would be one 
option, but you don't want to define a new pixel format for each 
combination of each standard pixel format with each accompanying data 
type, be it metadata or anything else. So, you would have to add support 
for per-plane format, which would contradict the current MPLANE API 
concept.

Therefore we're currently considering a different option of transferring 
different buffer types via different buffer queues. Initially we thought 
about simply using multiple video device nodes. That has a disadvantage 
when the number of those streams is variable and potentially large. So, 
another option is to add support for multiple buffer queues per video 
node. Those buffer queues would then have to get some form of 
identification, perhaps a stream ID. That stream ID would also be used to 
associate those streams to links between subdevice pads. That's all still 
very raw... Quite a bit of design and implementation work ahead.

Thanks
Guennadi

> Thanks in advance for your inputs
> 
> Regards,
> Sébastien
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
