Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57002 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1035464AbdEZI3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 04:29:16 -0400
Date: Fri, 26 May 2017 11:29:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>
Subject: Re: [PATCH] ov5670: Add Omnivision OV5670 5M sensor support
Message-ID: <20170526082907.GO29527@valkosipuli.retiisi.org.uk>
References: <1493849212-24998-1-git-send-email-chiranjeevi.rapolu@intel.com>
 <20170504084850.GT7456@valkosipuli.retiisi.org.uk>
 <8408A4B5C50F354EA5F62D9FC805153D018D4DD9@ORSMSX115.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8408A4B5C50F354EA5F62D9FC805153D018D4DD9@ORSMSX115.amr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chiranjeevi,

On Fri, May 26, 2017 at 01:19:59AM +0000, Rapolu, Chiranjeevi wrote:
> >> +/* Analog gain controls from sensor */
> >> +#define	ANALOG_GAIN_MIN		0
> >> +#define	ANALOG_GAIN_MAX		8191
> >> +#define	ANALOG_GAIN_STEP	1
> >> +#define	ANALOG_GAIN_DEFAULT	128
> >> +
> >> +/* Exposure controls from sensor */
> >> +#define	EXPOSURE_MIN		0
> >> +#define	EXPOSURE_MAX		1048575
> >> +#define	EXPOSURE_STEP		1
> >> +#define	EXPOSURE_DEFAULT	47232
> >
> >Are these values dependent on sensor configuration i.e. in the case of this
> >driver modes?
> >
> Default values for a given resolutions can be fine-tuned. I think it is up to
> the HAL/application as to what default exposure for a given resolution. Driver
> has the support to change per application.

How about the minimum and maximum values? Are they dependent on other
configuration?

...

> >> +/* Write a list of registers */
> >> +static int ov5670_write_regs(struct ov5670 *ov5670,
> >> +			     const struct ov5670_reg *regs,
> >> +			     int len)
> >
> >How about using unsigned int for len?
> >
> Now u32 len.
> >> +{
> >> +	struct i2c_client *client = v4l2_get_subdevdata(&ov5670->sd);
> >> +	int i;
> >
> >i as well.
> >
> Now u32 i

An insigned int should do. Types with explicit widths should be only used
when the exact value ranges is known, e.g. a 32-bit or 16-bit register.

...

> >> +static int ov5670_set_stream(struct v4l2_subdev *sd, int enable)
> >> +{
> >> +	struct ov5670 *ov5670 = to_ov5670(sd);
> >> +	int ret = 0;
> >> +
> >> +	mutex_lock(&ov5670->mutex);
> >> +	if (ov5670->streaming == enable) {
> >> +		mutex_unlock(&ov5670->mutex);
> >> +		return 0;
> >> +	}
> >> +	mutex_unlock(&ov5670->mutex);
> >> +
> >> +	if (enable) {
> >> +		ret = ov5670_prepare_streaming(ov5670);
> >
> >ov5670_prepare_streaming() and ov5670_start_streaming() are always called
> >sequientally. Could you combine the two?
> >
> >About locking --- you would likely benefit from an unlocked variant of
> >v4l2_ctrl_handler_setup(). I uploaded it here, let me know if it works for
> >you:
> >
> ><URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=ctrl-setup-unlocked>
> >
> Tried unlocked __v4l2_ctrl_handler_setup(), working fine, used.
> Can you push this patch?

Great! I sent it to the list a moment ago. :-)

> >> +static struct i2c_driver ov5670_i2c_driver = {
> >
> >const?
> >
> Made const

I later on figured out this was probably a bad suggestion. The driver
registration changes the i2c_driver struct, causing a compiler warning.

> >> +	.driver = {
> >> +		.name = "ov5670",
> >> +		.owner = THIS_MODULE,
> >> +		.pm = &ov5670_pm_ops,
> >> +		.acpi_match_table = ACPI_PTR(ov5670_acpi_ids),
> >> +	},
> >> +	.probe = ov5670_probe,
> >> +	.remove = ov5670_remove,
> >> +	.id_table = ov5670_id_table,
> >> +};
> >> +
> >> +module_i2c_driver(ov5670_i2c_driver);
> >> +
> >> +MODULE_AUTHOR("Rapolu, Chiranjeevi <chiranjeevi.rapolu@intel.com>");
> >> +MODULE_AUTHOR("Yang, Hyungwoo <hyungwoo.yang@intel.com>");
> >> +MODULE_AUTHOR("Pu, Yuning <yuning.pu@intel.com>");
> >> +MODULE_DESCRIPTION("Omnivision ov5670 sensor driver");
> >> +MODULE_LICENSE("GPL");

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
