Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39455 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2BBWf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 17:35:26 -0500
Received: by werb13 with SMTP id b13so2250049wer.19
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 14:35:25 -0800 (PST)
Message-ID: <1328222117.3572.27.camel@tvbox>
Subject: Re: DVB TS/PES filters
From: Malcolm Priestley <tvboxspy@gmail.com>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Date: Thu, 02 Feb 2012 22:35:17 +0000
In-Reply-To: <20120202190420.45629a9b@tiber>
References: <20120126154015.01eb2c18@tiber> <20120201133234.0b6222bc@junior>
	 <4F29791C.6060201@flensrocker.de> <20120202190420.45629a9b@tiber>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-02-02 at 19:04 +0000, Tony Houghton wrote:
> On Wed, 01 Feb 2012 18:40:44 +0100
> Lars Hanisch <dvb@flensrocker.de> wrote:
> 
> > Am 01.02.2012 14:32, schrieb Tony Houghton:
> > > On Thu, 26 Jan 2012 15:40:15 +0000 Tony Houghton<h@realh.co.uk>
> > > wrote:
> > >
> > >> I could do with a little more information about DMX_SET_PES_FILTER.
> > >> Specifically I want to use an output type of DMX_OUT_TS_TAP. I
> > >> believe there's a limit on how many filters can be set, but I don't
> > >> know whether the kernel imposes such a limit or whether it depends
> > >> on the hardware, If the latter, how can I read the limit?
> > >
> > > Can anyone help me get more information about this (and the "magic
> > > number" pid of 8192 for the whole stream)?
> > 
> >   In the TS-header there are 13 bits for the PID, so it can be from 0
> >   to 8191.  Therefore dvb-core interprets 8192 (and greater values I
> >   think) as "all PIDs".
> 
> Thanks for that. But it would be really helpful if I could find out
> whether there really is a limit to the number of filters and whether
> it's hardware dependent or the kernel.

The hardware usually only filters the TS packets unprocessed.

Hardware TS filtering is typically 16, 32 or 64. Nearly all can be
turned off(unfiltered).

dvb-usb devices the unfiltered limit is 255.

The most TS streams usually contain 20 to 40 or so.

