Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63234 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2JBBnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 21:43:53 -0400
Received: by lbon3 with SMTP id n3so4680746lbo.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 18:43:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349139145-22113-1-git-send-email-crope@iki.fi>
References: <1349139145-22113-1-git-send-email-crope@iki.fi>
Date: Mon, 1 Oct 2012 21:43:51 -0400
Message-ID: <CAOcJUbwGnm=jDkvqcJeQWr4ShraGbSNO9fGgkRgwr+18=h6H8g@mail.gmail.com>
Subject: Re: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 1, 2012 at 8:52 PM, Antti Palosaari <crope@iki.fi> wrote:
> New drxk firmware download does not work with tda18271. Actual
> reason is more drxk driver than tda18271. Anyhow, tda18271c2dd
> will work as it does not do as much I/O during attach than tda18271.
>
> Root of cause is tuner I/O during drx-k asynchronous firmware
> download. request_firmware_nowait()... :-/
>
> Cc: Michael Krufky <mkrufky@linuxtv.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/em28xx/em28xx-dvb.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 770a5af..fd750d4 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1122,9 +1122,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
>
>                 if (dvb->fe[0]) {
>                         /* attach tuner */
> -                       if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
> -                                       &dev->i2c_adap,
> -                                       &em28xx_cxd2820r_tda18271_config)) {
> +                       if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0],
> +                                       &dev->i2c_adap, 0x60)) {
>                                 dvb_frontend_detach(dvb->fe[0]);
>                                 result = -EINVAL;
>                                 goto out_free;
> --
> 1.7.11.4
>


utterly ridiculous.  I understand why Antti is making this patch, so I
cannot blame him for it, but this whole idea of asynchronous firmware
load instead of allowing the bridge driver to orchestrate things is a
major problem -- THAT is what needs fixing.  let's fix the ACTUAL
problem.

(if we have to merge this for the short-term, i understand... i just
reiterate - we set a horrible president by merging a second tda18271
driver)

-Mike
