Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49037 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab1INDUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 23:20:07 -0400
Received: by bkbzt4 with SMTP id zt4so1140718bkb.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 20:20:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com> <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 13 Sep 2011 23:19:45 -0400
Message-ID: <CAMjpGUfKehYY7_Tw+aUZ1hxtxxiO2i9hR1ENqw1MqibppYNKmw@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 4/4] v4l2: add blackfin capture
 bridge driver
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
> --- /dev/null
> +++ b/drivers/media/video/blackfin/Kconfig
> @@ -0,0 +1,10 @@
> +config VIDEO_BLACKFIN_CAPTURE
> +       tristate "Blackfin Video Capture Driver"
> +       depends on VIDEO_DEV && BLACKFIN
> +       select VIDEOBUF2_DMA_CONTIG

since the code needs i2c, this needs to list I2C under depends

> --- /dev/null
> +++ b/drivers/media/video/blackfin/bfin_capture.c
>
> +#include <linux/moduleparam.h>
> +#include <linux/version.h>
> +#include <linux/clk.h>

i think at least these three are unused and should get punted

> +static int __devinit bcap_probe(struct platform_device *pdev)
> +{
> +       struct bcap_device *bcap_dev;
> +       struct video_device *vfd;
> +       struct i2c_adapter *i2c_adap;

you need to include linux/i2c.h for this

> +static struct platform_driver bcap_driver = {
> +       .driver = {
> +               .name   = CAPTURE_DRV_NAME,
> +               .owner = THIS_MODULE,
> +       },
> +       .probe = bcap_probe,
> +       .remove = __devexit_p(bcap_remove),
> +};

no suspend/resume ? :)

> +MODULE_DESCRIPTION("Analog Devices video capture driver");

should mention the device part name in the desc

> --- /dev/null
> +++ b/drivers/media/video/blackfin/ppi.c
>
> +struct ppi_if *create_ppi_instance(const struct ppi_info *info)
> +void delete_ppi_instance(struct ppi_if *ppi)

should be ppi_{create,delete}_instance to match existing ppi_xxx style
-mike
