Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:51815 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759658AbZKZI1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 03:27:24 -0500
Message-ID: <50104.115.70.135.213.1259224041.squirrel@webmail.exetel.com.au>
In-Reply-To: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
Date: Thu, 26 Nov 2009 19:27:21 +1100 (EST)
Subject: Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1) tuning regression
From: "Robert Lowery" <rglowery@exemail.com.au>
To: mchehab@redhat.com, terrywu2009@gmail.com, awalls@radix.net
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi,
>
> After fixing up a hang on the DViCO FusionHDTV DVB-T Dual Digital 4 (rev
> 1) recently via http://linuxtv.org/hg/v4l-dvb/rev/1c11cb54f24d everything
> appeared to be ok, but I have now noticed certain channels in Australia
> are showing corruption which manifest themselves as blockiness and
> screeching audio.
>
> I have traced this issue down to
> http://linuxtv.org/hg/v4l-dvb/rev/e6a8672631a0 (Fix offset frequencies for
> DVB @ 6MHz)
Actually, in addition to the above changeset, I also had to revert
http://linuxtv.org/hg/v4l-dvb/rev/966ce12c444d (Fix 7 MHz DVB-T)  to get
things going.  Seems this one might have been an attempt to fix an issue
introduced by the latter, but for me both must be reverted.

-Rob

>
> In this change, the offset used by my card has been changed from 2750000
> to 2250000.
>
> The old code which works used to do something like
> offset = 2750000
> if (((priv->cur_fw.type & DTV7) &&
>     (priv->cur_fw.scode_table & (ZARLINK456 | DIBCOM52))) ||
>     ((priv->cur_fw.type & DTV78) && freq < 470000000))
>     offset -= 500000;
>
> In Australia, (type & DTV7) == true _BUT_ scode_table == 1<<29 == SCODE,
> so the subtraction is not done.
>
> The new code which does not work does
> if (priv->cur_fw.type & DTV7)
>     offset = 2250000;
> which appears to be off by 500khz causing the tuning regression for me.
>
> Could any one please advice why this check against scode_table &
> (ZARLINK456 | DIBCOM52) was removed?
>
> Thanks
>
> -Rob
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


