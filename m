Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54907 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945Ab2G1QyV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jul 2012 12:54:21 -0400
Subject: Re: [PATCH v3] cx18: Declare MODULE_FIRMWARE usage
From: Andy Walls <awalls@md.metrocast.net>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Date: Sat, 28 Jul 2012 12:53:45 -0400
In-Reply-To: <1343407521-45720-1-git-send-email-tim.gardner@canonical.com>
References: <1343340453.2575.10.camel@palomino.walls.org>
	 <1343407521-45720-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1343494426.2476.13.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-07-27 at 10:45 -0600, Tim Gardner wrote:
> Cc: Andy Walls <awalls@md.metrocast.net>

Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: ivtv-devel@ivtvdriver.org
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/media/video/cx18/cx18-av-firmware.c |    2 ++
>  drivers/media/video/cx18/cx18-driver.c      |    1 +
>  drivers/media/video/cx18/cx18-dvb.c         |    6 +++++-
>  drivers/media/video/cx18/cx18-firmware.c    |   10 ++++++++--
>  4 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-av-firmware.c b/drivers/media/video/cx18/cx18-av-firmware.c
> index 280aa4d..a34fd08 100644
> --- a/drivers/media/video/cx18/cx18-av-firmware.c
> +++ b/drivers/media/video/cx18/cx18-av-firmware.c
> @@ -221,3 +221,5 @@ int cx18_av_loadfw(struct cx18 *cx)
>  	release_firmware(fw);
>  	return 0;
>  }
> +
> +MODULE_FIRMWARE(FWFILE);
> diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
> index 7e5ffd6..c67733d 100644
> --- a/drivers/media/video/cx18/cx18-driver.c
> +++ b/drivers/media/video/cx18/cx18-driver.c
> @@ -1357,3 +1357,4 @@ static void __exit module_cleanup(void)
>  
>  module_init(module_start);
>  module_exit(module_cleanup);
> +MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
> diff --git a/drivers/media/video/cx18/cx18-dvb.c b/drivers/media/video/cx18/cx18-dvb.c
> index f41922b..3eac59c 100644
> --- a/drivers/media/video/cx18/cx18-dvb.c
> +++ b/drivers/media/video/cx18/cx18-dvb.c
> @@ -40,6 +40,8 @@
>  
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
> +#define FWFILE "dvb-cx18-mpc718-mt352.fw"
> +
>  #define CX18_REG_DMUX_NUM_PORT_0_CONTROL 0xd5a000
>  #define CX18_CLOCK_ENABLE2		 0xc71024
>  #define CX18_DMUX_CLK_MASK		 0x0080
> @@ -135,7 +137,7 @@ static int yuan_mpc718_mt352_reqfw(struct cx18_stream *stream,
>  				   const struct firmware **fw)
>  {
>  	struct cx18 *cx = stream->cx;
> -	const char *fn = "dvb-cx18-mpc718-mt352.fw";
> +	const char *fn = FWFILE;
>  	int ret;
>  
>  	ret = request_firmware(fw, fn, &cx->pci_dev->dev);
> @@ -603,3 +605,5 @@ static int dvb_register(struct cx18_stream *stream)
>  
>  	return ret;
>  }
> +
> +MODULE_FIRMWARE(FWFILE);
> diff --git a/drivers/media/video/cx18/cx18-firmware.c b/drivers/media/video/cx18/cx18-firmware.c
> index b85c292..a1c1cec 100644
> --- a/drivers/media/video/cx18/cx18-firmware.c
> +++ b/drivers/media/video/cx18/cx18-firmware.c
> @@ -376,6 +376,9 @@ void cx18_init_memory(struct cx18 *cx)
>  	cx18_write_reg(cx, 0x00000101, CX18_WMB_CLIENT14);  /* AVO */
>  }
>  
> +#define CX18_CPU_FIRMWARE "v4l-cx23418-cpu.fw"
> +#define CX18_APU_FIRMWARE "v4l-cx23418-apu.fw"
> +
>  int cx18_firmware_init(struct cx18 *cx)
>  {
>  	u32 fw_entry_addr;
> @@ -400,7 +403,7 @@ int cx18_firmware_init(struct cx18 *cx)
>  	cx18_sw1_irq_enable(cx, IRQ_CPU_TO_EPU | IRQ_APU_TO_EPU);
>  	cx18_sw2_irq_enable(cx, IRQ_CPU_TO_EPU_ACK | IRQ_APU_TO_EPU_ACK);
>  
> -	sz = load_cpu_fw_direct("v4l-cx23418-cpu.fw", cx->enc_mem, cx);
> +	sz = load_cpu_fw_direct(CX18_CPU_FIRMWARE, cx->enc_mem, cx);
>  	if (sz <= 0)
>  		return sz;
>  
> @@ -408,7 +411,7 @@ int cx18_firmware_init(struct cx18 *cx)
>  	cx18_init_scb(cx);
>  
>  	fw_entry_addr = 0;
> -	sz = load_apu_fw_direct("v4l-cx23418-apu.fw", cx->enc_mem, cx,
> +	sz = load_apu_fw_direct(CX18_APU_FIRMWARE, cx->enc_mem, cx,
>  				&fw_entry_addr);
>  	if (sz <= 0)
>  		return sz;
> @@ -451,3 +454,6 @@ int cx18_firmware_init(struct cx18 *cx)
>  	cx18_write_reg_expect(cx, 0x14001400, 0xc78110, 0x00001400, 0x14001400);
>  	return 0;
>  }
> +
> +MODULE_FIRMWARE(CX18_CPU_FIRMWARE);
> +MODULE_FIRMWARE(CX18_APU_FIRMWARE);


