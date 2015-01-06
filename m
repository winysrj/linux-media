Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:42335 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbAFAIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 19:08:00 -0500
Message-ID: <1420502814.14388.27.camel@hadess.net>
Subject: Re: Baytrail camera csi / isp support status ?
From: Bastien Nocera <hadess@hadess.net>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 06 Jan 2015 01:06:54 +0100
In-Reply-To: <548ACC7E.5070507@redhat.com>
References: <548ACC7E.5070507@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

On Fri, 2014-12-12 at 12:07 +0100, Hans de Goede wrote:
> Hi All,
> 
> A college of mine has a baytrail bases tablet:
> 
> http://www.onda-tablet.com/onda-v975w-quad-core-win-8-tablet-9-7-inch-retina-screen-ram-2gb-wifi-32gb.html
> 
> And he is trying to get Linux to run on it, he has things mostly
> working, but he would also like to get the cameras to work.
> 
> I've found this:
> 
> http://sourceforge.net/projects/e3845mipi/files/
> 
> Which is some not so pretty code, with the usual problems of using
> custom ioctls to pass info from the statistics block of the isp
> to userspace and then let some userspace thingie (blob?) handle it.
> 
> So I was wondering if anyone is working on proper support
> (targeting upstream) for this ? It would be nice if we could at least
> get the csi bits going, using the sensors or software auto-whitebal, etc.
> for now.

As I mentioned to Hans in private, I would be ready to provide the
hardware for somebody with a track record to keep, to allow testing and
hopefully maintaining that code longer term.

I would expect that this sort of hardware is already quite common
amongst Windows 8 tablets so it would be very helpful to have working
out-of-the-box on a stock Linux.

Cheers

