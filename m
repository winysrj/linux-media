Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.youplala.net ([88.191.51.216]:59950 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbZHXQBD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 12:01:03 -0400
Received: from [134.32.138.108] (unknown [134.32.138.108])
	by mail.youplala.net (Postfix) with ESMTPSA id 76C61D880C8
	for <linux-media@vger.kernel.org>; Mon, 24 Aug 2009 18:00:50 +0200 (CEST)
Subject: Re: Nova-TD-500 (84xxx) problems (was Re: dib0700 diversity
 support)
From: Nicolas Will <nico@youplala.net>
To: linux-media@vger.kernel.org
In-Reply-To: <A971DB9B-7353-4BD1-AFF3-6B30239533DF@cdu.edu.au>
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de>
	 <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de>
	 <1251042115.19935.16.camel@lychee.local> <4A9296D5.1070202@nildram.co.uk>
	 <A971DB9B-7353-4BD1-AFF3-6B30239533DF@cdu.edu.au>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 17:00:49 +0100
Message-Id: <1251129649.5234.42.camel@acropora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-08-25 at 00:36 +0930, Malcolm Caldwell wrote:
> > Have you tried adding:
> >
> > dvb_usb_dib0700.force_lna_activation=1
> >
> > to the modprobe options?
> >
> > The device I had wouldn't tune without this.
> 
> I should have mentioned that I have tried this and buggy sfn  
> workaround for the relavent modules.

I have read that sometimes the problem is not a low signal, but too
strong a signal.

Have you tried placing an attenuator in front of the card?

Nico

