Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43080 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754034Ab0BIPSP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 10:18:15 -0500
Date: Tue, 9 Feb 2010 10:18:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH/RESEND] soc-camera: add runtime pm support
 for subdevices
In-Reply-To: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>
Message-ID: <Pine.LNX.4.44L0.1002091016060.1665-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Feb 2010, Guennadi Liakhovetski wrote:

> To save power soc-camera powers subdevices down, when they are not in use, 
> if this is supported by the platform. However, the V4L standard dictates, 
> that video nodes shall preserve configuration between uses. This requires 
> runtime power management, which is implemented by this patch. It allows 
> subdevice drivers to specify their runtime power-management methods, by 
> assigning a type to the video device.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> I've posted this patch to linux-media earlier, but I'd also like to get 
> comments on linux-pm, sorry to linux-media falks for a duplicate. To 
> explain a bit - soc_camera.c is a management module, that binds video 
> interfaces on SoCs and sensor drivers. The calls, that I am adding to 
> soc_camera.c shall save and restore sensor registers before they are 
> powered down and after they are powered up.

This patch is not correct as it stands.  If you use runtime PM then the 
system PM resume method has to be changed.  See the discussion in 
section 6 of Documentation/power/runtime_pm.txt.

Alan Stern

