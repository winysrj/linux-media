Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:59245 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbZIDSFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2009 14:05:33 -0400
Received: by ewy2 with SMTP id 2so655973ewy.17
        for <linux-media@vger.kernel.org>; Fri, 04 Sep 2009 11:05:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
Date: Fri, 4 Sep 2009 14:05:31 -0400
Message-ID: <37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
	firmware name
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linuxtv-commits@linuxtv.org, Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

This fix should really go to Linus before 2.6.31 is released, if
possible.  It also should be backported to stable, but I need it in
Linus' tree before it will be accepted into -stable.

Do you think you can slip this in before the weekend?  As I
understand, Linus plans to release 2.6.31 on Saturday, September 5th.

If you dont have time for it, please let me know and I will send it in myself.

Thanks & regards,

Mike Krufky

On Tue, Sep 1, 2009 at 9:45 AM, Patch from Hans
Verkuil<hg-commit@linuxtv.org> wrote:
> The patch number 12613 was added via Hans Verkuil <hverkuil@xs4all.nl>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
>
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
>
> If anyone has any objections, please let us know by sending a message to:
>        Linux Media Mailing List <linux-media@vger.kernel.org>
>
> ------
>
> From: Hans Verkuil  <hverkuil@xs4all.nl>
> cx25840: fix determining the firmware name
>
>
> Depending on the model there are three different firmwares to choose from.
> Unfortunately if a cx23885 is loaded first, then the global firmware name
> is overwritten with that firmware and if ivtv is loaded next, then it
> tries to load the wrong firmware. In addition, the original approach would
> also overwrite any firmware that the user specified explicitly.
>
> Priority: normal
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> CC: Jarod Wilson <jarod@wilsonet.com>
>
>
> ---
>
>  linux/drivers/media/video/cx25840/cx25840-firmware.c |   35 ++++++-----
>  1 file changed, 22 insertions(+), 13 deletions(-)
>
> diff -r f69cb015dc77 -r 36a81289010d linux/drivers/media/video/cx25840/cx25840-firmware.c
> --- a/linux/drivers/media/video/cx25840/cx25840-firmware.c      Mon Aug 31 22:21:04 2009 +0200
> +++ b/linux/drivers/media/video/cx25840/cx25840-firmware.c      Mon Aug 31 22:57:52 2009 +0200
> @@ -24,10 +24,6 @@
>
>  #include "cx25840-core.h"
>
> -#define FWFILE "v4l-cx25840.fw"
> -#define FWFILE_CX23885 "v4l-cx23885-avcore-01.fw"
> -#define FWFILE_CX231XX "v4l-cx231xx-avcore-01.fw"
> -
>  /*
>  * Mike Isely <isely@pobox.com> - The FWSEND parameter controls the
>  * size of the firmware chunks sent down the I2C bus to the chip.
> @@ -41,11 +37,11 @@
>
>  #define FWDEV(x) &((x)->dev)
>
> -static char *firmware = FWFILE;
> +static char *firmware = "";
>
>  module_param(firmware, charp, 0444);
>
> -MODULE_PARM_DESC(firmware, "Firmware image [default: " FWFILE "]");
> +MODULE_PARM_DESC(firmware, "Firmware image to load");
>
>  static void start_fw_load(struct i2c_client *client)
>  {
> @@ -66,6 +62,19 @@
>        cx25840_write(client, 0x803, 0x03);
>  }
>
> +static const char *get_fw_name(struct i2c_client *client)
> +{
> +       struct cx25840_state *state = to_state(i2c_get_clientdata(client));
> +
> +       if (firmware[0])
> +               return firmware;
> +       if (state->is_cx23885)
> +               return "v4l-cx23885-avcore-01.fw";
> +       if (state->is_cx231xx)
> +               return "v4l-cx231xx-avcore-01.fw";
> +       return "v4l-cx25840.fw";
> +}
> +
>  static int check_fw_load(struct i2c_client *client, int size)
>  {
>        /* DL_ADDR_HB DL_ADDR_LB */
> @@ -73,11 +82,13 @@
>        s |= cx25840_read(client, 0x800);
>
>        if (size != s) {
> -               v4l_err(client, "firmware %s load failed\n", firmware);
> +               v4l_err(client, "firmware %s load failed\n",
> +                               get_fw_name(client));
>                return -EINVAL;
>        }
>
> -       v4l_info(client, "loaded %s firmware (%d bytes)\n", firmware, size);
> +       v4l_info(client, "loaded %s firmware (%d bytes)\n",
> +                       get_fw_name(client), size);
>        return 0;
>  }
>
> @@ -97,26 +108,24 @@
>        const struct firmware *fw = NULL;
>        u8 buffer[FWSEND];
>        const u8 *ptr;
> +       const char *fwname = get_fw_name(client);
>        int size, retval;
>        int MAX_BUF_SIZE = FWSEND;
>        u32 gpio_oe = 0, gpio_da = 0;
>
>        if (state->is_cx23885) {
> -               firmware = FWFILE_CX23885;
>                /* Preserve the GPIO OE and output bits */
>                gpio_oe = cx25840_read(client, 0x160);
>                gpio_da = cx25840_read(client, 0x164);
>        }
> -       else if (state->is_cx231xx)
> -               firmware = FWFILE_CX231XX;
>
>        if ((state->is_cx231xx) && MAX_BUF_SIZE > 16) {
>                v4l_err(client, " Firmware download size changed to 16 bytes max length\n");
>                MAX_BUF_SIZE = 16;  /* cx231xx cannot accept more than 16 bytes at a time */
>        }
>
> -       if (request_firmware(&fw, firmware, FWDEV(client)) != 0) {
> -               v4l_err(client, "unable to open firmware %s\n", firmware);
> +       if (request_firmware(&fw, fwname, FWDEV(client)) != 0) {
> +               v4l_err(client, "unable to open firmware %s\n", fwname);
>                return -EINVAL;
>        }
>
>
>
> ---
>
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/36a81289010d614758a64bd757ee37c8c154ad4b
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
>
