Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1522 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZFFL7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 07:59:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv5 1 of 8] v4l2_subdev i2c: Add v4l2_i2c_new_subdev_board i2c helper function
Date: Sat, 6 Jun 2009 13:59:19 +0200
Cc: "\\\"ext Mauro Carvalho Chehab\\\"" <mchehab@infradead.org>,
	"\\\"Nurkkala Eero.An (EXT-Offcode/Oulu)\\\""
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\"ext Douglas Schilling Landgraf\\\"" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com> <1243582408-13084-2-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1243582408-13084-2-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906061359.19732.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 29 May 2009 09:33:21 Eduardo Valentin wrote:
> # HG changeset patch
> # User Eduardo Valentin <eduardo.valentin@nokia.com>
> # Date 1243414605 -10800
> # Branch export
> # Node ID 4fb354645426f8b187c2c90cd8528b2518461005
> # Parent  142fd6020df3b4d543068155e49a2618140efa49
> Device drivers of v4l2_subdev devices may want to have
> board specific data. This patch adds an helper function
> to allow bridge drivers to pass board specific data to
> v4l2_subdev drivers.
>
> For those drivers which need to support kernel versions
> bellow 2.6.26, a .s_config callback was added. The
> idea of this callback is to pass board configuration
> as well. In that case, subdev driver should set .s_config
> properly, because v4l2_i2c_new_subdev_board will call
> the .s_config directly. Of course, if we are >= 2.6.26,
> the same data will be passed through i2c board info as well.

Hi Eduardo,

I finally had some time to look at this. After some thought I realized that 
the main problem is really that the API is becoming quite messy. Basically 
there are 9 different ways of loading and initializing a subdev:

First there are three basic initialization calls: no initialization, passing 
irq and platform_data, and passing the i2c_board_info struct directly 
(preferred for drivers that don't need pre-2.6.26 compatibility).

And for each flavor you would like to see three different versions as well: 
one with a fixed known i2c address, one where you probe for a list of 
addresses, and one where you can probe for a single i2c address.

I propose to change the API as follows:

#define V4L2_I2C_ADDRS(addr, addrs...) \
	((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })

struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
                struct i2c_adapter *adapter,
                const char *module_name, const char *client_type,
		u8 addr, const unsigned short *addrs);

struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
                struct i2c_adapter *adapter,
                const char *module_name, const char *client_type,
                int irq, void *platform_data,
                u8 addr, const unsigned short *addrs);

/* Only available for kernels >= 2.6.26 */
struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
                struct i2c_adapter *adapter, const char *module_name,
                struct i2c_board_info *info, const unsigned short *addrs);

If you use a fixed address, then only set addr (or info.addr) and set addrs 
to NULL. If you want to probe for a list of addrs, then set addrs to the 
list of addrs. If you want to probe for a single addr, then use 
V4L2_I2C_ADDRS(addr) as the addrs argument. This constructs an array with 
just two entries. Actually, this macro can also create arrays with more 
entries.

Note that v4l2_i2c_new_subdev will be an inline that calls 
v4l2_i2c_new_subdev_cfg with 0, NULL for the irq and platform_data.

And for kernels >= 2.6.26 v4l2_i2c_new_subdev_cfg can be an inline calling 
v4l2_i2c_new_subdev_board.

This approach reduces the number of functions to just one (not counting the 
inlines) and simplifies things all around. It does mean that all sources 
need to be changed, but if we go this route, then now is the time before 
the 2.6.31 window is closed. And I would also like to remove the '_new' 
from these function names. I never thought it added anything useful.

Comments? If we decide to go this way, then I need to know soon so that I 
can make the changes before the 2.6.31 window closes.

BTW, if the new s_config subdev call is present, then it should always be 
called. That way the subdev driver can safely do all of its initialization 
in s_config, no matter how it was initialized.

Sorry about the long delay in replying to this: it's been very hectic lately 
at the expense of my v4l-dvb work.

Regards,

	Hans

