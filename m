Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:60489 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067Ab2JNMh4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Oct 2012 08:37:56 -0400
Received: from [69.22.83.79] (helo=localhost.localdomain)
	by elasmtp-curtail.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <jonathan.625266@earthlink.net>)
	id 1TNNHm-000691-3T
	for linux-media@vger.kernel.org; Sun, 14 Oct 2012 08:27:14 -0400
Date: Sun, 14 Oct 2012 08:27:13 -0400
From: Jonathan <jonathan.625266@earthlink.net>
To: linux-media@vger.kernel.org
Subject: Re: HD-PVR fails consistently on Linux, works on Windows
Message-ID: <20121014082713.5f4f4dde@earthlink.net>
In-Reply-To: <F8199D50-FE9B-4F1E-B04A-1B7E8D216A5D@rothlis.net>
References: <5063BD18.4060309@austin.rr.com>
	<20121013112800.2d7a1a42@earthlink.net>
	<F8199D50-FE9B-4F1E-B04A-1B7E8D216A5D@rothlis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 13 Oct 2012 20:17:59 +0100
David Röthlisberger <david@rothlis.net> wrote:

> On Wed, 26 Sep 2012 21:42:32 -0500
> Keith Pyle <kpyle@austin.rr.com> wrote:
> > I recently purchased a Hauppauge HD-PVR (the 1212 version, label on 
> > bottom 49001LF, Rev F2).  I have consistent capture failures on Linux 
> > where data from the device simply stops, generally within a few minutes 
> > of starting a capture.
> > 
> > [...]
> > 
> > Sep 21 17:01:01 mythbe kernel: [535043.703947] hdpvr 9-1:1.0: firmware 
> > version 0x15 dated Jun 17 2010 09:26:53
> 
> When we contacted Hauppauge regarding the stability issue, they
> recommended upgrading to the latest firmware dated Mar 26 2012.
> We *think* this has improved stability, but it certainly hasn't
> fixed it completely.
> 
> Upgrading the firmware requires a Windows PC -- see
> http://www.hauppauge.com/site/support/support_hdpvr.html
> 
> 
> On 13 Oct 2012, at 16:28, Jonathan wrote:
> 
> > It may be a coincidence but I since I started using irqbalance (
> > https://code.google.com/p/irqbalance/ ) my HD-PVR has been completely
> > stable. Before that I was experiencing daily lockups.
> 
> Interesting. You definitely didn't upgrade the firmware around the same
> time?
> 
> We think the stability is worse when the Linux PC is heavily loaded: We
> do real-time image processing on the video stream from the HD PVR, so
> the CPUs are maxed out, and we get frequent lock-ups. We also think the
> lock-ups are more frequent when we have several HD PVRs connected to the
> same PC, all running at the same time. I'll have to try this irqbalance.
> 
> --Dave.

No change in my firmware; still on version 0x15. FWIW, after using irqblance for about 10 days, cat /proc/interrupts shows the interrupt for xhci_hcd (the USB3 bus my HD-PVR is attached to) is now spread across all 4 cores whereas before it was loaded up on CPU0.  Same thing was shown for  ahci,  and a lot of data is being written to disk when the HD-PVR is working so I guess that could be a factor as well.

Jonathan
