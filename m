Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:52888 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbcJJGbr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 02:31:47 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 0401320B17
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 08:31:16 +0200 (CEST)
Date: Mon, 10 Oct 2016 08:31:12 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Olivier Grenie <olivier.grenie@dibcom.fr>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RFC - unclear change in "[media] DiBxxxx: Codingstype updates"
Message-ID: <20161010083112.78aa2585@posteo.de>
In-Reply-To: <20161008135714.GA1239@osadl.at>
References: <20161008135714.GA1239@osadl.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, der Herr Hofrat ;-)

On Sat, 8 Oct 2016 13:57:14 +0000
Nicholas Mc Guire <der.herr@hofr.at> wrote:
> -                 lo6 |= (1 << 2) | 2;
> -         else
> -                 lo6 |= (1 << 2) | 1;
> +                 lo6 |= (1 << 2) | 2;    //SigmaDelta and Dither
> +         else {
> +                 if (state->identity.in_soc)
> +                         lo6 |= (1 << 2) | 2;    //SigmaDelta and
> Dither
> +                 else
> +                         lo6 |= (1 << 2) | 2;    //SigmaDelta and
> Dither
> +         }
> 
>  resulting in the current code-base of:
> 
>        if (Rest > 0) {
>                if (state->config->analog_output)
>                        lo6 |= (1 << 2) | 2;
>                else {
>                        if (state->identity.in_soc)
>                                lo6 |= (1 << 2) | 2;
>                        else
>                                lo6 |= (1 << 2) | 2;
>                }
>                Den = 255;
>        }
> 
>  The problem now is that the if and the else(if/else) are
>  all the same and thus the conditions have no effect. Further
>  the origninal code actually had different if/else - so I 
>  wonder if this is a cut&past bug here ?

I may answer on behalf of Olivier (didn't his address bounce?).

I don't remember the details, this patch must date from 2011 or
before, but at that time we generated the linux-driver from our/their
internal sources.

Updates in this area were achieved by a lot of thinking + a mix of trial
and error (after hours/days/weeks of RF hardware validation). 

This logic above has 3 possibilities: 

  - we use the analog-output, or 
  - we are using the digital one, then there is whether we are being in
    a SoC or not (SIP or sinlge chip).

At some point in time all values have been different. In the end, they
aren't anymore, but in case someone wants to try a different value,
there are placeholders in the code to easily inject these values.

Now the device is stable, maybe even obsolete. We could remove all the
branches resulting in the same value for lo6.

--
Patrick.
