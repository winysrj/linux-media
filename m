Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:46056 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab0CXK5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 06:57:54 -0400
Received: by fxm23 with SMTP id 23so2943286fxm.1
        for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 03:57:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269410755.2680.53.camel@localhost.localdomain>
References: <1269410755.2680.53.camel@localhost.localdomain>
Date: Wed, 24 Mar 2010 14:57:53 +0400
Message-ID: <1a297b361003240357k19226513q8b70730cfb12371@mail.gmail.com>
Subject: Re: saa716x driver status
From: Manu Abraham <abraham.manu@gmail.com>
To: Rodd Clarkson <rodd@clarkson.id.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Mar 24, 2010 at 10:05 AM, Rodd Clarkson <rodd@clarkson.id.au> wrote:
> Hi All,
>
> I've recently acquired a AverMedia Hybrid NanoExpress tv tuner and I'm
> trying to get it working with Fedora 13 and Fedora 12.
>
> I've found drivers at http://www.jusst.de/hg/saa716x/
>
> On f12 the driver build and install, but I have missing symbols when I
> try to modprobe the drivers.
>
> On f13 the drivers fail to build.
>
> I've tried contacting Manu Abraham (whom I believe is the developer)
> about the f12 issues, but haven't heard back.


I searched through my email, but was unable to find your email. Maybe
I happened to miss your email somehow.

> I've searched google for everything from saa716x, AverMedia Hybrid Nano
> Express, HC82 and 1461:0555 (the pci address, I guess).  There's bits
> and pieces about this driver in the results, but most are that they can
> build the driver, but it doesn't work.
>
> I'm happy to 'risk' my card and try stuff to get this to work, but I'm
> curious about whether or not development is ongoing and how I can help
> (not being a c coder)
>
> I'll attach the output of the build attempt on f13 in case someone can
> advise what is going wrong.  The build log was captured using:
>
> $ make &> /tmp/saa716x.build.log.f13
>

I switched to using a 2.6.31 kernel for the development, with regards
to the logs that you have attached, it looks that the recent IR
related changes are in conflict. It would be more productive on my
side to focus on the development of the driver, rather than to keep
switching, till I have something that is consumable for the end user.

With regards to Fedora 12, maybe that you have some module not
loaded/not built, so that you see those missing symbols.

Regards,
Manu
