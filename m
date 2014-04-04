Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:45845 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaDDNSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 09:18:07 -0400
Received: by mail-oa0-f50.google.com with SMTP id i7so3484509oag.23
        for <linux-media@vger.kernel.org>; Fri, 04 Apr 2014 06:18:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140403233135.27099.70965.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
	<20140403233135.27099.70965.stgit@zeus.muc.hardeman.nu>
Date: Fri, 4 Apr 2014 14:18:06 +0100
Message-ID: <CAAG0J98ODrummB6-N976ks8uM1VNpYyGUQUV27BuKSfypMH4jg@mail.gmail.com>
Subject: Re: [PATCH 04/49] rc-core: do not change 32bit NEC scancode format
 for now
From: James Hogan <james.hogan@imgtec.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

On 4 April 2014 00:31, David Härdeman <david@hardeman.nu> wrote:
> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
> index c0111d6..ee45795 100644
> --- a/drivers/media/rc/img-ir/img-ir-nec.c
> +++ b/drivers/media/rc/img-ir/img-ir-nec.c

>  /* Convert NEC data to a scancode */
>  static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protocol,
> @@ -23,11 +24,11 @@ static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protocol,
>         data_inv = (raw >> 24) & 0xff;
>         if ((data_inv ^ data) != 0xff) {
>                 /* 32-bit NEC (used by Apple and TiVo remotes) */
> -               /* scan encoding: aaAAddDD */
> -               *scancode = addr_inv << 24 |
> -                           addr     << 16 |
> -                           data_inv <<  8 |
> -                           data;
> +               /* scan encoding: AAaaDDdd (LSBit first) */

This scan encoding of NEC32 interprets the  raw data MSBit first (i.e.
the MSBit of scancode is the first bit received), so this comment is
wrong.

> +               *scancode = bitrev8(addr)     << 24 |
> +                           bitrev8(addr_inv) << 16 |
> +                           bitrev8(data)     <<  8 |
> +                           bitrev8(data_inv);
>         } else if ((addr_inv ^ addr) != 0xff) {
>                 /* Extended NEC */
>                 /* scan encoding: AAaaDD */
> @@ -56,13 +57,15 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
>
>         if ((in->data | in->mask) & 0xff000000) {
>                 /* 32-bit NEC (used by Apple and TiVo remotes) */
> -               /* scan encoding: aaAAddDD */
> -               addr_inv   = (in->data >> 24) & 0xff;
> -               addr_inv_m = (in->mask >> 24) & 0xff;
> -               addr       = (in->data >> 16) & 0xff;
> -               addr_m     = (in->mask >> 16) & 0xff;
> -               data_inv   = (in->data >>  8) & 0xff;
> -               data_inv_m = (in->mask >>  8) & 0xff;
> +               /* scan encoding: AAaaDDdd (LSBit first) */

same here

The actual code looks fine now though. If you fix those two comments:
Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> +               addr       = bitrev8(in->data >> 24);
> +               addr_m     = bitrev8(in->mask >> 24);
> +               addr_inv   = bitrev8(in->data >> 16);
> +               addr_inv_m = bitrev8(in->mask >> 16);
> +               data       = bitrev8(in->data >>  8);
> +               data_m     = bitrev8(in->mask >>  8);
> +               data_inv   = bitrev8(in->data >>  0);
> +               data_inv_m = bitrev8(in->mask >>  0);
>         } else if ((in->data | in->mask) & 0x00ff0000) {
>                 /* Extended NEC */
>                 /* scan encoding AAaaDD */
