Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33351 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LUKzg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 05:55:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James <angweiyang@gmail.com>
Subject: Re: Why is the Y12 support 12-bit grey formats at the CCDC input (Y12) is truncated to Y10 at the CCDC output?
Date: Wed, 21 Dec 2011 11:55:35 +0100
Cc: Michael Jones <michael.jones@matrix-vision.de>,
	linux-media@vger.kernel.org
References: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com> <CAOy7-nOc9U4_BRKYyagcVtDZyr2Z9ZEUAftmdBsfBrWVVLFGjA@mail.gmail.com> <CAOy7-nM4-qVjgmgwATPHuUnpPmAggVpsLtJ48H932tweaQdY0Q@mail.gmail.com>
In-Reply-To: <CAOy7-nM4-qVjgmgwATPHuUnpPmAggVpsLtJ48H932tweaQdY0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112211155.36565.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Wednesday 21 December 2011 04:06:33 James wrote:
> On Wed, Dec 21, 2011 at 10:50 AM, James wrote:
> > On Thu, Dec 15, 2011 at 6:10 PM, Michael Jones wrote:
> >> Hi James,
> >> 
> >> Laurent has a program 'media-ctl' to set up the pipeline (see
> >> http://git.ideasonboard.org/?p=media-ctl.git).  You will find many
> >> examples of its usage in the archives of this mailing list. It will
> >> look something like:
> >> media-ctl -r
> >> media-ctl -l '"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0 [1]'
> >> media-ctl -l '"your-sensor-name":0 -> "OMAP3 ISP CCDC":0 [1]'
> >> 
> >> you will also need to set the formats through the pipeline with
> >> 'media-ctl --set-format'.
> >> 
> >> After you use media-ctl to set up the pipeline, you can use yavta to
> >> capture the data from the CCDC output (for me, this is /dev/video2).
> >> 
> >> 
> >> -Michael
> > 
> > I encountered some obstacles with the driver testing of my monochrome
> > sensor on top of Steve's 3.0-pm branch. An NXP SC16IS750 I2C-UART
> > bridge is used to 'transform' the sensor into a I2C device.
> > 
> > The PCLK, VSYNC, HSYNC (640x512, 30Hz, fixed output format) are free
> > running upon power-on the sensor unlike MT9V032 which uses the XCLKA
> > to 'power-on/off' it.
> > 
> > My steps,
> > 
> > 1) media-ctl -r -l '"mono640":0->"OMAP3 ISP CCDC":0:[1], "OMAP3 ISP
> > CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> > 
> > Resetting all links to inactive
> > Setting up link 16:0 -> 5:0 [1]
> > Setting up link 5:1 -> 6:0 [1]
> > 
> > 2) media-ctl -f '"mono640":0[Y12 640x512]", "OMAP3 ISP CCDC":1[Y12
> > 640x512]'
> > 
> > Setting up format Y12 640x512 on pad OMAP3 ISP CCDC/0
> > Setting up format Y12 640x512 on pad OMAP3 ISP CCDC/1
> > 
> > 3) yavta -p -f Y12 -s 640x512 -n 4 --capture=61 --skip 1 -F `media-ctl
> > -e "OMAP3 ISP CCDC output"` --file=./DCIM/Y12
> > 
> > Unsupported video format 'Y12'
> > 
> > Did I missed something?

I've just pushed a patch to the yavta repository to support Y10 and Y12. 
Please update.

> > What parameters did you supplied to yavta to test the Y10/Y12
> > 
> > Many thanks in adv.
> > Sorry if duplicated emails received.
> 
> I changed the parameters for yavta from "-f Y12" to "-f Y16"
> 
> yavta -p -f Y16 -s 640x512 -n 2 --capture=10 --skip 5 -F `media-ctl -e
> "OMAP3 ISP CCDC output"` --file=./DCIM/Y16
> 
> and there are 2 chunks of message at the console now and it ended with
> "Unable to request buffers: Invalid argument (22).".
> 
> I've attached the logfile here. (mono640.log)
> 
> Hope you can assist me to grab the raw Y12 data to file.

-- 
Regards,

Laurent Pinchart
