Return-path: <mchehab@localhost>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61445 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758299Ab1GKRcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 13:32:46 -0400
Received: by eyx24 with SMTP id 24so1431299eyx.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jul 2011 10:32:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19995.12215.798514.99100@morden.metzler>
References: <201107031831.20378@orion.escape-edv.de>
	<CAGoCfiwaYhXFi1_QXX55nfSOivgnk1YyDNP5_sXL61k3hdabQA@mail.gmail.com>
	<19995.8804.939482.9336@morden.metzler>
	<CAGoCfizQhU10ECyHwcdY+T6=66-KcPxRL-j_w3ELHpK=6+wwdg@mail.gmail.com>
	<19995.12215.798514.99100@morden.metzler>
Date: Mon, 11 Jul 2011 13:32:44 -0400
Message-ID: <CAGoCfiwUtgpCM49WqpTorH-D-VVgkbtoGk++rp3FTsOJQD06rw@mail.gmail.com>
Subject: Re: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099
 and ngene
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Mon, Jul 11, 2011 at 1:15 PM, Ralph Metzler <rjkm@metzlerbros.de> wrote:
>  > Generally speaking with other devices the IF is configured for the
>  > tuner depending on the target modulation (there is a tda18271_config
>  > struct passed at attach time containing the IF for various modes).
>  > Then the demod driver is also configured for a particular IF.
>
> You mean the optional "struct tda18271_std_map *std_map;"?
> That would be a possibility. But then you have to handle IF tables for
> all kinds of tuners and demods in the bridge driver.
> Letting the tuner choose the IF and have a way to tell the demod (a simple
> get_if() call) is much easier.

The downside of the approach you've suggested is it prevents the tuner
driver from varying the IF based on the demod it is interacting with.
By having the information defined in the bridge driver, the IF can be
defined by the driver developer based on the attached demod.  Also, in
some cases the IF needs to different because of the PCB layout (rather
than just the chosen modulation or what demod it is attached to),
which there is no way a tuner driver could know that based solely on
what tuner/demod is being used.

In other words, in some cases the optimal IF for a given hardware
design is determined by cycling through the various possible values
with a spectrum analyzer attached, and that is the sort of
optimization that is defined in the bridge driver where it is known
exactly what product is being used.

>  > If there are indeed good reasons, then so be it.  But it feels like we
>  > are working around deficiencies in the core DVB framework that would
>  > apply to all drivers, and it would be good if we could avoid the
>  > maintenance headaches associated with two different drivers for the
>  > same chip.
>
> I know. At the time I was also just porting the DRX-K and only wanted
> to get it working based on the known to work Windows driver
> combination and not wrestle with other problems.
> I guess it whould not be too hard to adapt the old driver now.

I can certainly appreciate this, as I've done this myself at times.
That said though, for upstream inclusion we generally want to clean up
such issues.

> Another problem that keeps showing up in the existing drivers is that
> some tuner/demod combinations let the tuner call gate_ctrl, others
> only call it in the demod.
> This leads to problems when trying to use them in new combinations.
> Either the gate is not opened/closed at all or twice. In the latter
> case this can even lead to lockups if also using locking.

Yeah, this is a bit of a mess.  Whether it's done in the demod or the
tuner is typically dictated by what driver the developer happened to
have copied as skeleton code.  There are certainly merits to both
approaches under certain conditions, but the inconsistency across
drivers is very annoying.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
