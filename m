Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33090 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752140AbbETKUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 06:20:09 -0400
Date: Wed, 20 May 2015 13:19:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	cooloney@gmail.com, g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
Subject: Re: [PATCH 4/5] leds: aat1290: Pass dev and dev->of_node to
 v4l2_flash_init()
Message-ID: <20150520101933.GB8365@valkosipuli.retiisi.org.uk>
References: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
 <1432076645-4799-5-git-send-email-sakari.ailus@iki.fi>
 <555C582E.8000807@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555C582E.8000807@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, May 20, 2015 at 11:47:26AM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 05/20/2015 01:04 AM, Sakari Ailus wrote:
> >Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >---
> >  drivers/leds/leds-aat1290.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
> >index c656a2d..71bf6bb 100644
> >--- a/drivers/leds/leds-aat1290.c
> >+++ b/drivers/leds/leds-aat1290.c
> >@@ -524,9 +524,8 @@ static int aat1290_led_probe(struct platform_device *pdev)
> >  	led_cdev->dev->of_node = sub_node;
> >
> >  	/* Create V4L2 Flash subdev. */
> >-	led->v4l2_flash = v4l2_flash_init(fled_cdev,
> >-					  &v4l2_flash_ops,
> >-					  &v4l2_sd_cfg);
> >+	led->v4l2_flash = v4l2_flash_init(dev, NULL, fled_cdev,
> >+					  &v4l2_flash_ops, &v4l2_sd_cfg);
> 
> Here the first argument should be led_cdev->dev, not dev, which is
> &pdev->dev, whereas led_cdev->dev is returned by
> device_create_with_groups (it takes dev as a parent) called from
> led_classdev_register.

Should it? The underlying hardware is still the I2C device, not the LED
class device node.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
