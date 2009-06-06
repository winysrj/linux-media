Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:43829 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZFFROq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 13:14:46 -0400
Date: Sat, 6 Jun 2009 10:14:46 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Eduardo Valentin <eduardo.valentin@nokia.com>,
	"\\\\\\ext Mauro Carvalho Chehab\\\\\\" <mchehab@infradead.org>,
	"\\\\\\Nurkkala Eero.An (EXT-Offcode/Oulu)\\\\\\"
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\\\\ext Douglas Schilling Landgraf\\\\\\" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv5 1 of 8] v4l2_subdev i2c: Add v4l2_i2c_new_subdev_board
 i2c helper function
In-Reply-To: <200906061449.46720.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0906060940420.32713@shell2.speakeasy.net>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-2-git-send-email-eduardo.valentin@nokia.com>
 <200906061359.19732.hverkuil@xs4all.nl> <200906061449.46720.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 6 Jun 2009, Hans Verkuil wrote:
> On Saturday 06 June 2009 13:59:19 Hans Verkuil wrote:
> > I propose to change the API as follows:
> >
> > #define V4L2_I2C_ADDRS(addr, addrs...) \
> > 	((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
> >
> > struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
> >                 struct i2c_adapter *adapter,
> >                 const char *module_name, const char *client_type,
> > 		u8 addr, const unsigned short *addrs);
> >
> > struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
> >                 struct i2c_adapter *adapter,
> >                 const char *module_name, const char *client_type,
> >                 int irq, void *platform_data,
> >                 u8 addr, const unsigned short *addrs);
> >
> > /* Only available for kernels >= 2.6.26 */
> > struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device
> > *v4l2_dev, struct i2c_adapter *adapter, const char *module_name, struct
> > i2c_board_info *info, const unsigned short *addrs);

Maybe "addrs" could be changed to something like "probed_addrs" so it's
easier to tell that the two address fields are used differently?

Is v4l2_i2c_new_subdev() in effect just a wrapper around
v4l2_i2c_new_subdev_cfg() that calls it with NO_IRQ and NULL for irq and
platform_data?

And could v4l2_i2c_new_subdev_cfg() be done like this?

struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
                 struct i2c_adapter *adapter, const char *module_name,
		 const char *client_type, int irq, void *platform_data,
                 u8 addr, const unsigned short *addrs)
{
	struct i2c_board_info info = {
		.addr = addr, .platform_data = platform_data, .irq = irq, };

	strlcpy(info.type, client_type, sizeof(info.type));
	return v4l2_i2c_new_subdev_board(v4l2_dev, adapter, module_name,
			                 &info, addrs);
}
