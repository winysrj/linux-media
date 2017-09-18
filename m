Return-path: <linux-media-owner@vger.kernel.org>
Received: from unicorn.mansr.com ([81.2.72.234]:48422 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751450AbdIRPlI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 11:41:08 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v1] media: rc: Add driver for tango IR decoder
References: <e05783d3-012d-0798-9a54-ff42039e728d@sigmadesigns.com>
Date: Mon, 18 Sep 2017 16:33:47 +0100
In-Reply-To: <e05783d3-012d-0798-9a54-ff42039e728d@sigmadesigns.com> (Marc
        Gonzalez's message of "Mon, 18 Sep 2017 16:18:56 +0200")
Message-ID: <yw1xd16oyqas.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marc Gonzalez <marc_gonzalez@sigmadesigns.com> writes:

> The tango IR decoder supports NEC, RC-5, RC-6 protocols.
> NB: Only the NEC decoder was tested.
>
> Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
> ---
>  drivers/media/rc/Kconfig    |   5 +
>  drivers/media/rc/Makefile   |   1 +
>  drivers/media/rc/tango-ir.c | 263 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 269 insertions(+)
>  create mode 100644 drivers/media/rc/tango-ir.c
>
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index d9ce8ff55d0c..f84923289964 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -469,6 +469,11 @@ config IR_SIR
>  	   To compile this driver as a module, choose M here: the module will
>  	   be called sir-ir.
>  +config IR_TANGO
> +	tristate "Sigma Designs SMP86xx IR decoder"
> +	depends on RC_CORE
> +	depends on ARCH_TANGO || COMPILE_TEST
> +
>  config IR_ZX
>  	tristate "ZTE ZX IR remote control"
>  	depends on RC_CORE

This hunk looks damaged.

What have you changed compared to my original code?

I tested all three protocols with a few random remotes I had lying
around back when I wrote the driver, but that's quite a while ago.

You should also write a devicetree binding.

Finally, when sending patches essentially written by someone else,
please make sure to set a From: line for correct attribution.  It's not
nice to take other people's code and apparently pass it off as your own
even you've made a few small changes.

-- 
Måns Rullgård
