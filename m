Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41587 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3DVHSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 03:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de> <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 22 Apr 2013 12:47:46 +0530
Message-ID: <CA+V-a8uLsr8MkLs8rjEohqEo=7x-PJq37nhVuAUzsfF5j_uJiA@mail.gmail.com>
Subject: Re: [PATCH v9 02/20] V4L2: support asynchronous subdevice registration
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch!

On Fri, Apr 12, 2013 at 9:10 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Currently bridge device drivers register devices for all subdevices
> synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
> is attached to a video bridge device, the bridge driver will create an I2C
> device and wait for the respective I2C driver to probe. This makes linking
> of devices straight forward, but this approach cannot be used with
> intrinsically asynchronous and unordered device registration systems like
> the Flattened Device Tree. To support such systems this patch adds an
> asynchronous subdevice registration framework to V4L2. To use it respective
> (e.g. I2C) subdevice drivers must register themselves with the framework.
> A bridge driver on the other hand must register notification callbacks,
> that will be called upon various related events.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

with this https://patchwork.linuxtv.org/patch/18096/ patch applied, yo
can add my

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar
