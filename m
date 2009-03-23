Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.atmel.fr ([81.80.104.162]:35126 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844AbZCWPVK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 11:21:10 -0400
Message-ID: <49C7A8DF.3040101@atmel.com>
Date: Mon, 23 Mar 2009 16:21:03 +0100
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: atmel v4l2 soc driver
References: <49B789F8.3070906@atmel.com> <Pine.LNX.4.64.0903111100050.4818@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903111100050.4818@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am writing a driver for the ov9655 sensor from Omnivision.
To do so I am using the ov772x.c file as an example.
But I don't understant, because it seems that I never enter the 
video_probe function...
Do you have any idea what could I do wrong? Is it coming from a wrong 
i2c config?

Regards,
Sedji

Guennadi Liakhovetski a écrit :
> On Wed, 11 Mar 2009, Sedji Gaouaou wrote:
> 
>> I am currently porting an atmel isi driver to the soc layer,
> 
> This is good!
> 
>> and I encounter some problems.
>> I have based my driver on pax-camera. and sh_mobile_ceu_camera.c.
>> The point is I can't see any video entry in /dev when I do ls dev/ on my
>> board...
>> So I wonder when is soc_camera_video_start(which call video_register_device)
>> called? Is that at the probe?
> 
> Well, you could just do
> 
> grep soc_camera_video_start drivers/media/video/*.c
> 
> Then you would immediately see, that each specific camera (sensor, 
> decoder, whatever) driver explicitly calls this function.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 


