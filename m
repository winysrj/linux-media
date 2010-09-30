Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37651 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0I3S5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 14:57:24 -0400
Received: by bwz11 with SMTP id 11so1653009bwz.19
        for <linux-media@vger.kernel.org>; Thu, 30 Sep 2010 11:57:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100928154655.183af4b3@pedra>
References: <cover.1285699057.git.mchehab@redhat.com>
	<20100928154655.183af4b3@pedra>
Date: Thu, 30 Sep 2010 14:57:22 -0400
Message-ID: <AANLkTindJwXKPpHgT=fN8NdNGstQHqGh+=FHu6xwYG3b@mail.gmail.com>
Subject: Re: [PATCH 03/10] V4L/DVB: tda18271: Add some hint about what
 tda18217 reg ID returned
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Sep 28, 2010 at 2:46 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Instead of doing:
>
> [   82.581639] tda18271 4-0060: creating new instance
> [   82.588411] Unknown device detected @ 4-0060, device not supported.
> [   82.594695] tda18271_attach: [4-0060|M] error -22 on line 1272
> [   82.600530] tda18271 4-0060: destroying instance
>
> Print:
> [  468.740392] Unknown device (0) detected @ 4-0060, device not supported.
>
> for the error message, to help detecting what's going wrong with the
> device.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
> index 7955e49..77e3642 100644
> --- a/drivers/media/common/tuners/tda18271-fe.c
> +++ b/drivers/media/common/tuners/tda18271-fe.c
> @@ -1177,7 +1177,7 @@ static int tda18271_get_id(struct dvb_frontend *fe)
>                break;
>        }
>
> -       tda_info("%s detected @ %d-%04x%s\n", name,
> +       tda_info("%s (%i) detected @ %d-%04x%s\n", name, regs[R_ID] & 0x7f,
>                 i2c_adapter_id(priv->i2c_props.adap),
>                 priv->i2c_props.addr,
>                 (0 == ret) ? "" : ", device not supported.");

A patch like this is fine for testing, but I see no reason for merging
this into the kernel.  Can you provide an explaination as per why this
would be useful?  In general, if you see, "Unknown device detected @
X-00YY, device not supported." then it means that this is not a
tda182x1.

Regards,

Mike Krufky
