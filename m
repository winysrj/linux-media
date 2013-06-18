Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58847 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3FRU6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 16:58:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wouter Thielen <wouter@morannon.org>
Cc: linux-media@vger.kernel.org
Subject: Re: Mistake on the colorspace page in the API doc
Date: Tue, 18 Jun 2013 22:58:47 +0200
Message-ID: <19880516.7ZPIjvT6Bx@avalon>
In-Reply-To: <CACySJQX-GUYax5MPounyFCUczgncPx=SV=8O6ORd_zwfn31jkQ@mail.gmail.com>
References: <CACySJQX-GUYax5MPounyFCUczgncPx=SV=8O6ORd_zwfn31jkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wouter,

On Sunday 26 May 2013 15:34:26 Wouter Thielen wrote:
> Hi all,
> 
> I have been trying to get the colors right in the images grabbed from my
> webcam, and I tried the color conversion code on
> http://linuxtv.org/downloads/v4l-dvb-apis/colorspaces.html.
> 
> It turned out to be very white, so I checked out the intermediate steps,
> and thought the part:
> 
> ER = clamp (r * 255); /* [ok? one should prob. limit y1,pb,pr] */
> EG = clamp (g * 255);
> EB = clamp (b * 255);
> 
> 
> should be without the * 255. I tried removing *255 and that worked.

Good catch. I would instead do

y1 = (Y1 - 16) / 219.0;
pb = (Cb - 128) / 224.0;
pr = (Cr - 128) / 224.0;

and keep the E[RGB] lines unmodified to keep lower-case variables in the [0.0 
1.0] or [-0.5 0.5] range.

Would you like to post a patch for the documentation ? If not I can take care 
of it.

-- 
Regards,

Laurent Pinchart

