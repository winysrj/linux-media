Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591AbZGGOfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2009 10:35:47 -0400
Date: Tue, 7 Jul 2009 11:35:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Erik =?ISO-8859-1?B?QW5kculu?= <erik.andren@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: howto handle driver changes which require libv4l > x.y ?
Message-ID: <20090707113538.71ecd68e@pedra.chehab.org>
In-Reply-To: <62e5edd40907070655g75dbfc5dy3799d85a15ad4a6c@mail.gmail.com>
References: <4A53509D.8060503@redhat.com>
	<62e5edd40907070655g75dbfc5dy3799d85a15ad4a6c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 7 Jul 2009 15:55:59 +0200
Erik Andrén <erik.andren@gmail.com> escreveu:

> 2009/7/7 Hans de Goede <hdegoede@redhat.com>:
> > Hi All,
> >
> > So recently I've hit 2 issues where kernel side fixes need
> > to go hand in hand with libv4l updates to not cause regressions.
> >
> > First lets discuss the 2 cases:
> > 1) The pac207 driver currently limits the framerate (and thus
> >   the minimum exposure time) because at higher framerate the
> >   cam starts using a higher compression and we could not
> >   decompress this. Thanks to Bertrik Sikken we can now handle
> >   the higher decompression.
> >
> >   So no I really want to enable the higher framerates as those
> >   are needed to make the cam work properly in full daylight.
> >
> >   But if I do this, things will regress for people with an
> >   older libv4l, as that won't be able to decompress the frames
> >
> > 2) Several zc3xxx cams have a timing issue between the bridge and
> >   the sensor (the windows drivers have the same issue) which
> >   makes them do only 320x236 instead of 320x240. Currently
> >   we report their resolution to userspace as 320x240, leading to
> >   a bar of noise at the bottom of the screen.
> >
> >   The fix here obviously is to report the real effective resoltion
> >   to userspace, but this will cause regressions for apps which blindly
> >   assume 320x240 is available (such as skype). The latest libv4l will
> >   make the apps happy again by giving them 320x240 by adding small
> >   black borders.
> >
> >
> > Now I see 2 solutions here:
> >
> > a) Just make the changes, seen from the kernel side these are most
> >   certainly bugfixes. I tend towards this for case 2)
> >
> > b) Come up with an API to tell the libv4l version to the kernel and
> >   make these changes in the drivers conditional on the libv4l version
> >
> >
> Solution b) sounds messy and will probably lead to a lot of error
> prone glue code in the kernel.
> Fast-forward a couple of libv4l releases and you will have a nightmare
> maintainability scenario.
> 
> If people run an old libv4l with a new kernel and run into problem,
> just tell them to upgrade their libv4l version.

(b) seems a very bad hack, IMO. Between the two, I choose (a).

Another alternative would be to make liv4l to check (with querycap) the driver
version and adjust libv4l correspondingly. 

For example, in the example (1), pac207 will default to use the lower
compression rate. A newer libv4l can adjust the pac207 to a higher compression
rate, if running a newer driver that driver supports it.

In the case of (2), I couldn't see what should be the expected behavior.



Cheers,
Mauro
