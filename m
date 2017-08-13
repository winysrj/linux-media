Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:37896 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdHMMbK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 08:31:10 -0400
Received: by mail-qt0-f193.google.com with SMTP id p3so7497384qtg.5
        for <linux-media@vger.kernel.org>; Sun, 13 Aug 2017 05:31:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170813100629.24034-1-rosca.eugeniu@gmail.com>
References: <20170813100629.24034-1-rosca.eugeniu@gmail.com>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Sun, 13 Aug 2017 08:31:09 -0400
Message-ID: <CAOcJUbyLpQ1A8xGfsU3pMxT63qYTJghbAC5kK3tr8t2DaZ9ykw@mail.gmail.com>
Subject: Re: [PATCH] [media] mxl111sf: Fix potential null pointer dereference
To: Eugeniu Rosca <roscaeugeniu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 13, 2017 at 6:06 AM, Eugeniu Rosca <roscaeugeniu@gmail.com> wrote:
> From: Eugeniu Rosca <erosca@de.adit-jv.com>
>
> Reviewing the delta between cppcheck output of v4.9.39 and v4.9.40
> stable updates, I stumbled on the new warning:
>
> mxl111sf.c:80: (warning) Possible null pointer dereference: rbuf
>
> Since copying state->rcvbuf into rbuf is not needed in the 'write-only'
> scenario (i.e. calling mxl111sf_ctrl_msg() from mxl111sf_i2c_send_data()
> or from mxl111sf_write_reg()), bypass memcpy() in this case.
>
> Fixes: d90b336f3f65 ("[media] mxl111sf: Fix driver to use heap allocate buffers for USB messages")
> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> ---
>  drivers/media/usb/dvb-usb-v2/mxl111sf.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)


Reviewed-by:  Michael Ira Krufky <mkrufky@linuxtv.org>


Thank you for this, Eugeniu




> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> index b0d5904a4ea6..67953360fda5 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> @@ -77,7 +77,9 @@ int mxl111sf_ctrl_msg(struct mxl111sf_state *state,
>                 dvb_usbv2_generic_rw(d, state->sndbuf, 1+wlen, state->rcvbuf,
>                                      rlen);
>
> -       memcpy(rbuf, state->rcvbuf, rlen);
> +       if (rbuf)
> +               memcpy(rbuf, state->rcvbuf, rlen);
> +
>         mutex_unlock(&state->msg_lock);
>
>         mxl_fail(ret);
> --
> 2.14.1
>
