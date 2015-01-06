Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40778 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbAFHza (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 02:55:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Baytrail camera csi / isp support status ?
Date: Tue, 06 Jan 2015 09:55:37 +0200
Message-ID: <2140737.P20K9QBf6L@avalon>
In-Reply-To: <1420502814.14388.27.camel@hadess.net>
References: <548ACC7E.5070507@redhat.com> <1420502814.14388.27.camel@hadess.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastien,

On Tuesday 06 January 2015 01:06:54 Bastien Nocera wrote:
> On Fri, 2014-12-12 at 12:07 +0100, Hans de Goede wrote:
> > Hi All,
> > 
> > A college of mine has a baytrail bases tablet:
> > 
> > http://www.onda-tablet.com/onda-v975w-quad-core-win-8-tablet-9-7-inch-reti
> > na-screen-ram-2gb-wifi-32gb.html
> > 
> > And he is trying to get Linux to run on it, he has things mostly
> > working, but he would also like to get the cameras to work.
> > 
> > I've found this:
> > 
> > http://sourceforge.net/projects/e3845mipi/files/
> > 
> > Which is some not so pretty code, with the usual problems of using
> > custom ioctls to pass info from the statistics block of the isp
> > to userspace and then let some userspace thingie (blob?) handle it.
> > 
> > So I was wondering if anyone is working on proper support
> > (targeting upstream) for this ? It would be nice if we could at least
> > get the csi bits going, using the sensors or software auto-whitebal, etc.
> > for now.
> 
> As I mentioned to Hans in private, I would be ready to provide the
> hardware for somebody with a track record to keep, to allow testing and
> hopefully maintaining that code longer term.
> 
> I would expect that this sort of hardware is already quite common
> amongst Windows 8 tablets so it would be very helpful to have working
> out-of-the-box on a stock Linux.

$ cat BYT_LSP_3.11_ISP_2013-12-26.patch | diffstat -s
 302 files changed, 91662 insertions(+), 2 deletions(-)

There's no interest in upstreaming the code on Intel's side. As far as I 
understand their ISP is more like a programmable DSP than a fixed pipeline 
ISP. I expect the driver they have published to hardcode the pipeline 
programmed in a particular firmware and thus be specific to a limited number 
of devices. Given the amount of work required to get the code in shape, and 
given that reusability would be very limited if my assumptions are correct, I 
don't really see this happening unless you can find a motivated developer with 
way too much free time.

-- 
Regards,

Laurent Pinchart

