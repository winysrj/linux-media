Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-43.csi.cam.ac.uk ([131.111.8.143]:39777 "EHLO
	ppsw-43.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab0DPK3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 06:29:17 -0400
Message-ID: <4BC836FD.8010301@cam.ac.uk>
Date: Fri, 16 Apr 2010 11:07:57 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: pxa_camera + ov9655: image shifted on first capture after reset
References: <4BC81EEF.3000107@hni.uni-paderborn.de>
In-Reply-To: <4BC81EEF.3000107@hni.uni-paderborn.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/10 09:25, Stefan Herbrechtsmeier wrote:
> Hi,
> 
> I have updated my ov9655 driver to kernel 2.6.33 and
> did some test regarding the image shift problem on pxa.
> (http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/10773/focus=11810)
> 
> 
> - The image was shifted 32 pixels (64 bytes) to the right
>  or rather the first 32 pixels belongs to the previous image.
> - The image was only shifted on the first capture after reset.
>   It doesn't matter whether I previous change the resolution with v4l2-ctl.
> - On big images (1280 x 1024) the shift disappears after some images,
>   but not on small images (320 x 240).
> 
> It looks like the FIFO was not cleared at start capture.
> 
Sounds reasonable.  Similar problem seen with ov7670 attached to pxa271.
I've never taken the time to try and track it down.
