Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:58772 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZIXSlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 14:41:22 -0400
Received: by ewy7 with SMTP id 7so1925246ewy.17
        for <linux-media@vger.kernel.org>; Thu, 24 Sep 2009 11:41:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090922210635.GB8661@systol-ng.god.lan>
References: <20090922210635.GB8661@systol-ng.god.lan>
Date: Thu, 24 Sep 2009 14:41:25 -0400
Message-ID: <37219a840909241141s548e4ab4oeb4fa68479062a8@mail.gmail.com>
Subject: Re: [PATCH 2/4] 18271_calc_main_pll small bugfix
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 22, 2009 at 5:06 PM,  <spam@systol-ng.god.lan> wrote:
>
> Removed code fragment that is not part of the (C2) specs. Possibly an early
> remnant of an attempted if_notch filter configuration. It is already
> handled correctly in the tda18271_set_if_notch function.
>
> Signed-off-by: Henk.Vergonet@gmail.com
>
> diff -r 29e4ba1a09bc linux/drivers/media/common/tuners/tda18271-common.c
> --- a/linux/drivers/media/common/tuners/tda18271-common.c       Sat Sep 19 09:45:22 2009 -0300
> +++ b/linux/drivers/media/common/tuners/tda18271-common.c       Tue Sep 22 22:06:31 2009 +0200
> @@ -582,15 +582,6 @@
>
>        regs[R_MPD]   = (0x77 & pd);
>
> -       switch (priv->mode) {
> -       case TDA18271_ANALOG:
> -               regs[R_MPD]  &= ~0x08;
> -               break;
> -       case TDA18271_DIGITAL:
> -               regs[R_MPD]  |=  0x08;
> -               break;
> -       }
> -
>        div =  ((d * (freq / 1000)) << 7) / 125;
>
>        regs[R_MD1]   = 0x7f & (div >> 16);
>


NACK.  This bit needs to remain -- do not merge this.

Regards,

Mike Krufky
