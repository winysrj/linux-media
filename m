Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:60834 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab1BVOea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 09:34:30 -0500
Date: Tue, 22 Feb 2011 15:34:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Hans Verkuil <hansverk@cisco.com>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
In-Reply-To: <A24693684029E5489D1D202277BE894488C56A9A@dlee02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1102221515190.1380@axis700.grange>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <Pine.LNX.4.64.1102221215350.1380@axis700.grange> <201102221432.50847.hansverk@cisco.com>
 <A24693684029E5489D1D202277BE894488C56A9A@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 22 Feb 2011, Aguirre, Sergio wrote:

> For example, at least OMAP3 & 4 has the following pin pairs:
> 
> CSI2_DX0, CSI2_DY0
> CSI2_DX1, CSI2_DY1
> CSI2_DX2, CSI2_DY2
> CSI2_DX3, CSI2_DY3
> CSI2_DX4, CSI2_DY4
> 
> So, what you do is that, you can control where do you want the clock,
> where do you want each datalane pair, and also the pin polarity
> (X: +, Y: -, or viceversa). And this is something that is static.
> THIS I think should go in the host driver's platform data.

I think, these are two different things: pin roles - yes, they are 
SoC-specific and, probably, hard-wired. But once you've assigned roles, 
you have to configure them - roles, functions, not pins. And that 
configuration is no longer SoC specific, at least some of the parameters 
are common to all such set ups - polarities and edges. So, you can use the 
same set of parameters for them on different platforms.

And yes - you have to be able to configure them dynamically. Consider two 
sensors switching to the same host by means of some board logic. So, at 
least there have to be multiple parameter sets to use, depending on the 
connection topology.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
