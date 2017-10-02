Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:52452 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJBKec (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Oct 2017 06:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <20171001193101.8898-4-jeremy.lefaure@lse.epita.fr>
References: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr> <20171001193101.8898-4-jeremy.lefaure@lse.epita.fr>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Mon, 2 Oct 2017 06:34:31 -0400
Message-ID: <CAOcJUbyb0LgdNeCaJTuq+BHQqqPOXrtH9me7-KvtG+2BciUuxA@mail.gmail.com>
Subject: Re: [PATCH 03/18] media: use ARRAY_SIZE
To: =?UTF-8?B?SsOpcsOpbXkgTGVmYXVyZQ==?= <jeremy.lefaure@lse.epita.fr>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 1, 2017 at 3:30 PM, J=C3=A9r=C3=A9my Lefaure
<jeremy.lefaure@lse.epita.fr> wrote:
> Using the ARRAY_SIZE macro improves the readability of the code. Also,
> it is not always useful to use a variable to store this constant
> calculated at compile time.
>
> Found with Coccinelle with the following semantic patch:
> @r depends on (org || report)@
> type T;
> T[] E;
> position p;
> @@
> (
>  (sizeof(E)@p /sizeof(*E))
> |
>  (sizeof(E)@p /sizeof(E[...]))
> |
>  (sizeof(E)@p /sizeof(T))
> )
>
> Signed-off-by: J=C3=A9r=C3=A9my Lefaure <jeremy.lefaure@lse.epita.fr>


Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>


> ---
>  drivers/media/common/saa7146/saa7146_video.c | 9 ++++-----
>  drivers/media/dvb-frontends/cxd2841er.c      | 7 +++----
>  drivers/media/pci/saa7146/hexium_gemini.c    | 3 ++-
>  drivers/media/pci/saa7146/hexium_orion.c     | 3 ++-
>  drivers/media/pci/saa7146/mxb.c              | 3 ++-
>  drivers/media/usb/dvb-usb/cxusb.c            | 3 ++-
>  drivers/media/usb/dvb-usb/friio-fe.c         | 5 ++---
>  7 files changed, 17 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media=
/common/saa7146/saa7146_video.c
> index 37b4654dc21c..612aefd804f0 100644
> --- a/drivers/media/common/saa7146/saa7146_video.c
> +++ b/drivers/media/common/saa7146/saa7146_video.c
> @@ -4,6 +4,7 @@
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-ctrls.h>
>  #include <linux/module.h>
> +#include <linux/kernel.h>
>
>  static int max_memory =3D 32;
>
> @@ -86,13 +87,11 @@ static struct saa7146_format formats[] =3D {
>     due to this, it's impossible to provide additional *packed* formats, =
which are simply byte swapped
>     (like V4L2_PIX_FMT_YUYV) ... 8-( */
>
> -static int NUM_FORMATS =3D sizeof(formats)/sizeof(struct saa7146_format)=
;
> -
>  struct saa7146_format* saa7146_format_by_fourcc(struct saa7146_dev *dev,=
 int fourcc)
>  {
> -       int i, j =3D NUM_FORMATS;
> +       int i;
>
> -       for (i =3D 0; i < j; i++) {
> +       for (i =3D 0; i < ARRAY_SIZE(formats); i++) {
>                 if (formats[i].pixelformat =3D=3D fourcc) {
>                         return formats+i;
>                 }
> @@ -524,7 +523,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh,=
 const struct v4l2_framebuf
>
>  static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh, struct v=
4l2_fmtdesc *f)
>  {
> -       if (f->index >=3D NUM_FORMATS)
> +       if (f->index >=3D ARRAY_SIZE(formats))
>                 return -EINVAL;
>         strlcpy((char *)f->description, formats[f->index].name,
>                         sizeof(f->description));
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-=
frontends/cxd2841er.c
> index 48ee9bc00c06..2cb97a3130be 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -29,6 +29,7 @@
>  #include <linux/math64.h>
>  #include <linux/log2.h>
>  #include <linux/dynamic_debug.h>
> +#include <linux/kernel.h>
>
>  #include "dvb_math.h"
>  #include "dvb_frontend.h"
> @@ -1696,12 +1697,10 @@ static u32 cxd2841er_dvbs_read_snr(struct cxd2841=
er_priv *priv,
>                 min_index =3D 0;
>                 if (delsys =3D=3D SYS_DVBS) {
>                         cn_data =3D s_cn_data;
> -                       max_index =3D sizeof(s_cn_data) /
> -                               sizeof(s_cn_data[0]) - 1;
> +                       max_index =3D ARRAY_SIZE(s_cn_data) - 1;
>                 } else {
>                         cn_data =3D s2_cn_data;
> -                       max_index =3D sizeof(s2_cn_data) /
> -                               sizeof(s2_cn_data[0]) - 1;
> +                       max_index =3D ARRAY_SIZE(s2_cn_data) - 1;
>                 }
>                 if (value >=3D cn_data[min_index].value) {
>                         res =3D cn_data[min_index].cnr_x1000;
> diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pc=
i/saa7146/hexium_gemini.c
> index d31a2d4494d1..39357eddee32 100644
> --- a/drivers/media/pci/saa7146/hexium_gemini.c
> +++ b/drivers/media/pci/saa7146/hexium_gemini.c
> @@ -27,6 +27,7 @@
>
>  #include <media/drv-intf/saa7146_vv.h>
>  #include <linux/module.h>
> +#include <linux/kernel.h>
>
>  static int debug;
>  module_param(debug, int, 0);
> @@ -388,7 +389,7 @@ static struct saa7146_ext_vv vv_data =3D {
>         .inputs =3D HEXIUM_INPUTS,
>         .capabilities =3D 0,
>         .stds =3D &hexium_standards[0],
> -       .num_stds =3D sizeof(hexium_standards) / sizeof(struct saa7146_st=
andard),
> +       .num_stds =3D ARRAY_SIZE(hexium_standards),
>         .std_callback =3D &std_callback,
>  };
>
> diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci=
/saa7146/hexium_orion.c
> index 043318aa19e2..461e421080f3 100644
> --- a/drivers/media/pci/saa7146/hexium_orion.c
> +++ b/drivers/media/pci/saa7146/hexium_orion.c
> @@ -27,6 +27,7 @@
>
>  #include <media/drv-intf/saa7146_vv.h>
>  #include <linux/module.h>
> +#include <linux/kernel.h>
>
>  static int debug;
>  module_param(debug, int, 0);
> @@ -460,7 +461,7 @@ static struct saa7146_ext_vv vv_data =3D {
>         .inputs =3D HEXIUM_INPUTS,
>         .capabilities =3D 0,
>         .stds =3D &hexium_standards[0],
> -       .num_stds =3D sizeof(hexium_standards) / sizeof(struct saa7146_st=
andard),
> +       .num_stds =3D ARRAY_SIZE(hexium_standards),
>         .std_callback =3D &std_callback,
>  };
>
> diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/=
mxb.c
> index 930218cc2de1..0144f305ea24 100644
> --- a/drivers/media/pci/saa7146/mxb.c
> +++ b/drivers/media/pci/saa7146/mxb.c
> @@ -30,6 +30,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/i2c/saa7115.h>
>  #include <linux/module.h>
> +#include <linux/kernel.h>
>
>  #include "tea6415c.h"
>  #include "tea6420.h"
> @@ -837,7 +838,7 @@ static struct saa7146_ext_vv vv_data =3D {
>         .inputs         =3D MXB_INPUTS,
>         .capabilities   =3D V4L2_CAP_TUNER | V4L2_CAP_VBI_CAPTURE | V4L2_=
CAP_AUDIO,
>         .stds           =3D &standard[0],
> -       .num_stds       =3D sizeof(standard)/sizeof(struct saa7146_standa=
rd),
> +       .num_stds       =3D ARRAY_SIZE(standard),
>         .std_callback   =3D &std_callback,
>  };
>
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-us=
b/cxusb.c
> index 37dea0adc695..9b486bb5004d 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -26,6 +26,7 @@
>  #include <media/tuner.h>
>  #include <linux/vmalloc.h>
>  #include <linux/slab.h>
> +#include <linux/kernel.h>
>
>  #include "cxusb.h"
>
> @@ -303,7 +304,7 @@ static int cxusb_aver_power_ctrl(struct dvb_usb_devic=
e *d, int onoff)
>                         0x0e, 0x2, 0x47, 0x88,
>                 };
>                 msleep(20);
> -               for (i =3D 0; i < sizeof(bufs)/sizeof(u8); i +=3D 4/sizeo=
f(u8)) {
> +               for (i =3D 0; i < ARRAY_SIZE(bufs); i +=3D 4 / sizeof(u8)=
) {
>                         ret =3D cxusb_ctrl_msg(d, CMD_I2C_WRITE,
>                                              bufs+i, 4, &buf, 1);
>                         if (ret)
> diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb=
-usb/friio-fe.c
> index 0251a4e91d47..a6c84a4390d1 100644
> --- a/drivers/media/usb/dvb-usb/friio-fe.c
> +++ b/drivers/media/usb/dvb-usb/friio-fe.c
> @@ -13,6 +13,7 @@
>  #include <linux/init.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> +#include <linux/kernel.h>
>
>  #include "friio.h"
>
> @@ -362,8 +363,6 @@ static u8 init_code[][2] =3D {
>         {0x76, 0x0C},
>  };
>
> -static const int init_code_len =3D sizeof(init_code) / sizeof(u8[2]);
> -
>  static int jdvbt90502_init(struct dvb_frontend *fe)
>  {
>         int i =3D -1;
> @@ -377,7 +376,7 @@ static int jdvbt90502_init(struct dvb_frontend *fe)
>         msg.addr =3D state->config.demod_address;
>         msg.flags =3D 0;
>         msg.len =3D 2;
> -       for (i =3D 0; i < init_code_len; i++) {
> +       for (i =3D 0; i < ARRAY_SIZE(init_code); i++) {
>                 msg.buf =3D init_code[i];
>                 ret =3D i2c_transfer(state->i2c, &msg, 1);
>                 if (ret !=3D 1)
> --
> 2.14.1
>
