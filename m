Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41401 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1HEHVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 03:21:37 -0400
Received: by qyk38 with SMTP id 38so159453qyk.19
        for <linux-media@vger.kernel.org>; Fri, 05 Aug 2011 00:21:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110804132500.GF31521@pengutronix.de>
References: <op.vzdduqnuyxxkfz@localhost.localdomain>
	<20110729075143.GX16561@pengutronix.de>
	<op.vzdhx5ucyxxkfz@localhost.localdomain>
	<20110729092311.GY16561@pengutronix.de>
	<op.vzdldvr1yxxkfz@localhost.localdomain>
	<20110729115732.GA16561@pengutronix.de>
	<op.vzoxkxheyxxkfz@localhost.localdomain>
	<20110804132500.GF31521@pengutronix.de>
Date: Fri, 5 Aug 2011 09:21:36 +0200
Message-ID: <CABMiYf9MDzDbVjQMsBZSxsumSU1ZDJEm7AapF86dN4m3qWe6_A@mail.gmail.com>
Subject: Re: mx2_camera driver on mx27ipcam: dma_alloc_coherent size failed
From: Jan Pohanka <xhpohanka@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Uwe,
thank you for the hint. There was problem with insufficient memory.
dma_alloc_from_coherent is called several times and when I allocated
only 4MB, last call failed. When I passed 8MB to
dma_declare_coherent_memory, it works. Unfortunately I do not
understand why 4MB is not enough for 640x480 YUV image...

regards
Jan

2011/8/4 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hello Jan,
>
> On Thu, Aug 04, 2011 at 03:11:11PM +0200, Jan Pohanka wrote:
>> Dear Uwe,
>> could you please give me some advice once more? It seems I'm not
>> able to make mx2_camera working by myself.
>> I have tried dma memory allocation in my board file in several ways,
>> but nothing seems to work. I use Video capture example for v4l2 for
>> testing.
>>
>> regards
>> Jan
>>
>> mx27ipcam_camera_power: 1
>> mx27ipcam_camera_reset
>> mx2-camera mx2-camera.0: Camera driver attached to camera 0
>> mx2-camera mx2-camera.0: dma_alloc_coherent size 614400 failed
>> mmap error 12, Cannot allocate memory
>> mx2-camera mx2-camera.0: Camera driver detached from camera 0
>> mx27ipcam_camera_power: 0
> Cannot say offhand. I'd instrument dma_alloc_from_coherent to check
> where it fails.
>
> The patch looks OK from a first glance.
>
> Best regards
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
