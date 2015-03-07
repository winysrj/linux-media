Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:57079 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbbCGXHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 18:07:39 -0500
Message-ID: <1425769657.2300.55.camel@x220>
Subject: Re: [PATCH v3] media: i2c: add support for omnivision's ov2659
 sensor
From: Paul Bolle <pebolle@tiscali.nl>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org
Date: Sun, 08 Mar 2015 00:07:37 +0100
In-Reply-To: <1425741700-23506-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425741700-23506-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2015-03-07 at 15:21 +0000, Lad Prabhakar wrote:
> --- /dev/null
> +++ b/drivers/media/i2c/ov2659.c
> @@ -0,0 +1,1495 @@
> +/*
> + * Omnivision OV2659 CMOS Image Sensor driver
> + *
> + * Copyright (C) 2015 Texas Instruments, Inc.
> + *
> + * Benoit Parrot <bparrot@ti.com>
> + * Lad, Prabhakar <prabhakar.csengg@gmail.com>
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */

This states the license of this modules is GPL v2.

> +MODULE_LICENSE("GPL");

So you probably want
    MODULE_LICENSE("GPL v2");

here.

(If you think this is a bit silly, and somewhere I think so too, you're
invited to jump into the discussion starting at
https://lkml.org/lkml/2015/3/7/119 .)



Paul Bolle

