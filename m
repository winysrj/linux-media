Return-path: <linux-media-owner@vger.kernel.org>
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:39565 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbZCaWrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 18:47:06 -0400
Date: Wed, 1 Apr 2009 00:47:02 +0200
From: Gabriele Dini Ciacci <dark.schneider@iol.it>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [PATCH] Drivers for Pinnacle pctv200e and pctv60e
Message-ID: <20090401004702.539afbda@gdc1>
In-Reply-To: <412bdbff0903311451w776c7b68t22fc3acbcd23fe64@mail.gmail.com>
References: <20090329155608.396d2257@gdc1>
	<20090331075610.53620db8@pedra.chehab.org>
	<20090331212052.152d2ffc@gdc1>
	<412bdbff0903311359i3f3883dds2d870c93e23d08f2@mail.gmail.com>
	<20090331233524.4000cb61@gdc1>
	<412bdbff0903311451w776c7b68t22fc3acbcd23fe64@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Mar 2009 17:51:23 -0400
Devin Heitmueller <devin.heitmueller@gmail.com> wrote:

> On Tue, Mar 31, 2009 at 5:35 PM, Gabriele Dini Ciacci
> <dark.schneider@iol.it> wrote:
> > I it's so, say me how to make or where to look to create a profile
> > for the existing driver.
> >
> > I am willing to do the work.
> >
> > (when I first wrote the driver to me it seemed that this was the
> > simplet way.
> >
> > Meanwhile I will try to look at the Cypress FX2
> 
> As Michael Krufky pointed out to me off-list, I was not exactly
> correct here.
> 
> While there are indeed drivers based on the same FX2 chip in your
> device, it may be possible to reuse an existing driver, or you may
> need a whole new driver, depending on how much the firmware varies
> between your product versus the others.  You may want to look at the
> pvrusb2 and cxusb drivers, which also use the FX2 chip, and see what
> similarities exist in terms of the API and command set.  If it is not
> similar to any of the others, then writing a new driver is probably
> the correct approach.
> 
> Regards,
> 
> Devin
> 

Fine perfect, thanks,

I will have a look asap and report for judge.

Cheers.
Gabriele

----------- 
http://linux-wildo.sf.net
http://www.diniciacci.org
