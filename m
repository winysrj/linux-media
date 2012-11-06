Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:46525 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2KFJok (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2012 04:44:40 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so171143lag.19
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2012 01:44:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121106101423.068bcd3e@wker>
References: <20121106101423.068bcd3e@wker>
Date: Tue, 6 Nov 2012 10:44:38 +0100
Message-ID: <CABYn4szDisJk=LXBhRKKe3dQ4hco-t75RVYLFayyxNjTBteCAQ@mail.gmail.com>
Subject: Re: Using OV5642 sensor driver for CM8206-A500SA-E
From: Bastian Hecht <hechtb@googlemail.com>
To: Anatolij Gustschin <agust@denx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Bastian Hecht <hechtb@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anatolij,

if I remember correctly I had the same issue inverted. For me the
initialization sequence of the freescale driver didn't work. Generally
it was quite difficult to deduce anything from the docs to split the
initialization into sensible parts. Too many parts were undocumented
or didn't work as expected. Maybe there are different hardware
revisions out there that need a different register setup.
Unfortunately I can only give you some general notes here as I no
longer possess an OV5642.

Good luck,

 Bastian

2012/11/6 Anatolij Gustschin <agust@denx.de>
>
> Hi,
>
> I'm trying to use mainline ov5642 driver for ov5642 based camera
> module CM8206-A500SA-E from TRULY. The driver loads and initializes
> the sensor, but the initialization seems to be incomplete, the sensor
> doesn't generate pixel clock and sync signals.
>
> For a quick test I've replaced the default initialisation sequences
> from ov5642_default_regs_init[] and ov5642_default_regs_finalise[]
> with an init sequence in ov5642_setting_30fps_720P_1280_720[] taken
> from Freescale ov5642 driver [1] and commented out ov5642_set_resolution()
> in ov5642_s_power(). With these changes to the mainline driver the
> sensor starts clocking out pixels and I receive 1280x720 image.
>
> Is anyone using the mainline ov5642 driver for mentioned TRULY camera
> module? Just wanted to ask before digging further to find out what
> changes to the mainline driver are really needed to make it working
> with TRULY camera module.
>
> Thanks,
> Anatolij
>
> [1] http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git/plain/drivers/media/video/mxc/capture/ov5642.c?h=imx_3.0.15
