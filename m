Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.atmel.fr ([81.80.104.162]:42088 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbZCWQPE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 12:15:04 -0400
Message-ID: <49C7B57C.7040809@atmel.com>
Date: Mon, 23 Mar 2009 17:14:52 +0100
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: atmel v4l2 soc driver
References: <49B789F8.3070906@atmel.com> <Pine.LNX.4.64.0903111100050.4818@axis700.grange> <49C7A8DF.3040101@atmel.com> <Pine.LNX.4.64.0903231632020.6370@axis700.grange> <49C7B226.6000302@atmel.com> <Pine.LNX.4.64.0903231705080.6370@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903231705080.6370@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well I am confused now...Should I still convert the atmel ISI driver to 
a soc driver?
My concern was not to release a driver for the ov9655, but to have one 
which is working so I could test my atmel-soc driver :)
Because I only have an ov9655 sensor here...

Regards
Sedji

Guennadi Liakhovetski a écrit :
> On Mon, 23 Mar 2009, Sedji Gaouaou wrote:
> 
>> Guennadi Liakhovetski a écrit :
>>> Wouldn't ov9655 be similar enough to ov9650 as used in stk-sensor.c? Hans,
>>> would that one also be converted to v4l2-device? If so, Sedji, you don't
>>> need to write yet another driver for it. 
>> I had a look at the stk-sensor file. Does it follow the soc arch?
> 
> No, it does not. But soc-camera is going to be converted to v4l2-device, 
> so, if stkweb is going to be converted too, then the driver will be 
> re-used.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 


