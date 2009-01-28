Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx33.mail.ru ([194.67.23.194]:5794 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbZA1RzS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 12:55:18 -0500
Date: Wed, 28 Jan 2009 21:04:07 +0300
From: Goga777 <goga777@bk.ru>
To: Manu <eallaud@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Re : [linux-dvb] Technotrend Budget S2-3200 Digital artefacts
 on HDchannels
Message-ID: <20090128210407.3aceba63@bk.ru>
In-Reply-To: <1233159564.8255.0@manu-laptop>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
	<c74595dc0901261107i66125bfdpe35cb7b89144ab11@mail.gmail.com>
	<497F6B2E.6010305@gmail.com>
	<c74595dc0901271240i2008cacdp565fe69f3269ea55@mail.gmail.com>
	<497F7C40.6030300@gmail.com>
	<c74595dc0901271402g5a44fe05pecae642570e54e0f@mail.gmail.com>
	<497F927E.8050009@gmail.com>
	<b1dab3a10901280303s62a5afd8oe906ce93f05614dd@mail.gmail.com>
	<1233159564.8255.0@manu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > I am writing just to share my experience with tt3200 drivers. The
> > following are just observations about the behavior of my card:
> > 
> > 1. The card has never tuned reliably with the v4l-dvb s2api driver or
> > the multiproto driver. This concerns not just high rate dvb-s2
> > transponders but also some plain dvb-s transponders as well. And this
> > is not just random hiccups but consistent behavior. German Eurosport 
> > @
> > 19.2e is a prime example.
> > 2. When Igor first increased the high clock to 135MHz, there was a
> > marked improvement. All of the tuning issues were gone. However I am
> > using a rotor and the higher clock rate somehow broke rotor control.
> > 3. Next Igor backed down the high clock to 99MHz and introduced a
> > "very high clock" of 135MHz. Tuning went back to unreliable. Rotor
> > control was ok.
> > 4. I bought a hvr4000. And now all of my issues are gone.
> 
> I am thinking about it also :(
> Does it work reliably with dvb-s/s2 and CAM?

concerning of dvb-s/s2 - yes it works well
concerning of CAM - I didn't check,  I don't know

Goga

