Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45176 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2EUP6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 11:58:07 -0400
Received: by vbbff1 with SMTP id ff1so3572729vbb.19
        for <linux-media@vger.kernel.org>; Mon, 21 May 2012 08:58:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337614442-31599-1-git-send-email-mkrufky@linuxtv.org>
References: <1337614442-31599-1-git-send-email-mkrufky@linuxtv.org>
Date: Mon, 21 May 2012 11:58:06 -0400
Message-ID: <CAOcJUbwCYfR875md-mnqO_tdU0pmJc97CQqAP3chHV-qz0VfSg@mail.gmail.com>
Subject: Re: [PATCH] lg2160: fix off-by-one error in lg216x_write_regs
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

eeek!  spelling error in dan's name!  my apologies.  I will correct
this in my tree before I ask Mauro to merge it.

-Mike

On Mon, May 21, 2012 at 11:34 AM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> Fix an off-by-one error in lg216x_write_regs, causing the last element
> of the lg216x init block to be ignored.  Spotted by Dan Carpenteter.
>
> Thanks-to: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
> ---
>  drivers/media/dvb/frontends/lg2160.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb/frontends/lg2160.c b/drivers/media/dvb/frontends/lg2160.c
> index a3ab1a5..cc11260 100644
> --- a/drivers/media/dvb/frontends/lg2160.c
> +++ b/drivers/media/dvb/frontends/lg2160.c
> @@ -126,7 +126,7 @@ static int lg216x_write_regs(struct lg216x_state *state,
>
>        lg_reg("writing %d registers...\n", len);
>
> -       for (i = 0; i < len - 1; i++) {
> +       for (i = 0; i < len; i++) {
>                ret = lg216x_write_reg(state, regs[i].reg, regs[i].val);
>                if (lg_fail(ret))
>                        return ret;
> --
> 1.7.9.5
>
