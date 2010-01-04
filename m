Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:34322 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0ADE1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jan 2010 23:27:53 -0500
Message-ID: <2088.115.70.135.213.1262579258.squirrel@webmail.exetel.com.au>
In-Reply-To: <1328.64.213.30.2.1260920972.squirrel@webmail.exetel.com.au>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
    <50104.115.70.135.213.1259224041.squirrel@webmail.exetel.com.au>
    <702870ef0911260137r35f1784exc27498d0db3769c2@mail.gmail.com>
    <56069.115.70.135.213.1259234530.squirrel@webmail.exetel.com.au>
    <46566.64.213.30.2.1259278557.squirrel@webmail.exetel.com.au>
    <702870ef0912010118r1e5e3been840726e6364d991a@mail.gmail.com>
    <829197380912020657v52e42690k46172f047ebd24b0@mail.gmail.com>
    <36364.64.213.30.2.1260252173.squirrel@webmail.exetel.com.au>
    <1328.64.213.30.2.1260920972.squirrel@webmail.exetel.com.au>
Date: Mon, 4 Jan 2010 15:27:38 +1100 (EST)
Subject: Re: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)     
      tuning      regression
From: "Robert Lowery" <rglowery@exemail.com.au>
To: mchehab@redhat.com
Cc: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Vincent McIntyre" <vincent.mcintyre@gmail.com>,
	terrywu2009@gmail.com, awalls@radix.net,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Mauro,
>
> I've split the revert2.diff that I sent you previously to fix the tuning
> regression on my DViCO Dual Digital 4 (rev 1) into three separate patches
> that will hopefully allow you to review more easily.
>
> The first two patches revert their respective changesets and nothing else,
> fixing the issue for me.
> 12167:966ce12c444d tuner-xc2028: Fix 7 MHz DVB-T
> 11918:e6a8672631a0 tuner-xc2028: Fix offset frequencies for DVB @ 6MHz
>
> The third patch does what I believe is the obvious equivalent fix to
> e6a8672631a0 but without the cleanup that breaks tuning on my card.
>
> Please review and merge
>
> Signed-off-by: Robert Lowery <rglowery@exemail.com.au>

Mauro,

I'm yet to receive a response from you on this clear regression introduced
in the 2.6.31 kernel.  You attention would be appreciated

Thanks

-Rob
>
> Thanks
>
> -Rob
>


