Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60137 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab2K0QjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:39:08 -0500
Date: Tue, 27 Nov 2012 17:39:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: RE: [PATCH 10/15] [media] marvell-ccic: split mcam core into 2 parts
 for soc_camera support
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D1367C905@SC-VEXCH1.marvell.com>
Message-ID: <Pine.LNX.4.64.1211271735530.22273@axis700.grange>
References: <1353677652-24288-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271405340.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C905@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Nov 2012, Albert Wang wrote:

[snip]

> >you did change a couple of things - like replaced printk() with cam_err(), and actually
> >here:
> >
> >> +		cam_err(cam, "marvell-cam: Cafe can't do S/G I/O," \
> >> +			"attempting vmalloc mode instead\n");
> >
> >and here
> >
> >> +			cam_warn(cam, "Unable to alloc DMA buffers at load" \
> >> +					"will try again later\n");
> >
> >the backslashes are not needed... Also in these declarations:
> >
> Sorry, I have to clarify it. :)
> I replaced printk() and add backslashes just because the tool scripts/checkpatch.pl.
> It will report error when remove the blackslash and report warning when using printk().
> But these errors and warnings will be reported only in latest kernel code. :)
> 
> If you think we can ignore these errors and warnings, I'm OK to get back to the original code. :)

Replacing printk() with cam_*() is ok, just please remove the backslashes. 
Actually, there are also spaces missing in above strings - when they'll be 
pasted together. As for checkpatch, I would ignore this its warning, 
because this is not new code, this has been there also in the original 
driver, you're just moving the code around.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
