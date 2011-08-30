Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:53873 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1H3VTh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 17:19:37 -0400
Date: Wed, 31 Aug 2011 00:19:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Enrico <ebutera@users.berlios.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: Getting started with OMAP3 ISP
Message-ID: <20110830211932.GI12368@valkosipuli.localdomain>
References: <4E56734A.3080001@mlbassoc.com>
 <4E5CEECC.6040804@mlbassoc.com>
 <4E5CF118.3050903@mlbassoc.com>
 <201108301620.09365.laurent.pinchart@ideasonboard.com>
 <4E5CFA0B.3010207@mlbassoc.com>
 <CA+2YH7sfhWz_ubLExnGKmyLKOVKGOXYOmH6a1Hoy8ssJeMQnWQ@mail.gmail.com>
 <4E5D0E69.6020909@mlbassoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5D0E69.6020909@mlbassoc.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 10:23:05AM -0600, Gary Thomas wrote:
> On 2011-08-30 10:07, Enrico wrote:
> >On Tue, Aug 30, 2011 at 4:56 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
> >>Yes, that helped a lot.  When I create the devices by hand, I can now see
> >>my driver starting to be accessed (right now it's very much an empty stub)
> >
> >>From your logs it seems you are using a tvp5150, i've posted a patch
> >[1] for tvp5150 that makes it very close to work, it could be faster
> >to debug it instead of starting from scratch.
> >
> >Enrico
> >
> >[1] http://www.spinics.net/lists/linux-media/msg37116.html
> 
> Thanks, I'll give it a look.
> 
> Your note says that /dev/video* is properly registered.  Does this
> mean that udev created them for you on boot as well?  If so, what

No. This message means that the device has been registered to the kernel (
it is accessbile through a major/minor number pair). Device node referring
to the major/minor pair is separately created by udev.

-- 
Sakari Ailus
sakari.ailus@iki.fi
