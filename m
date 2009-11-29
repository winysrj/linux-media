Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56081 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbZK2TuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 14:50:05 -0500
Date: 29 Nov 2009 20:49:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jonsmirl@gmail.com
Cc: alan@lxorguk.ukuu.org.uk
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: maximlevitsky@gmail.com
Cc: mchehab@redhat.com
Cc: ray-lk@madrabbit.org
Cc: stefanr@s5r6.in-berlin.de
Cc: superm1@ubuntu.com
Message-ID: <BDodzfumqgB@lirc>
In-Reply-To: <9e4733910911291116r66dda6dap591d1b0f322f9663@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

on 29 Nov 09 at 14:16, Jon Smirl wrote:
> On Sun, Nov 29, 2009 at 2:04 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> Jon is asking for an architecture discussion, y'know, with use cases.
[...]
> So we're just back to the status quo of last year which is to do
> nothing except some minor clean up.
>
> We'll be back here again next year repeating this until IR gets
> redesigned into something fairly invisible like keyboard and mouse
> drivers.

Last year everyone complained that LIRC does not support evdev - so I  
added support for evdev.

This year everyone complains that LIRC is not plug'n'play - we'll fix that  
'til next year.

There's progress. ;-)

Christoph
