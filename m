Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2352 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbZCWSXV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 14:23:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: atmel v4l2 soc driver
Date: Mon, 23 Mar 2009 19:23:40 +0100
Cc: Sedji Gaouaou <sedji.gaouaou@atmel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <49B789F8.3070906@atmel.com> <49C7A8DF.3040101@atmel.com> <Pine.LNX.4.64.0903231632020.6370@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903231632020.6370@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231923.40533.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 23 March 2009 16:40:06 Guennadi Liakhovetski wrote:
> On Mon, 23 Mar 2009, Sedji Gaouaou wrote:
> > I am writing a driver for the ov9655 sensor from Omnivision.
> > To do so I am using the ov772x.c file as an example.
> > But I don't understant, because it seems that I never enter the
> > video_probe function...
> > Do you have any idea what could I do wrong? Is it coming from a wrong
> > i2c config?
>
> Wouldn't ov9655 be similar enough to ov9650 as used in stk-sensor.c?
> Hans, would that one also be converted to v4l2-device? If so, Sedji, you
> don't need to write yet another driver for it.

stk-sensor.c isn't a proper i2c driver: it's programmed through registers on 
the stk1125 control interface. That driver should probably be rewritten as 
a stk1125 driver that creates an i2c adapter which would allow stk-sensor.c 
to be rewritten as a proper i2c subdev.

Anyway, stk-sensor.c won't be (nor needs to be) converted. This obviously 
means that stk-sensor is not reusable in any other driver. There is no easy 
solution to that, other than a stk-*.c rewrite.

Note that there is also ov965x support in gspca/ov534.c. I think that 
several gspca drivers should really be rewritten so that they just create 
an i2c adapter and load the i2c sensor subdev.

Regards,

	Hans

> What concerns your probing problem - you most likely are missing platform
> bindings in your board code. See arch/arm/mach-pxa/pcm990-baseboard.c for
> an example.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
