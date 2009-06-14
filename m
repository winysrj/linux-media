Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3813 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbZFNMoz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 08:44:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: hvaibhav@ti.com
Subject: Re: [PATCH (V2)] TVP514x: Migration to sub-device framework
Date: Sun, 14 Jun 2009 14:44:53 +0200
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Brijesh Jadav <brijesh.j@ti.com>,
	Hardik Shah <hardik.shah@ti.com>
References: <hvaibhav@ti.com> <1241634693-28208-1-git-send-email-hvaibhav@ti.com> <200906141214.38355.hverkuil@xs4all.nl>
In-Reply-To: <200906141214.38355.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141444.54105.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 14 June 2009 12:14:38 Hans Verkuil wrote:
> On Wednesday 06 May 2009 20:31:33 hvaibhav@ti.com wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> > 
> > This patch converts TVP514x driver to sub-device framework
> > from V4L2-int framework.
> > 
> > NOTE: Please note that this patch has not been tested on any board,
> >       only compilation/build tested.
> > 
> > Changes (From Previous post):
> >     - Added static function to_decoder which will replace all
> >       container_of instances.
> >     - "unsigned int" replaced with "u32".
> >     - Cleaned up for line indentation.
> >     - pdata initialized, was missing in earlier patch.
> > 
> > TODO:
> >     - Add support for some basic video/core functionality like,
> >         .g_chip_ident
> > 	.reset
> > 	.g_input_status
> >     - Migration master driver to validate this driver.
> >     - validate on Davinci and OMAP boards.
> > 
> > Reviewed By "Hans Verkuil".
> > 
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> >  drivers/media/video/tvp514x.c      |  854 ++++++++++++++----------------------
> >  drivers/media/video/tvp514x_regs.h |   10 -
> >  include/media/tvp514x.h            |    4 -
> >  3 files changed, 330 insertions(+), 538 deletions(-)
> > 
> > diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> > index 4262e60..12b49ad 100644
> > --- a/drivers/media/video/tvp514x.c
> > +++ b/drivers/media/video/tvp514x.c

<snip>

> > +/*
> >   * tvp514x_remove - decoder driver i2c remove handler
> >   * @client: i2c driver client device structure
> >   *
> > @@ -1460,13 +1301,10 @@ out_free:
> >   */
> >  static int __exit tvp514x_remove(struct i2c_client *client)

This can't be __exit since it is called when the adapter is removed, not when
the driver is removed. And that's perfectly valid even if this driver is
compiled in the kernel instead of as a module.

> >  {
> > -	struct tvp514x_decoder *decoder = i2c_get_clientdata(client);
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +	struct tvp514x_decoder *decoder = to_decoder(sd);
> > 
> > -	if (!client->adapter)
> > -		return -ENODEV;	/* our client isn't attached */
> > -
> > -	v4l2_int_device_unregister(&decoder->v4l2_int_device);
> > -	i2c_set_clientdata(client, NULL);
> > +	v4l2_device_unregister_subdev(sd);
> >  	kfree(decoder);
> >  	return 0;
> >  }
> > @@ -1485,11 +1323,9 @@ static const struct tvp514x_reg tvp5146_init_reg_seq[] = {
> >  	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x00},
> >  	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
> >  	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
> > +	{TOK_TERM, 0, 0},
> >  };
> > -static const struct tvp514x_init_seq tvp5146_init = {
> > -	.no_regs = ARRAY_SIZE(tvp5146_init_reg_seq),
> > -	.init_reg_seq = tvp5146_init_reg_seq,
> > -};
> > +
> >  /*
> >   * TVP5147 Init/Power on Sequence
> >   */
> > @@ -1512,22 +1348,18 @@ static const struct tvp514x_reg tvp5147_init_reg_seq[] =	{
> >  	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x00},
> >  	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
> >  	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
> > +	{TOK_TERM, 0, 0},
> >  };
> > -static const struct tvp514x_init_seq tvp5147_init = {
> > -	.no_regs = ARRAY_SIZE(tvp5147_init_reg_seq),
> > -	.init_reg_seq = tvp5147_init_reg_seq,
> > -};
> > +
> >  /*
> >   * TVP5146M2/TVP5147M1 Init/Power on Sequence
> >   */
> >  static const struct tvp514x_reg tvp514xm_init_reg_seq[] = {
> >  	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
> >  	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
> > +	{TOK_TERM, 0, 0},
> >  };
> > -static const struct tvp514x_init_seq tvp514xm_init = {
> > -	.no_regs = ARRAY_SIZE(tvp514xm_init_reg_seq),
> > -	.init_reg_seq = tvp514xm_init_reg_seq,
> > -};
> > +
> >  /*
> >   * I2C Device Table -
> >   *
> > @@ -1535,48 +1367,22 @@ static const struct tvp514x_init_seq tvp514xm_init = {
> >   * driver_data - Driver data
> >   */
> >  static const struct i2c_device_id tvp514x_id[] = {
> > -	{"tvp5146", (unsigned long)&tvp5146_init},
> > -	{"tvp5146m2", (unsigned long)&tvp514xm_init},
> > -	{"tvp5147", (unsigned long)&tvp5147_init},
> > -	{"tvp5147m1", (unsigned long)&tvp514xm_init},
> > +	{"tvp5146", (unsigned long)tvp5146_init_reg_seq},
> > +	{"tvp5146m2", (unsigned long)tvp514xm_init_reg_seq},
> > +	{"tvp5147", (unsigned long)tvp5147_init_reg_seq},
> > +	{"tvp5147m1", (unsigned long)tvp514xm_init_reg_seq},
> >  	{},
> >  };
> > 
> >  MODULE_DEVICE_TABLE(i2c, tvp514x_id);
> > 
> > -static struct i2c_driver tvp514x_i2c_driver = {
> > -	.driver = {
> > -		   .name = TVP514X_MODULE_NAME,
> > -		   .owner = THIS_MODULE,
> > -		   },
> > +static struct v4l2_i2c_driver_data v4l2_i2c_data = {
> > +	.name = TVP514X_MODULE_NAME,
> 
> Please don't use v4l2_i2c_driver_data. That is only necessary if this module
> has to support pre-2.6.26 kernels. Since this driver will never be built for
> such older kernels there is also no need to use this struct. Do it the same
> as was done in the ths7303 driver, i.e. as a regular i2c driver.
> 
> Don't forget to remove the media/v4l2-i2c-drv.h include!
> 
> >  	.probe = tvp514x_probe,
> >  	.remove = __exit_p(tvp514x_remove),

__exit_p should not be used.

> >  	.id_table = tvp514x_id,
> >  };

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
