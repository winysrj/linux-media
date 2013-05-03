Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:38123 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3ECCXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 22:23:46 -0400
Date: Thu, 2 May 2013 23:24:07 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	jonjon.arnearne@gmail.com
Subject: Re: [PATCH V2 3/3] saa7115: Add register setup and config for gm7113c
Message-ID: <20130503022406.GD5722@localhost>
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
 <1367268069-11429-4-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367268069-11429-4-git-send-email-jonarne@jonarne.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 29, 2013 at 10:41:09PM +0200, Jon Arne Jørgensen wrote:
> 
> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>

Every patch *must* have a proper commit message indicating what you're doing
and why you're doing it.

In particular, please add as much information as you can about this new clone decoder.

If you know *why* we have to add those quirks for PAL and NTSC, it would
be nice to add that information to the commit message and maybe even
in a comment somewhere in the code.

> ---
>  drivers/media/i2c/saa7115.c | 48 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 39 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> index eb2c19d..77c13dc 100644
> --- a/drivers/media/i2c/saa7115.c
> +++ b/drivers/media/i2c/saa7115.c
> @@ -126,6 +126,8 @@ static int saa711x_has_reg(const int id, const u8 reg)
>  		return 0;
>  
>  	switch (id) {
> +	case V4L2_IDENT_GM7113C:
> +		return reg != 0x14 && (reg < 0x18 || reg > 0x1e) && reg < 0x20;
>  	case V4L2_IDENT_SAA7113:
>  		return reg != 0x14 && (reg < 0x18 || reg > 0x1e) && (reg < 0x20 || reg > 0x3f) &&
>  		       reg != 0x5d && reg < 0x63;
> @@ -447,6 +449,30 @@ static const unsigned char saa7115_cfg_50hz_video[] = {
>  
>  /* ============== SAA7715 VIDEO templates (end) =======  */
>  
> +/* ============== GM7113C VIDEO templates =============  */
> +static const unsigned char gm7113c_cfg_60hz_video[] = {
> +	R_08_SYNC_CNTL, 0x68,			/* 0xBO: auto detection, 0x68 = NTSC */
> +	R_0E_CHROMA_CNTL_1, 0x07,		/* video autodetection is on */
> +
> +#if 0
> +	R_5A_V_OFF_FOR_SLICER, 0x06,		/* standard 60hz value for ITU656 line counting */
> +#endif

What's the meaning of this ifdef? In general it's better to remove dead
code, or at least to put some fat comment about it.

> +	0x00, 0x00
> +};
> +
> +static const unsigned char gm7113c_cfg_50hz_video[] = {
> +	R_08_SYNC_CNTL, 0x28,			/* 0x28 = PAL */
> +	R_0E_CHROMA_CNTL_1, 0x07,
> +
> +#if 0
> +	R_5A_V_OFF_FOR_SLICER, 0x03,		/* standard 50hz value */
> +#endif

Ditto.

I've tested this with an stk1160/gm7113c device and now
it's working fine (NTSC, PAL-M, PAL-Nc).

I also tested against regressions using stk1160/saa7113 and
em28xx/saa7115 devices.

I must admit I'm quite happy to have this issue finally fixed!

Could you please re-send the whole series, taking account of this
comments. You can add my:

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

to every patch in the series.

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
