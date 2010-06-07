Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:7402 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab0FGKBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 06:01:38 -0400
Message-ID: <4C0CC374.5030901@atmel.com>
Date: Mon, 07 Jun 2010 12:01:24 +0200
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: question about v4l2_subdev
References: <4C03D80B.5090009@atmel.com>	 <1275329947.2261.19.camel@localhost>  <4C04C17D.8020702@atmel.com> <1275701258.2247.16.camel@localhost>
In-Reply-To: <1275701258.2247.16.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>
> Look at
>
> 	drivers/media/video/cafe_ccic.c
>
> And examine cafe_pci_probe() and the definition and use of the
> sensor_call() macro.
>
> Also note
>
> $ grep -Ril ov7670 drivers/media/video/*
>
> will show you in what drivers, the ov7670 might be used.
>

I had a look at cafe_ccic.c and also at vpif_capture.c.

I tried to use "v4l2_i2c_new_subdev_board", but at boot time I have the 
following error:
i2c i2c-0: Failed to register i2c client ov2640 at 0x30 (-16)


I don't understand where it could come from, I pass the proper 
i2c_board_info struct, and it seems to check the proper i2c address, 
since it is not working.

Basically I do like cafe_ccic.c execpt that I use the 
v4l2_i2c_new_subdev_board instead of v4l2_i2c_new_subdev...

Any idea why I can't detect the sensor here?

Regards,
Sedji

