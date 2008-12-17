Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1LCngG-0003LE-15
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 05:06:42 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1559761fga.25
	for <linux-dvb@linuxtv.org>; Tue, 16 Dec 2008 20:06:35 -0800 (PST)
Message-ID: <37219a840812162006h33118a2fr109638bb0802603@mail.gmail.com>
Date: Tue, 16 Dec 2008 23:06:35 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0812161931r17fc2371mfcb28306a3acc610@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0812161931r17fc2371mfcb28306a3acc610@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] RFC - xc5000 init_fw option is broken for HVR-950q
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Devin,

On Tue, Dec 16, 2008 at 10:31 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> It looks like because the reset callback is set *after* the
> dvb_attach(xc5000...), the if the init_fw option is set the firmware
> load will fail (saying "xc5000: no tuner reset callback function,
> fatal")
>
> We need to be setting the callback *before* the dvb_attach() to handle
> this case.
>
> Let me know if anybody sees anything wrong with this proposed patch,
> otherwise I will submit a pull request.
>
> Thanks,
>
> Devin
>
> diff -r 95d2c94ec371 linux/drivers/media/video/au0828/au0828-dvb.c
> --- a/linux/drivers/media/video/au0828/au0828-dvb.c     Tue Dec 16
> 21:35:23 2008 -0500
> +++ b/linux/drivers/media/video/au0828/au0828-dvb.c     Tue Dec 16
> 22:27:57 2008 -0500
> @@ -382,6 +382,9 @@
>
>        dprintk(1, "%s()\n", __func__);
>
> +       /* define general-purpose callback pointer */
> +       dvb->frontend->callback = au0828_tuner_callback;
> +
>        /* init frontend */
>        switch (dev->board) {
>        case AU0828_BOARD_HAUPPAUGE_HVR850:
> @@ -431,8 +434,6 @@
>                       __func__);
>                return -1;
>        }
> -       /* define general-purpose callback pointer */
> -       dvb->frontend->callback = au0828_tuner_callback;
>
>        /* register everything */
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller


This patch is fine & correct - Thanks - Please have it merged into master.

Acked-by: Michael Krufky <mkrufky@linuxtv.org>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
