Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37748 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0BOVui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 16:50:38 -0500
Received: by bwz5 with SMTP id 5so1447351bwz.1
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 13:50:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <310bfb251002151257x7121b20cme3cbe5096decea4b@mail.gmail.com>
References: <310bfb251002151257x7121b20cme3cbe5096decea4b@mail.gmail.com>
Date: Mon, 15 Feb 2010 16:50:35 -0500
Message-ID: <829197381002151350xa46c99dm93d3bb2b11d4fe4a@mail.gmail.com>
Subject: Re: ATI TV Wonder 650 PCI development
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Samuel Cantrell <samuelcantrell@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 15, 2010 at 3:57 PM, Samuel Cantrell
<samuelcantrell@gmail.com> wrote:
> Hello,
>
> I have an ATI TV Wonder 650 PCI card, and have started to work on the
> wiki page on LinuxTV.org regarding it. I want to *attempt* to write a
> driver for it (more like, take a look at the code and run), and have
> printed off some information on the wiki. I need to get pictures up of
> the card and lspci output, etc.
>
> Is there anyone else more experienced at writing drivers that could
> perhaps help?
>
> http: // www.linuxtv.org / pipermail / linux-dvb / 2007-October /
> 021228.html says that three pieces of documentation are missing. I've
> emailed Samsung regarding the tuner module on the card, as I could not
> find it on their website. I checked some of their affiliates as well,
> but still had no luck. I've emailed AMD/ATI regarding the card and
> technical documentation.
>
> Is it likely that that the tuner module has an XC3028 in it? In the
> same linux-dvb message thread noted above, someone speculated that
> there is a XC3028. As the v4l tree has XC3028 support, if this is
> true, wouldn't that help at least a little bit?

The big issue with this board is not the tuner itself, but the PCI
bridge.  Developing the drivers for a bridge can take months of work,
and unlike bridges from NXP or Conexant which are used in dozens of
products, this bridge is only ever used in this one board by this one
vendor.  And in the cases of NXP and Conexant bridges, usually the
person writing the driver for the bridge has real documentation.

It just isn't worth any developer's effort to spend three months
reverse engineering a bridge to an older and more obscure product with
no supporting documentation (and three months as an estimate is what
it would take an *experienced* LinuxTV developer who has worked on
other bridges).  There are just *much* better uses for developer
resources.

Also, not only is the bridge not supported, but neither is the
demodulator (it's an ATI312).  Again, no documentation and it's only
used in that one hardware design, so it's not like the work would
really help with other more popular products.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
