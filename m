Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3655 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab2EQJEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 05:04:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] [resend] radio-sf16fmr2: add PnP support for SF16-FMD2
Date: Thu, 17 May 2012 11:04:30 +0200
Cc: linux-media@vger.kernel.org
References: <201205171055.01352.linux@rainbow-software.org>
In-Reply-To: <201205171055.01352.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205171104.30437.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu May 17 2012 10:55:01 Ondrej Zary wrote:
> Add PnP support to radio-sf16fmr2 driver to support SF16-FMD2 card (SB16 +
> TEA5757). The driver can now handle two cards (FMR2 is hardwired to 0x384,
> FMD2 can be put at 0x384 or 0x284 by PnP).
> Tested with both SF16-FMR2 and SF16-FMD2 (the can work at the same time by
> using kernel parameter "pnp_reserve_io=0x384,2" so the FMD2 is put at 0x284).
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -329,7 +329,7 @@ config RADIO_SF16FMI
>  	  module will be called radio-sf16fmi.
>  
>  config RADIO_SF16FMR2
> -	tristate "SF16FMR2 Radio"
> +	tristate "SF16-FMR2/SF16-FMD2 Radio"
>  	depends on ISA && VIDEO_V4L2 && SND
>  	---help---
>  	  Choose Y here if you have one of these FM radio cards.
> --- a/drivers/media/radio/radio-sf16fmr2.c
> +++ b/drivers/media/radio/radio-sf16fmr2.c
> @@ -1,4 +1,4 @@
> -/* SF16-FMR2 radio driver for Linux
> +/* SF16-FMR2 and SF16-FMD2 radio driver for Linux
>   * Copyright (c) 2011 Ondrej Zary
>   *
>   * Original driver was (c) 2000-2002 Ziglio Frediano, freddy77@angelfire.com
> @@ -13,15 +13,19 @@
>  #include <linux/ioport.h>	/* request_region		*/
>  #include <linux/io.h>		/* outb, outb_p			*/
>  #include <linux/isa.h>
> +#include <linux/pnp.h>
>  #include <sound/tea575x-tuner.h>
>  
>  MODULE_AUTHOR("Ondrej Zary");
> -MODULE_DESCRIPTION("MediaForte SF16-FMR2 FM radio card driver");
> +MODULE_DESCRIPTION("MediaForte SF16-FMR2 and SF16-FMD2 FM radio card driver");
>  MODULE_LICENSE("GPL");
>  
> -static int radio_nr = -1;
> -module_param(radio_nr, int, 0444);
> -MODULE_PARM_DESC(radio_nr, "Radio device number");
> +/* these cards can only use two different ports (0x384 and 0x284) */
> +#define FMR2_MAX 2
> +
> +static int radio_nr[FMR2_MAX] = { [0 ... (FMR2_MAX - 1)] = -1 };
> +module_param_array(radio_nr, int, NULL, 0444);
> +MODULE_PARM_DESC(radio_nr, "Radio device numbers");
>  
>  struct fmr2 {
>  	int io;
> @@ -29,9 +33,15 @@ struct fmr2 {
>  	struct snd_tea575x tea;
>  	struct v4l2_ctrl *volume;
>  	struct v4l2_ctrl *balance;
> +	bool is_fmd2;
>  };
>  
> -/* the port is hardwired so no need to support multiple cards */
> +static int num_fmr2_cards;
> +static struct fmr2 *fmr2_cards[FMR2_MAX];
> +static bool isa_registered;
> +static bool pnp_registered;
> +
> +/* the port is hardwired on SF16-FMR2 */
>  #define FMR2_PORT	0x384
>  
>  /* TEA575x tuner pins */
> @@ -174,7 +184,8 @@ static int fmr2_tea_ext_init(struct snd_tea575x *tea)
>  {
>  	struct fmr2 *fmr2 = tea->private_data;
>  
> -	if (inb(fmr2->io) & FMR2_HASVOL) {
> +	/* FMR2 can have volume control, FMD2 can't (uses SB16 mixer) */
> +	if (!fmr2->is_fmd2 && inb(fmr2->io) & FMR2_HASVOL) {
>  		fmr2->volume = v4l2_ctrl_new_std(&tea->ctrl_handler, &fmr2_ctrl_ops, V4L2_CID_AUDIO_VOLUME, 0, 68, 2, 56);
>  		fmr2->balance = v4l2_ctrl_new_std(&tea->ctrl_handler, &fmr2_ctrl_ops, V4L2_CID_AUDIO_BALANCE, -68, 68, 2, 0);
>  		if (tea->ctrl_handler.error) {
> @@ -186,22 +197,28 @@ static int fmr2_tea_ext_init(struct snd_tea575x *tea)
>  	return 0;
>  }
>  
> -static int __devinit fmr2_probe(struct device *pdev, unsigned int dev)
> +static struct pnp_device_id fmr2_pnp_ids[] __devinitdata = {
> +	{ .id = "MFRad13" }, /* tuner subdevice of SF16-FMD2 */
> +	{ .id = "" }
> +};
> +MODULE_DEVICE_TABLE(pnp, fmr2_pnp_ids);
> +
> +static int __devinit fmr2_probe(struct fmr2 *fmr2, struct device *pdev, int io)
>  {
> -	struct fmr2 *fmr2;
> -	int err;
> +	int err, i;
> +	char *card_name = fmr2->is_fmd2 ? "SF16-FMD2" : "SF16-FMR2";
>  
> -	fmr2 = kzalloc(sizeof(*fmr2), GFP_KERNEL);
> -	if (fmr2 == NULL)
> -		return -ENOMEM;
> +	/* avoid errors if a card was already registered at given port */
> +	for (i = 0; i < num_fmr2_cards; i++)
> +		if (io == fmr2_cards[i]->io)
> +			return -EBUSY;
>  
> -	strlcpy(fmr2->v4l2_dev.name, dev_name(pdev),
> -			sizeof(fmr2->v4l2_dev.name));
> -	fmr2->io = FMR2_PORT;
> +	strlcpy(fmr2->v4l2_dev.name, "radio-sf16fmr2",
> +			sizeof(fmr2->v4l2_dev.name)),
> +	fmr2->io = io;
>  
>  	if (!request_region(fmr2->io, 2, fmr2->v4l2_dev.name)) {
>  		printk(KERN_ERR "radio-sf16fmr2: I/O port 0x%x already in use\n", fmr2->io);
> -		kfree(fmr2);
>  		return -EBUSY;
>  	}
>  
> @@ -210,56 +227,121 @@ static int __devinit fmr2_probe(struct device *pdev, unsigned int dev)
>  	if (err < 0) {
>  		v4l2_err(&fmr2->v4l2_dev, "Could not register v4l2_device\n");
>  		release_region(fmr2->io, 2);
> -		kfree(fmr2);
>  		return err;
>  	}
>  	fmr2->tea.v4l2_dev = &fmr2->v4l2_dev;
>  	fmr2->tea.private_data = fmr2;
> -	fmr2->tea.radio_nr = radio_nr;
> +	fmr2->tea.radio_nr = radio_nr[num_fmr2_cards];
>  	fmr2->tea.ops = &fmr2_tea_ops;
>  	fmr2->tea.ext_init = fmr2_tea_ext_init;
> -	strlcpy(fmr2->tea.card, "SF16-FMR2", sizeof(fmr2->tea.card));
> -	snprintf(fmr2->tea.bus_info, sizeof(fmr2->tea.bus_info), "ISA:%s",
> -			fmr2->v4l2_dev.name);
> +	strlcpy(fmr2->tea.card, card_name, sizeof(fmr2->tea.card));
> +	snprintf(fmr2->tea.bus_info, sizeof(fmr2->tea.bus_info), "%s:%s",
> +			fmr2->is_fmd2 ? "PnP" : "ISA", dev_name(pdev));
>  
>  	if (snd_tea575x_init(&fmr2->tea)) {
>  		printk(KERN_ERR "radio-sf16fmr2: Unable to detect TEA575x tuner\n");
>  		release_region(fmr2->io, 2);
> -		kfree(fmr2);
>  		return -ENODEV;
>  	}
>  
> -	printk(KERN_INFO "radio-sf16fmr2: SF16-FMR2 radio card at 0x%x.\n", fmr2->io);
> +	printk(KERN_INFO "radio-sf16fmr2: %s radio card at 0x%x.\n",
> +			card_name, fmr2->io);
>  	return 0;
>  }
>  
> -static int __exit fmr2_remove(struct device *pdev, unsigned int dev)
> +static int __devinit fmr2_isa_match(struct device *pdev, unsigned int ndev)
> +{
> +	struct fmr2 *fmr2 = kzalloc(sizeof(*fmr2), GFP_KERNEL);
> +	if (!fmr2)
> +		return 0;
> +
> +	if (fmr2_probe(fmr2, pdev, FMR2_PORT)) {
> +		kfree(fmr2);
> +		return 0;
> +	}
> +	dev_set_drvdata(pdev, fmr2);
> +	fmr2_cards[num_fmr2_cards++] = fmr2;
> +
> +	return 1;
> +}
> +
> +static int __devinit fmr2_pnp_probe(struct pnp_dev *pdev,
> +				const struct pnp_device_id *id)
>  {
> -	struct fmr2 *fmr2 = dev_get_drvdata(pdev);
> +	int ret;
> +	struct fmr2 *fmr2 = kzalloc(sizeof(*fmr2), GFP_KERNEL);
> +	if (!fmr2)
> +		return -ENOMEM;
>  
> +	fmr2->is_fmd2 = true;
> +	ret = fmr2_probe(fmr2, &pdev->dev, pnp_port_start(pdev, 0));
> +	if (ret) {
> +		kfree(fmr2);
> +		return ret;
> +	}
> +	pnp_set_drvdata(pdev, fmr2);
> +	fmr2_cards[num_fmr2_cards++] = fmr2;
> +
> +	return 0;
> +}
> +
> +static void __devexit fmr2_remove(struct fmr2 *fmr2)
> +{
>  	snd_tea575x_exit(&fmr2->tea);
>  	release_region(fmr2->io, 2);
>  	v4l2_device_unregister(&fmr2->v4l2_dev);
>  	kfree(fmr2);
> +}
> +
> +static int __devexit fmr2_isa_remove(struct device *pdev, unsigned int ndev)
> +{
> +	fmr2_remove(dev_get_drvdata(pdev));
> +	dev_set_drvdata(pdev, NULL);
> +
>  	return 0;
>  }
>  
> -struct isa_driver fmr2_driver = {
> -	.probe		= fmr2_probe,
> -	.remove		= fmr2_remove,
> +static void __devexit fmr2_pnp_remove(struct pnp_dev *pdev)
> +{
> +	fmr2_remove(pnp_get_drvdata(pdev));
> +	pnp_set_drvdata(pdev, NULL);
> +}
> +
> +struct isa_driver fmr2_isa_driver = {
> +	.match		= fmr2_isa_match,
> +	.remove		= __devexit_p(fmr2_isa_remove),
>  	.driver		= {
>  		.name	= "radio-sf16fmr2",
>  	},
>  };
>  
> +struct pnp_driver fmr2_pnp_driver = {
> +	.name		= "radio-sf16fmr2",
> +	.id_table	= fmr2_pnp_ids,
> +	.probe		= fmr2_pnp_probe,
> +	.remove		= __devexit_p(fmr2_pnp_remove),
> +};
> +
>  static int __init fmr2_init(void)
>  {
> -	return isa_register_driver(&fmr2_driver, 1);
> +	int ret;
> +
> +	ret = pnp_register_driver(&fmr2_pnp_driver);
> +	if (!ret)
> +		pnp_registered = true;
> +	ret = isa_register_driver(&fmr2_isa_driver, 1);
> +	if (!ret)
> +		isa_registered = true;
> +
> +	return (pnp_registered || isa_registered) ? 0 : ret;
>  }
>  
>  static void __exit fmr2_exit(void)
>  {
> -	isa_unregister_driver(&fmr2_driver);
> +	if (pnp_registered)
> +		pnp_unregister_driver(&fmr2_pnp_driver);
> +	if (isa_registered)
> +		isa_unregister_driver(&fmr2_isa_driver);
>  }
>  
>  module_init(fmr2_init);
> 
> 
> 
