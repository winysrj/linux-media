Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34472 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbcKFUFf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2016 15:05:35 -0500
MIME-Version: 1.0
In-Reply-To: <632081ba085ddf0ded63cce3dbcf3870485d3cd3.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com> <632081ba085ddf0ded63cce3dbcf3870485d3cd3.1476179975.git.mchehab@s-opensource.com>
From: VDR User <user.vdr@gmail.com>
Date: Sun, 6 Nov 2016 11:51:14 -0800
Message-ID: <CAA7C2qiW+Co3XVt1AQDYka9MdSYG8OELxNzecqAia9df0P3Neg@mail.gmail.com>
Subject: Re: [PATCH v2 18/31] gp8psk: don't do DMA on stack
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I applied this patch to the 4.8.4 kernel driver (that I'm currently
running) and it caused nothing but "frontend 0/0 timed out while
tuning". Is there another patch that should be used in conjunction
with this? If not, this patch breaks the gp8psk driver.

Thanks.

On Tue, Oct 11, 2016 at 3:09 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/dvb-usb/gp8psk.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
> index 5d0384dd45b5..fa215ad37f7b 100644
> --- a/drivers/media/usb/dvb-usb/gp8psk.c
> +++ b/drivers/media/usb/dvb-usb/gp8psk.c
> @@ -24,6 +24,10 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DV
>
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>
> +struct gp8psk_state {
> +       unsigned char data[80];
> +};
> +
>  static int gp8psk_get_fw_version(struct dvb_usb_device *d, u8 *fw_vers)
>  {
>         return (gp8psk_usb_in_op(d, GET_FW_VERS, 0, 0, fw_vers, 6));
> @@ -53,17 +57,19 @@ static void gp8psk_info(struct dvb_usb_device *d)
>
>  int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
>  {
> +       struct gp8psk_state *st = d->priv;
>         int ret = 0,try = 0;
>
>         if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
>                 return ret;
>
>         while (ret >= 0 && ret != blen && try < 3) {
> +               memcpy(st->data, b, blen);
>                 ret = usb_control_msg(d->udev,
>                         usb_rcvctrlpipe(d->udev,0),
>                         req,
>                         USB_TYPE_VENDOR | USB_DIR_IN,
> -                       value,index,b,blen,
> +                       value, index, st->data, blen,
>                         2000);
>                 deb_info("reading number %d (ret: %d)\n",try,ret);
>                 try++;
> @@ -86,6 +92,7 @@ int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
>  int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
>                              u16 index, u8 *b, int blen)
>  {
> +       struct gp8psk_state *st = d->priv;
>         int ret;
>
>         deb_xfer("out: req. %x, val: %x, ind: %x, buffer: ",req,value,index);
> @@ -94,11 +101,12 @@ int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
>         if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
>                 return ret;
>
> +       memcpy(st->data, b, blen);
>         if (usb_control_msg(d->udev,
>                         usb_sndctrlpipe(d->udev,0),
>                         req,
>                         USB_TYPE_VENDOR | USB_DIR_OUT,
> -                       value,index,b,blen,
> +                       value,index, st->data, blen,
>                         2000) != blen) {
>                 warn("usb out operation failed.");
>                 ret = -EIO;
> @@ -265,6 +273,8 @@ static struct dvb_usb_device_properties gp8psk_properties = {
>         .usb_ctrl = CYPRESS_FX2,
>         .firmware = "dvb-usb-gp8psk-01.fw",
>
> +       .size_of_priv = sizeof(struct gp8psk_state),
> +
>         .num_adapters = 1,
>         .adapter = {
>                 {
> --
> 2.7.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
