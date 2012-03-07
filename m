Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61643 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2CGQpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 11:45:55 -0500
Received: by gghe5 with SMTP id e5so2251297ggh.19
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 08:45:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F578E65.4070409@redhat.com>
References: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com>
	<4F572611.50607@redhat.com>
	<CALF0-+V5kTMXZ+Nfy4yqOSgyMwBYmjGH4EfFbqjju+d3GdsvSA@mail.gmail.com>
	<20120307154311.GB14836@kroah.com>
	<4F578E65.4070409@redhat.com>
Date: Wed, 7 Mar 2012 13:45:54 -0300
Message-ID: <CALF0-+W5HwFFnp96sK=agjc07V_GuizrD6k+Eu9b7sQXOW=Ngw@mail.gmail.com>
Subject: Re: A second easycap driver implementation
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: gregkh <gregkh@linuxfoundation.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 7, 2012 at 1:35 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> Yes, the driver is weird, as it encapsulates the demod code
> inside it , instead of using the saa7115 driver, that covers most
> of saa711x devices, including saa7113.
>
> Btw, is this driver really needed? The em28xx driver has support
> for the Easy Cap Capture DC-60 model (I had access to one of those
> in the past, and I know that the driver works properly).
>
> What's the chipset using on your Easycap device?

Chipset is STK116. I'm not entirely sure but is seems that
there are to models: DC60 and DC60+.

Apparently, the former would be using STK1160.

>
> If it is not an Empiatech em28xx USB bridge, then it makes sense
> to have a separate driver for it. Otherwise, it is just easier
> and better to add support for your device there.

Ok, I'll take a look at the em28xx driver and also at the saa711x
to see how would it be possible to add support for this device.
Perhaps, we'll end up with a separate driver but based on
some common code.

Thanks,
Ezequiel.
