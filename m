Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46691 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbZLPCTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 21:19:32 -0500
Received: by bwz27 with SMTP id 27so428522bwz.21
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2009 18:19:29 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: Success for Compro E650F analog television and alsa sound.
Date: Wed, 16 Dec 2009 04:19:35 +0200
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>
References: <200912070400.03469.liplianin@me.by> <83bcf6340912070804i64eeb132hdf97546f68fa31cb@mail.gmail.com>
In-Reply-To: <83bcf6340912070804i64eeb132hdf97546f68fa31cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912160419.36060.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7 декабря 2009 18:04:14 Steven Toth wrote:
> On Sun, Dec 6, 2009 at 9:00 PM, Igor M. Liplianin <liplianin@me.by> wrote:
> > Hi Steve
> >
> > I'm able to watch now analog television with Compro E650F.
> > I rich this by merging your cx23885-alsa tree and adding some
> > modifications for Compro card definition.
> > Actually, I take it from Mygica definition, only tuner type and DVB port
> > is different. Tested with Tvtime.
> >
> > tvtime | arecord -D hw:2,0 -r 32000 -c 2 -f S16_LE | aplay -
> >
> > My tv card is third for alsa, so parameter -D for arecord is hw:2,0.
> > SECAM works well also.
> > I didn't test component input, though it present in my card.
>
> Thanks Igor, I'll merge this into the cx23885-alsa tree in the next
> couple of days.
>
> Regards,
Tested Television and Composite inputs.

			{
				.type	= CX23885_VMUX_TELEVISION,
				.vmux	= CX25840_COMPOSITE2,
			}, {
				.type	= CX23885_VMUX_COMPOSITE1,
				.vmux	= CX25840_COMPOSITE1,
			}
The card also have Svideo and Component inputs.
I will try to test them later.
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
