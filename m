Return-path: <linux-media-owner@vger.kernel.org>
Received: from bm.shmanahar.org ([80.68.91.236]:46642 "EHLO bm.shmanahar.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbcGAIvE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 04:51:04 -0400
Date: Fri, 1 Jul 2016 09:41:24 +0100
From: Nick Dyer <nick@shmanahar.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	jon.older@itdev.co.uk, nick.dyer@itdev.co.uk
Subject: Re: [PATCH v6 10/11] Input: synaptics-rmi4 - add support for F54
 diagnostics
Message-ID: <20160701084124.GA6384@bm.shmanahar.org>
References: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
 <1467308334-12580-11-git-send-email-nick@shmanahar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1467308334-12580-11-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 30, 2016 at 06:38:53PM +0100, Nick Dyer wrote:
> Function 54 implements access to various RMI4 diagnostic features.
> 
> This patch adds support for retrieving this data. It registers a V4L2
> device to output the data to user space.
> 
> Signed-off-by: Nick Dyer <nick@shmanahar.org>
> ---
>  drivers/input/rmi4/Kconfig      |  11 +
>  drivers/input/rmi4/Makefile     |   1 +
>  drivers/input/rmi4/rmi_bus.c    |   3 +
>  drivers/input/rmi4/rmi_driver.h |   1 +
>  drivers/input/rmi4/rmi_f54.c    | 754 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 770 insertions(+)
>  create mode 100644 drivers/input/rmi4/rmi_f54.c
[...]
> index 0000000..2361157
> --- /dev/null
> +++ b/drivers/input/rmi4/rmi_f54.c
[...]
> +static int rmi_f54_vidioc_querycap(struct file *file, void *priv,
> +				   struct v4l2_capability *cap)
> +{
> +	struct f54_data *f54 = video_drvdata(file);
> +
> +	strlcpy(cap->driver, F54_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, SYNAPTICS_INPUT_DEVICE_NAME, sizeof(cap->card));
> +	strlcpy(cap->bus_info, dev_name(&f54->fn->dev), sizeof(cap->bus_info));

I need to correct this to prefix the bus. RMI4 registers its own bus, so
devices appear under eg /sys/bus/rmi4/devices/rmi4-00.fn54

So I will change to:
snprintf(cap->bus_info, sizeof(cap->bus_info), "rmi4:%s", dev_name(&f54->fn->dev));

And I will need to add rmi4 to the valid prefixes in v4l2-complaince as well.

> +
> +	return 0;
> +}
