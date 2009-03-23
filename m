Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42354 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755784AbZCWQGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 12:06:03 -0400
Date: Mon, 23 Mar 2009 17:06:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: atmel v4l2 soc driver
In-Reply-To: <49C7B226.6000302@atmel.com>
Message-ID: <Pine.LNX.4.64.0903231705080.6370@axis700.grange>
References: <49B789F8.3070906@atmel.com> <Pine.LNX.4.64.0903111100050.4818@axis700.grange>
 <49C7A8DF.3040101@atmel.com> <Pine.LNX.4.64.0903231632020.6370@axis700.grange>
 <49C7B226.6000302@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Mar 2009, Sedji Gaouaou wrote:

> Guennadi Liakhovetski a écrit :
> > 
> > Wouldn't ov9655 be similar enough to ov9650 as used in stk-sensor.c? Hans,
> > would that one also be converted to v4l2-device? If so, Sedji, you don't
> > need to write yet another driver for it. 
> 
> I had a look at the stk-sensor file. Does it follow the soc arch?

No, it does not. But soc-camera is going to be converted to v4l2-device, 
so, if stkweb is going to be converted too, then the driver will be 
re-used.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
