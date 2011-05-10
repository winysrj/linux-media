Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60962 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab1EJP2B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 11:28:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Current status report of mt9p031.
Date: Tue, 10 May 2011 17:28:49 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Rodley <carlighting@yahoo.co.nz>
References: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com> <BANLkTinBmoeuPBfwNL2z62xLhzZK_owM1Q@mail.gmail.com> <BANLkTin9GKVUfzr+oZSMetzRVo2ENquKqQ@mail.gmail.com>
In-Reply-To: <BANLkTin9GKVUfzr+oZSMetzRVo2ENquKqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105101728.49895.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Javier,

On Tuesday 10 May 2011 16:14:09 javier Martin wrote:
> Hi Laurent,
> information for data lane shifter is passed through platform data:
> 
> /**
>  * struct isp_parallel_platform_data - Parallel interface platform data
>  * @data_lane_shift: Data lane shifter
>  *		0 - CAMEXT[13:0] -> CAM[13:0]
>  *		1 - CAMEXT[13:2] -> CAM[11:0]
>  *		2 - CAMEXT[13:4] -> CAM[9:0]
>  *		3 - CAMEXT[13:6] -> CAM[7:0]
>  * @clk_pol: Pixel clock polarity
>  *		0 - Non Inverted, 1 - Inverted
>  * @bridge: CCDC Bridge input control
>  *		ISPCTRL_PAR_BRIDGE_DISABLE - Disable
>  *		ISPCTRL_PAR_BRIDGE_LENDIAN - Little endian
>  *		ISPCTRL_PAR_BRIDGE_BENDIAN - Big endian
>  */
> struct isp_parallel_platform_data {
> 	unsigned int data_lane_shift:2;
> 	unsigned int clk_pol:1;
> 	unsigned int bridge:4;
> };
> 
> This way I am able to convert from 12bpp to 8bpp:
> data_lane_shift = 2  and  bridge = ISPCTRL_PAR_BRIDGE_DISABLE

That's usually used to define a static conversion, when sensor data lines 7-0 
are connected to ISP data lines 11-3. Capturing 8-bit raw bayer data from a 
12-bit raw bayer sensor should be done by dynamically configuring the 
pipeline.

I'm not at home and don't have access to my OMAP3 hardware now, I'll try your 
use case when I'll come back (end of the week or during the weekend).

-- 
Regards,

Laurent Pinchart
