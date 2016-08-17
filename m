Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55154 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750763AbcHQGrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 02:47:07 -0400
Date: Wed, 17 Aug 2016 09:47:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@s-opensource.com
Subject: Re: Submit media entity without media device
Message-ID: <20160817064702.GC3182@valkosipuli.retiisi.org.uk>
References: <0b6c1a36-8770-b9f0-4d31-6b2aa31bed5c@synopsys.com>
 <3968b7c6-ee8b-b290-22e4-edb46ae1b6cc@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3968b7c6-ee8b-b290-22e4-edb46ae1b6cc@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On Tue, Aug 16, 2016 at 04:13:46PM +0100, Ramiro Oliveira wrote:
> Just adding some people to the CC list.
> 
> 
> On 28-06-2016 13:00, Ramiro Oliveira wrote:
> > Hi all,
> >
> > We at Synopsys have a media device driver and in that media device we have a
> > media entity for our CSI-2 Host.
> >
> > At the moment we aren't ready to submit the entire media device, so I was
> > wondering if it was possible to submit a media entity driver separately, without
> > the rest of the architecture, and if so where should we place it.

Just the CSI-2 receiver support should be fine. You can then extend it later
on to cover more functionality. A media device is still needed: media
entities may not exist without the media device. The media graph may well be
amended later on. (But changing what's already there should be avoided as it
changes the user space interface.)

Pick a name, typically hardware block names or such work the best in such
cases. If yours is a platform driver it'll go under
drivers/media/platform (PCI goes under pci and so on).

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
