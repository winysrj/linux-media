Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2248 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbZGCJTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 05:19:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 1/11 - v3] vpfe capture bridge driver for DM355 and DM6446
Date: Fri, 3 Jul 2009 11:18:52 +0200
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
References: <1246566758-26398-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1246566758-26398-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031118.53623.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 02 July 2009 22:32:38 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> Re-sending to add description (and also experimental status) for
> VPFE_CMD_S_CCDC_RAW_PARAMS and updating debug prints with \n and
> fixing an error coder ENOMEM
> 
> VPFE Capture bridge driver
> 
> This is version, v3 of vpfe capture bridge driver for doing video
> capture on DM355 and DM6446 evms. The ccdc hw modules register with the
> driver and are used for configuring the CCD Controller for a specific
> decoder interface. The driver also registers the sub devices required
> for a specific evm. More than one sub devices can be registered.
> This allows driver to switch dynamically to capture video from
> any sub device that is registered. Currently only one sub device
> (tvp5146) is supported. But in future this driver is expected
> to do capture from sensor devices such as Micron's MT9T001,MT9T031
> and MT9P031 etc. The driver currently supports MMAP based IO.
> 
> Following are the updates based on review comments:-
> 	1) clean up of setting bus parameters in ccdc
> 	2) removed v4l2_routing structure type
> 	3) module authors, description changes 
> 	4) pixel aspect constants removed
> 
> Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
> Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
> Reviewed by: Alexey Klimov <klimov.linux@gmail.com>
> Reviewed by: Mauro Carvalho Chehab <mchehab@infradead.org>
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to v4l-dvb repository
> 
>  drivers/media/video/davinci/vpfe_capture.c | 2138 ++++++++++++++++++++++++++++
>  include/media/davinci/vpfe_capture.h       |  195 +++
>  include/media/davinci/vpfe_types.h         |   51 +
>  3 files changed, 2384 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/vpfe_capture.c
>  create mode 100644 include/media/davinci/vpfe_capture.h
>  create mode 100644 include/media/davinci/vpfe_types.h
> 
> diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
> new file mode 100644
> index 0000000..600da0d
> --- /dev/null
> +++ b/drivers/media/video/davinci/vpfe_capture.c

<snip>

> +/*
> + * vpfe_probe : This function creates device entries by register
> + * itself to the V4L2 driver and initializes fields of each
> + * device objects
> + */
> +static __init int vpfe_probe(struct platform_device *pdev)
> +{
> +	struct vpfe_config *vpfe_cfg;
> +	struct resource *res1;
> +	struct vpfe_device *vpfe_dev;
> +	struct i2c_adapter *i2c_adap;
> +	struct i2c_client *client;
> +	struct video_device *vfd;
> +	int ret = -ENOMEM, i, j;
> +	int num_subdevs = 0;

<snip>

> +
> +	for (i = 0; i < num_subdevs; i++) {
> +		struct vpfe_subdev_info *sdinfo = &vpfe_cfg->sub_devs[i];
> +		struct v4l2_input *inps;
> +
> +		list_for_each_entry(client, &i2c_adap->clients, list) {
> +			if (!strcmp(client->name, sdinfo->name))
> +				break;
> +		}

This no longer compiles :-(

The latest linux git tree no longer has the i2c_adap->clients field, nor is
there a 'list' field in struct i2c_client.

The initialization of the subdevs should be done in a similar way as
vpif_probe does it in vpif_display.c (see my v4l-dvb-dm646x tree).

Using i2c core internals as is being done here is a really bad idea.
Of course, when this was written originally the v4l2_i2c_new_subdev_board()
function didn't exist yet, and you need that one in order to implement this
properly.

I've made a new v4l-dvb-vpfe-cap tree with your latest changes, but it is
obviously impossible to merge at the moment and fixing this problem is, I
suspect, a non-trivial change.

I see three options:

1) You manage to come up with a proper fix very quickly,
2) We postpone everything until the next merge window,
3) We only merge the tvp514x patches (not sure whether this is a useful
   alternative or not).

Mauro, the v4l-dvb-dm646x tree for which I posted a pull request a week ago
compiles fine against the latest linux-git tree, so it shouldn't be a problem
(I hope :-) ) to merge that one for 2.6.31.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
