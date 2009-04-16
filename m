Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35969 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZDPWoh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 18:44:37 -0400
Subject: Re: [RFC] V4L2 CID for Testpattern mode
From: Andy Walls <awalls@radix.net>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <A24693684029E5489D1D202277BE89442ED66B69@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE89442ED66B69@dlee02.ent.ti.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 19:44:56 -0400
Message-Id: <1239925496.3207.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-04-16 at 08:34 -0500, Aguirre Rodriguez, Sergio Alberto
wrote:
> Hi,
> 
> During the omap3camera development, we came across with the case of
> imaging sensors which can produce test patterns instead of capturing
> images from the CCD.
> 
> What we did in an attempt to keep an standard interface, is that we
> created a CID named V4L2_CID_TEST_PATTERN of integer type, so 0 is "no
> test pattern", and from 1 to any supported quantity, to select between
> supported pattern modes.

Maybe instead of an integer (V4L2_CTRL_TYPE_INTEGER), you could use a
menu type control (V4L2_CTRL_TYPE_MENU) and present meaningful, driver
specific names to the user of the control.

There are a few modules under linux/driver/media/video/ that use it.
I'm familiar with ivtv and cx18 but their implementation is split with
some common parts in the cx2341x module, so they may not be the easiest
example to follow.

Maybe the cpia2 module would be a simpler example of menu controls to
look at.


> So, do you think this is good approach? Or is it something which
> supports already this kind of setting? I think it is a pretty common
> feature in capturing devices.

cx18 & ivtv have a video_mute boolean control, and a video_mute_yuv
integer control: essentially a simple test pattern controlled by a pair
of user controls.

So I think you already have a precedent.

Regards,
Andy


> Regards,
> Sergio


