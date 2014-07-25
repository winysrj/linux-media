Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:50124 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaGYXE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 19:04:56 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9A00DEYIS6OX80@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jul 2014 19:04:54 -0400 (EDT)
Date: Fri, 25 Jul 2014 20:04:49 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 39/49] rc-core: make IR raw handling a separate module
Message-id: <20140725200449.36b7ee71.m.chehab@samsung.com>
In-reply-to: <20140403233433.27099.91851.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
 <20140403233433.27099.91851.stgit@zeus.muc.hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Apr 2014 01:34:33 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Make drivers/media/rc/rc-ir-raw.c a separate kernel module.
> 
> Drivers which use IR decoding must use these functions:
> 	rc_register_ir_raw_device()
> 	rc_unregister_ir_raw_device()
> instead of:
> 	rc_register_device()
> 	rc_unregister_device()
> 
> This allows scancode drivers to skip lots of unnecessary functionality.

Makes sense to me. Please rebase.

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/common/siano/smsir.c          |    5 +-
>  drivers/media/common/siano/smsir.h          |    2 -
>  drivers/media/i2c/cx25840/cx25840-ir.c      |    2 -
>  drivers/media/pci/cx23885/cx23885-input.c   |   13 +---
>  drivers/media/pci/cx23885/cx23888-ir.c      |    2 -
>  drivers/media/pci/cx88/cx88-input.c         |   18 +++---
>  drivers/media/pci/dm1105/dm1105.c           |    1 
>  drivers/media/pci/saa7134/saa7134-input.c   |   14 +++--
>  drivers/media/pci/saa7134/saa7134.h         |    2 -
>  drivers/media/rc/Makefile                   |    3 +
>  drivers/media/rc/ati_remote.c               |    1 
>  drivers/media/rc/ene_ir.c                   |    9 +--
>  drivers/media/rc/fintek-cir.c               |    7 +-
>  drivers/media/rc/gpio-ir-recv.c             |    9 +--
>  drivers/media/rc/iguanair.c                 |    7 +-
>  drivers/media/rc/img-ir/img-ir-raw.c        |    7 +-
>  drivers/media/rc/imon.c                     |    1 
>  drivers/media/rc/ite-cir.c                  |    9 +--
>  drivers/media/rc/mceusb.c                   |    7 +-
>  drivers/media/rc/nuvoton-cir.c              |    7 +-
>  drivers/media/rc/rc-core-priv.h             |   10 ++-
>  drivers/media/rc/rc-ir-raw.c                |   39 +++++++++----
>  drivers/media/rc/rc-loopback.c              |    7 +-
>  drivers/media/rc/rc-main.c                  |   36 +-----------
>  drivers/media/rc/redrat3.c                  |    7 +-
>  drivers/media/rc/streamzap.c                |    7 +-
>  drivers/media/rc/ttusbir.c                  |    9 +--
>  drivers/media/rc/winbond-cir.c              |    9 +--
>  drivers/media/usb/dvb-usb-v2/dvb_usb.h      |    5 +-
>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |   12 +++-
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |    2 -
>  drivers/media/usb/dvb-usb/dvb-usb-remote.c  |    9 ++-
>  drivers/media/usb/dvb-usb/dvb-usb.h         |    5 +-
>  drivers/media/usb/dvb-usb/technisat-usb2.c  |    2 -
>  drivers/media/usb/em28xx/em28xx-input.c     |    5 --
>  drivers/media/usb/tm6000/tm6000-input.c     |    1 
>  include/media/rc-core.h                     |   73 +-----------------------
>  include/media/rc-ir-raw.h                   |   83 +++++++++++++++++++++++++++
>  38 files changed, 222 insertions(+), 225 deletions(-)
>  create mode 100644 include/media/rc-ir-raw.h
> 
> diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
> index 273043e..f6938f4 100644
> --- a/drivers/media/common/siano/smsir.c
> +++ b/drivers/media/common/siano/smsir.c
> @@ -87,14 +87,13 @@ int sms_ir_init(struct smscore_device_t *coredev)
>  #endif
>  
>  	dev->priv = coredev;
> -	dev->driver_type = RC_DRIVER_IR_RAW;
>  	dev->allowed_protocols = RC_BIT_ALL;
>  	dev->map_name = sms_get_board(board_id)->rc_codes;
>  	dev->driver_name = MODULE_NAME;
>  
>  	sms_log("Input device (IR) %s is set for key events", dev->input_name);
>  
> -	err = rc_register_device(dev);
> +	err = rc_register_ir_raw_device(dev);
>  	if (err < 0) {
>  		sms_err("Failed to register device");
>  		rc_free_device(dev);
> @@ -108,7 +107,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
>  void sms_ir_exit(struct smscore_device_t *coredev)
>  {
>  	if (coredev->ir.dev)
> -		rc_unregister_device(coredev->ir.dev);
> +		rc_unregister_ir_raw_device(coredev->ir.dev);
>  
>  	sms_log("");
>  }
> diff --git a/drivers/media/common/siano/smsir.h b/drivers/media/common/siano/smsir.h
> index fc8b792..05a2b01 100644
> --- a/drivers/media/common/siano/smsir.h
> +++ b/drivers/media/common/siano/smsir.h
> @@ -28,7 +28,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
>  #define __SMS_IR_H__
>  
>  #include <linux/input.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #define IR_DEFAULT_TIMEOUT		100
>  
> diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
> index e6588ee..119d4e8 100644
> --- a/drivers/media/i2c/cx25840/cx25840-ir.c
> +++ b/drivers/media/i2c/cx25840/cx25840-ir.c
> @@ -25,7 +25,7 @@
>  #include <linux/kfifo.h>
>  #include <linux/module.h>
>  #include <media/cx25840.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #include "cx25840-core.h"
>  
> diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
> index 1940c18..e2ba28d 100644
> --- a/drivers/media/pci/cx23885/cx23885-input.c
> +++ b/drivers/media/pci/cx23885/cx23885-input.c
> @@ -36,7 +36,7 @@
>   */
>  
>  #include <linux/slab.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  #include <media/v4l2-subdev.h>
>  
>  #include "cx23885.h"
> @@ -258,7 +258,6 @@ int cx23885_input_init(struct cx23885_dev *dev)
>  	struct cx23885_kernel_ir *kernel_ir;
>  	struct rc_dev *rc;
>  	char *rc_map;
> -	enum rc_driver_type driver_type;
>  	unsigned long allowed_protos;
>  
>  	int ret;
> @@ -276,28 +275,24 @@ int cx23885_input_init(struct cx23885_dev *dev)
>  	case CX23885_BOARD_HAUPPAUGE_HVR1290:
>  	case CX23885_BOARD_HAUPPAUGE_HVR1250:
>  		/* Integrated CX2388[58] IR controller */
> -		driver_type = RC_DRIVER_IR_RAW;
>  		allowed_protos = RC_BIT_ALL;
>  		/* The grey Hauppauge RC-5 remote */
>  		rc_map = RC_MAP_HAUPPAUGE;
>  		break;
>  	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
>  		/* Integrated CX23885 IR controller */
> -		driver_type = RC_DRIVER_IR_RAW;
>  		allowed_protos = RC_BIT_NEC;
>  		/* The grey Terratec remote with orange buttons */
>  		rc_map = RC_MAP_NEC_TERRATEC_CINERGY_XS;
>  		break;
>  	case CX23885_BOARD_TEVII_S470:
>  		/* Integrated CX23885 IR controller */
> -		driver_type = RC_DRIVER_IR_RAW;
>  		allowed_protos = RC_BIT_ALL;
>  		/* A guess at the remote */
>  		rc_map = RC_MAP_TEVII_NEC;
>  		break;
>  	case CX23885_BOARD_MYGICA_X8507:
>  		/* Integrated CX23885 IR controller */
> -		driver_type = RC_DRIVER_IR_RAW;
>  		allowed_protos = RC_BIT_ALL;
>  		/* A guess at the remote */
>  		rc_map = RC_MAP_TOTAL_MEDIA_IN_HAND_02;
> @@ -305,7 +300,6 @@ int cx23885_input_init(struct cx23885_dev *dev)
>  	case CX23885_BOARD_TBS_6980:
>  	case CX23885_BOARD_TBS_6981:
>  		/* Integrated CX23885 IR controller */
> -		driver_type = RC_DRIVER_IR_RAW;
>  		allowed_protos = RC_BIT_ALL;
>  		/* A guess at the remote */
>  		rc_map = RC_MAP_TBS_NEC;
> @@ -345,7 +339,6 @@ int cx23885_input_init(struct cx23885_dev *dev)
>  		rc->input_id.product = dev->pci->device;
>  	}
>  	rc->dev.parent = &dev->pci->dev;
> -	rc->driver_type = driver_type;
>  	rc->allowed_protocols = allowed_protos;
>  	rc->priv = kernel_ir;
>  	rc->open = cx23885_input_ir_open;
> @@ -355,7 +348,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
>  
>  	/* Go */
>  	dev->kernel_ir = kernel_ir;
> -	ret = rc_register_device(rc);
> +	ret = rc_register_ir_raw_device(rc);
>  	if (ret)
>  		goto err_out_stop;
>  
> @@ -379,7 +372,7 @@ void cx23885_input_fini(struct cx23885_dev *dev)
>  
>  	if (dev->kernel_ir == NULL)
>  		return;
> -	rc_unregister_device(dev->kernel_ir->rc);
> +	rc_unregister_ir_raw_device(dev->kernel_ir->rc);
>  	kfree(dev->kernel_ir->phys);
>  	kfree(dev->kernel_ir->name);
>  	kfree(dev->kernel_ir);
> diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
> index 2c951de..c4961f8 100644
> --- a/drivers/media/pci/cx23885/cx23888-ir.c
> +++ b/drivers/media/pci/cx23885/cx23888-ir.c
> @@ -25,7 +25,7 @@
>  #include <linux/slab.h>
>  
>  #include <media/v4l2-device.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #include "cx23885.h"
>  #include "cx23888-ir.h"
> diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
> index cb587ce..2b68ede 100644
> --- a/drivers/media/pci/cx88/cx88-input.c
> +++ b/drivers/media/pci/cx88/cx88-input.c
> @@ -29,7 +29,7 @@
>  #include <linux/module.h>
>  
>  #include "cx88.h"
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #define MODULE_NAME "cx88xx"
>  
> @@ -474,20 +474,17 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
>  	dev->open = cx88_ir_open;
>  	dev->close = cx88_ir_close;
>  	dev->scancode_mask = hardware_mask;
> +	ir->core = core;
> +	core->ir = ir;
>  
>  	if (ir->sampling) {
> -		dev->driver_type = RC_DRIVER_IR_RAW;
>  		dev->timeout = 10 * 1000 * 1000; /* 10 ms */
> +		err = rc_register_ir_raw_device(dev);
>  	} else {
> -		dev->driver_type = RC_DRIVER_SCANCODE;
>  		dev->allowed_protocols = rc_type;
> +		err = rc_register_device(dev);
>  	}
>  
> -	ir->core = core;
> -	core->ir = ir;
> -
> -	/* all done */
> -	err = rc_register_device(dev);
>  	if (err)
>  		goto err_out_free;
>  
> @@ -509,7 +506,10 @@ int cx88_ir_fini(struct cx88_core *core)
>  		return 0;
>  
>  	cx88_ir_stop(core);
> -	rc_unregister_device(ir->dev);
> +	if (ir->sampling)
> +		rc_unregister_ir_raw_device(ir->dev);
> +	else
> +		rc_unregister_device(ir->dev);
>  	kfree(ir);
>  
>  	/* done */
> diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
> index e8826c5..015aa07 100644
> --- a/drivers/media/pci/dm1105/dm1105.c
> +++ b/drivers/media/pci/dm1105/dm1105.c
> @@ -752,7 +752,6 @@ static int dm1105_ir_init(struct dm1105_dev *dm1105)
>  
>  	dev->driver_name = MODULE_NAME;
>  	dev->map_name = RC_MAP_DM1105_NEC;
> -	dev->driver_type = RC_DRIVER_SCANCODE;
>  	dev->input_name = "DVB on-card IR receiver";
>  	dev->input_phys = dm1105->ir.input_phys;
>  	dev->input_id.bustype = BUS_PCI;
> diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
> index 4ba61ff..27a3f48 100644
> --- a/drivers/media/pci/saa7134/saa7134-input.c
> +++ b/drivers/media/pci/saa7134/saa7134-input.c
> @@ -864,9 +864,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  	rc->priv = dev;
>  	rc->open = saa7134_ir_open;
>  	rc->close = saa7134_ir_close;
> -	if (raw_decode)
> -		rc->driver_type = RC_DRIVER_IR_RAW;
> -
>  	rc->input_name = ir->name;
>  	rc->input_phys = ir->phys;
>  	rc->input_id.bustype = BUS_PCI;
> @@ -882,7 +879,11 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  	rc->map_name = ir_codes;
>  	rc->driver_name = MODULE_NAME;
>  
> -	err = rc_register_device(rc);
> +	if (raw_decode)
> +		err = rc_register_ir_raw_device(rc);
> +	else
> +		err = rc_register_device(rc);
> +
>  	if (err)
>  		goto err_out_free;
>  
> @@ -901,7 +902,10 @@ void saa7134_input_fini(struct saa7134_dev *dev)
>  		return;
>  
>  	saa7134_ir_stop(dev);
> -	rc_unregister_device(dev->remote->dev);
> +	if (dev->remote->raw_decode)
> +		rc_unregister_ir_raw_device(dev->remote->dev);
> +	else
> +		rc_unregister_device(dev->remote->dev);
>  	kfree(dev->remote);
>  	dev->remote = NULL;
>  }
> diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
> index 2474e84..5a25486 100644
> --- a/drivers/media/pci/saa7134/saa7134.h
> +++ b/drivers/media/pci/saa7134/saa7134.h
> @@ -39,7 +39,7 @@
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/tuner.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  #include <media/ir-kbd-i2c.h>
>  #include <media/videobuf-dma-sg.h>
>  #include <sound/core.h>
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index 661f449..ac39628 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -1,8 +1,9 @@
> -rc-core-objs	:= rc-main.o rc-keytable.o rc-ir-raw.o
> +rc-core-objs	:= rc-main.o rc-keytable.o
>  
>  obj-y += keymaps/
>  
>  obj-$(CONFIG_RC_CORE) += rc-core.o
> +obj-$(CONFIG_RC_CORE) += rc-ir-raw.o
>  obj-$(CONFIG_LIRC) += lirc_dev.o
>  obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
>  obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
> diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
> index 6ef5716..170aac8 100644
> --- a/drivers/media/rc/ati_remote.c
> +++ b/drivers/media/rc/ati_remote.c
> @@ -784,7 +784,6 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
>  	struct rc_dev *rdev = ati_remote->rdev;
>  
>  	rdev->priv = ati_remote;
> -	rdev->driver_type = RC_DRIVER_SCANCODE;
>  	rdev->allowed_protocols = RC_BIT_OTHER;
>  	rdev->driver_name = "ati_remote";
>  
> diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
> index cab5da9..57d61e5 100644
> --- a/drivers/media/rc/ene_ir.c
> +++ b/drivers/media/rc/ene_ir.c
> @@ -39,7 +39,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  #include "ene_ir.h"
>  
>  static int sample_period;
> @@ -1053,7 +1053,6 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
>  	if (!dev->hw_learning_and_tx_capable)
>  		learning_mode_force = false;
>  
> -	rdev->driver_type = RC_DRIVER_IR_RAW;
>  	rdev->allowed_protocols = RC_BIT_ALL;
>  	rdev->priv = dev;
>  	rdev->open = ene_open;
> @@ -1083,7 +1082,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
>  	device_set_wakeup_capable(&pnp_dev->dev, true);
>  	device_set_wakeup_enable(&pnp_dev->dev, true);
>  
> -	error = rc_register_device(rdev);
> +	error = rc_register_ir_raw_device(rdev);
>  	if (error < 0)
>  		goto exit_free_dev_rdev;
>  
> @@ -1104,7 +1103,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
>  exit_release_hw_io:
>  	release_region(dev->hw_io, ENE_IO_SIZE);
>  exit_unregister_device:
> -	rc_unregister_device(rdev);
> +	rc_unregister_ir_raw_device(rdev);
>  	rdev = NULL;
>  exit_free_dev_rdev:
>  	rc_free_device(rdev);
> @@ -1125,7 +1124,7 @@ static void ene_remove(struct pnp_dev *pnp_dev)
>  
>  	free_irq(dev->irq, dev);
>  	release_region(dev->hw_io, ENE_IO_SIZE);
> -	rc_unregister_device(dev->rdev);
> +	rc_unregister_ir_raw_device(dev->rdev);
>  	kfree(dev);
>  }
>  
> diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
> index f000faf..ce2db15 100644
> --- a/drivers/media/rc/fintek-cir.c
> +++ b/drivers/media/rc/fintek-cir.c
> @@ -32,7 +32,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  #include <linux/pci_ids.h>
>  
>  #include "fintek-cir.h"
> @@ -540,7 +540,6 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
>  
>  	/* Set up the rc device */
>  	rdev->priv = fintek;
> -	rdev->driver_type = RC_DRIVER_IR_RAW;
>  	rdev->allowed_protocols = RC_BIT_ALL;
>  	rdev->open = fintek_open;
>  	rdev->close = fintek_close;
> @@ -569,7 +568,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
>  			FINTEK_DRIVER_NAME, (void *)fintek))
>  		goto exit_free_cir_addr;
>  
> -	ret = rc_register_device(rdev);
> +	ret = rc_register_ir_raw_device(rdev);
>  	if (ret)
>  		goto exit_free_irq;
>  
> @@ -609,7 +608,7 @@ static void fintek_remove(struct pnp_dev *pdev)
>  	free_irq(fintek->cir_irq, fintek);
>  	release_region(fintek->cir_addr, fintek->cir_port_len);
>  
> -	rc_unregister_device(fintek->rdev);
> +	rc_unregister_ir_raw_device(fintek->rdev);
>  
>  	kfree(fintek);
>  }
> diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
> index 7d01560..ff30bdb 100644
> --- a/drivers/media/rc/gpio-ir-recv.c
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -20,7 +20,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/platform_device.h>
>  #include <linux/irq.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  #include <media/gpio-ir-recv.h>
>  
>  #define GPIO_IR_DRIVER_NAME	"gpio-rc-recv"
> @@ -135,7 +135,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
>  	}
>  
>  	rcdev->priv = gpio_dev;
> -	rcdev->driver_type = RC_DRIVER_IR_RAW;
>  	rcdev->input_name = GPIO_IR_DEVICE_NAME;
>  	rcdev->input_phys = GPIO_IR_DEVICE_NAME "/input0";
>  	rcdev->input_id.bustype = BUS_HOST;
> @@ -161,7 +160,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
>  	if (rc < 0)
>  		goto err_gpio_direction_input;
>  
> -	rc = rc_register_device(rcdev);
> +	rc = rc_register_ir_raw_device(rcdev);
>  	if (rc < 0) {
>  		dev_err(&pdev->dev, "failed to register rc device\n");
>  		goto err_register_rc_device;
> @@ -179,7 +178,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
>  	return 0;
>  
>  err_request_irq:
> -	rc_unregister_device(rcdev);
> +	rc_unregister_ir_raw_device(rcdev);
>  	rcdev = NULL;
>  err_register_rc_device:
>  err_gpio_direction_input:
> @@ -196,7 +195,7 @@ static int gpio_ir_recv_remove(struct platform_device *pdev)
>  	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
>  
>  	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
> -	rc_unregister_device(gpio_dev->rcdev);
> +	rc_unregister_ir_raw_device(gpio_dev->rcdev);
>  	gpio_free(gpio_dev->gpio_nr);
>  	kfree(gpio_dev);
>  	return 0;
> diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
> index 8a4baf5..3b7327a 100644
> --- a/drivers/media/rc/iguanair.c
> +++ b/drivers/media/rc/iguanair.c
> @@ -25,7 +25,7 @@
>  #include <linux/usb/input.h>
>  #include <linux/slab.h>
>  #include <linux/completion.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #define DRIVER_NAME "iguanair"
>  #define BUF_SIZE 152
> @@ -513,7 +513,6 @@ static int iguanair_probe(struct usb_interface *intf,
>  	rc->input_phys = ir->phys;
>  	usb_to_input_id(ir->udev, &rc->input_id);
>  	rc->dev.parent = &intf->dev;
> -	rc->driver_type = RC_DRIVER_IR_RAW;
>  	rc->allowed_protocols = RC_BIT_ALL;
>  	rc->priv = ir;
>  	rc->open = iguanair_open;
> @@ -529,7 +528,7 @@ static int iguanair_probe(struct usb_interface *intf,
>  	iguanair_set_tx_carrier(rc, 38000);
>  	iguanair_set_tx_mask(rc, 0);
>  
> -	ret = rc_register_device(rc);
> +	ret = rc_register_ir_raw_device(rc);
>  	if (ret < 0) {
>  		dev_err(&intf->dev, "failed to register rc device %d", ret);
>  		goto out2;
> @@ -558,7 +557,7 @@ static void iguanair_disconnect(struct usb_interface *intf)
>  {
>  	struct iguanair *ir = usb_get_intfdata(intf);
>  
> -	rc_unregister_device(ir->rc);
> +	rc_unregister_ir_raw_device(ir->rc);
>  	usb_set_intfdata(intf, NULL);
>  	usb_kill_urb(ir->urb_in);
>  	usb_kill_urb(ir->urb_out);
> diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
> index 5b6d8e9..95a4da1 100644
> --- a/drivers/media/rc/img-ir/img-ir-raw.c
> +++ b/drivers/media/rc/img-ir/img-ir-raw.c
> @@ -8,7 +8,7 @@
>   */
>  
>  #include <linux/spinlock.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  #include "img-ir.h"
>  
>  #define ECHO_TIMEOUT_MS 150	/* ms between echos */
> @@ -112,10 +112,9 @@ int img_ir_probe_raw(struct img_ir_priv *priv)
>  	}
>  	rdev->priv = priv;
>  	rdev->input_name = "IMG Infrared Decoder Raw";
> -	rdev->driver_type = RC_DRIVER_IR_RAW;
>  
>  	/* Register raw decoder */
> -	error = rc_register_device(rdev);
> +	error = rc_register_ir_raw_device(rdev);
>  	if (error) {
>  		dev_err(priv->dev, "failed to register raw IR input device\n");
>  		rc_free_device(rdev);
> @@ -144,7 +143,7 @@ void img_ir_remove_raw(struct img_ir_priv *priv)
>  	img_ir_write(priv, IMG_IR_IRQ_CLEAR, IMG_IR_IRQ_EDGE);
>  	spin_unlock_irq(&priv->lock);
>  
> -	rc_unregister_device(rdev);
> +	rc_unregister_ir_raw_device(rdev);
>  
>  	del_timer_sync(&raw->timer);
>  }
> diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
> index 2461933..1aa2ac0 100644
> --- a/drivers/media/rc/imon.c
> +++ b/drivers/media/rc/imon.c
> @@ -1875,7 +1875,6 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
>  	rdev->dev.parent = ictx->dev;
>  
>  	rdev->priv = ictx;
> -	rdev->driver_type = RC_DRIVER_SCANCODE;
>  	rdev->allowed_protocols = RC_BIT_OTHER | RC_BIT_RC6_MCE; /* iMON PAD or MCE */
>  	rdev->change_protocol = imon_ir_change_protocol;
>  	rdev->driver_name = MOD_NAME;
> diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
> index 0d404a2..795fbc6 100644
> --- a/drivers/media/rc/ite-cir.c
> +++ b/drivers/media/rc/ite-cir.c
> @@ -40,7 +40,7 @@
>  #include <linux/slab.h>
>  #include <linux/input.h>
>  #include <linux/bitops.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  #include <linux/pci_ids.h>
>  
>  #include "ite-cir.h"
> @@ -1557,7 +1557,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
>  
>  	/* set up ir-core props */
>  	rdev->priv = itdev;
> -	rdev->driver_type = RC_DRIVER_IR_RAW;
>  	rdev->allowed_protocols = RC_BIT_ALL;
>  	rdev->open = ite_open;
>  	rdev->close = ite_close;
> @@ -1586,7 +1585,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
>  	rdev->driver_name = ITE_DRIVER_NAME;
>  	rdev->map_name = RC_MAP_RC6_MCE;
>  
> -	ret = rc_register_device(rdev);
> +	ret = rc_register_ir_raw_device(rdev);
>  	if (ret)
>  		goto exit_free_dev_rdev;
>  
> @@ -1607,7 +1606,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
>  exit_release_cir_addr:
>  	release_region(itdev->cir_addr, itdev->params.io_region_size);
>  exit_unregister_device:
> -	rc_unregister_device(rdev);
> +	rc_unregister_ir_raw_device(rdev);
>  	rdev = NULL;
>  exit_free_dev_rdev:
>  	rc_free_device(rdev);
> @@ -1634,7 +1633,7 @@ static void ite_remove(struct pnp_dev *pdev)
>  	free_irq(dev->cir_irq, dev);
>  	release_region(dev->cir_addr, dev->params.io_region_size);
>  
> -	rc_unregister_device(dev->rdev);
> +	rc_unregister_ir_raw_device(dev->rdev);
>  
>  	kfree(dev);
>  }
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index e0c8552..eac87ec 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -43,7 +43,7 @@
>  #include <linux/usb.h>
>  #include <linux/usb/input.h>
>  #include <linux/pm_wakeup.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #define DRIVER_VERSION	"1.92"
>  #define DRIVER_AUTHOR	"Jarod Wilson <jarod@redhat.com>"
> @@ -1217,7 +1217,6 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
>  	usb_to_input_id(ir->usbdev, &rc->input_id);
>  	rc->dev.parent = dev;
>  	rc->priv = ir;
> -	rc->driver_type = RC_DRIVER_IR_RAW;
>  	rc->allowed_protocols = RC_BIT_ALL;
>  	rc->timeout = MS_TO_NS(100);
>  	if (!ir->flags.no_tx) {
> @@ -1229,7 +1228,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
>  	rc->map_name = mceusb_model[ir->model].rc_map ?
>  			mceusb_model[ir->model].rc_map : RC_MAP_RC6_MCE;
>  
> -	ret = rc_register_device(rc);
> +	ret = rc_register_ir_raw_device(rc);
>  	if (ret < 0) {
>  		dev_err(dev, "remote dev registration failed");
>  		goto out;
> @@ -1414,7 +1413,7 @@ static void mceusb_dev_disconnect(struct usb_interface *intf)
>  		return;
>  
>  	ir->usbdev = NULL;
> -	rc_unregister_device(ir->rc);
> +	rc_unregister_ir_raw_device(ir->rc);
>  	usb_kill_urb(ir->urb_in);
>  	usb_free_urb(ir->urb_in);
>  	usb_free_coherent(dev, ir->len_in, ir->buf_in, ir->dma_in);
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 160d685..a8c9b5f 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -34,7 +34,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  #include <linux/pci_ids.h>
>  
>  #include "nuvoton-cir.h"
> @@ -1054,7 +1054,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
>  
>  	/* Set up the rc device */
>  	rdev->priv = nvt;
> -	rdev->driver_type = RC_DRIVER_IR_RAW;
>  	rdev->allowed_protocols = RC_BIT_ALL;
>  	rdev->open = nvt_open;
>  	rdev->close = nvt_close;
> @@ -1119,7 +1118,7 @@ exit_free_irq:
>  exit_release_cir_addr:
>  	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
>  exit_unregister_device:
> -	rc_unregister_device(rdev);
> +	rc_unregister_ir_raw_device(rdev);
>  	rdev = NULL;
>  exit_free_dev_rdev:
>  	rc_free_device(rdev);
> @@ -1147,7 +1146,7 @@ static void nvt_remove(struct pnp_dev *pdev)
>  	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
>  	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
>  
> -	rc_unregister_device(nvt->rdev);
> +	rc_unregister_ir_raw_device(nvt->rdev);
>  
>  	kfree(nvt);
>  }
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index 0159836..0b32ef8 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -19,6 +19,12 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
> +
> +enum rc_driver_type {
> +	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
> +	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
> +};
>  
>  struct ir_raw_handler {
>  	struct list_head list;
> @@ -148,12 +154,8 @@ static inline bool is_timing_event(struct ir_raw_event ev)
>  /*
>   * Routines from rc-raw.c to be used internally and by decoders
>   */
> -u64 ir_raw_get_allowed_protocols(void);
> -int ir_raw_event_register(struct rc_dev *dev);
> -void ir_raw_event_unregister(struct rc_dev *dev);
>  int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
>  void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
> -void ir_raw_init(void);
>  
>  /*
>   * Methods from rc-keytable.c to be used internally
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index 5ed8007..86f5aa7 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -16,6 +16,7 @@
>  #include <linux/kthread.h>
>  #include <linux/mutex.h>
>  #include <linux/kmod.h>
> +#include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/freezer.h>
>  #include "rc-core-priv.h"
> @@ -269,8 +270,7 @@ void ir_raw_event_handle(struct rc_dev *dev)
>  EXPORT_SYMBOL_GPL(ir_raw_event_handle);
>  
>  /* used internally by the sysfs interface */
> -u64
> -ir_raw_get_allowed_protocols(void)
> +static u64 ir_raw_get_allowed_protocols(struct rc_dev *dev)
>  {
>  	u64 protocols;
>  	mutex_lock(&ir_raw_handler_lock);
> @@ -287,7 +287,7 @@ static int change_protocol(struct rc_dev *dev, u64 *rc_type) {
>  /*
>   * Used to (un)register raw event clients
>   */
> -int ir_raw_event_register(struct rc_dev *dev)
> +int rc_register_ir_raw_device(struct rc_dev *dev)
>  {
>  	int rc;
>  	struct ir_raw_handler *handler;
> @@ -301,14 +301,16 @@ int ir_raw_event_register(struct rc_dev *dev)
>  
>  	dev->raw->dev = dev;
>  	dev->enabled_protocols = ~0;
> +	dev->get_protocols = ir_raw_get_allowed_protocols;
> +	dev->driver_type = RC_DRIVER_IR_RAW;
>  	dev->change_protocol = change_protocol;
> +	spin_lock_init(&dev->raw->lock);
>  	rc = kfifo_alloc(&dev->raw->kfifo,
>  			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
>  			 GFP_KERNEL);
>  	if (rc < 0)
>  		goto out;
>  
> -	spin_lock_init(&dev->raw->lock);
>  	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
>  				       dev_name(&dev->dev));
>  
> @@ -317,6 +319,10 @@ int ir_raw_event_register(struct rc_dev *dev)
>  		goto out;
>  	}
>  
> +	rc = rc_register_device(dev);
> +	if (rc < 0)
> +		goto out_thread;
> +
>  	mutex_lock(&ir_raw_handler_lock);
>  	list_add_tail(&dev->raw->list, &ir_raw_client_list);
>  	list_for_each_entry(handler, &ir_raw_handler_list, list)
> @@ -326,13 +332,16 @@ int ir_raw_event_register(struct rc_dev *dev)
>  
>  	return 0;
>  
> +out_thread:
> +	kthread_stop(dev->raw->thread);
>  out:
>  	kfree(dev->raw);
>  	dev->raw = NULL;
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(rc_register_ir_raw_device);
>  
> -void ir_raw_event_unregister(struct rc_dev *dev)
> +void rc_unregister_ir_raw_device(struct rc_dev *dev)
>  {
>  	struct ir_raw_handler *handler;
>  
> @@ -351,7 +360,9 @@ void ir_raw_event_unregister(struct rc_dev *dev)
>  	kfifo_free(&dev->raw->kfifo);
>  	kfree(dev->raw);
>  	dev->raw = NULL;
> +	rc_unregister_device(dev);
>  }
> +EXPORT_SYMBOL_GPL(rc_unregister_ir_raw_device);
>  
>  /*
>   * Extension interface - used to register the IR decoders
> @@ -387,10 +398,11 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
>  }
>  EXPORT_SYMBOL(ir_raw_handler_unregister);
>  
> -void ir_raw_init(void)
> +static struct work_struct wq_load;
> +
> +static void rc_ir_raw_init_decoders(struct work_struct *work)
>  {
>  	/* Load the decoder modules */
> -
>  	load_nec_decode();
>  	load_rc5_decode();
>  	load_rc6_decode();
> @@ -400,8 +412,15 @@ void ir_raw_init(void)
>  	load_sharp_decode();
>  	load_mce_kbd_decode();
>  	load_lirc_codec();
> +}
>  
> -	/* If needed, we may later add some init code. In this case,
> -	   it is needed to change the CONFIG_MODULE test at rc-core.h
> -	 */
> +static int __init rc_ir_raw_init(void)
> +{
> +	INIT_WORK(&wq_load, rc_ir_raw_init_decoders);
> +	schedule_work(&wq_load);
> +	return 0;
>  }
> +subsys_initcall(rc_ir_raw_init);
> +
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
> index f201395..343c8d0 100644
> --- a/drivers/media/rc/rc-loopback.c
> +++ b/drivers/media/rc/rc-loopback.c
> @@ -26,7 +26,7 @@
>  #include <linux/device.h>
>  #include <linux/module.h>
>  #include <linux/sched.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #define DRIVER_NAME	"rc-loopback"
>  #define dprintk(x...)	if (debug) printk(KERN_INFO DRIVER_NAME ": " x)
> @@ -227,7 +227,6 @@ static int __init loop_init(void)
>  	rc->input_id.version	= 1;
>  	rc->driver_name		= DRIVER_NAME;
>  	rc->priv		= &loopdev;
> -	rc->driver_type		= RC_DRIVER_IR_RAW;
>  	rc->allowed_protocols	= RC_BIT_ALL;
>  	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
>  	rc->min_timeout		= 1;
> @@ -250,7 +249,7 @@ static int __init loop_init(void)
>  	loopdev.learning	= false;
>  	loopdev.carrierreport	= false;
>  
> -	ret = rc_register_device(rc);
> +	ret = rc_register_ir_raw_device(rc);
>  	if (ret < 0) {
>  		printk(KERN_ERR DRIVER_NAME ": rc_dev registration failed\n");
>  		rc_free_device(rc);
> @@ -263,7 +262,7 @@ static int __init loop_init(void)
>  
>  static void __exit loop_exit(void)
>  {
> -	rc_unregister_device(loopdev.dev);
> +	rc_unregister_ir_raw_device(loopdev.dev);
>  }
>  
>  module_init(loop_init);
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 8729d0a..7caca4f 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -343,10 +343,7 @@ static ssize_t show_protocols(struct device *device,
>  
>  	if (fattr->type == RC_FILTER_NORMAL) {
>  		enabled = dev->enabled_protocols;
> -		if (dev->raw)
> -			allowed = ir_raw_get_allowed_protocols();
> -		else
> -			allowed = dev->allowed_protocols;
> +		allowed = dev->allowed_protocols;
>  	} else {
>  		enabled = dev->enabled_wakeup_protocols;
>  		allowed = dev->allowed_wakeup_protocols;
> @@ -919,10 +916,7 @@ void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx)
>  	rx->rx_enabled = 0x1;
>  	rx->rx_connected = 0x1;
>  	rx->protocols_enabled[0] = dev->enabled_protocols;
> -	if (dev->driver_type == RC_DRIVER_SCANCODE)
> -		rx->protocols_supported[0] = dev->allowed_protocols;
> -	else
> -		rx->protocols_supported[0] = ir_raw_get_allowed_protocols();
> +	rx->protocols_supported[0] = dev->allowed_protocols;
>  	rx->timeout = dev->timeout;
>  	rx->timeout_min = dev->min_timeout;
>  	rx->timeout_max = dev->max_timeout;
> @@ -1135,9 +1129,6 @@ static void rc_dev_release(struct device *device)
>  {
>  	struct rc_dev *dev = to_rc_dev(device);
>  
> -	if (dev->driver_type == RC_DRIVER_IR_RAW)
> -		ir_raw_event_unregister(dev);
> -
>  	kfifo_free(&dev->txfifo);
>  	kfree(dev);
>  	module_put(THIS_MODULE);
> @@ -1267,7 +1258,6 @@ EXPORT_SYMBOL_GPL(rc_free_device);
>  
>  int rc_register_device(struct rc_dev *dev)
>  {
> -	static bool raw_init = false; /* raw decoders loaded? */
>  	struct rc_map *rc_map = NULL;
>  	int attr = 0;
>  	int minor;
> @@ -1290,18 +1280,6 @@ int rc_register_device(struct rc_dev *dev)
>  			goto out_minor;
>  	}
>  
> -	if (dev->driver_type == RC_DRIVER_IR_RAW) {
> -		/* Load raw decoders, if they aren't already */
> -		if (!raw_init) {
> -			IR_dprintk(1, "Loading raw decoders\n");
> -			ir_raw_init();
> -			raw_init = true;
> -		}
> -		rc = ir_raw_event_register(dev);
> -		if (rc < 0)
> -			goto out_minor;
> -	}
> -
>  	dev->dev.groups = dev->sysfs_groups;
>  	dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
>  	if (dev->s_filter)
> @@ -1319,13 +1297,13 @@ int rc_register_device(struct rc_dev *dev)
>  		u64 rc_type = (1 << rc_map->scan[0].protocol);
>  		rc = dev->change_protocol(dev, &rc_type);
>  		if (rc < 0)
> -			goto out_raw;
> +			goto out_minor;
>  		dev->enabled_protocols = rc_type;
>  	}
>  
>  	rc = cdev_add(&dev->cdev, dev->dev.devt, 1);
>  	if (rc)
> -		goto out_raw;
> +		goto out_minor;
>  
>  	rc = device_add(&dev->dev);
>  	if (rc)
> @@ -1347,9 +1325,6 @@ out_dev:
>  	device_del(&dev->dev);
>  out_cdev:
>  	cdev_del(&dev->cdev);
> -out_raw:
> -	if (dev->driver_type == RC_DRIVER_IR_RAW)
> -		ir_raw_event_unregister(dev);
>  out_minor:
>  	ida_simple_remove(&rc_ida, minor);
>  	return rc;
> @@ -1377,9 +1352,6 @@ void rc_unregister_device(struct rc_dev *dev)
>  
>  	cdev_del(&dev->cdev);
>  
> -	if (dev->driver_type == RC_DRIVER_IR_RAW)
> -		ir_raw_event_unregister(dev);
> -
>  	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
>  		rc_remove_keytable(dev, i);
>  
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> index 3a931a5..17974bf 100644
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -52,7 +52,7 @@
>  #include <linux/slab.h>
>  #include <linux/usb.h>
>  #include <linux/usb/input.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  /* Driver Information */
>  #define DRIVER_AUTHOR "Jarod Wilson <jarod@redhat.com>"
> @@ -936,7 +936,6 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
>  	usb_to_input_id(rr3->udev, &rc->input_id);
>  	rc->dev.parent = dev;
>  	rc->priv = rr3;
> -	rc->driver_type = RC_DRIVER_IR_RAW;
>  	rc->allowed_protocols = RC_BIT_ALL;
>  	rc->timeout = US_TO_NS(2750);
>  	rc->tx_ir = redrat3_transmit_ir;
> @@ -945,7 +944,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
>  	rc->rx_resolution = US_TO_NS(2);
>  	rc->map_name = RC_MAP_HAUPPAUGE;
>  
> -	ret = rc_register_device(rc);
> +	ret = rc_register_ir_raw_device(rc);
>  	if (ret < 0) {
>  		dev_err(dev, "remote dev registration failed\n");
>  		goto out;
> @@ -1114,7 +1113,7 @@ static void redrat3_dev_disconnect(struct usb_interface *intf)
>  		return;
>  
>  	usb_set_intfdata(intf, NULL);
> -	rc_unregister_device(rr3->rc);
> +	rc_unregister_ir_raw_device(rr3->rc);
>  	led_classdev_unregister(&rr3->led);
>  	del_timer_sync(&rr3->rx_timeout);
>  	redrat3_delete(rr3, udev);
> diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
> index 2659f66..149e824 100644
> --- a/drivers/media/rc/streamzap.c
> +++ b/drivers/media/rc/streamzap.c
> @@ -36,7 +36,7 @@
>  #include <linux/slab.h>
>  #include <linux/usb.h>
>  #include <linux/usb/input.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #define DRIVER_VERSION	"1.61"
>  #define DRIVER_NAME	"streamzap"
> @@ -314,12 +314,11 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
>  	usb_to_input_id(sz->usbdev, &rdev->input_id);
>  	rdev->dev.parent = dev;
>  	rdev->priv = sz;
> -	rdev->driver_type = RC_DRIVER_IR_RAW;
>  	rdev->allowed_protocols = RC_BIT_ALL;
>  	rdev->driver_name = DRIVER_NAME;
>  	rdev->map_name = RC_MAP_STREAMZAP;
>  
> -	ret = rc_register_device(rdev);
> +	ret = rc_register_ir_raw_device(rdev);
>  	if (ret < 0) {
>  		dev_err(dev, "remote input device register failed\n");
>  		goto out;
> @@ -484,7 +483,7 @@ static void streamzap_disconnect(struct usb_interface *interface)
>  		return;
>  
>  	sz->usbdev = NULL;
> -	rc_unregister_device(sz->rdev);
> +	rc_unregister_ir_raw_device(sz->rdev);
>  	usb_kill_urb(sz->urb_in);
>  	usb_free_urb(sz->urb_in);
>  	usb_free_coherent(usbdev, sz->buf_in_len, sz->buf_in, sz->dma_in);
> diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
> index bc214e2..19317e2 100644
> --- a/drivers/media/rc/ttusbir.c
> +++ b/drivers/media/rc/ttusbir.c
> @@ -23,7 +23,7 @@
>  #include <linux/usb/input.h>
>  #include <linux/slab.h>
>  #include <linux/leds.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #define DRIVER_NAME	"ttusbir"
>  #define DRIVER_DESC	"TechnoTrend USB IR Receiver"
> @@ -317,7 +317,6 @@ static int ttusbir_probe(struct usb_interface *intf,
>  	rc->input_phys = tt->phys;
>  	usb_to_input_id(tt->udev, &rc->input_id);
>  	rc->dev.parent = &intf->dev;
> -	rc->driver_type = RC_DRIVER_IR_RAW;
>  	rc->allowed_protocols = RC_BIT_ALL;
>  	rc->priv = tt;
>  	rc->driver_name = DRIVER_NAME;
> @@ -329,7 +328,7 @@ static int ttusbir_probe(struct usb_interface *intf,
>  	 */
>  	rc->rx_resolution = NS_PER_BIT;
>  
> -	ret = rc_register_device(rc);
> +	ret = rc_register_ir_raw_device(rc);
>  	if (ret) {
>  		dev_err(&intf->dev, "failed to register rc device %d\n", ret);
>  		goto out2;
> @@ -347,7 +346,7 @@ static int ttusbir_probe(struct usb_interface *intf,
>  
>  	return 0;
>  out3:
> -	rc_unregister_device(rc);
> +	rc_unregister_ir_raw_device(rc);
>  	rc = NULL;
>  out2:
>  	led_classdev_unregister(&tt->led);
> @@ -378,7 +377,7 @@ static void ttusbir_disconnect(struct usb_interface *intf)
>  
>  	tt->udev = NULL;
>  
> -	rc_unregister_device(tt->rc);
> +	rc_unregister_ir_raw_device(tt->rc);
>  	led_classdev_unregister(&tt->led);
>  	for (i = 0; i < NUM_URBS; i++) {
>  		usb_kill_urb(tt->urb[i]);
> diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
> index 8871109..07da3e0 100644
> --- a/drivers/media/rc/winbond-cir.c
> +++ b/drivers/media/rc/winbond-cir.c
> @@ -54,7 +54,7 @@
>  #include <linux/slab.h>
>  #include <linux/wait.h>
>  #include <linux/sched.h>
> -#include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #define DRVNAME "winbond-cir"
>  
> @@ -1051,7 +1051,6 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
>  		goto exit_unregister_led;
>  	}
>  
> -	data->dev->driver_type = RC_DRIVER_IR_RAW;
>  	data->dev->driver_name = DRVNAME;
>  	data->dev->input_name = WBCIR_NAME;
>  	data->dev->input_phys = "wbcir/cir0";
> @@ -1071,7 +1070,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
>  	data->dev->rx_resolution = US_TO_NS(2);
>  	data->dev->allowed_protocols = RC_BIT_ALL;
>  
> -	err = rc_register_device(data->dev);
> +	err = rc_register_ir_raw_device(data->dev);
>  	if (err)
>  		goto exit_free_rc;
>  
> @@ -1117,7 +1116,7 @@ exit_release_ebase:
>  exit_release_wbase:
>  	release_region(data->wbase, WAKEUP_IOMEM_LEN);
>  exit_unregister_device:
> -	rc_unregister_device(data->dev);
> +	rc_unregister_ir_raw_device(data->dev);
>  	data->dev = NULL;
>  exit_free_rc:
>  	rc_free_device(data->dev);
> @@ -1148,7 +1147,7 @@ wbcir_remove(struct pnp_dev *device)
>  	/* Clear BUFF_EN, END_EN, MATCH_EN */
>  	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
>  
> -	rc_unregister_device(data->dev);
> +	rc_unregister_ir_raw_device(data->dev);
>  
>  	led_classdev_unregister(&data->led);
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> index 124b4ba..ccdf0c6 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> @@ -25,6 +25,7 @@
>  #include <linux/usb/input.h>
>  #include <linux/firmware.h>
>  #include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #include "dvb_frontend.h"
>  #include "dvb_demux.h"
> @@ -131,7 +132,7 @@ struct dvb_usb_driver_info {
>   * @change_protocol: callback to change protocol
>   * @query: called to query an event from the device
>   * @interval: time in ms between two queries
> - * @driver_type: used to point if a device supports raw mode
> + * @rc_raw: used to point if a device supports raw mode
>   * @bulk_mode: device supports bulk mode for rc (disable polling mode)
>   */
>  struct dvb_usb_rc {
> @@ -140,7 +141,7 @@ struct dvb_usb_rc {
>  	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int (*query) (struct dvb_usb_device *d);
>  	unsigned int interval;
> -	enum rc_driver_type driver_type;
> +	bool rc_raw;
>  	bool bulk_mode;
>  };
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> index eaa76ef..ea84894b 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> @@ -163,12 +163,15 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
>  	/* TODO: likely RC-core should took const char * */
>  	dev->driver_name = (char *) d->props->driver_name;
>  	dev->map_name = d->rc.map_name;
> -	dev->driver_type = d->rc.driver_type;
>  	dev->allowed_protocols = d->rc.allowed_protos;
>  	dev->change_protocol = d->rc.change_protocol;
>  	dev->priv = d;
>  
> -	ret = rc_register_device(dev);
> +	if (d->rc.rc_raw)
> +		ret = rc_register_ir_raw_device(dev);
> +	else
> +		ret = rc_register_device(dev);
> +
>  	if (ret < 0) {
>  		rc_free_device(dev);
>  		goto err;
> @@ -201,7 +204,10 @@ static int dvb_usbv2_remote_exit(struct dvb_usb_device *d)
>  
>  	if (d->rc_dev) {
>  		cancel_delayed_work_sync(&d->rc_query_work);
> -		rc_unregister_device(d->rc_dev);
> +		if (d->rc.rc_raw)
> +			rc_unregister_ir_raw_device(d->rc_dev);
> +		else
> +			rc_unregister_device(d->rc_dev);
>  		d->rc_dev = NULL;
>  	}
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 15f1e70..0412862 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1373,7 +1373,7 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
>  		return rtl28xx_wr_reg(d, IR_RX_IE, 0x00);
>  
>  	rc->allowed_protos = RC_BIT_ALL;
> -	rc->driver_type = RC_DRIVER_IR_RAW;
> +	rc->rc_raw = true;
>  	rc->query = rtl2832u_rc_query;
>  	rc->interval = 400;
>  
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
> index 5986626..88574d0 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
> @@ -273,14 +273,17 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
>  	dev->map_name = d->props.rc.core.rc_codes;
>  	dev->change_protocol = d->props.rc.core.change_protocol;
>  	dev->allowed_protocols = d->props.rc.core.allowed_protos;
> -	dev->driver_type = d->props.rc.core.driver_type;
>  	usb_to_input_id(d->udev, &dev->input_id);
>  	dev->input_name = "IR-receiver inside an USB DVB receiver";
>  	dev->input_phys = d->rc_phys;
>  	dev->dev.parent = &d->udev->dev;
>  	dev->priv = d;
>  
> -	err = rc_register_device(dev);
> +	if (d->props.rc.core.rc_raw)
> +		err = rc_register_ir_raw_device(dev);
> +	else
> +		err = rc_register_device(dev);
> +
>  	if (err < 0) {
>  		rc_free_device(dev);
>  		return err;
> @@ -341,6 +344,8 @@ int dvb_usb_remote_exit(struct dvb_usb_device *d)
>  		cancel_delayed_work_sync(&d->rc_query_work);
>  		if (d->props.rc.mode == DVB_RC_LEGACY)
>  			input_unregister_device(d->input_dev);
> +		else if (d->props.rc.core.rc_raw)
> +			rc_unregister_ir_raw_device(d->rc_dev);
>  		else
>  			rc_unregister_device(d->rc_dev);
>  	}
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
> index ce4c4e3..8e4b31e 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/usb/dvb-usb/dvb-usb.h
> @@ -15,6 +15,7 @@
>  #include <linux/firmware.h>
>  #include <linux/mutex.h>
>  #include <media/rc-core.h>
> +#include <media/rc-ir-raw.h>
>  
>  #include "dvb_frontend.h"
>  #include "dvb_demux.h"
> @@ -191,7 +192,7 @@ struct dvb_rc_legacy {
>   * @rc_codes: name of rc codes table
>   * @protocol: type of protocol(s) currently used by the driver
>   * @allowed_protos: protocol(s) supported by the driver
> - * @driver_type: Used to point if a device supports raw mode
> + * @rc_raw: Used to point if a device supports raw mode
>   * @change_protocol: callback to change protocol
>   * @rc_query: called to query an event event.
>   * @rc_interval: time in ms between two queries.
> @@ -201,7 +202,7 @@ struct dvb_rc {
>  	char *rc_codes;
>  	u64 protocol;
>  	u64 allowed_protos;
> -	enum rc_driver_type driver_type;
> +	bool rc_raw;
>  	int (*change_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	char *module_name;
>  	int (*rc_query) (struct dvb_usb_device *d);
> diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
> index 98d24ae..288f24c 100644
> --- a/drivers/media/usb/dvb-usb/technisat-usb2.c
> +++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
> @@ -733,7 +733,7 @@ static struct dvb_usb_device_properties technisat_usb2_devices = {
>  		.module_name = "technisat-usb2",
>  		.rc_query    = technisat_usb2_rc_query,
>  		.allowed_protos = RC_BIT_ALL,
> -		.driver_type    = RC_DRIVER_IR_RAW,
> +		.rc_raw      = true,
>  	}
>  };
>  
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 1232e32..8fdb515 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -856,9 +856,6 @@ static int em28xx_ir_suspend(struct em28xx *dev)
>  	if (ir)
>  		cancel_delayed_work_sync(&ir->work);
>  	cancel_delayed_work_sync(&dev->buttons_query_work);
> -	/* is canceling delayed work sufficient or does the rc event
> -	   kthread needs stopping? kthread is stopped in
> -	   ir_raw_event_unregister() */
>  	return 0;
>  }
>  
> @@ -870,8 +867,6 @@ static int em28xx_ir_resume(struct em28xx *dev)
>  		return 0;
>  
>  	em28xx_info("Resuming input extension");
> -	/* if suspend calls ir_raw_event_unregister(), the should call
> -	   ir_raw_event_register() */
>  	if (ir)
>  		schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
>  	if (dev->num_button_polling_addresses)
> diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
> index 7c9b58d..1d4b191 100644
> --- a/drivers/media/usb/tm6000/tm6000-input.c
> +++ b/drivers/media/usb/tm6000/tm6000-input.c
> @@ -452,7 +452,6 @@ int tm6000_ir_init(struct tm6000_core *dev)
>  		ir->polling = 50;
>  		INIT_DELAYED_WORK(&ir->work, tm6000_ir_handle_key);
>  	}
> -	rc->driver_type = RC_DRIVER_SCANCODE;
>  
>  	snprintf(ir->name, sizeof(ir->name), "tm5600/60x0 IR (%s)",
>  						dev->name);
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 228510e..25c1d38 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -177,11 +177,6 @@ struct rc_keytable_ioctl {
>  	char name[RC_KEYTABLE_NAME_SIZE];
>  } __packed;
>  
> -enum rc_driver_type {
> -	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
> -	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
> -};
> -
>  /* This is used for the input EVIOC[SG]KEYCODE_V2 ioctls */
>  struct rc_scancode {
>  	__u16 protocol;
> @@ -304,6 +299,7 @@ enum rc_filter_type {
>   * @rx_resolution : resolution (in ns) of input sampler
>   * @tx_resolution: resolution (in ns) of output sampler
>   * @change_protocol: allow changing the protocol used on hardware decoders
> + * @get_protocols: returns a bitmask of allowed protocols
>   * @change_wakeup_protocol: allow changing the protocol used for wakeup
>   *	filtering
>   * @open: callback to allow drivers to enable polling/irq when IR input device
> @@ -347,7 +343,7 @@ struct rc_dev {
>  	wait_queue_head_t		txwait;
>  	wait_queue_head_t		rxwait;
>  	struct ir_raw_event_ctrl	*raw;
> -	enum rc_driver_type		driver_type;
> +	unsigned			driver_type;
>  	bool				idle;
>  	u64				allowed_protocols;
>  	u64				enabled_protocols;
> @@ -363,6 +359,7 @@ struct rc_dev {
>  	u32				max_timeout;
>  	u32				rx_resolution;
>  	u32				tx_resolution;
> +	u64				(*get_protocols)(struct rc_dev *dev);
>  	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int				(*change_wakeup_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int				(*open)(struct rc_dev *dev);
> @@ -461,70 +458,6 @@ static inline void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protoco
>  	rc_do_keydown(dev, protocol, scancode, toggle, false);
>  }
>  
> -/*
> - * From rc-raw.c
> - * The Raw interface is specific to InfraRed. It may be a good idea to
> - * split it later into a separate header.
> - */
> -
> -enum raw_event_type {
> -	IR_SPACE        = (1 << 0),
> -	IR_PULSE        = (1 << 1),
> -	IR_START_EVENT  = (1 << 2),
> -	IR_STOP_EVENT   = (1 << 3),
> -};
> -
> -struct ir_raw_event {
> -	union {
> -		u32             duration;
> -
> -		struct {
> -			u32     carrier;
> -			u8      duty_cycle;
> -		};
> -	};
> -
> -	unsigned                pulse:1;
> -	unsigned                reset:1;
> -	unsigned                timeout:1;
> -	unsigned                carrier_report:1;
> -};
> -
> -#define DEFINE_IR_RAW_EVENT(event) \
> -	struct ir_raw_event event = { \
> -		{ .duration = 0 } , \
> -		.pulse = 0, \
> -		.reset = 0, \
> -		.timeout = 0, \
> -		.carrier_report = 0 }
> -
> -static inline void init_ir_raw_event(struct ir_raw_event *ev)
> -{
> -	memset(ev, 0, sizeof(*ev));
> -}
> -
> -#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
> -#define US_TO_NS(usec)		((usec) * 1000)
> -#define MS_TO_US(msec)		((msec) * 1000)
> -#define MS_TO_NS(msec)		((msec) * 1000 * 1000)
> -
> -void ir_raw_event_handle(struct rc_dev *dev);
> -int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
> -int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
> -int ir_raw_event_store_with_filter(struct rc_dev *dev,
> -				struct ir_raw_event *ev);
> -void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
> -int ir_raw_get_tx_event(struct rc_dev *dev, struct rc_event *ev);
> -
> -static inline void ir_raw_event_reset(struct rc_dev *dev)
> -{
> -	DEFINE_IR_RAW_EVENT(ev);
> -	ev.reset = true;
> -
> -	ir_raw_event_store(dev, &ev);
> -	ir_raw_event_handle(dev);
> -}
> -
>  /* extract mask bits out of data and pack them into the result */
>  static inline u32 ir_extract_bits(u32 data, u32 mask)
>  {
> diff --git a/include/media/rc-ir-raw.h b/include/media/rc-ir-raw.h
> new file mode 100644
> index 0000000..dad3eb2
> --- /dev/null
> +++ b/include/media/rc-ir-raw.h
> @@ -0,0 +1,83 @@
> +/*
> + * Remote Controller core header
> + *
> + * Copyright (C) 2009-2010 by Mauro Carvalho Chehab
> + *
> + * This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + */
> +
> +#ifndef _RC_IR_RAW
> +#define _RC_IR_RAW
> +
> +#include <linux/spinlock.h>
> +#include <linux/kfifo.h>
> +#include <media/rc-core.h>
> +
> +enum raw_event_type {
> +	IR_SPACE        = (1 << 0),
> +	IR_PULSE        = (1 << 1),
> +	IR_START_EVENT  = (1 << 2),
> +	IR_STOP_EVENT   = (1 << 3),
> +};
> +
> +struct ir_raw_event {
> +	union {
> +		u32             duration;
> +
> +		struct {
> +			u32     carrier;
> +			u8      duty_cycle;
> +		};
> +	};
> +
> +	unsigned                pulse:1;
> +	unsigned                reset:1;
> +	unsigned                timeout:1;
> +	unsigned                carrier_report:1;
> +};
> +
> +#define DEFINE_IR_RAW_EVENT(event) \
> +	struct ir_raw_event event = { \
> +		{ .duration = 0 } , \
> +		.pulse = 0, \
> +		.reset = 0, \
> +		.timeout = 0, \
> +		.carrier_report = 0 }
> +
> +static inline void init_ir_raw_event(struct ir_raw_event *ev)
> +{
> +	memset(ev, 0, sizeof(*ev));
> +}
> +
> +#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
> +#define US_TO_NS(usec)		((usec) * 1000)
> +#define MS_TO_US(msec)		((msec) * 1000)
> +#define MS_TO_NS(msec)		((msec) * 1000 * 1000)
> +
> +void ir_raw_event_handle(struct rc_dev *dev);
> +int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
> +int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
> +int ir_raw_event_store_with_filter(struct rc_dev *dev,
> +				struct ir_raw_event *ev);
> +void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
> +int ir_raw_get_tx_event(struct rc_dev *dev, struct rc_event *ev);
> +int rc_register_ir_raw_device(struct rc_dev *dev);
> +void rc_unregister_ir_raw_device(struct rc_dev *dev);
> +
> +static inline void ir_raw_event_reset(struct rc_dev *dev)
> +{
> +	DEFINE_IR_RAW_EVENT(ev);
> +	ev.reset = true;
> +
> +	ir_raw_event_store(dev, &ev);
> +	ir_raw_event_handle(dev);
> +}
> +
> +#endif /* _RC_IR_RAW */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
