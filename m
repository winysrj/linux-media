Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54755 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbcFCLfN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2016 07:35:13 -0400
Message-ID: <1464953708.2432.51.camel@hadess.net>
Subject: Re: NTSC/PAL resolution support for "EasyCap" device
From: Bastien Nocera <hadess@hadess.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Fri, 03 Jun 2016 13:35:08 +0200
In-Reply-To: <1495486.1uKbyyPPu6@avalon>
References: <1464691129.3878.59.camel@hadess.net>
	 <2081548.sYXtIeXGjI@avalon> <1464951211.2432.44.camel@hadess.net>
	 <1495486.1uKbyyPPu6@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2016-06-03 at 14:08 +0300, Laurent Pinchart wrote:
> 
<snip>
> > Full lsusb below.
> 
> Thanks. The device only advertises two resolutions, 640x480 and
> 352x288.

As I read.

> > > If the device doesn't expose resolutions other than the above
> > > two, the
> > > box could be lying, or the device could use non-standard
> > > extensions to UVC
> > > to support additional resolutions. The first step would be to try
> > > the
> > > camera in a  Windows machine to see if additional resolutions are
> > > available (without installing any additional device-specific
> > > software).
> > 
> > I should be able to find a Windows somewhere, but which application
> > should I use to see if those resolutions are indeed available?
> 
> My (lack of) Windows knowledge doesn't allow me to answer that
> question, but 
> I'm sure searching online will give you answers.

"AMCap" seems to be the simplest software for that purpose, and it only
shows "640x480".

> > BTW, given the price of the device, I'd be fine getting one for you
> > to
> > test (6€ from eBay, shipping included).
> 
> Thanks, but I'm already overwhelmed with work, I'd rather have you
> performing 
> the tests. Beside, I have no Windows machine :-)

I've started the process of yelling at the vendor.

Cheers
