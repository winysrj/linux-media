Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.atmel.fr ([81.80.104.162]:33720 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759033Ab0ECOHe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 10:07:34 -0400
Message-ID: <4BDED3A8.4090606@atmel.com>
Date: Mon, 03 May 2010 15:46:16 +0200
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: ATMEL camera interface
References: <4BD9AA8A.7030306@atmel.com> <Pine.LNX.4.64.1004291824200.4666@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1004291824200.4666@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I will try to write a soc driver(it seems easier ;)).

Are the mx?_camera.c a good starting point?

Regards,
Sedji

Le 4/29/2010 6:35 PM, Guennadi Liakhovetski a écrit :
> Hi Sedji
>
> On Thu, 29 Apr 2010, Sedji Gaouaou wrote:
>
>> Hi,
>>
>> I need to re-work my driver so I could commit it to the community.
>> Is there a git tree that I can use?
>
> Nice to hear that! As far as soc-camera is concerned, the present APIs are
> pretty stable. Just use the Linus' git tree, or, if you like, you can use
> the v4l-dvb git tree at git://linuxtv.org/v4l-dvb.git. In fact, you don't
> have to use the soc-camera API these days, you can just write a complete
> v4l2-device driver, using the v4l2-subdev API to interface to video
> clients (sensors, decoders, etc.) However, you can still write your driver
> as an soc-camera host driver, which would make your task a bit easier at
> the cost of some reduced flexibility, it's up to you to decide.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>


