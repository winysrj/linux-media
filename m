Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:48902 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZDGH3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 03:29:48 -0400
Message-ID: <49DB00E6.1030405@hni.uni-paderborn.de>
Date: Tue, 07 Apr 2009 09:29:42 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: aderach <aderach@free.fr>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] Add ov9655 camera driver
References: <dcfc60e44b2c05b865fd.1239026767@SCT-Book>	 <Pine.LNX.4.64.0904061755230.4285@axis700.grange> <1239044648.4346.2.camel@ubtonio>
In-Reply-To: <1239044648.4346.2.camel@ubtonio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

aderach schrieb:
> Does this driver is working for ov534 with 9657 sensor ID ?
I don't know the ov534. The sensor ID is the same.

At the moment the driver support only the YUV formats.
I don't know, which format the ov534 expect.
>
> Where did you find the document to write this code?
I haven't a real documentation. I get the preliminary OV9655 datasheet 
with the register
description from OmniVision.

Most of the register values in the driver were extracted from the inf 
file of the evaluation
board driver. I compare the values for the different output sizes and 
analyze them.
Based on this and some test I write the driver.

Regards
    Stefan

> -------- Message initial --------
> *De*: Guennadi Liakhovetski <g.liakhovetski@gmx.de 
> <mailto:Guennadi%20Liakhovetski%20%3cg.liakhovetski@gmx.de%3e>>
> *À*: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de 
> <mailto:Stefan%20Herbrechtsmeier%20%3chbmeier@hni.uni-paderborn.de%3e>>
> *Cc*: Linux Media Mailing List <linux-media@vger.kernel.org 
> <mailto:Linux%20Media%20Mailing%20List%20%3clinux-media@vger.kernel.org%3e>>, 
> Hans Verkuil <hverkuil@xs4all.nl 
> <mailto:Hans%20Verkuil%20%3chverkuil@xs4all.nl%3e>>
> *Sujet*: Re: [PATCH] Add ov9655 camera driver
> *Date*: Mon, 6 Apr 2009 17:58:57 +0200 (CEST)
>
> On Mon, 6 Apr 2009, Stefan Herbrechtsmeier wrote:
>
> > Add a driver for the OmniVision ov9655 camera sensor.
> > The driver use the soc_camera framework.
> > It was tested on the BeBot robot with a PXA270 processor.
> > 
> > Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de <mailto:hbmeier@hni.uni-paderborn.de>>
>
> Hans, does it make sense to include this one or shall we wait for gspca on 
> this one too?
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org <mailto:majordomo@vger.kernel.org>
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
