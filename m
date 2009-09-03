Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46717 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbZICLam (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:30:42 -0400
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not
	working	well together
From: Andy Walls <awalls@radix.net>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4A9FA729.3010207@onelan.com>
References: <4A9E9E08.7090104@onelan.com>  <4A9EAF07.3040303@hhs.nl>
	 <1251975978.22279.8.camel@morgan.walls.org>  <4A9FA729.3010207@onelan.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 07:29:07 -0400
Message-Id: <1251977347.22279.21.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-09-03 at 12:23 +0100, Simon Farnsworth wrote:
> Andy Walls wrote:
> > But I suspect no user pays for the extra cost of the CX2341[568]
> > hardware MPEG encoder, if the user primarily wants uncompressed YUV
> > video as their main format.
> 
> Actually, we're doing exactly that. We want a PCI card from a reputable
> manufacturer which provides uncompressed YUV and ATSC (both OTA and
> ClearQAM cable). As we already buy Hauppauge HVR-1110s for DVB-T and
> uncompressed analogue, a Hauppauge card suits us, and the only thing
> they have that fits the needs is the HVR-1600; the MPEG encoder is thus
> left idle.

Ah. OK, this is more than an academic exercise. :)

If you can prioritize your needs for the cx18 driver, I can see what I
can get done.

If you'd like to submit patches, I'll be happy to review them to make
sure they don't break anything and then get them integrated.

Regards,
Andy

