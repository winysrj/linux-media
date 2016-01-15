Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52022 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754341AbcAORdi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2016 12:33:38 -0500
From: Sebastien LEDUC <sebastien.leduc@st.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 15 Jan 2016 18:33:31 +0100
Subject: RE: V4L2 encoder APIs
Message-ID: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F5781@SAFEX1MAIL1.st.com>
References: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F53E0@SAFEX1MAIL1.st.com>
 <Pine.LNX.4.64.1601132156280.13265@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1601132156280.13265@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your answer

> I think this should be handled in the same way as the output direction. We
> are currently discussing this with several V4L developers. For output we have
> to capture different data types to different buffers, running multiplexed on
> the bus, e.g. over CSI-2. Using the MPLANE API would be one option, but you
> don't want to define a new pixel format for each combination of each
> standard pixel format with each accompanying data type, be it metadata or
> anything else. So, you would have to add support for per-plane format,
> which would contradict the current MPLANE API concept.

Dont know what are the other use cases you are discussing
But in our case there is only one combination:
The first plane should contain the header data, and the second one should contain the slice data

At the end the compressed frame is just the concatenation of the first buffer (header) and the second one (slice data)

So there is no reason to have multiple combinations in the future

> 
> Therefore we're currently considering a different option of transferring
> different buffer types via different buffer queues. Initially we thought about
> simply using multiple video device nodes. That has a disadvantage when the
> number of those streams is variable and potentially large. So, another option
> is to add support for multiple buffer queues per video node. Those buffer
> queues would then have to get some form of identification, perhaps a
> stream ID. That stream ID would also be used to associate those streams to
> links between subdevice pads. That's all still very raw... Quite a bit of design
> and implementation work ahead.
> 


In our case using separate buffer queues does not look very appropriate, because there is a strong ordering constraint, and we always want to get a header and slice data together

So my current feeling is really that MPLANE is the best fit for our need

Regards
Sebastien
