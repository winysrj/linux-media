Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41063 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1DUJna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 05:43:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
Date: Thu, 21 Apr 2011 11:43:32 +0200
Cc: =?utf-8?q?Lo=C3=AFc_Akue?= <akue.loic@gmail.com>,
	Enric =?utf-8?q?Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com> <201103301532.16635.laurent.pinchart@ideasonboard.com> <BANLkTimccZM=ipUUhEBNM+pPhAvQgn=AbQ@mail.gmail.com>
In-Reply-To: <BANLkTimccZM=ipUUhEBNM+pPhAvQgn=AbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104211143.32620.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Raffaele,

On Wednesday 20 April 2011 17:25:58 Raffaele Recalcati wrote:
> On Wed, Mar 30, 2011 at 3:32 PM, Laurent Pinchart wrote:
> > On Wednesday 30 March 2011 13:05:08 Loïc Akue wrote:
> >> Hi Laurent,
> >> 
> >> > The OMAP3 ISP should support interleaving interlaced frames, but
> >> > that's not implemented in the driver. You will need to at least
> >> > implement interlaced frames support in the CCDC module to report
> >> > field identifiers to userspace.
> >> 
> >> Are you saying that the OMAP ISP could be configured to provide some
> >> full field frames on the CCDC output? I'm looking at the ISP's TRM but
> >> I can't find anything interesting.
> > 
> > Look at the "Line-Output Control" section in the OMAP3 TRM (SWPU177B,
> > page 1201).
> > 
> >> Or is it the job of the user space application to recompose the image
> >> with the interleaved frames?
> 
> I'm using tvp5151 in DaVinci with the drivers/media/video/tvp5150.c
> driver with little modification to enhance v4l2 interface.
> It works.
> Now I'm moving to dm3730 and I see that evm dm3730 uses tvp514x-int.c
> from Arago tree, that is really different from tvp514x.c .
> I'm trying to understand if I need to create a tvp5150-int.c using the
> call v4l2_int_device_register instead of v4l2_i2c_subdev_init.
> The drivers/media/video/omap34xxcam.c driver calls
> v4l2_int_device_register and so it needs v4l2_int_device_register.
> 
> Maybe you have done some modifications to
> drivers/media/video/tvp5150.c that I could merge with mines ?

My best advice is to get rid of the Arago kernel tree and go for the latest 
mainline kernel version. The OMAP3 ISP driver has been merged into mainline in 
2.6.39-rc1. The version available in the Arago kernel tree is plain crap and 
should never ever be used.

-- 
Regards,

Laurent Pinchart
