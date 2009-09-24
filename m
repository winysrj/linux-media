Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:38143
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZIXVmr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 17:42:47 -0400
Date: Thu, 24 Sep 2009 23:42:33 +0200
From: spam@systol-ng.god.lan
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] tda18271_set_analog_params major bugfix
Message-ID: <20090924214233.GA13708@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
References: <20090922210500.GA8661@systol-ng.god.lan> <37219a840909241146q72af5395hc028b91b6a97ada1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840909241146q72af5395hc028b91b6a97ada1@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 24, 2009 at 02:46:06PM -0400, Michael Krufky wrote:
> On Tue, Sep 22, 2009 at 5:05 PM,  <spam@systol-ng.god.lan> wrote:
> >
> > Multiplication by 62500 causes an overflow in the 32 bits "freq" register when
> > using radio. FM radio reception on a Zolid Hybrid PCI is now working. Other
> > tda18271 configurations may also benefit from this change ;)
> >
> > Signed-off-by: Henk.Vergonet@gmail.com
> >
> > diff -r 29e4ba1a09bc linux/drivers/media/common/tuners/tda18271-fe.c
...
> > -               freq = freq / 1000;
> > +               freq = params->frequency * 625;
> > +               freq = freq / 10;

Hmm now that I review my own patch:

-               freq = freq / 1000;
+               freq = params->frequency * 125;
+               freq = freq / 2;

might even be better...

regards
henk
