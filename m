Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761024AbZFPS7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 14:59:44 -0400
Date: Tue, 16 Jun 2009 15:59:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Nikitenko <jan.nikitenko@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] zl10353 and qt1010: fix stack corruption bug
Message-ID: <20090616155937.3f5d869d@pedra.chehab.org>
In-Reply-To: <4A2F50E0.8030404@gmail.com>
References: <4A28CEAD.9000000@gmail.com>
	<4A293B89.30502@iki.fi>
	<c4bc83220906091539x51ec2931i9260e36363784728@mail.gmail.com>
	<4A2EFA23.6020602@iki.fi>
	<4A2F50E0.8030404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Jun 2009 08:21:20 +0200
Jan Nikitenko <jan.nikitenko@gmail.com> escreveu:

> This patch fixes stack corruption bug present in dump_regs function of zl10353 
> and qt1010 drivers:
> the buffer buf is one byte smaller than required - there is 4 chars
> for address prefix, 16*3 chars for dump of 16 eeprom bytes per line
> and 1 byte for zero ending the string required, i.e. 53 bytes, but
> only 52 were provided.
> The one byte missing in stack based buffer buf can cause stack corruption 
> possibly leading to kernel oops, as discovered originally with af9015 driver.
> 
> Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
> 
> ---
> 
> Antti Palosaari wrote:
>  > On 06/10/2009 01:39 AM, Jan Nikitenko wrote:
>  >> Solved with "[PATCH] af9015: fix stack corruption bug".
>  >
>  > This error leads to the zl10353.c and there it was copied to qt1010.c
>  > and af9015.c.
>  >
> Antti, thanks for pointing out that the same problem was also in zl10353.c and 
> qt1010.c. Include your Sign-off-by, please.
> 
> Best regards,
> Jan
> 
>   linux/drivers/media/common/tuners/qt1010.c  |    2 +-
>   linux/drivers/media/dvb/frontends/zl10353.c |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff -r cff06234b725 linux/drivers/media/common/tuners/qt1010.c
> --- a/linux/drivers/media/common/tuners/qt1010.c	Sun May 31 23:07:01 2009 +0300
> +++ b/linux/drivers/media/common/tuners/qt1010.c	Wed Jun 10 07:37:51 2009 +0200
> @@ -65,7 +65,7 @@
>   /* dump all registers */
>   static void qt1010_dump_regs(struct qt1010_priv *priv)
>   {
> -	char buf[52], buf2[4];
> +	char buf[4+3*16+1], buf2[4];

CodingStyle is incorrect. It should be buf[4 + 3 * 16 + 1].


>   	u8 reg, val;
> 
>   	for (reg = 0; ; reg++) {
> diff -r cff06234b725 linux/drivers/media/dvb/frontends/zl10353.c
> --- a/linux/drivers/media/dvb/frontends/zl10353.c	Sun May 31 23:07:01 2009 +0300
> +++ b/linux/drivers/media/dvb/frontends/zl10353.c	Wed Jun 10 07:37:51 2009 +0200
> @@ -102,7 +102,7 @@
>   static void zl10353_dump_regs(struct dvb_frontend *fe)
>   {
>   	struct zl10353_state *state = fe->demodulator_priv;
> -	char buf[52], buf2[4];
> +	char buf[4+3*16+1], buf2[4];

Same CodingStyle issue here.

>   	int ret;
>   	u8 reg;
> 

Without having actually looking at the source code, would it be possible to
change the logic in order to use something else instead of a magic number for
buf size - e. g. using sizeof(something) ?

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
