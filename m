Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55366 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaBLPib (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 10:38:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: OMAP3 ISP capabilities
Date: Wed, 12 Feb 2014 16:39:33 +0100
Message-ID: <17190750.bpa3L6qe94@avalon>
In-Reply-To: <alpine.DEB.2.01.1402111543380.6474@pmeerw.net>
References: <alpine.DEB.2.01.1402111543380.6474@pmeerw.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Tuesday 11 February 2014 15:54:00 Peter Meerwald wrote:
> Hello Laurent,
> 
> some quick question about the OMAP3 ISP pipeline capabilities:
> 
> (1) can the OMAP3 ISP CCDC output concurrently to memory AND the resizer
> in YUV mode? I think the answer is no due to hardware limitation

Based on the TRM I would say that the hardware is capable of doing so, but 
this isn't implemented in the driver.

> (2) in RAW mode, I think it should be possible to connect pad 1 of the
> OMAP3 ISP CCDC to CCDC output and pad 2 to the ISP preview and
> subsequently to the resizer? so two stream can be read concurrently from
> video2 and video6?

That's my understanding as well, but once again this isn't supported by the 
driver.

> (3) it should be possible to use the ISP resizer input / output
> (memory-to-memory) independently; it there any example code doing this?

I haven't written any sample code as such for memory-to-memory operation. I 
usually use the following media-ctl and yavta commands to test memory-to-
memory resizing :

--------------------------------
media-ctl -r

media-ctl -l '"OMAP3 ISP resizer input":0->"OMAP3 ISP resizer":0[1]'
media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'

media-ctl -V '"OMAP3 ISP resizer":0[YUYV 2048x1536]'
media-ctl -V '"OMAP3 ISP resizer":1[YUYV 1024x768]'

yavta -f YUYV -s 2048x1536 -n 4 --capture=100 \
	`media-ctl -e "OMAP3 ISP resizer input"` > resizer-input.log 2>&1 &
yavta -f YUYV -s 1024x768 -n 4 --capture=100 \
	`./media-ctl -e "OMAP3 ISP resizer output"` > resizer-output.log 2>&1 &
--------------------------------

You can also have a look at the omap3-isp-live application available at

	http://git.ideasonboard.org/omap3-isp-live.git

It contains a library that offers viewfinder, snapshot and scaling functions 
on top of the ISP and two sample applications that use the library. The 
resizer memory-to-memory is used by the live application to scale captured 
snapshots when displaying them on screen.

-- 
Regards,

Laurent Pinchart

