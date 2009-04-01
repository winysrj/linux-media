Return-path: <linux-media-owner@vger.kernel.org>
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:53072 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZDAS3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 14:29:05 -0400
Date: Wed, 1 Apr 2009 20:28:55 +0200
From: Gabriele Dini Ciacci <dark.schneider@iol.it>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Drivers for Pinnacle pctv200e and pctv60e
Message-ID: <20090401202855.61f5cdd4@gdc1>
In-Reply-To: <alpine.LRH.1.10.0904011716370.21921@pub4.ifh.de>
References: <20090329155608.396d2257@gdc1>
	<20090331075610.53620db8@pedra.chehab.org>
	<20090331212052.152d2ffc@gdc1>
	<412bdbff0903311359i3f3883dds2d870c93e23d08f2@mail.gmail.com>
	<20090331233524.4000cb61@gdc1>
	<412bdbff0903311451w776c7b68t22fc3acbcd23fe64@mail.gmail.com>
	<20090401004702.539afbda@gdc1>
	<alpine.LRH.1.10.0904011716370.21921@pub4.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 1 Apr 2009 17:27:04 +0200 (CEST)
Patrick Boettcher <patrick.boettcher@desy.de> wrote:

> Hi,
> 
> On Wed, 1 Apr 2009, Gabriele Dini Ciacci wrote:
> 
> > On Tue, 31 Mar 2009 17:51:23 -0400
> > Devin Heitmueller <devin.heitmueller@gmail.com> wrote:
> >
> >> On Tue, Mar 31, 2009 at 5:35 PM, Gabriele Dini Ciacci
> >> <dark.schneider@iol.it> wrote:
> >>> I it's so, say me how to make or where to look to create a profile
> >>> for the existing driver.
> >>>
> >>> I am willing to do the work.
> >>>
> >>> (when I first wrote the driver to me it seemed that this was the
> >>> simplet way.
> >>>
> >>> Meanwhile I will try to look at the Cypress FX2
> >>
> >> As Michael Krufky pointed out to me off-list, I was not exactly
> >> correct here.
> >>
> >> While there are indeed drivers based on the same FX2 chip in your
> >> device, it may be possible to reuse an existing driver, or you may
> >> need a whole new driver, depending on how much the firmware varies
> >> between your product versus the others.  You may want to look at
> >> the pvrusb2 and cxusb drivers, which also use the FX2 chip, and
> >> see what similarities exist in terms of the API and command set.
> >> If it is not similar to any of the others, then writing a new
> >> driver is probably the correct approach.
> >>
> >> Regards,
> >>
> >> Devin
> >>
> >
> > Fine perfect, thanks,
> 
> Attached you can find my attempts from 2005. I2C should work, please 
> re-use this implementation as it nicely splits i2c_transfer from the
> rest of the required functionality.
> 
> I think I still have the pctv 200e somewhere in a box... I may get it 
> back, undust it and try.
> 
> Patrick.
> 
> --
>    Mail: patrick.boettcher@desy.de
>    WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

I had a quick look (1 min) and I think the interface is to port to the
new "style" used. I can merge my version of the driver with your and
get a final driver, indeed your i2c is much better, as I coded i2c as a
i2c ignorant, so just copying from the other drivers. I will just take
your implementation for that part.

Thanks a lot for the i2c explanation, that explains! Now my view is
much clearer.

So what if I try to merge the two drivers to get a clean one, test them
on pctv60e, you test them on pctv200e and... done!

The cherry would be to spend some time on the IR also, but just wait to
have a driver.

Regards & cheers,
Gabriele
