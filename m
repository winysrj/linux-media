Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62560 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1I1OUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 10:20:53 -0400
Received: by bkbzt4 with SMTP id zt4so8073217bkb.19
        for <linux-media@vger.kernel.org>; Wed, 28 Sep 2011 07:20:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109281350.52099.simon.farnsworth@onelan.com>
References: <201109281350.52099.simon.farnsworth@onelan.com>
Date: Wed, 28 Sep 2011 10:20:51 -0400
Message-ID: <CAGoCfiwUm268x3JF-YS5DLLmtPr-A4EADP+oFaZNErB=kHsC9A@mail.gmail.com>
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner)
 - workaround hack included
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Wed, Sep 28, 2011 at 8:50 AM, Simon Farnsworth
<simon.farnsworth@onelan.com> wrote:
> (note - the CC list is everyone over 50% certainty from get_maintainer.pl)
>
> I'm having problems getting a Hauppauge HVR-1110 card to successfully
> tune PAL-D at 85.250 MHz vision frequency; by experimentation, I've
> determined that the tda18271 is tuning to a frequency 1.25 MHz lower
> than the vision frequency I've requested, so the following workaround
> "fixes" it for me.
>
> diff --git a/drivers/media/common/tuners/tda18271-fe.c
> b/drivers/media/common/tuners/tda18271-fe.c
> index 63cc400..1a94e1a 100644
> --- a/drivers/media/common/tuners/tda18271-fe.c
> +++ b/drivers/media/common/tuners/tda18271-fe.c
> @@ -1031,6 +1031,7 @@ static int tda18271_set_analog_params(struct
> dvb_frontend *fe,
>                mode = "I";
>        } else if (params->std & V4L2_STD_DK) {
>                map = &std_map->atv_dk;
> +                freq += 1250000;
>                mode = "DK";
>        } else if (params->std & V4L2_STD_SECAM_L) {
>                map = &std_map->atv_l;
>
> I've checked with a signal analyser, and confirmed that my signal
> generator is getting the spectrum right - I am seeing vision peaking
> at 85.25 MHz, with one sideband going down to 84.5 MHz, and the other
> going up to 90.5MHz. I also see an audio carrier at 91.75 MHz.
>
> I'm going to run with this hack in place, but I'd appreciate it if
> someone who knew more about the TDA18271 looked at this, and either
> gave me a proper fix for testing, or confirmed that what I'm doing is
> right.

Hi Simon,

This is interesting.  I did some testing with an 18271 based device a
few months back (a Hauppauge cx231xx based tuner), and I believe
PAL-DK was working (although I did have unrelated issues with the DIF
configuration).

When you are doing the tuning request, are you explicitly stating
PAL-D in your calling application?  Or are you passing "PAL" to the
V4L layer and expecting it to work with a PAL-D feed?

I'm not doubting your findings, and clearly you've done a good bit of
research/analysis, but I did want to raise it as a data point to
consider....

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
