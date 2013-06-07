Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1048 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3FGINf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 04:13:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: Re: [PATCH] Reimplement SAA712x setup routine
Date: Fri, 7 Jun 2013 10:13:18 +0200
Cc: linux-media@vger.kernel.org
References: <1370491937-2431-1-git-send-email-ismael.luceno@corp.bluecherry.net>
In-Reply-To: <1370491937-2431-1-git-send-email-ismael.luceno@corp.bluecherry.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306071013.18931.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ismael,

On Thu June 6 2013 06:12:17 Ismael Luceno wrote:

Can you give some more details? Is this just a cleanup/refactor change, or
does this actually fix bugs or add enhancements as well? It's next to
impossible to tell from just the patch.

If this does both cleanup and fixes/improvements, then it is a good idea
in the future not to mix the two in one patch.

Regards,

	Hans

> Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> ---
>  drivers/staging/media/solo6x10/solo6x10-tw28.c | 112 +++++++++++++++----------
>  1 file changed, 66 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/staging/media/solo6x10/solo6x10-tw28.c b/drivers/staging/media/solo6x10/solo6x10-tw28.c
> index ad00e2b..af65ea6 100644
> --- a/drivers/staging/media/solo6x10/solo6x10-tw28.c
> +++ b/drivers/staging/media/solo6x10/solo6x10-tw28.c
> @@ -513,62 +513,82 @@ static int tw2815_setup(struct solo_dev *solo_dev, u8 dev_addr)
>  #define FIRST_ACTIVE_LINE	0x0008
>  #define LAST_ACTIVE_LINE	0x0102
>  
> -static void saa7128_setup(struct solo_dev *solo_dev)
> +static void saa712x_write_regs(struct solo_dev *dev, const uint8_t *vals,
> +		int start, int n)
>  {
> -	int i;
> -	unsigned char regs[128] = {
> -		0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00,
> -		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> -		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	for (;start < n; start++, vals++) {
> +		/* Skip read-only registers */
> +		switch (start) {
> +		/* case 0x00 ... 0x25: */
> +		case 0x2e ... 0x37:
> +		case 0x60:
> +		case 0x7d:
> +			continue;
> +		}
> +		solo_i2c_writebyte(dev, SOLO_I2C_SAA, 0x46, start, *vals);
> +	}
> +}
> +
> +#define SAA712x_reg7c (0x80 | ((LAST_ACTIVE_LINE & 0x100) >> 2) \
> +		| ((FIRST_ACTIVE_LINE & 0x100) >> 4))
> +
> +static void saa712x_setup(struct solo_dev *dev)
> +{
> +	const int reg_start = 0x26;
> +	const uint8_t saa7128_regs_ntsc[] = {
> +	/* :0x26 */
> +		0x0d, 0x00,
> +	/* :0x28 */
> +		0x59, 0x1d, 0x75, 0x3f, 0x06, 0x3f,
> +	/* :0x2e XXX: read-only */
> +		0x00, 0x00,
>  		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> -		0x1C, 0x2B, 0x00, 0x00, 0x00, 0x00, 0x0d, 0x00,
> -		0x59, 0x1d, 0x75, 0x3f, 0x06, 0x3f, 0x00, 0x00,
> -		0x1c, 0x33, 0x00, 0x3f, 0x00, 0x00, 0x3f, 0x00,
> +	/* :0x38 */
>  		0x1a, 0x1a, 0x13, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	/* :0x40 */
>  		0x00, 0x00, 0x00, 0x68, 0x10, 0x97, 0x4c, 0x18,
>  		0x9b, 0x93, 0x9f, 0xff, 0x7c, 0x34, 0x3f, 0x3f,
> +	/* :0x50 */
>  		0x3f, 0x83, 0x83, 0x80, 0x0d, 0x0f, 0xc3, 0x06,
>  		0x02, 0x80, 0x71, 0x77, 0xa7, 0x67, 0x66, 0x2e,
> +	/* :0x60 */
>  		0x7b, 0x11, 0x4f, 0x1f, 0x7c, 0xf0, 0x21, 0x77,
> -		0x41, 0x88, 0x41, 0x12, 0xed, 0x10, 0x10, 0x00,
> +		0x41, 0x88, 0x41, 0x52, 0xed, 0x10, 0x10, 0x00,
> +	/* :0x70 */
> +		0x41, 0xc3, 0x00, 0x3e, 0xb8, 0x02, 0x00, 0x00,
> +		0x00, 0x00, FIRST_ACTIVE_LINE, LAST_ACTIVE_LINE & 0xff,
> +		SAA712x_reg7c, 0x00, 0xff, 0xff,
> +	}, saa7128_regs_pal[] = {
> +	/* :0x26 */
> +		0x0d, 0x00,
> +	/* :0x28 */
> +		0xe1, 0x1d, 0x75, 0x3f, 0x06, 0x3f,
> +	/* :0x2e XXX: read-only */
> +		0x00, 0x00,
> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	/* :0x38 */
> +		0x1a, 0x1a, 0x13, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	/* :0x40 */
> +		0x00, 0x00, 0x00, 0x68, 0x10, 0x97, 0x4c, 0x18,
> +		0x9b, 0x93, 0x9f, 0xff, 0x7c, 0x34, 0x3f, 0x3f,
> +	/* :0x50 */
> +		0x3f, 0x83, 0x83, 0x80, 0x0d, 0x0f, 0xc3, 0x06,
> +		0x02, 0x80, 0x0f, 0x77, 0xa7, 0x67, 0x66, 0x2e,
> +	/* :0x60 */
> +		0x7b, 0x02, 0x35, 0xcb, 0x8a, 0x09, 0x2a, 0x77,
> +		0x41, 0x88, 0x41, 0x52, 0xf1, 0x10, 0x20, 0x00,
> +	/* :0x70 */
>  		0x41, 0xc3, 0x00, 0x3e, 0xb8, 0x02, 0x00, 0x00,
> -		0x00, 0x00, 0x08, 0xff, 0x80, 0x00, 0xff, 0xff,
> +		0x00, 0x00, 0x12, 0x30,
> +		SAA712x_reg7c | 0x40, 0x00, 0xff, 0xff,
>  	};
>  
> -	regs[0x7A] = FIRST_ACTIVE_LINE & 0xff;
> -	regs[0x7B] = LAST_ACTIVE_LINE & 0xff;
> -	regs[0x7C] = ((1 << 7) |
> -			(((LAST_ACTIVE_LINE >> 8) & 1) << 6) |
> -			(((FIRST_ACTIVE_LINE >> 8) & 1) << 4));
> -
> -	/* PAL: XXX: We could do a second set of regs to avoid this */
> -	if (solo_dev->video_type != SOLO_VO_FMT_TYPE_NTSC) {
> -		regs[0x28] = 0xE1;
> -
> -		regs[0x5A] = 0x0F;
> -		regs[0x61] = 0x02;
> -		regs[0x62] = 0x35;
> -		regs[0x63] = 0xCB;
> -		regs[0x64] = 0x8A;
> -		regs[0x65] = 0x09;
> -		regs[0x66] = 0x2A;
> -
> -		regs[0x6C] = 0xf1;
> -		regs[0x6E] = 0x20;
> -
> -		regs[0x7A] = 0x06 + 12;
> -		regs[0x7b] = 0x24 + 12;
> -		regs[0x7c] |= 1 << 6;
> -	}
> -
> -	/* First 0x25 bytes are read-only? */
> -	for (i = 0x26; i < 128; i++) {
> -		if (i == 0x60 || i == 0x7D)
> -			continue;
> -		solo_i2c_writebyte(solo_dev, SOLO_I2C_SAA, 0x46, i, regs[i]);
> -	}
> -
> -	return;
> +	if (dev->video_type == SOLO_VO_FMT_TYPE_PAL)
> +		saa712x_write_regs(dev, saa7128_regs_pal, reg_start,
> +				sizeof(saa7128_regs_pal));
> +	else
> +		saa712x_write_regs(dev, saa7128_regs_ntsc, reg_start,
> +				sizeof(saa7128_regs_ntsc));
>  }
>  
>  int solo_tw28_init(struct solo_dev *solo_dev)
> @@ -609,7 +629,7 @@ int solo_tw28_init(struct solo_dev *solo_dev)
>  		return -EINVAL;
>  	}
>  
> -	saa7128_setup(solo_dev);
> +	saa712x_setup(solo_dev);
>  
>  	for (i = 0; i < solo_dev->tw28_cnt; i++) {
>  		if ((solo_dev->tw2865 & (1 << i)))
> 
