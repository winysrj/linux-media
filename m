Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:34540 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbZCCIGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 03:06:45 -0500
Date: Tue, 3 Mar 2009 00:06:43 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <200903030819.01420.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903022356380.24268@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl>
 <Pine.LNX.4.58.0903021351370.24268@shell2.speakeasy.net>
 <200903030819.01420.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Mar 2009, Hans Verkuil wrote:
> On Monday 02 March 2009 23:47:31 Trent Piepho wrote:
> > On Mon, 2 Mar 2009, Hans Verkuil wrote:
> > > There are good reasons as a developer for keeping backwards
> > > compatibility with older kernels:
> >
> > Do you mean no backwards compatibility with any older kernels?  Or do you
> > mean just dropping support for the oldest kernels now supported.  What
> > you've said above sounds like the former.
>
> This was about the advantages of having compat code at all to support
> kernels other than the bleeding edge git kernel.

I thought the poll was only about dropping support for kernels older than
2.6.22?

> > Will you allow drivers to use a combination of probe based and detect
> > based i2c using the new i2c api?  It's my understanding that you only
> > support the new i2c api for probe-only drivers.  Probe/detect or ever
> > detect-only drivers for the new i2c api haven't been done?  I think much
> > of the difficulty of supporting <2.6.22 will be solved once there is a
> > way to allow drivers to use both probe and detect with the new api.
>
> The difficulties are not with probe or detect, but with the fact that with
> the new API the adapter driver has to initiate the probe instead of the
> autoprobing that happened in the past by just loading the i2c module. The

That's not true.  Using the new API's ->probe() method works like you say,
but using the new API's ->detect() method is much more like the autoprobing
that happened in the past.

> I don't think we have to use the detect() functionality at all in i2c
> modules, although I need to look at bttv more closely to see whether that
> is a true statement. I'm at this moment opposed to the use of detect()
> since I fear it can lead to pretty much the same problems as autoprobing
> does when you start to rely on it. It's meant for legacy code where proper
> device/address information is not present. In the case of v4l-dvb the only
> driver that might qualify is bttv.

In some cases there is no way to identify the what hardware a card has and
there is also new cards that are still unknown.

> > I think I would have gone about it from the other side.  Convert bttv to
> > use detect and then make that backward compatible.  That compatibility
> > should be much easier and less invasive.
>
> This wouldn't have made any difference at all.

But you said yourself that the difficulties are "with the fact that with
the new API the adapter driver has to initiate the probe instead of the
autoprobing that happened in the past." Converting the bttv driver to use
detect with the new API would avoid those difficulties.
