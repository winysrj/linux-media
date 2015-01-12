Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35152 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbbALPWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 10:22:54 -0500
Message-ID: <54B3E6C0.2090608@xs4all.nl>
Date: Mon, 12 Jan 2015 16:22:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>,
	linux-media@vger.kernel.org
Subject: Re: CMYG support in V4L2
References: <201412291433.58677.linux@rainbow-software.org>
In-Reply-To: <201412291433.58677.linux@rainbow-software.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/29/2014 02:33 PM, Ondrej Zary wrote:
> Hello,
> I'm working on an old driver called "qcamvc" for Connectix QuickCam VC webcams 
> (parallel port and USB models), found here:
> http://sourceforge.net/projects/usb-quickcam-vc/
> 
> Luckily, it was modified last year to compile with 3.x kernels.
> 
> After trivial modification (mfr and model), it works with parallel-port 
> QuickCam Pro (sort of - only at 320x240 and with vertical lines on the left 
> and blank part at the top). I don't have QuickCam VC (yet).
> 
> After removing a lot of code (it's now around 1200 [main] + 660 [parallel] + 
> 320 [usb] lines), one problem still remains: in-kernel colour conversion with 
> software contrast, hue, saturation and gamma.
> 
> According to comments in the code, the camera sensor seems to have a CMYG 
> filter, like no other linux-supported camera. So the proper way to support 
> these cameras is to introduce a new pixel format, move the conversion to 
> libv4lconvert and remove all controls not provided by hardware?
> 

Correct.

Regards,

	Hans
