Return-path: <linux-media-owner@vger.kernel.org>
Received: from phobos02.frii.com ([216.17.128.162]:51155 "EHLO mail.frii.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755289AbZGYCWK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 22:22:10 -0400
Date: Fri, 24 Jul 2009 20:22:06 -0600
From: Mark Zimmerman <markzimm@frii.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org
Subject: Re: TBS 8920 still fails to initialize - cx24116_readreg error
Message-ID: <20090725022206.GA17704@io.frii.com>
References: <20090724023315.GA96337@io.frii.com> <200907241906.11914.liplianin@me.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907241906.11914.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 24, 2009 at 07:06:11PM +0300, Igor M. Liplianin wrote:
> On 24 ???? 2009 05:33:15 Mark Zimmerman wrote:
> > Greetings:
> >
> > Using current current v4l-dvb drivers, I get the following in the
> > dmesg:
> >
> > cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
> > cx88[1]/2: cx2388x based DVB/ATSC card
> > cx8802_alloc_frontends() allocating 1 frontend(s)
> > cx24116_readreg: reg=0xff (error=-6)
> > cx24116_readreg: reg=0xfe (error=-6)
> > Invalid probe, probably not a CX24116 device
> > cx88[1]/2: frontend initialization failed
> > cx88[1]/2: dvb_register failed (err = -22)
> > cx88[1]/2: cx8802 probe failed, err = -22
> >
> > Does this mean that one of the chips on this card is different than
> > expected? How can I gather useful information about this?
> Hi
> You can try:
> http://www.tbsdtv.com/download/tbs6920_8920_v23_linux_x86_x64.rar

This code did not compile as-is, but after I commented out some things
in drivers I do not need, I managed to build something. The TBS card
now seems to be initialized, but it also broke support for my DViCO
FusionHDTV7 Dual Express card, which also uses a cx23885.

I am going to move this card to another machine that does not have any
other capture cards and repeat the process. This should make it easier
to know what the TBS card/driver is doing.

I am assuming that you are interested in using me to gather
information to update the v4l-dvb drivers so that this card can be
supported properly. Is this correct?  Please let me know what I can do
to assist.

-- Mark
