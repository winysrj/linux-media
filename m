Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:39635 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754477Ab1KBJKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 05:10:50 -0400
Date: Wed, 2 Nov 2011 10:10:46 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
Message-ID: <20111102091046.GA14955@minime.bse>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com>
 <b3e1d11fbdb6c1fe02954f7b2dd29b01@chewa.net>
 <201111011349.47132.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111011349.47132.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tue, Nov 01, 2011 at 01:49:46PM +0100, Laurent Pinchart wrote:
> > Nevertheless, I agree that the monotonic clock is better than the real
> > time clock.
> > In user space, VLC, Gstreamer already switched to monotonic a while ago as
> > far as I know.
> > 
> > And I guess there is no way to detect this, other than detect ridiculously
> > large gap between the timestamp and the current clock value?
> 
> That's right. We could add a device capability flag if needed, but that 
> wouldn't help older applications that expect system time in the timestamps.

I just so happen to have tried to use V4L2 and ALSA timestamps in a
single application. In ALSA the core supports switching between
monotonic and realtime timestamps, with the library always using
monotonic available.

How about making all drivers record monotonic timestamps and doing
the conversion to/from realtime timestamps in v4l2-ioctl.c's
__video_do_ioctl if requested? We then just need an extension of the
spec to switch to monotonic, which can be implemented without touching
a single driver.

  Daniel
