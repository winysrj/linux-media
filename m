Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34685 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752561AbZBRS0Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 13:26:16 -0500
Date: Wed, 18 Feb 2009 19:26:22 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
To: Alexey Klimov <klimov.linux@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] soc-camera: board bindings for camera host driver
 for i.MX3x SoCs
In-Reply-To: <208cbae30812231459k7fd4308cw93140e97e8b7593c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0902181916310.6371@axis700.grange>
References: <Pine.LNX.4.64.0812231225520.5188@axis700.grange>
 <Pine.LNX.4.64.0812231232500.5188@axis700.grange>
 <208cbae30812231459k7fd4308cw93140e97e8b7593c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(moved to the new v4l list)

Hi Alexey,

On Wed, 24 Dec 2008, Alexey Klimov wrote:

> Hello, Guennadi

See, I didn't ignore your email and didn't forget about it:-)

> > +static struct platform_device mx3_camera = {
> > +       .name           = "mx3-camera",
> 
> You include mach/mx3_camera.h in this file. Why don't define
> MX3_CAM_DRV_NAME "mx3-camera" in mach/mx3_camera.h file(you defined it
> in /drivers/media/video/mx3_camera.c file) ? So you can use variable
> in that c-file and here, in this file.

Well, to be honest, I cannot give you a definite answer "why." But if you 
do something like

grep -r "[[:space:]]\.name[[:space:]]*=" arch/arm/

you'll see, that almost all platform devices define names explicitly 
without using macros. I only found a few occurrences following your 
suggestion:

arch/arm/mach-sa1100/jornada720.c:      .name           = S1D_DEVICENAME,
arch/arm/mach-orion5x/common.c: .name           = MV643XX_ETH_NAME,
arch/arm/mach-orion5x/common.c: .name           = MV64XXX_I2C_CTLR_NAME,
arch/arm/mach-orion5x/common.c: .name           = MV_XOR_SHARED_NAME,
arch/arm/mach-orion5x/common.c: .name           = MV_XOR_NAME,
...

(and a few more with the same Marvell device names.) I think, the logic 
behind using an explicit string is to show "I know what I am talking 
about," i.e., I know what driver I want to link to, and if the name 
changes, I better fail. But I'm not sure which way is actually better.

> > +       /* ATA power off, disable ATA Buffer, enable CSI buffer  */
> > +       ret = gpio_request(IOMUX_TO_GPIO(MX31_PIN_CSI_D4), "CSI D4");
> > +       if (!ret) {
> > +               mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D4, IOMUX_CONFIG_GPIO));
> > +               gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_CSI_D4), 0);
> > +       } else
> > +               printk(KERN_WARNING "Could not get GPIO %u\n",
> > +                      IOMUX_TO_GPIO(MX31_PIN_CSI_D4));
> 
> If people wanted to define where this message come from do this
> information in this printk will be enough ? May be it's better to add
> module name here(or something), is it ?
> 
> > +
> > +       ret = gpio_request(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), "CSI D5");
> > +       if (!ret) {
> > +               mxc_iomux_mode(IOMUX_MODE(MX31_PIN_CSI_D5, IOMUX_CONFIG_GPIO));
> > +               gpio_direction_output(IOMUX_TO_GPIO(MX31_PIN_CSI_D5), 1);
> > +       } else
> > +               printk(KERN_WARNING "Could not get GPIO %u\n",
> > +                      IOMUX_TO_GPIO(MX31_PIN_CSI_D5));
> 
> And the same here.

Yes, you're right, I'll change that.

> May be i'm wrong, Guennadi

Maybe you're not:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
