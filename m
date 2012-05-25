Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:34401 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2EYKAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 06:00:10 -0400
Date: Fri, 25 May 2012 03:00:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sergio Aguirre <sergio.a.aguirre@gmail.com>
Cc: Sergio Aguirre <saaguirre@ti.com>, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 08/10] arm: omap4panda: Add support for omap4iss
 camera
Message-ID: <20120525100008.GQ17852@atomide.com>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
 <1335971749-21258-9-git-send-email-saaguirre@ti.com>
 <20120508234641.GV5088@atomide.com>
 <CAC-OdnBLvZ2TR52bRHXDDtsvo-PUJ-N2Qj3gWaGhq3Ri+dv-bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC-OdnBLvZ2TR52bRHXDDtsvo-PUJ-N2Qj3gWaGhq3Ri+dv-bw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Sergio Aguirre <sergio.a.aguirre@gmail.com> [120523 21:49]:
> Hi Tony,
> 
> On Tue, May 8, 2012 at 6:46 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Sergio Aguirre <saaguirre@ti.com> [120502 08:21]:
> >> This adds support for camera interface with the support for
> >> following sensors:
> >>
> >> - OV5640
> >> - OV5650
> >
> > It seems that at this point we should initialize new things like this
> > with DT only. We don't quite yet have the muxing in place, but I'd
> > rather not add yet another big platform_data file for something that
> > does not even need to be there for DT booted devices.
> 
> Ok.
> 
> I'll look at that.
> 
> By the way, I've been very out of the loop on al DT related development..
> 
> Are these instructions valid for current master k.org branch?
> 
> http://omappedia.org/wiki/Device_Tree#Booting_with_DT_blob

Yeah seems about right.

Regards,

Tony