>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  drivers/media/video/v4l2-common.c |   37
> +++++++++++++++++++++++++++++++++++-- include/linux/v4l2-common.h       |
>    8 ++++++++
>  include/linux/v4l2-subdev.h       |    1 +
>  3 files changed, 44 insertions(+), 2 deletions(-)
>
> diff -r 142fd6020df3 -r 4fb354645426
> linux/drivers/media/video/v4l2-common.c ---
> a/linux/drivers/media/video/v4l2-common.c	Mon May 18 02:31:55 2009 +0000
> +++ b/linux/drivers/media/video/v4l2-common.c	Wed May 27 11:56:45 2009
> +0300 @@ -819,9 +819,10 @@
>
>
>  /* Load an i2c sub-device. */
> -struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
> +static struct v4l2_subdev *__v4l2_i2c_new_subdev(struct v4l2_device
> *v4l2_dev, struct i2c_adapter *adapter,
> -		const char *module_name, const char *client_type, u8 addr)
> +		const char *module_name, const char *client_type, u8 addr,
> +		int irq, void *platform_data)
>  {
>  	struct v4l2_subdev *sd = NULL;
>  	struct i2c_client *client;
> @@ -840,6 +841,8 @@
>  	memset(&info, 0, sizeof(info));
>  	strlcpy(info.type, client_type, sizeof(info.type));
>  	info.addr = addr;
> +	info.irq = irq;
> +	info.platform_data = platform_data;
>
>  	/* Create the i2c client */
>  	client = i2c_new_device(adapter, &info);
> @@ -877,8 +880,38 @@
>  #endif
>  	return sd;
>  }
> +
> +struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
> +		struct i2c_adapter *adapter,
> +		const char *module_name, const char *client_type, u8 addr)
> +{
> +	return __v4l2_i2c_new_subdev(v4l2_dev, adapter, module_name,
> +		client_type, addr, 0, NULL);
> +}
>  EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
>
> +struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device
> *v4l2_dev, +		struct i2c_adapter *adapter,
> +		const char *module_name, const char *client_type, u8 addr,
> +		int irq, void *platform_data)
> +{
> +	struct v4l2_subdev *sd;
> +	int err = 0;
> +
> +	sd = __v4l2_i2c_new_subdev(v4l2_dev, adapter, module_name, client_type,
> +					addr, irq, platform_data);
> +
> +	/*
> +	 * We return errors from v4l2_subdev_call only if we have the callback
> +	 * as the .s_config is not mandatory
> +	 */
> +	if (sd && sd->ops && sd->ops->core && sd->ops->core->s_config)
> +		err = sd->ops->core->s_config(sd, irq, platform_data);
> +
> +	return err < 0 ? NULL : sd;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_board);
> +
>  /* Probe and load an i2c sub-device. */
>  struct v4l2_subdev *v4l2_i2c_new_probed_subdev(struct v4l2_device
> *v4l2_dev, struct i2c_adapter *adapter,
> diff -r 142fd6020df3 -r 4fb354645426 linux/include/media/v4l2-common.h
> --- a/linux/include/media/v4l2-common.h	Mon May 18 02:31:55 2009 +0000
> +++ b/linux/include/media/v4l2-common.h	Wed May 27 11:56:45 2009 +0300
> @@ -147,6 +147,14 @@
>  struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
>  		struct i2c_adapter *adapter,
>  		const char *module_name, const char *client_type, u8 addr);
> +/*
> + * Same as v4l2_i2c_new_subdev, but with the opportunity to configure
> + * subdevice with board specific data (irq and platform_data).
> + */
> +struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device
> *v4l2_dev, +		struct i2c_adapter *adapter,
> +		const char *module_name, const char *client_type, u8 addr,
> +		int irq, void *platform_data);
>  /* Probe and load an i2c module and return an initialized v4l2_subdev
> struct. Only call request_module if module_name != NULL.
>     The client_type argument is the name of the chip that's on the
> adapter. */ diff -r 142fd6020df3 -r 4fb354645426
> linux/include/media/v4l2-subdev.h ---
> a/linux/include/media/v4l2-subdev.h	Mon May 18 02:31:55 2009 +0000 +++
> b/linux/include/media/v4l2-subdev.h	Wed May 27 11:56:45 2009 +0300 @@
> -96,6 +96,7 @@
>  struct v4l2_subdev_core_ops {
>  	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident
> *chip); int (*log_status)(struct v4l2_subdev *sd);
> +	int (*s_config)(struct v4l2_subdev *sd, int irq, void *platform_data);
>  	int (*init)(struct v4l2_subdev *sd, u32 val);
>  	int (*load_fw)(struct v4l2_subdev *sd);
>  	int (*reset)(struct v4l2_subdev *sd, u32 val);



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
