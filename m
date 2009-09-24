Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:14904 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZIXSsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 14:48:30 -0400
Received: by ey-out-2122.google.com with SMTP id d26so451661eyd.19
        for <linux-media@vger.kernel.org>; Thu, 24 Sep 2009 11:48:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090922210748.GC8661@systol-ng.god.lan>
References: <20090922210748.GC8661@systol-ng.god.lan>
Date: Thu, 24 Sep 2009 14:48:32 -0400
Message-ID: <37219a840909241148x5123bf72k1011183d777c239a@mail.gmail.com>
Subject: Re: [PATCH 3/4] tda8290 enable deemphasis_50 module parameter.
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 22, 2009 at 5:07 PM,  <spam@systol-ng.god.lan> wrote:
>
> This adds a forgotten module_param macro needed to set a deemphasis of 50us.
> It is the standard setting for commercial FM radio broadcasts outside the US.
>
> Signed-off-by: Henk.Vergonet@gmail.com
>
> diff -r 29e4ba1a09bc linux/drivers/media/common/tuners/tda8290.c
> --- a/linux/drivers/media/common/tuners/tda8290.c       Sat Sep 19 09:45:22 2009 -0300
> +++ b/linux/drivers/media/common/tuners/tda8290.c       Tue Sep 22 22:06:31 2009 +0200
> @@ -34,6 +34,7 @@
>  MODULE_PARM_DESC(debug, "enable verbose debug messages");
>
>  static int deemphasis_50;
> +module_param(deemphasis_50, int, 0644);
>  MODULE_PARM_DESC(deemphasis_50, "0 - 75us deemphasis; 1 - 50us deemphasis");
>
>  /* ---------------------------------------------------------------------- */
>

Reviewed-by: Michael Krufky <mkrufky@kernellabs.com>

Mauro, this patch is OK to merge ASAP -- if it's not merged already by
the time I have the tda18271 fixes ready, then I'll send this to you
in the same pull request.

Thanks for this fix, Henk.

Regards,

 Mike Krufky
