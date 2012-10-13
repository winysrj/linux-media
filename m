Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39445 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2JMTSD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Oct 2012 15:18:03 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so2299554wey.19
        for <linux-media@vger.kernel.org>; Sat, 13 Oct 2012 12:18:01 -0700 (PDT)
Subject: Re: HD-PVR fails consistently on Linux, works on Windows
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: =?iso-8859-1?Q?David_R=F6thlisberger?= <david@rothlis.net>
In-Reply-To: <20121013112800.2d7a1a42@earthlink.net>
Date: Sat, 13 Oct 2012 20:17:59 +0100
Cc: linux-media@vger.kernel.org, will@williammanley.net
Content-Transfer-Encoding: 7bit
Message-Id: <F8199D50-FE9B-4F1E-B04A-1B7E8D216A5D@rothlis.net>
References: <5063BD18.4060309@austin.rr.com> <20121013112800.2d7a1a42@earthlink.net>
To: Jonathan <jonathan.625266@earthlink.net>,
	Keith Pyle <kpyle@austin.rr.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Sep 2012 21:42:32 -0500
Keith Pyle <kpyle@austin.rr.com> wrote:
> I recently purchased a Hauppauge HD-PVR (the 1212 version, label on 
> bottom 49001LF, Rev F2).  I have consistent capture failures on Linux 
> where data from the device simply stops, generally within a few minutes 
> of starting a capture.
> 
> [...]
> 
> Sep 21 17:01:01 mythbe kernel: [535043.703947] hdpvr 9-1:1.0: firmware 
> version 0x15 dated Jun 17 2010 09:26:53

When we contacted Hauppauge regarding the stability issue, they
recommended upgrading to the latest firmware dated Mar 26 2012.
We *think* this has improved stability, but it certainly hasn't
fixed it completely.

Upgrading the firmware requires a Windows PC -- see
http://www.hauppauge.com/site/support/support_hdpvr.html


On 13 Oct 2012, at 16:28, Jonathan wrote:

> It may be a coincidence but I since I started using irqbalance (
> https://code.google.com/p/irqbalance/ ) my HD-PVR has been completely
> stable. Before that I was experiencing daily lockups.

Interesting. You definitely didn't upgrade the firmware around the same
time?

We think the stability is worse when the Linux PC is heavily loaded: We
do real-time image processing on the video stream from the HD PVR, so
the CPUs are maxed out, and we get frequent lock-ups. We also think the
lock-ups are more frequent when we have several HD PVRs connected to the
same PC, all running at the same time. I'll have to try this irqbalance.

--Dave.

