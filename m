Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62006 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab0JKPyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:54:09 -0400
Received: by iwn9 with SMTP id 9so37477iwn.19
        for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 08:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinkYSHB5cLav2jw1snWa=1mYWL2+DmUb4ckgZHT@mail.gmail.com>
References: <AANLkTinkYSHB5cLav2jw1snWa=1mYWL2+DmUb4ckgZHT@mail.gmail.com>
Date: Mon, 11 Oct 2010 08:54:08 -0700
Message-ID: <AANLkTimmDGJaj6BZyS+Kp8xOZQDTPvQqHQ-pkd+WXC2z@mail.gmail.com>
Subject: Re: [PATCH] gp8psk: fix tuner delay
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>,
	Alan Nisota <alannisota@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

People are still waiting for this to be applied.  Any reason it hasn't been?

On Tue, Aug 17, 2010 at 10:34 AM, VDR User <user.vdr@gmail.com> wrote:
> This patches adjusts the tuner delay to be longer in response to
> several users experiencing tuner timeouts.  This change fixes that
> problem and allows those users to be able to tune.
>
> Signed-off-by: Derek Kelly <user.vdr@gmail.com>
> ----------
> --- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c
> 2010-08-17 09:53:27.000000000 -0700
> +++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c 2010-08-17
> 10:00:28.000000000 -0700
> @@ -109,7 +109,7 @@ static int gp8psk_fe_read_signal_strengt
>
>  static int gp8psk_fe_get_tune_settings(struct dvb_frontend* fe,
> struct dvb_frontend_tune_settings *tune)
>  {
> -       tune->min_delay_ms = 200;
> +       tune->min_delay_ms = 800;
>        return 0;
>  }
>
