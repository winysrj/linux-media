Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53529 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbZK3QOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 11:14:14 -0500
MIME-Version: 1.0
In-Reply-To: <4B13C799.4060906@redhat.com>
References: <m3r5riy7py.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259469121.3125.28.camel@palomino.walls.org>
	 <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	 <1259515703.3284.11.camel@maxim-laptop>
	 <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
	 <1259537732.5231.11.camel@palomino.walls.org>
	 <4B13B2FA.4050600@redhat.com>
	 <1259585852.3093.31.camel@palomino.walls.org>
	 <4B13C799.4060906@redhat.com>
Date: Mon, 30 Nov 2009 10:14:19 -0600
Message-ID: <7004b08e0911300814tb474f96s42ec56ca2e43cf7a@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: kevin granade <kevin.granade@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>, Ray Lee <ray-lk@madrabbit.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jon Smirl <jonsmirl@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 30, 2009 at 7:24 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

> After the boot, a device can open the raw API, disabling any in-kernel
> decoding/handling and handle IR directly. Alternatively, an udev rule
> can load a different keymap based on some config written on a file.

This idea of the in-kernel decoding being disabled when the raw API is
opened worries me.  What guarantees that the following scenario will
not happen?

User uses apps which retrieve the decoded IR messages from the kernel.
User installs an app which decodes messages via the raw API (not lirc).
User's other applications no longer receive IR messages.

I know the assumption has been that "only lirc will use the raw API",
but this seems like a poor assumption for an API design to me.

A related question, what is an application developer who wishes to
decode the raw IR signal (for whatever reason) to do?  Are they
*required* to implement full decoding and feed all the messages back
to the kernel so they don't break other applications?

For clarity, I'm not arguing for a particular approach, I'm not fully
able to follow the discussion on this issue, but this one issue
bothered me.

Thank you for your time,
Kevin

> Cheers,
> Mauro.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
