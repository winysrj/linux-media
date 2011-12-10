Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab1LJM3z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 07:29:55 -0500
Message-ID: <4EE350BF.1090402@redhat.com>
Date: Sat, 10 Dec 2011 10:29:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 06/10] DVB: Use a unique delivery system identifier
 for DVBC_ANNEX_C
References: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com>
In-Reply-To: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-12-2011 02:43, Manu Abraham wrote:


> From 92a79a1e0a1b5403f06f60661f00ede365b10108 Mon Sep 17 00:00:00 2001
> From: Manu Abraham <abraham.manu@gmail.com>
> Date: Thu, 24 Nov 2011 17:09:09 +0530
> Subject: [PATCH 06/10] DVB: Use a unique delivery system identifier for DVBC_ANNEX_C,
>  just like any other. DVBC_ANNEX_A and DVBC_ANNEX_C have slightly
>  different parameters and used in 2 geographically different
>  locations.
>
> Signed-off-by: Manu Abraham <abraham.manu@gmail.com>
> ---
>  include/linux/dvb/frontend.h |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index f80b863..a3c7623 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -335,7 +335,7 @@ typedef enum fe_rolloff {
>
>  typedef enum fe_delivery_system {
>  	SYS_UNDEFINED,
> -	SYS_DVBC_ANNEX_AC,
> +	SYS_DVBC_ANNEX_A,
>  	SYS_DVBC_ANNEX_B,
>  	SYS_DVBT,
>  	SYS_DSS,
> @@ -352,8 +352,13 @@ typedef enum fe_delivery_system {
>  	SYS_DAB,
>  	SYS_DVBT2,
>  	SYS_TURBO,
> +	SYS_DVBC_ANNEX_C,
>  } fe_delivery_system_t;
>
> +
> +#define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A
> +
> +
>  struct dtv_cmds_h {
>  	char	*name;		/* A display name for debugging purposes */

This patch conflicts with the approach given by this patch:

	http://www.mail-archive.com/linux-media@vger.kernel.org/msg39262.html

merged as commit 39ce61a846c8e1fa00cb57ad5af021542e6e8403.

The approach there were to allow calls to SYS_DVBC_ANNEX_AC to replace the Annex A
roll-off factor of 0.15 by the one used on Annex C (0.13).

As this patch didn't show-up at an stable version, we can still change it to use a
separate delivery system for DVB-C annex C, but this patch needs to be reverted, and
a few changes on existing drivers are needed (drxk, xc5000 and tda18271c2dd explicitly
supports both standards).

So, let's discuss it a little more, and then take a decision on what approach to take.
In any case, I suggest to remove this patch from the series, to not impact on merging
the remaining ones, and add it on another patch series that would contain the needed
changes on other places, if we decide to go on that direction.

-

What ITU-T J83 04/97 defines for Annex C is:

	The system employs the transport multiplexing based on MPEG-2 (see Reference [2]),
	guaranteeing interoperability with other media such as digital broadcasting,
	ISDN networks or packaged media. The framing structure and the channel
	coding are the same as in Annex A. The modulation is 64-QAM, and the QAM symbol
	rate and the roll-off factor are optimized for the 6 MHz channel plan.

So, as stated there, Annex C is a sub-set of Annex A, in terms of modulation, and uses a
smaller roll-off factor (0.13, instead of 0.15).

Also, all Annex A demods need to support QAM64, so it handles Annex C. Several of
them explicitly says that.

For the tuner, the only difference is how to estimate the needed bandwidth,
given a desired signal rate, in order to select the low-pass filter between 6MHz and
7MHz (in practice, affecting only Annex A, as, Annex C is not used on any Country
using more than 6MHz bandwidth).

In other words, SYS_DVBC_ANNEX_AC actually makes sense, as this covers the range of
devices that are able to work with both ways. I'm not aware of any pure Annex C demod.
If we ever found any, then I think we'll need a SYS_DVBC_ANNEX_C. Otherwise, it seems
to be an over-design to add it, while we are not aware of any driver needing it.

If we agree to replace SYS_DVBC_ANNEX_AC by SYS_DVBC_ANNEX_A/SYS_DVBC_ANNEX_C,
this means that it is needed to review every driver that supports SYS_DVBC_ANNEX_AC and
the FE_QAM logic, in order to be sure that the support for SYS_DVBC_ANNEX_C would be
there for all those drivers that support it, otherwise it would be a regression.

Regards,
Mauro





