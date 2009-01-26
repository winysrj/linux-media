Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:52248 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZAZQof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 11:44:35 -0500
Received: by ti-out-0910.google.com with SMTP id b6so3346794tic.23
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2009 08:44:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ea11fea30901150845o415c7b0dt21c325d0220e12@mail.gmail.com>
References: <ea11fea30901150845o415c7b0dt21c325d0220e12@mail.gmail.com>
Date: Mon, 26 Jan 2009 22:14:32 +0530
Message-ID: <ea11fea30901260844g67f2b8c7g2eaf23cdcab61e29@mail.gmail.com>
Subject: Re: [PATCH] : Fix compilation errors in drivers/media/video/cx88/cx88-i2c.c
From: Manish Katiyar <mkatiyar@gmail.com>
To: rjkm@thp.uni-koeln.de, mocm@thp.uni-koeln.de, yurij@naturesoft.net,
	kraxel@bytesex.org, linux-media@vger.kernel.org
Cc: mkatiyar@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[resending to  linux-media]

Thanks -
Manish

On Thu, Jan 15, 2009 at 10:15 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> Below patch fixes the following build errors.
>
>  CC [M]  drivers/media/video/cx88/cx88-i2c.o
> drivers/media/video/cx88/cx88-i2c.c: In function 'cx88_call_i2c_clients':
> drivers/media/video/cx88/cx88-i2c.c:122: error: 'struct cx88_core' has
> no member named 'gate_ctrl'
> drivers/media/video/cx88/cx88-i2c.c:123: error: 'struct cx88_core' has
> no member named 'gate_ctrl'
> drivers/media/video/cx88/cx88-i2c.c:127: error: 'struct cx88_core' has
> no member named 'gate_ctrl'
> drivers/media/video/cx88/cx88-i2c.c:128: error: 'struct cx88_core' has
> no member named 'gate_ctrl'
> make[4]: *** [drivers/media/video/cx88/cx88-i2c.o] Error 1
> make[3]: *** [drivers/media/video/cx88] Error 2
>
>
>
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  drivers/media/video/cx88/cx88-i2c.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/cx88/cx88-i2c.c
> b/drivers/media/video/cx88/cx88-i2c.c
> index c0ff230..6d04b6a 100644
> --- a/drivers/media/video/cx88/cx88-i2c.c
> +++ b/drivers/media/video/cx88/cx88-i2c.c
> @@ -119,13 +119,17 @@ void cx88_call_i2c_clients(struct cx88_core
> *core, unsigned int cmd, void *arg)
>        if (0 != core->i2c_rc)
>                return;
>
> +#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
>        if (core->gate_ctrl)
>                core->gate_ctrl(core, 1);
> +#endif
>
> -       i2c_clients_command(&core->i2c_adap, cmd, arg);
>
> +       i2c_clients_command(&core->i2c_adap, cmd, arg);
> +#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
>        if (core->gate_ctrl)
>                core->gate_ctrl(core, 0);
> +#endif
>  }
>
>  static const struct i2c_algo_bit_data cx8800_i2c_algo_template = {
> --
> 1.5.4.3
>
>
> Thanks -
> Manish
>
