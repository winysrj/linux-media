Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.youplala.net ([88.191.51.216]:39824 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbZHLOHH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 10:07:07 -0400
Received: from [10.11.11.141] (host81-151-5-7.range81-151.btcentralplus.com [81.151.5.7])
	by mail.youplala.net (Postfix) with ESMTPSA id 4D5E1D880C7
	for <linux-media@vger.kernel.org>; Wed, 12 Aug 2009 16:06:55 +0200 (CEST)
Subject: Re: [linux-dvb] problem: Hauppauge Nova TD500
From: Nicolas Will <nico@youplala.net>
To: linux-media@vger.kernel.org
In-Reply-To: <CE7D00C2-9D6E-4DF9-A82A-9DA270CD22E9@dockerz.net>
References: <4A8169D0.3030008@dockerz.net>
	 <1249996315.30127.3.camel@youkaida>
	 <CE7D00C2-9D6E-4DF9-A82A-9DA270CD22E9@dockerz.net>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 15:06:48 +0100
Message-Id: <1250086008.4732.1.camel@youkaida>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-08-12 at 23:04 +1000, Tim Docker wrote:
> On 11/08/2009, at 11:11 PM, Nicolas Will wrote:
> 
> > On Tue, 2009-08-11 at 13:53 +0100, Tim Docker wrote:
> >> Hi,
> >>
> >> I'm trying to diagnose a problem with a mythtv setup based upon a
> >> hauppauge nova td 500. I've had the setup for some months - it
> seemed
> >> to
> >> work reasonably reliably initially, but over the last few weeks
> I've
> >> had
> >> consistent problems with the tuner card entering a state where it
> is
> >> unable to receive a signal.
> 
> > This problem is most probably caused by the tuner being in USB
> suspend
> > when MythTV wants to use it too quickly.
> >
> > Either disable usb suspend in your kernel, or tell mythtv to take
> wait
> > some more before tuning.
> >
> > I told MythTV to wait some more, and all is fine.
> >
> >
> http://www.youplala.net/linux/home-theater-pc#toc-not-losing-one-of-the-nova-t-500s-tuners
> 
> Thanks - I've make the changes, and it's survived the first 24
> hours,  
> which is an improvement. Time will tell if the problem has really
> gone.

It should be.

My system has been up for more than 14 days, since the last kernel
update that required a reboot.

Before that it was up for more than a month.

Nico

