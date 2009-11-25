Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:60795 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbZKYDjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 22:39:18 -0500
Date: Tue, 24 Nov 2009 19:32:42 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: IR raw input is not sutable for input system
In-Reply-To: <1259105571.28219.20.camel@maxim-laptop>
Message-ID: <Pine.LNX.4.58.0911241918390.30284@shell2.speakeasy.net>
References: <200910200956.33391.jarod@redhat.com>  <200910200958.50574.jarod@redhat.com>
 <4B0A765F.7010204@redhat.com>  <4B0A81BF.4090203@redhat.com>
 <m36391tjj3.fsf@intrepid.localdomain>  <20091123173726.GE17813@core.coreip.homeip.net>
  <4B0B6321.3050001@wilsonet.com> <1259105571.28219.20.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Nov 2009, Maxim Levitsky wrote:
>
> Its not the case.
> There are many protocols, I know that by experimenting with my universal
> remote. There are many receivers, and all have different accuracy.
> Most remotes aren't designed to be used with PC, thus user has to invent
> mapping between buttons and actions.
> Its is not possible to identify remotes accurately, many remotes send
> just a 8 bit integer that specifies the 'model' thus many remotes can
> share it.

The signal recevied by the ir receiver contains glitches.  Depending on the
receiver there can be quite a few.  It is also not trivial to turn the raw
signal sent by the remote into a digital value, even if you know what to
expect.  It takes digital signal processing techniques to turn the messy
sequence of inaccurate mark and space lengths into a best guess at what
digital code the remote sent.

It's like turning raw VBI data into decoded ASCII teletext from a simulated
keyboard device, all in the kernel.

> Kernel job is to take the information from device and present it to
> userspace using uniform format, that is kernel does 1:1 translating, but
> doesn't parse the data.

One thing that could be done, unless it has changed much since I wrote it
10+ years ago, is to take the mark/space protocol the ir device uses and sent
that data to lircd via the input layer.  It would be less efficient, but
would avoid another kernel interface.  Of course the input layer to lircd
interface would be somewhat different than other input devices, so
it's not entirely correct to say another interface is avoided.
