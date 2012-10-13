Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4405 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2JMULM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Oct 2012 16:11:12 -0400
Message-ID: <5079CADD.8020409@austin.rr.com>
Date: Sat, 13 Oct 2012 15:11:09 -0500
From: Keith Pyle <kpyle@austin.rr.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_R=F6thlisberger?= <david@rothlis.net>
CC: Jonathan <jonathan.625266@earthlink.net>,
	linux-media@vger.kernel.org, will@williammanley.net
Subject: Re: HD-PVR fails consistently on Linux, works on Windows
References: <5063BD18.4060309@austin.rr.com> <20121013112800.2d7a1a42@earthlink.net> <F8199D50-FE9B-4F1E-B04A-1B7E8D216A5D@rothlis.net>
In-Reply-To: <F8199D50-FE9B-4F1E-B04A-1B7E8D216A5D@rothlis.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/13/12 14:17, David Röthlisberger wrote:
> On Wed, 26 Sep 2012 21:42:32 -0500
> Keith Pyle <kpyle@austin.rr.com> wrote:
>> I recently purchased a Hauppauge HD-PVR (the 1212 version, label on
>> bottom 49001LF, Rev F2).  I have consistent capture failures on Linux
>> where data from the device simply stops, generally within a few minutes
>> of starting a capture.
>>
>> [...]
>>
>> Sep 21 17:01:01 mythbe kernel: [535043.703947] hdpvr 9-1:1.0: firmware
>> version 0x15 dated Jun 17 2010 09:26:53
> When we contacted Hauppauge regarding the stability issue, they
> recommended upgrading to the latest firmware dated Mar 26 2012.
> We *think* this has improved stability, but it certainly hasn't
> fixed it completely.
>
> Upgrading the firmware requires a Windows PC -- see
> http://www.hauppauge.com/site/support/support_hdpvr.html
The Mar 26, 2012 firmware is the 1.7.1.30059 version that shows as 0x1e 
in the kernel messages.  In my case, I've tried both 0x1e and 0x15 with 
no discernible difference in stability.  That is, both hang reliably and 
repeatedly on Linux but not when using a Windows system.
>
> On 13 Oct 2012, at 16:28, Jonathan wrote:
>
>> It may be a coincidence but I since I started using irqbalance (
>> https://code.google.com/p/irqbalance/ ) my HD-PVR has been completely
>> stable. Before that I was experiencing daily lockups.
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
>
All of my tests have been using only one HD-PVR on otherwise nearly idle 
systems with *lots* of system resources available.  One test system is 
an Intel Core 2 Quad Q9400 (2.66 GHz) and the other is an Intel i7 950 
(3.0 GHz).  CPU loads are low during captures - not anywhere near having 
any core at 100%.  While system load could certainly be a factor for 
some, I do not believe it is in my tests.

Keith
