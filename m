Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35815 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0AIBzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 20:55:25 -0500
Date: Fri, 8 Jan 2010 20:55:21 -0500
From: Ralph Siemsen <ralphs@netwinder.org>
To: linux-media@vger.kernel.org
Subject: Re: cx23885 oops during loading, WinTV-HVR-1850 card -- SOLVED
Message-ID: <20100109015521.GK2257@harvey.netwinder.org>
References: <20100108191459.GJ2257@harvey.netwinder.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108191459.GJ2257@harvey.netwinder.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 08, 2010 at 02:14:59PM -0500, Ralph Siemsen wrote:
> 
> I tried replacing only the cx23885.ko driver, as well as installing all
> of the v4l-dvb drivers -- behaviour seemed to be the same.  With all
> drivers installed, system bootup does not complete, udev hangs, but I
> see the same kernel oops from cx23885.

Solved this part, the oops was caused by the missing sysfs NULL,
already reported at http://patchwork.kernel.org/patch/70126/

Now the driver loads, and I follow it up with "modprobe tuner".
Unfortunately, no luck yet using tvtime, it just reports:
videoinput: No inputs available on video4linux2 device '/dev/video0'.
But I suspect that is a different issue!

-Ralph
