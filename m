Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54230 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab3HQKwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 06:52:01 -0400
Received: from localhost ([89.204.137.175]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MHXd2-1V7Lms3rx6-003MK5 for
 <linux-media@vger.kernel.org>; Sat, 17 Aug 2013 12:51:59 +0200
Date: Sat, 17 Aug 2013 12:51:52 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?Q?Frank_Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	=?UTF-8?Q?Frank_Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <74016946-c59e-4b0b-a25b-4c976f60ae43.maildroid@localhost>
In-Reply-To: <520E76E7.30201@googlemail.com>
References: <520E76E7.30201@googlemail.com>
Subject: Re: em28xx + ov2640 and v4l2-clk
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,
As I mentioned on the list, I'm currently on a holiday, so, replying briefly. Since em28xx is a USB device, I conclude, that it's supplying clock to its components including the ov2640 sensor. So, yes, I think the driver should export a V4L2 clock.
Thanks
Guennadi


-----Original Message-----
From: "Frank Schäfer" <fschaefer.oss@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Linux Media Mailing List <linux-media@vger.kernel.org>
Sent: Fr., 16 Aug 2013 21:03
Subject: em28xx + ov2640 and v4l2-clk

Hi Guennadi,

since commit 9aea470b399d797e88be08985c489855759c6c60 "soc-camera:
switch I2C subdevice drivers to use v4l2-clk", the em28xx driver fails
to register the ov2640 subdevice (if needed).
The reason is that v4l2_clk_get() fails in ov2640_probe().
Does the em28xx driver have to register a (pseudo ?) clock first ?

Regards,
Frank
