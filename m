Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45555 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753001AbbEUKGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 06:06:09 -0400
Date: Thu, 21 May 2015 13:06:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	cooloney@gmail.com, g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
Subject: Re: [PATCH 4/5] leds: aat1290: Pass dev and dev->of_node to
 v4l2_flash_init()
Message-ID: <20150521100604.GG8601@valkosipuli.retiisi.org.uk>
References: <1432076645-4799-1-git-send-email-sakari.ailus@iki.fi>
 <1432076645-4799-5-git-send-email-sakari.ailus@iki.fi>
 <555C582E.8000807@samsung.com>
 <555C63CF.2020304@samsung.com>
 <20150520122714.GC8365@valkosipuli.retiisi.org.uk>
 <555C906D.4030902@samsung.com>
 <20150520143143.GA8601@valkosipuli.retiisi.org.uk>
 <555D9D2F.9020500@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555D9D2F.9020500@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Thu, May 21, 2015 at 10:54:07AM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 05/20/2015 04:31 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Wed, May 20, 2015 at 03:47:25PM +0200, Jacek Anaszewski wrote:
> >...
> >>>>>>--- a/drivers/leds/leds-aat1290.c
> >>>>>>+++ b/drivers/leds/leds-aat1290.c
> >>>>>>@@ -524,9 +524,8 @@ static int aat1290_led_probe(struct
> >>>>>>platform_device *pdev)
> >>>>>>      led_cdev->dev->of_node = sub_node;
> >>>>>>
> >>>>>>      /* Create V4L2 Flash subdev. */
> >>>>>>-    led->v4l2_flash = v4l2_flash_init(fled_cdev,
> >>>>>>-                      &v4l2_flash_ops,
> >>>>>>-                      &v4l2_sd_cfg);
> >>>>>>+    led->v4l2_flash = v4l2_flash_init(dev, NULL, fled_cdev,
> >>>>>>+                      &v4l2_flash_ops, &v4l2_sd_cfg);
> >>>>>
> >>>>>Here the first argument should be led_cdev->dev, not dev, which is
> >>>>>&pdev->dev, whereas led_cdev->dev is returned by
> >>>>>device_create_with_groups (it takes dev as a parent) called from
> >>>>>led_classdev_register.
> >>>>
> >>>>The reason for this is the fact that pdev->dev has its of_node
> >>>>field initialized, which makes v4l2_async trying to match
> >>>>subdev by parent node of a LED device, not by sub-LED related
> >>>>DT node.
> >>>
> >>>If v4l2_subdev->of_node is set, then it won't be replaced with one from
> >>>struct device. I.e. you need to provide of_node pointer only if it's
> >>>different from dev->of_node.
> >>>
> >>
> >>It will always be different since dev->of_node pointer is related
> >>to the main DT node of LED device, whereas each LED connected to it
> >>must be expressed in the form of sub-node, as
> >>Documentation/devicetree/bindings/leds/common.txt DT states.
> >
> >You can still refer to the device's root device_node using a phandle.
> 
> Why should I need to refer to the device's root node?
> 
> What I meant here was that DT documentation enforces that even if
> there is a single LED connected to the device it has to be expressed
> as a sub-node anyway. Each LED will have to be matched by the phandle
> to the sub-node representing it. This implies that v4l2_subdev->of_node
> (related to sub-LED DT node) will be always different from dev->of_node
> (related to LED controller DT node).

>From driver point of view this makes no difference; it's just easier to
parse if you don't refer to the LEDs separately. I think this is a bit
special case; nowadays many LED flash controllers drive two LEDs.

> 
> >Say, if you have a LED flash controller with an indicator. It's intended to
> >be used together with the flash LED, and the existing as3645a driver exposes
> >it through the same sub-device. I think that'd make sense with LED class
> >driver as well (i.e. you'd have two LED class devices but a single
> >sub-device). Small changes to the wrapper would be needed.
> >
> 
> How the sub-device name should look like then? We would have to
> concatenate somehow both LED class device names?

It'd be different, i.e. there would be no flash or indicator in the name.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
