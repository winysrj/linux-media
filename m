Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2160 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZFFRJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 13:09:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv5 1 of 8] v4l2_subdev i2c: Add v4l2_i2c_new_subdev_board i2c helper function
Date: Sat, 6 Jun 2009 19:09:28 +0200
Cc: "\\\"ext Mauro Carvalho Chehab\\\"" <mchehab@infradead.org>,
	"\\\"Nurkkala Eero.An (EXT-Offcode/Oulu)\\\""
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\"ext Douglas Schilling Landgraf\\\"" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com> <200906061359.19732.hverkuil@xs4all.nl> <200906061449.46720.hverkuil@xs4all.nl>
In-Reply-To: <200906061449.46720.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906061909.28157.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 06 June 2009 14:49:46 Hans Verkuil wrote:
> On Saturday 06 June 2009 13:59:19 Hans Verkuil wrote:
> > On Friday 29 May 2009 09:33:21 Eduardo Valentin wrote:
> > > # HG changeset patch
> > > # User Eduardo Valentin <eduardo.valentin@nokia.com>
> > > # Date 1243414605 -10800
> > > # Branch export
> > > # Node ID 4fb354645426f8b187c2c90cd8528b2518461005
> > > # Parent  142fd6020df3b4d543068155e49a2618140efa49
> > > Device drivers of v4l2_subdev devices may want to have
> > > board specific data. This patch adds an helper function
> > > to allow bridge drivers to pass board specific data to
> > > v4l2_subdev drivers.
> > >
> > > For those drivers which need to support kernel versions
> > > bellow 2.6.26, a .s_config callback was added. The
> > > idea of this callback is to pass board configuration
> > > as well. In that case, subdev driver should set .s_config
> > > properly, because v4l2_i2c_new_subdev_board will call
> > > the .s_config directly. Of course, if we are >= 2.6.26,
> > > the same data will be passed through i2c board info as well.
> >
> > Hi Eduardo,
> >
> > I finally had some time to look at this. After some thought I realized
> > that the main problem is really that the API is becoming quite messy.
> > Basically there are 9 different ways of loading and initializing a
> > subdev:
> >
> > First there are three basic initialization calls: no initialization,
> > passing irq and platform_data, and passing the i2c_board_info struct
> > directly (preferred for drivers that don't need pre-2.6.26
> > compatibility).
> >
> > And for each flavor you would like to see three different versions as
> > well: one with a fixed known i2c address, one where you probe for a
> > list of addresses, and one where you can probe for a single i2c
> > address.
> >
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
> > struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device
> > *v4l2_dev, struct i2c_adapter *adapter,
> >                 const char *module_name, const char *client_type,
> >                 int irq, void *platform_data,
> >                 u8 addr, const unsigned short *addrs);
> >
> > /* Only available for kernels >= 2.6.26 */
> > struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device
> > *v4l2_dev, struct i2c_adapter *adapter, const char *module_name, struct
> > i2c_board_info *info, const unsigned short *addrs);
> >
> > If you use a fixed address, then only set addr (or info.addr) and set
> > addrs to NULL. If you want to probe for a list of addrs, then set addrs
> > to the list of addrs. If you want to probe for a single addr, then use
> > V4L2_I2C_ADDRS(addr) as the addrs argument. This constructs an array
> > with just two entries. Actually, this macro can also create arrays with
> > more entries.
> >
> > Note that v4l2_i2c_new_subdev will be an inline that calls
> > v4l2_i2c_new_subdev_cfg with 0, NULL for the irq and platform_data.
> >
> > And for kernels >= 2.6.26 v4l2_i2c_new_subdev_cfg can be an inline
> > calling v4l2_i2c_new_subdev_board.
> >
> > This approach reduces the number of functions to just one (not counting
> > the inlines) and simplifies things all around. It does mean that all
> > sources need to be changed, but if we go this route, then now is the
> > time before the 2.6.31 window is closed. And I would also like to
> > remove the '_new' from these function names. I never thought it added
> > anything useful.
> >
> > Comments? If we decide to go this way, then I need to know soon so that
> > I can make the changes before the 2.6.31 window closes.
> >
> > BTW, if the new s_config subdev call is present, then it should always
> > be called. That way the subdev driver can safely do all of its
> > initialization in s_config, no matter how it was initialized.
> >
> > Sorry about the long delay in replying to this: it's been very hectic
> > lately at the expense of my v4l-dvb work.
>
> I've done the initial conversion to the new API (no _cfg or _board
> version yet) in my ~hverkuil/v4l-dvb-subdev tree. It really simplifies
> things and if nobody objects then I'd like to get this in before 2.6.31.

I've added the new _cfg and _board fucntions as well in this tree. It needs 
a bit of a cleanup before I can do a pull request (the last two patches 
should be merged to one), but otherwise this is the code as I think it 
should be:

/* Construct an I2C_CLIENT_END-terminated array of i2c addresses on the fly 
*/
#define V4L2_I2C_ADDRS(addr, addrs...) \
        ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })

/* Load an i2c module and return an initialized v4l2_subdev struct.
   Only call request_module if module_name != NULL.
   The client_type argument is the name of the chip that's on the adapter. 
*/
struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
                struct i2c_adapter *adapter,
                const char *module_name, const char *client_type,
                int irq, void *platform_data,
                u8 addr, const unsigned short *addrs);

static inline struct v4l2_subdev *v4l2_i2c_new_subdev(
                struct v4l2_device *v4l2_dev,
                struct i2c_adapter *adapter,
                const char *module_name, const char *client_type,
                u8 addr, const unsigned short *addrs)
{
        return v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter, module_name,
                        client_type, 0, NULL, addr, addrs);
}

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
struct i2c_board_info;

struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
                struct i2c_adapter *adapter, const char *module_name,
                struct i2c_board_info *info, const unsigned short *addrs);
#endif

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
