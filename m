Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:65292 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbZHGMj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 08:39:27 -0400
Subject: Re: [PATCHv14 6/8] FM TX: si4713: Add files to handle si4713 i2c
 device
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
In-Reply-To: <1248707530-4068-7-git-send-email-eduardo.valentin@nokia.com>
References: <1248707530-4068-1-git-send-email-eduardo.valentin@nokia.com>
	 <1248707530-4068-2-git-send-email-eduardo.valentin@nokia.com>
	 <1248707530-4068-3-git-send-email-eduardo.valentin@nokia.com>
	 <1248707530-4068-4-git-send-email-eduardo.valentin@nokia.com>
	 <1248707530-4068-5-git-send-email-eduardo.valentin@nokia.com>
	 <1248707530-4068-6-git-send-email-eduardo.valentin@nokia.com>
	 <1248707530-4068-7-git-send-email-eduardo.valentin@nokia.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 15:38:53 +0300
Message-Id: <1249648733.31807.102.camel@masi.ntc.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

On Mon, 2009-07-27 at 17:12 +0200, Valentin Eduardo (Nokia-D/Helsinki)
wrote:
> This patch adds files to control si4713 devices.
> Internal functions to control device properties

....

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
> +               v4l2_err(&sdev->sd, "Failed to alloc video device.\n");
                           ^^^^^^^^^^
> +               rval = -ENOMEM;
> +               goto exit;
> +       }

....

You shouldn't do sdev->sd if sdev is NULL.

Cheers,
Matti







