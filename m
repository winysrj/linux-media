Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:32475 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750766AbeFAJmL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 05:42:11 -0400
Date: Fri, 1 Jun 2018 12:42:07 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com, tfiga@chromium.org
Subject: Re: [RESEND PATCH V2 2/2] media: ak7375: Add ak7375 lens voice coil
 driver
Message-ID: <20180601094207.355n2vzpscsgwyc6@paasikivi.fi.intel.com>
References: <1527242135-22866-1-git-send-email-bingbu.cao@intel.com>
 <1527242135-22866-2-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527242135-22866-2-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 05:55:35PM +0800, bingbu.cao@intel.com wrote:
> +static int ak7375_i2c_write(struct ak7375_device *ak7375,
> +	u8 addr, u16 data, int size)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&ak7375->sd);
> +	int ret;
> +	u8 buf[3];
> +
> +	if (size != 1 && size != 2)
> +		return -EINVAL;
> +	buf[0] = addr;
> +	buf[2] = data & 0xff;
> +	if (size == 2)
> +		buf[1] = data >> 8;
> +	ret = i2c_master_send(client, (const char *)buf, size + 1);

I don't have a data datasheet for this thing, but it looks like buf[1] will
be undefined for writes the size of which is 1. And this what appears to be
written to the device as well...

> +	if (ret < 0)
> +		return ret;
> +	if (ret != size + 1)
> +		return -EIO;
> +	return 0;
> +}

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
