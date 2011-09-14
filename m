Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60754 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab1IND2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 23:28:37 -0400
Received: by bkbzt4 with SMTP id zt4so1145066bkb.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 20:28:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315938892-20243-3-git-send-email-scott.jiang.linux@gmail.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com> <1315938892-20243-3-git-send-email-scott.jiang.linux@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 13 Sep 2011 23:28:16 -0400
Message-ID: <CAMjpGUenjQbGAM69J7mAt4anP9advZcdngXNuMddt+=HUnVK+w@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 3/4] v4l2: add vs6624 sensor driver
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	uclinux-dist-devel@blackfin.uclinux.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 13, 2011 at 14:34, Scott Jiang wrote:
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
>
> +obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
>  obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o

should be after vpx, not before ?

> --- /dev/null
> +++ b/drivers/media/video/vs6624.c
>
> +#include <asm/gpio.h>

run these patches through checkpatch.pl ?  this should be linux/gpio.h ...

> +static const u16 vs6624_p1[] = {
> +static const u16 vs6624_p2[] = {

add comments as to what these are for ?

> +static inline int vs6624_read(struct v4l2_subdev *sd, u16 index)
> +static inline int vs6624_write(struct v4l2_subdev *sd, u16 index,
> +                               u8 value)

should these be inline ?  they're a little "fat" ... better to let the
compiler choose

> +static int vs6624_writeregs(struct v4l2_subdev *sd, const u16 *regs)
> +{
> +       u16 reg, data;
> +
> +       while (*regs != 0x00) {
> +               reg = *regs++;
> +               data = *regs++;
> +
> +               vs6624_write(sd, reg, (u8)data);

what's the point of declaring data as u16 if the top 8 bits are never used ?

> +static int vs6624_g_chip_ident(struct v4l2_subdev *sd,
> +               struct v4l2_dbg_chip_ident *chip)
> +{
> +       int rev;
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +       rev = vs6624_read(sd, VS6624_FW_VSN_MAJOR) << 8
> +               | vs6624_read(sd, VS6624_FW_VSN_MINOR);

i'm a little surprised the compiler didnt warn about this.  usually
bit shifts + bitwise operators want paren to keep things clear.

> +#ifdef CONFIG_VIDEO_ADV_DEBUG

just use DEBUG ?

> +       v4l_info(client, "chip found @ 0x%02x (%s)\n",
> +                       client->addr << 1, client->adapter->name);

is that "<< 1" correct ?  i dont think so ...
-mike
