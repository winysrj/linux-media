Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:16503 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbZHJJkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 05:40:10 -0400
Subject: Re: [PATCHv15 6/8] FM TX: si4713: Add files to handle si4713 i2c
 device
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
In-Reply-To: <1249729833-24975-7-git-send-email-eduardo.valentin@nokia.com>
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-2-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-4-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-5-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-6-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-7-git-send-email-eduardo.valentin@nokia.com>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 12:39:50 +0300
Message-Id: <1249897190.31807.120.camel@masi.ntc.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On Sat, 2009-08-08 at 13:10 +0200, Valentin Eduardo (Nokia-D/Helsinki)
wrote:

...

> +/*
> + * I2C driver interface
> + */
> +/* si4713_probe - probe for the device */
> +static int si4713_probe(struct i2c_client *client,
> +                                       const struct i2c_device_id *id)
> +{
> +       struct si4713_device *sdev;
> +       int rval;
> +
> +       sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
> +       if (!sdev) {
> +               dev_err(&client->dev, "Failed to alloc video device.\n");
> +               rval = -ENOMEM;
> +               goto exit;
> +       }
> +
> +       sdev->platform_data = client->dev.platform_data;
> +       if (!sdev->platform_data) {
> +               v4l2_err(&sdev->sd, "No platform data registered.\n");
                           ^^^^^^^^^
It looks like sdev-sd is still uninitialized here... 

> +               rval = -ENODEV;
> +               goto free_sdev;
> +       }
> +
> +       v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
                               ^^^^^^^^^^
> +

B.R.
Matti





