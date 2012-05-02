Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:36878 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2EBInZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 04:43:25 -0400
Received: from kipc2.localdomain (unknown [3.249.69.203])
	by mail-rly-prd-01.am.health.ge.com (Postfix) with ESMTP id 710B747BB7
	for <linux-media@vger.kernel.org>; Wed,  2 May 2012 08:43:19 +0000 (GMT)
Date: Wed, 2 May 2012 10:43:18 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: linux-media@vger.kernel.org
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
Message-ID: <20120502084318.GA21181@kipc2.localdomain>
References: <20120424122156.GA16769@kipc2.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424122156.GA16769@kipc2.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please can someone shed a little light on this?

Greatly appreciated,
Karl

On Tue 120424, Karl Kiniger wrote:
> Dear all,
> 
> guvcview does not display the extra controls (focus, led etc)
> any more since kernel 3.2 an higher (Fedora 16, x86_64).
> 
> after the various video modes it says:
> 
> vid:046d
> pid:0990
> driver:uvcvideo
> Adding control for Pan (relative)
> UVCIOC_CTRL_ADD - Error: Inappropriate ioctl for device
> checking format: 1196444237
> VIDIOC_G_COMP:: Inappropriate ioctl for device
> fps is set to 1/25
> drawing controls
> 
> Checking video mode 640x480@32bpp : OK
> 
> ----------
> 
> /usr/bin/uvcdynctrl -i /usr/share/uvcdynctrl/data/046d/logitech.xml
> [libwebcam] Unsupported V4L2_CID_EXPOSURE_AUTO control with a non-contiguous range of choice IDs found
> [libwebcam] Invalid or unsupported V4L2 control encountered: ctrl_id = 0x009A0901, name = 'Exposure, Auto'
> Importing dynamic controls from file /usr/share/uvcdynctrl/data/046d/logitech.xml.
> ERROR: Unable to import dynamic controls: Invalid device or device cannot be opened. (Code: 5)
> /usr/share/uvcdynctrl/data/046d/logitech.xml: error: device 'video0' \
>     skipped because the driver 'uvcvideo' behind it does not seem to support \
>         dynamic controls.
> 
> ----------
> 
> Is there work in progess to get the missing functionality back?
> 
> Can I help somehow?
> 
> Greetings,
> Karl
> 
> 
