Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50430 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2HTWKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 18:10:18 -0400
Received: by ialo24 with SMTP id o24so2835342ial.19
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 15:10:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5032B407.8030407@redhat.com>
References: <20120816221514.GA26546@pequod.mess.org>
	<502D7E62.9040204@redhat.com>
	<20120820213659.GC14636@hardeman.nu>
	<5032B407.8030407@redhat.com>
Date: Mon, 20 Aug 2012 18:10:16 -0400
Message-ID: <CAGoCfizxSnUgC2Ka5uz3_gXaFf65057kt+EBNz7WassEvVsDHg@mail.gmail.com>
Subject: Re: [media] rc-core: move timeout and checks to lirc
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Sean Young <sean@mess.org>, Jarod Wilson <jwilson@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 20, 2012 at 6:02 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> So, IMO, it makes sense to have a "high end" API that accepts
> writing keystrokes like above, working with both "raw drivers"
> using some kernel IR protocol encoders, and with devices that can
> accept "processed" keystrokes, like HDMI CEC.

It might also make sense to have a third mode for devices that support
high level protocols such as RC5/NEC but you want to leverage the very
large existing LIRC database of remote controls.  The device would
advertise all the modes it supports (RC5/NEC/RC6/whatever), and from
there it can accept the actual RC codes instead of a raw waveform.

I recognize that this is case that falls in between the two models
proposed, but there are devices that fall into this category.  The
alternative for those devices would be for LIRC to convert the RC5
code into a raw waveform, send the raw waveform to the kernel, and
then the driver convert it back into a code, which would be quite
messy since it would have to figure out what RC format it was
originally in.  It would be much better if LIRC could just send the
RC5 code directly into the kernel.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
