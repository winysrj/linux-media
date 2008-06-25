Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KBTua-0003oV-Ti
	for linux-dvb@linuxtv.org; Wed, 25 Jun 2008 14:15:46 +0200
Received: by rv-out-0506.google.com with SMTP id b25so11207246rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 25 Jun 2008 05:15:40 -0700 (PDT)
Message-ID: <d9def9db0806250515l6a758e9aua39ed554ae393bde@mail.gmail.com>
Date: Wed, 25 Jun 2008 14:15:39 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jaswinder Singh" <jaswinder@infradead.org>
In-Reply-To: <1214127575.4974.7.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Disposition: inline
References: <1214127575.4974.7.camel@jaswinder.satnam>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] firmware: convert av7110 driver to
	request_firmware()
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

On 6/22/08, Jaswinder Singh <jaswinder@infradead.org> wrote:
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> --
> drivers/media/dvb/ttpci/Kconfig     |    7 +++++++
> drivers/media/dvb/ttpci/av7110_hw.c |   35 ++++++++++++-----------------------
> drivers/media/dvb/ttpci/av7110_hw.h |    3 ++-
> firmware/Makefile                   |    1 +
> firmware/WHENCE                     |   10 ++++++++++
> firmware/av7110/bootcode.bin.ihex   |   15 +++++++++++++++
> 6 files changed, 47 insertions(+), 24 deletions(-)
> create mode 100644 firmware/av7110/bootcode.bin.ihex
> diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/dvb/ttpci/Kconfig
> index d4339b1..e0bbcaf 100644
> --- a/drivers/media/dvb/ttpci/Kconfig
> +++ b/drivers/media/dvb/ttpci/Kconfig
> @@ -32,6 +32,13 @@ config DVB_AV7110
>
>          Say Y if you own such a card and want to use it.
>
> +config DVB_AV7110_BOOTCODE
> +       bool "Compile AV7110 bootcode into the driver"
> +       depends on DVB_AV7110
> +       help
> +         This includes firmware for AV7110 bootcode
> +         Say 'N' and let it get loaded from userspace on demand
> +
>  config DVB_AV7110_FIRMWARE
>        bool "Compile AV7110 firmware into the driver"
>        depends on DVB_AV7110 && !STANDALONE
> diff --git a/drivers/media/dvb/ttpci/av7110_hw.c b/drivers/media/dvb/ttpci/av7110_hw.c
> index 9d81074..646d2c9 100644
> --- a/drivers/media/dvb/ttpci/av7110_hw.c
> +++ b/drivers/media/dvb/ttpci/av7110_hw.c
> @@ -198,29 +198,10 @@ static int load_dram(struct av7110 *av7110, u32 *data, int len)
>
>  /* we cannot write av7110 DRAM directly, so load a bootloader into
>  * the DPRAM which implements a simple boot protocol */
> -static u8 bootcode[] = {
> -  0xea, 0x00, 0x00, 0x0e, 0xe1, 0xb0, 0xf0, 0x0e, 0xe2, 0x5e, 0xf0, 0x04,
> -  0xe2, 0x5e, 0xf0, 0x04, 0xe2, 0x5e, 0xf0, 0x08, 0xe2, 0x5e, 0xf0, 0x04,
> -  0xe2, 0x5e, 0xf0, 0x04, 0xe2, 0x5e, 0xf0, 0x04, 0x2c, 0x00, 0x00, 0x24,
> -  0x00, 0x00, 0x00, 0x0c, 0x00, 0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x34,
> -  0x00, 0x00, 0x00, 0x00, 0xa5, 0xa5, 0x5a, 0x5a, 0x00, 0x1f, 0x15, 0x55,
> -  0x00, 0x00, 0x00, 0x09, 0xe5, 0x9f, 0xd0, 0x7c, 0xe5, 0x9f, 0x40, 0x74,
> -  0xe3, 0xa0, 0x00, 0x00, 0xe5, 0x84, 0x00, 0x00, 0xe5, 0x84, 0x00, 0x04,
> -  0xe5, 0x9f, 0x10, 0x70, 0xe5, 0x9f, 0x20, 0x70, 0xe5, 0x9f, 0x30, 0x64,
> -  0xe8, 0xb1, 0x1f, 0xe0, 0xe8, 0xa3, 0x1f, 0xe0, 0xe1, 0x51, 0x00, 0x02,
> -  0xda, 0xff, 0xff, 0xfb, 0xe5, 0x9f, 0xf0, 0x50, 0xe1, 0xd4, 0x10, 0xb0,
> -  0xe3, 0x51, 0x00, 0x00, 0x0a, 0xff, 0xff, 0xfc, 0xe1, 0xa0, 0x10, 0x0d,
> -  0xe5, 0x94, 0x30, 0x04, 0xe1, 0xd4, 0x20, 0xb2, 0xe2, 0x82, 0x20, 0x3f,
> -  0xe1, 0xb0, 0x23, 0x22, 0x03, 0xa0, 0x00, 0x02, 0xe1, 0xc4, 0x00, 0xb0,
> -  0x0a, 0xff, 0xff, 0xf4, 0xe8, 0xb1, 0x1f, 0xe0, 0xe8, 0xa3, 0x1f, 0xe0,
> -  0xe8, 0xb1, 0x1f, 0xe0, 0xe8, 0xa3, 0x1f, 0xe0, 0xe2, 0x52, 0x20, 0x01,
> -  0x1a, 0xff, 0xff, 0xf9, 0xe2, 0x2d, 0xdb, 0x05, 0xea, 0xff, 0xff, 0xec,
> -  0x2c, 0x00, 0x03, 0xf8, 0x2c, 0x00, 0x04, 0x00, 0x9e, 0x00, 0x08, 0x00,
> -  0x2c, 0x00, 0x00, 0x74, 0x2c, 0x00, 0x00, 0xc0
> -};
> -
>  int av7110_bootarm(struct av7110 *av7110)
>  {
> +       const struct firmware *fw;
> +       const char *fw_name = "av7110/bootcode.bin";
>        struct saa7146_dev *dev = av7110->dev;
>        u32 ret;
>        int i;
> @@ -261,7 +242,15 @@ int av7110_bootarm(struct av7110 *av7110)
>        //saa7146_setgpio(dev, DEBI_DONE_LINE, SAA7146_GPIO_INPUT);
>        //saa7146_setgpio(dev, 3, SAA7146_GPIO_INPUT);
>
> -       mwdebi(av7110, DEBISWAB, DPRAM_BASE, bootcode, sizeof(bootcode));
> +       ret = request_firmware(&fw, fw_name, &dev->pci->dev);
> +       if (ret) {
> +               printk(KERN_ERR "dvb-ttpci: Failed to load firmware \"%s\"\n",
> +                       fw_name);
> +               return ret;
> +       }
> +
> +       mwdebi(av7110, DEBISWAB, DPRAM_BASE, fw->data, fw->size);
> +       release_firmware(fw);
>        iwdebi(av7110, DEBINOSWAP, AV7110_BOOT_STATE, BOOTSTATE_BUFFER_FULL, 2);
>
>        if (saa7146_wait_for_debi_done(av7110->dev, 1)) {
> @@ -302,7 +291,7 @@ int av7110_bootarm(struct av7110 *av7110)
>        av7110->arm_ready = 1;
>        return 0;
>  }
> -
> +MODULE_FIRMWARE("av7110/bootcode.bin");
>
>  /****************************************************************************
>  * DEBI command polling
> diff --git a/drivers/media/dvb/ttpci/av7110_hw.h b/drivers/media/dvb/ttpci/av7110_hw.h
> index 74d940f..da29f0f 100644
> --- a/drivers/media/dvb/ttpci/av7110_hw.h
> +++ b/drivers/media/dvb/ttpci/av7110_hw.h
> @@ -393,7 +393,8 @@ static inline void iwdebi(struct av7110 *av7110, u32 config, int addr, u32 val,
>  }
>
>  /* buffer writes */
> -static inline void mwdebi(struct av7110 *av7110, u32 config, int addr, u8 *val, int count)
> +static inline void mwdebi(struct av7110 *av7110, u32 config, int addr,
> +                         const u8 *val, int count)
>  {
>        memcpy(av7110->debi_virt, val, count);
>        av7110_debiwrite(av7110, config, addr, 0, count);
> diff --git a/firmware/Makefile b/firmware/Makefile
> index e2a99a5..ce5e916 100644
> --- a/firmware/Makefile
> +++ b/firmware/Makefile
> @@ -18,6 +18,7 @@ fw-shipped-$(CONFIG_USB_KAWETH_FIRMWARE) += kaweth/new_code.bin \
>                kaweth/new_code_fix.bin kaweth/trigger_code.bin \
>                kaweth/trigger_code_fix.bin
>  fw-shipped-$(CONFIG_DVB_TTUSB_BUDGET_FIRMWARE) += ttusb-budget/dspbootcode.bin
> +fw-shipped-$(CONFIG_DVB_AV7110_BOOTCODE) += av7110/bootcode.bin
>  fw-shipped-$(CONFIG_E100_FIRMWARE) += e100/d101m_ucode.bin \
>                e100/d101s_ucode.bin e100/d102e_ucode.bin
>  fw-shipped-$(CONFIG_ACENIC_TG1_FIRMWARE) += acenic/tg1.bin
> diff --git a/firmware/WHENCE b/firmware/WHENCE
> index 2321512..49ac8ba 100644
> --- a/firmware/WHENCE
> +++ b/firmware/WHENCE
> @@ -279,3 +279,13 @@ Licence:
>  Found in hex form in kernel source.
>
>  --------------------------------------------------------------------------
> +
> +Driver: DVB AV7110 -- AV7110 cards
> +
> +File: av7110/bootcode.bin
> +
> +Licence: GPLv2 or later
> +
> +ARM assembly source code available at http://www.linuxtv.org/downloads/firmware/Boot.S
> +
> +--------------------------------------------------------------------------
> diff --git a/firmware/av7110/bootcode.bin.ihex b/firmware/av7110/bootcode.bin.ihex
> new file mode 100644
> index 0000000..26a2993
> --- /dev/null
> +++ b/firmware/av7110/bootcode.bin.ihex
> @@ -0,0 +1,15 @@
> +:10000000EA00000EE1B0F00EE25EF004E25EF00401
> +:10001000E25EF008E25EF004E25EF004E25EF0040C
> +:100020002C0000240000000C000000002C00003414
> +:1000300000000000A5A55A5A001F15550000000930
> +:10004000E59FD07CE59F4074E3A00000E5840000BC
> +:10005000E5840004E59F1070E59F2070E59F306403
> +:10006000E8B11FE0E8A31FE0E1510002DAFFFFFB67
> +:10007000E59FF050E1D410B0E35100000AFFFFFC0F
> +:10008000E1A0100DE5943004E1D420B2E282203FDB
> +:10009000E1B0232203A00002E1C400B00AFFFFF494
> +:1000A000E8B11FE0E8A31FE0E8B11FE0E8A31FE00C
> +:1000B000E25220011AFFFFF9E22DDB05EAFFFFEC17
> +:1000C0002C0003F82C0004009E0008002C00007493
> +:0400D0002C0000C040
> +:00000001FF
>

the patch seems to be ok, please be aware that request_firmware is not
waterproof though (eg. name collisions, like the comment in the
request firmware module says).

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
