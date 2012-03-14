Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33434 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2CNTyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 15:54:04 -0400
Received: by gghe5 with SMTP id e5so2223793ggh.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 12:54:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjTZvYVtuSm0v-_Q7od=iUDvHbkMe4c5ycAQZwoErCCe=N+Bg@mail.gmail.com>
References: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com>
	<CALF0-+Wp03vsbiaJFUt=ymnEncEvDg_KmnV+2OWjtO-_0qqBVg@mail.gmail.com>
	<CALjTZvYVtuSm0v-_Q7od=iUDvHbkMe4c5ycAQZwoErCCe=N+Bg@mail.gmail.com>
Date: Wed, 14 Mar 2012 16:47:16 -0300
Message-ID: <CALF0-+W3HenNpUt_yGxqs+fohcZ22ozDw9MhTWua0B++ZFA2vA@mail.gmail.com>
Subject: Re: eMPIA EM2710 Webcam (em28xx) and LIRC
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Rui Salvaterra <rsalvaterra@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2012/3/14 Rui Salvaterra <rsalvaterra@gmail.com>:
>
> Hi, Ezequiel. Thanks a lot for your reply.
> I'm attaching a copy of my full dmesg, its a bit hard to spot exactly
> where all modules are loaded (since the boot sequence became
> asynchronous).

Indeed.

>
>
> Sure, no problem at all. I booted with em28xx disable_ir=1 and got the
> same result. Additionally:
>
> rui@wilykat:~$ lsmod | grep ir
> ir_lirc_codec          12901  0
> lirc_dev               19204  1 ir_lirc_codec
> ir_mce_kbd_decoder     12724  0
> ir_sanyo_decoder       12513  0
> ir_sony_decoder        12510  0
> ir_jvc_decoder         12507  0
> ir_rc6_decoder         12507  0
> ir_rc5_decoder         12507  0
> ir_nec_decoder         12507  0
> rc_core                26373  9
> ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,em28xx,ir_rc5_decoder,ir_nec_decoder
> rui@wilykat:~$

Mmmm...
Are you completely sure that em28xx driver is triggering the load of
the ir related modules?
Perhaps you could disable the module (blacklist, or compile out the
module, or erase em28xx.ko to make sure)
so you can see that effectively em28xx doesn't load and the rest of
the modules doesn't load either,
do you follow my line of reasoning?

I'm also no kernel expert, just trying to be helpful.

Hope it helps,
Ezequiel.
