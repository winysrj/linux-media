Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53929 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab1FMWMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 18:12:51 -0400
Received: by eyx24 with SMTP id 24so1762486eyx.19
        for <linux-media@vger.kernel.org>; Mon, 13 Jun 2011 15:12:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinH57qGYmw2_DNM5NXX_PoMwK8v7w@mail.gmail.com>
References: <BANLkTinH57qGYmw2_DNM5NXX_PoMwK8v7w@mail.gmail.com>
Date: Mon, 13 Jun 2011 18:12:49 -0400
Message-ID: <BANLkTi=mURYJ78ETA1KKZjve=PNEP49ZOg@mail.gmail.com>
Subject: Re: Status on DRX-K based tuner cards
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Markus Partheymueller <mail@klee-parthy.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 13, 2011 at 6:05 PM, Markus Partheymueller
<mail@klee-parthy.de> wrote:
> Hello there,
>
> I just wanted to ask whether there is a change in the situation of
> tuners used in e.g. Terratec H5 / WinTV HVR-930c / MSI Digivox Trio
> etc. As far as I can understand all the information available in
> various mailing lists and boards, the real problem was (or is) the
> DRX-K chip. Now there's a driver for Terratec H7 which includes some
> drxk-* source code. Is this a different chip or is this the desired
> source code for providing linux support for those devices?
>
> I would really appreciate linux support for this kind of tuners - of
> course I've got one myself, but in general I hate the idea that there
> are products not available to the linux domain. Especially when it
> comes to TV - there are all kinds of custom VDR solutions featuring
> Linux, as well as many lightweight laptops like the eeePC, which can't
> access the huge variety of dvb tuner cards.

In the case of the drx-k, the problem is no longer with the chipset
vendor - they have provided source code under a license that will
permit merging into an upstream kernel.

The problem at this point is simply a lack of developers who are both
qualified and willing to do the work.  A secondary problem is that
even if somebody gets a board working, a huge refactoring of the code
is required in order for it to be accepted upstream.  This for example
is why the drx-j (the ATSC/QAM equivalent to the drxk-) isn't in the
mainline kernel despite there having been an out-of-tree GPL driver
available for almost a year.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
