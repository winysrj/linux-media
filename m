Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62321 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2EURTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 13:19:35 -0400
Received: by vcbf11 with SMTP id f11so370474vcb.19
        for <linux-media@vger.kernel.org>; Mon, 21 May 2012 10:19:34 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 May 2012 13:19:34 -0400
Message-ID: <CAOcJUbymMft6NXeRDJQTGmg9DT8xPEtkBQWfVHA7LFs=eWN6mA@mail.gmail.com>
Subject: [PULL BUG-FIX] git://git.linuxtv.org/mkrufky/mxl111sf lg2160
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please merge:

The following changes since commit abed623ca59a7d1abed6c4e7459be03e25a90a1e:

  [media] radio-sf16fmi: add support for SF16-FMD (2012-05-20 16:10:05 -0300)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/mxl111sf lg2160

for you to fetch changes up to 80fed89735a02dd03d682261967a246ca9b0129f:

  lg2160: fix off-by-one error in lg216x_write_regs (2012-05-21 12:04:05 -0400)

----------------------------------------------------------------
Michael Krufky (1):
      lg2160: fix off-by-one error in lg216x_write_regs

 drivers/media/dvb/frontends/lg2160.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


On Mon, May 21, 2012 at 12:06 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> Fix an off-by-one error in lg216x_write_regs, causing the last element
> of the lg216x init block to be ignored.  Spotted by Dan Carpenter.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
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
