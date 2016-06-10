Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34454 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbcFJMd6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 08:33:58 -0400
Received: by mail-wm0-f68.google.com with SMTP id n184so17628759wmn.1
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2016 05:33:58 -0700 (PDT)
Subject: Re: [PATCH RFC 1/2] v4l: platform: Add Renesas R-Car FDP1 Driver
To: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
References: <1465493879-5419-1-git-send-email-kieran@bingham.xyz>
 <1465493879-5419-2-git-send-email-kieran@bingham.xyz>
Cc: linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <575AB3A8.4090905@bingham.xyz>
Date: Fri, 10 Jun 2016 13:33:44 +0100
MIME-Version: 1.0
In-Reply-To: <1465493879-5419-2-git-send-email-kieran@bingham.xyz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Today I learned about make C=1

So ... reviewing my own patch, consider the following sparse warnings
'fixed up'

I'll run make C=1 before any future submissions from now on.


On 09/06/16 18:37, Kieran Bingham wrote:
> The FDP1 driver performs advanced de-interlacing on a memory 2 memory
> based video stream, and supports conversion from YCbCr/YUV
> to RGB pixel formats
> 
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
> ---
>  drivers/media/platform/Kconfig     |   13 +
>  drivers/media/platform/Makefile    |    1 +
>  drivers/media/platform/rcar_fdp1.c | 2038 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 2052 insertions(+)
>  create mode 100644 drivers/media/platform/rcar_fdp1.c

...

> +/* FDP1 Lookup tables range from 0...255 only */
> +unsigned char fdp1_diff_adj[256] = {
sparse: warning: symbol '...' was not declared. Should it be static?
+ static unsigned...

> +	0x00, 0x24, 0x43, 0x5E, 0x76, 0x8C, 0x9E, 0xAF,
...
> +	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
> +};
> +
> +unsigned char fdp1_sad_adj[256] = {
likewise

> +	0x00, 0x24, 0x43, 0x5E, 0x76, 0x8C, 0x9E, 0xAF,
...
> +	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
> +};
> +
> +unsigned char fdp1_bld_gain[256] = {
and again ...
> +	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
...
> +	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
> +};
> +
> +unsigned char fdp1_dif_gain[256] = {
> +	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
...
> +	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
> +};
> +
> +unsigned char fdp1_mdet[256] = {
and finally for the lut...
> +	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
...
> +	0xF8, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF
> +};
> +
...

> +static void fdp1_write(struct fdp1_dev *fdp1, u32 val, unsigned int reg)
> +{
> +	if (debug >= 2)
> +		dprintk(fdp1, "Write to %p\n", fdp1->regs + reg);
> +
> +	iowrite32(val, fdp1->regs + reg);
> +}
> +
> +
> +void fdp1_print_regs32(struct fdp1_dev *fdp1)
Another +static

...

> +static struct fdp1_plane_addrs vb2_dc_to_pa(struct vb2_v4l2_buffer *buf,
> +		unsigned int planes)
> +{
> +	struct fdp1_plane_addrs pa = { 0 };

sparse: warning: missing braces around initializer
+ struct fdp1_plane_addrs pa = { { 0 } };

-- 
Regards

Kieran Bingham
