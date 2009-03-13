Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:50124 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbZCMIdf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 04:33:35 -0400
Date: Fri, 13 Mar 2009 01:33:33 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: VDR User <user.vdr@gmail.com>, Peter Baartz <baartzy@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Kconfig changes in /hg/v4l-dvb caused dvb_usb_cxusb to stop
 building (fwd)
In-Reply-To: <alpine.LRH.2.00.0903090746470.6607@caramujo.chehab.org>
Message-ID: <Pine.LNX.4.58.0903130126270.28292@shell2.speakeasy.net>
References: <alpine.LRH.2.00.0903090746470.6607@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 9 Mar 2009, Mauro Carvalho Chehab wrote:
> Btw, if you look at DVB_FE_CUSTOMISE help, it is recommended tho unselect it,
> if you're not sure what to do.
>
>   >
> >  Anyways, here's what I get:
> >
> >  $ grep "^CONFIG" .config
> >  [everything is 'm']
> >  CONFIG_DVB_VES1820=m
> >  CONFIG_DVB_STV0297=m
> >  CONFIG_DVB_LNBP21=m
>
> Seems perfect to my eyes.

I think it might be nicer if the default value for a frontend when
customize was turned on was whatever it was selected to by the drivers that
use it.

When you don't use customize, all the frontends default to 'n'.  If you
set some driver to 'm', it will set all the frontends it uses to 'm'.  Set
the driver to 'y' and then those frontends get set to 'y'.

If you turn on customize, the default for the frontends should be same as
what they are when customize is off.  The difference is now you can see
them and change their value.
