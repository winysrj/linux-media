Return-path: <linux-media-owner@vger.kernel.org>
Received: from hl140.dinaserver.com ([82.98.160.94]:49629 "EHLO
	hl140.dinaserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbbG2ImP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2015 04:42:15 -0400
Message-ID: <55B891DD.3030900@by.com.es>
Date: Wed, 29 Jul 2015 10:42:05 +0200
From: Javier Martin <javiermartin@by.com.es>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: coda: Problems with encoding in i.MX6DL.
References: <55B87201.1070801@by.com.es> <1438157501.4303.16.camel@pengutronix.de>
In-Reply-To: <1438157501.4303.16.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,
thanks for your fast answer.

>> Apparently, the firmware is being loaded properly although it complains
>> about that version not being supported.
>>
>> After queuing some YUV420 buffers with a simple application I perform a
>> VIDIOC_STREAMON in both the CAPTURE and the OUTPUT interfaces but I get
>> the following error:
>>
>> coda 2040000.vpu: coda is not initialized.
>
> ... but then suddenly it's not.
> (coda_is_initialized just checks whether PC != 0)
>
> Could this have something to do with the PU power domain? Do all coda
> registers read 0x0 ?
> Do you have CONFIG_PM disabled? Check if d438462c20a3 ("ARM: imx6: gpc:
> always enable PU domain if CONFIG_PM is not set") makes a difference.
> I think that patch hasn't made it into stable yet.

Indeed, I was having problems with the runtime PM from the beginning and 
hacked up the code in the gpmc a bit to make sure the coda was always 
enabled but somehow I forgot to comment the poweroff callback and the 
codas was being powered off and never turned on again.

Just in case it is useful for someone else these are the functions in 
arch/arm/mach-imx/gpc.c whose code I completely commented out:

_imx6q_pm_pu_power_off
imx6q_pm_pu_power_off

Anyway, it looks like power management for the coda is a bit broken in 
the i.MX6D. I'll leave it disabled for now so that I continue with my 
development but I plan to have a look at it later on to see if I can fix 
it properly.

>
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 91 at drivers/media/v4l2-core/videobuf2-core.c:1792
>> vb2_start_streaming+0xe0/0x15c()
>
> That is because after copying buffers to the bitstream, the driver
> currently marks them as done. When start_streaming fails, videobuf2
> expects drivers to re-queue them. So we'd have to flush the bitstream
> and re-queue the buffers so they can be copied to the bitstream all over
> during the next try.
> This warning is a result of incomplete error handling in the coda
> start_streaming implementation.

I see, I might look into this if I manage to get some spare time.

Regards,
Javier.
