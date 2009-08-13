Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:57474 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbZHMKyV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 06:54:21 -0400
To: Steve Gotthardt <gotthardt@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] adds webcam for Micron device MT9M111 0x143A to em28xx
References: <3ca13d320908121621u725d7c7bl8d22d571bbfb1996@mail.gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 13 Aug 2009 12:54:12 +0200
In-Reply-To: <3ca13d320908121621u725d7c7bl8d22d571bbfb1996@mail.gmail.com> (Steve Gotthardt's message of "Wed\, 12 Aug 2009 16\:21\:44 -0700")
Message-ID: <874oscugq3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Gotthardt <gotthardt@gmail.com> writes:

> +/* FIXME: Should be replaced by a proper mt9m111 driver */
There is one, but only in camera SoC framework.

I think Hans and Guennadi are currently working so that sensor drivers become
available as v4l2 subdevices, hence usable by every over host.


> +       case 0x143A:    /* MT9M111 as found in the ECS G200 */
> +               dev->model = EM2750_BOARD_UNKNOWN;
> +               em28xx_set_model(dev);
> +
> +               sensor_name = "mt9m111";
> +               dev->board.xclk = EM28XX_XCLK_FREQUENCY_48MHZ;
> +               dev->em28xx_sensor = EM28XX_MT9M111;
> +               em28xx_initialize_mt9m111(dev);
> +               dev->sensor_xres = 640;
> +               dev->sensor_yres = 512;
>From memory, I can take pictures of resolution 1280x1024 with my mt9m111
chip. Is the 640x512 a special constraint ?

Cheers.

--
Robert
