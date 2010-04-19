Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:57991 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0DSJ6a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Apr 2010 05:58:30 -0400
Date: Mon, 19 Apr 2010 11:58:18 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 5/8] ir-core: convert mantis from ir-functions.c
Message-ID: <20100419095818.GA3055@hardeman.nu>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
 <20100415214620.14142.19939.stgit@localhost.localdomain>
 <u2x1a297b361004151617gbd08bc10l4fa202ab8dcec306@mail.gmail.com>
 <20100416205638.GA2873@hardeman.nu>
 <j2r1a297b361004161427q88bd9fa3hbf64a38662199712@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <j2r1a297b361004161427q88bd9fa3hbf64a38662199712@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 17, 2010 at 01:27:05AM +0400, Manu Abraham wrote:
> On Sat, Apr 17, 2010 at 12:56 AM, David Härdeman <david@hardeman.nu> wrote:
> > On Fri, Apr 16, 2010 at 03:17:35AM +0400, Manu Abraham wrote:
> >> On Fri, Apr 16, 2010 at 1:46 AM, David Härdeman <david@hardeman.nu> wrote:
> >> > Convert drivers/media/dvb/mantis/mantis_input.c to not use ir-functions.c
> >> > (The driver is anyway not complete enough to actually use the subsystem yet).
> >>
> >> Huh ? I don't follow what you imply here ..
> >>
> >
> > The mantis_input.c file seems to be a skeleton as far as I could
> > tell...not actually in use yet. Or am I mistaken?
> 
> Only the input related parts of the IR stuff is there in
> mantis_input.c, the hardware handling is done by mantis_uart.c/h.
> There is a small bit which has not gone upstream yet, which is
> pending;
> http://jusst.de/hg/mantis-v4l-dvb/rev/ad8b00c9edc2
> 

Yes, and that patch includes actually calling mantis_input_init(), which 
wasn't called previously, so mantis_input.c wasn't actually in use.

Anyways, my patch still applies (or the principle at least) - use the 
functionality of ir-core and not ir-functions.c (which is going away).

And on a related note, the above patch adds keytables with entries like 
KEY_0, they should probably be KEY_NUMERIC_* instead.

-- 
David Härdeman
