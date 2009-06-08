Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1533 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZFHGWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 02:22:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv5 1 of 8] v4l2_subdev i2c: Add v4l2_i2c_new_subdev_board i2c helper function
Date: Mon, 8 Jun 2009 08:22:02 +0200
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	"\\\"Nurkkala Eero.An (EXT-Offcode/Oulu)\\\""
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\"ext Douglas Schilling Landgraf\\\"" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com> <200906070840.09166.hverkuil@xs4all.nl> <20090607222914.314c3fc7@pedra.chehab.org>
In-Reply-To: <20090607222914.314c3fc7@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906080822.03392.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 June 2009 03:29:14 Mauro Carvalho Chehab wrote:
> Em Sun, 7 Jun 2009 08:40:08 +0200
>
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > On Saturday 06 June 2009 22:40:21 Eduardo Valentin wrote:
> > > Hi Hans,
> > >
> > > On Sat, Jun 6, 2009 at 8:09 PM, Hans Verkuil <hverkuil@xs4all.nl> 
wrote:
> > > > On Saturday 06 June 2009 14:49:46 Hans Verkuil wrote:
> > > > > On Saturday 06 June 2009 13:59:19 Hans Verkuil wrote:
> > > > > > On Friday 29 May 2009 09:33:21 Eduardo Valentin wrote:
> > > > > > > # HG changeset patch
> > > > > > > # User Eduardo Valentin <eduardo.valentin@nokia.com>
> > > > > > > # Date 1243414605 -10800
> > > > > > > # Branch export
> > > > > > > # Node ID 4fb354645426f8b187c2c90cd8528b2518461005
> > > > > > > # Parent  142fd6020df3b4d543068155e49a2618140efa49
> > > > > > > Device drivers of v4l2_subdev devices may want to have
> > > > > > > board specific data. This patch adds an helper function
> > > > > > > to allow bridge drivers to pass board specific data to
> > > > > > > v4l2_subdev drivers.
> > > > > > >
> > > > > > > For those drivers which need to support kernel versions
> > > > > > > bellow 2.6.26, a .s_config callback was added. The
> > > > > > > idea of this callback is to pass board configuration
> > > > > > > as well. In that case, subdev driver should set .s_config
> > > > > > > properly, because v4l2_i2c_new_subdev_board will call
> > > > > > > the .s_config directly. Of course, if we are >= 2.6.26,
> > > > > > > the same data will be passed through i2c board info as well.
> > > > > >
> > > > > > Hi Eduardo,
> > > > > >
> > > > > > I finally had some time to look at this. After some thought I
> > > > > > realized that the main problem is really that the API is
> > > > > > becoming quite messy. Basically there are 9 different ways of
> > > > > > loading and initializing a subdev:
> > > > > >
> > > > > > First there are three basic initialization calls: no
> > > > > > initialization, passing irq and platform_data, and passing the
> > > > > > i2c_board_info struct directly (preferred for drivers that
> > > > > > don't need pre-2.6.26 compatibility).
> > > > > >
> > > > > > And for each flavor you would like to see three different
> > > > > > versions as well: one with a fixed known i2c address, one where
> > > > > > you probe for a list of addresses, and one where you can probe
> > > > > > for a single i2c address.
> > > > > >
> > > > > > I propose to change the API as follows:
> > > > > >
> > > > > > #define V4L2_I2C_ADDRS(addr, addrs...) \
> > > > > >     ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END
> > > > > > })
> > > > > >
> > > > > > struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device
> > > > > > *v4l2_dev, struct i2c_adapter *adapter,
> > > > > >                 const char *module_name, const char
> > > > > > *client_type, u8 addr, const unsigned short *addrs);
> > > > > >
> > > > > > struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device
> > > > > > *v4l2_dev, struct i2c_adapter *adapter,
> > > > > >                 const char *module_name, const char
> > > > > > *client_type, int irq, void *platform_data,
> > > > > >                 u8 addr, const unsigned short *addrs);
> > > > > >
> > > > > > /* Only available for kernels >= 2.6.26 */
> > > > > > struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct
> > > > > > v4l2_device *v4l2_dev, struct i2c_adapter *adapter, const char
> > > > > > *module_name, struct i2c_board_info *info, const unsigned short
> > > > > > *addrs);
> > > > > >
> > > > > > If you use a fixed address, then only set addr (or info.addr)
> > > > > > and set addrs to NULL. If you want to probe for a list of
> > > > > > addrs, then set addrs to the list of addrs. If you want to
> > > > > > probe for a single addr, then use V4L2_I2C_ADDRS(addr) as the
> > > > > > addrs argument. This constructs an array with just two entries.
> > > > > > Actually, this macro can also create arrays with more entries.
> > > > > >
> > > > > > Note that v4l2_i2c_new_subdev will be an inline that calls
> > > > > > v4l2_i2c_new_subdev_cfg with 0, NULL for the irq and
> > > > > > platform_data.
> > > > > >
> > > > > > And for kernels >= 2.6.26 v4l2_i2c_new_subdev_cfg can be an
> > > > > > inline calling v4l2_i2c_new_subdev_board.
> > > > > >
> > > > > > This approach reduces the number of functions to just one (not
> > > > > > counting the inlines) and simplifies things all around. It does
> > > > > > mean that all sources need to be changed, but if we go this
> > > > > > route, then now is the time before the 2.6.31 window is closed.
> > > > > > And I would also like to remove the '_new' from these function
> > > > > > names. I never thought it added anything useful.
> > > > > >
> > > > > > Comments? If we decide to go this way, then I need to know soon
> > > > > > so that I can make the changes before the 2.6.31 window closes.
> > > > > >
> > > > > > BTW, if the new s_config subdev call is present, then it should
> > > > > > always be called. That way the subdev driver can safely do all
> > > > > > of its initialization in s_config, no matter how it was
> > > > > > initialized.
> > > > > >
> > > > > > Sorry about the long delay in replying to this: it's been very
> > > > > > hectic lately at the expense of my v4l-dvb work.
> > > > >
> > > > > I've done the initial conversion to the new API (no _cfg or
> > > > > _board version yet) in my ~hverkuil/v4l-dvb-subdev tree. It
> > > > > really simplifies things and if nobody objects then I'd like to
> > > > > get this in before 2.6.31.
>
> No please. We did already lots of change due to the i2c changes, and
> there are still some occasional complaints at ML about regressions that
> might be due to i2c changes.

Please point them out to me. I can't remember seeing those. Admittedly, I've 
been swamped with work in the past few weeks, so I might have missed them.

> Let's keep 2.6.31 clean, as previously agreed, without new KABI changes.
> We should focus 2.6.31 on fixing any core issues that may still have.
> Only with 2.6.30 we'll start to have feedbacks from normal users.

It's a new API, so it is normal that we find things that need improvement. 
This is the case here. Eduardo needs to pass extra initialization info to 
the i2c drivers, so he is adding new functions to the API. But those make 
an overly complex (as I've come to realize) API even more complex. Isn't is 
better to do it right?

And I don't see the advantage of waiting with this. If there are any 
problems with 2.6.30 then we will get them whether we change this internal 
API or not. In addition, I think this is pretty much the only change in the 
API to be queued for 2.6.31.

And how long do you intend to wait? It will take a while before all the 
distros take up 2.6.30. So wait until 2.6.32? 2.6.33?

> > > > I've added the new _cfg and _board fucntions as well in this tree.
> > > > It needs a bit of a cleanup before I can do a pull request (the
> > > > last two patches should be merged to one), but otherwise this is
> > > > the code as I think it should be:
> > > >
> > > > /* Construct an I2C_CLIENT_END-terminated array of i2c addresses on
> > > > the fly */
> > > > #define V4L2_I2C_ADDRS(addr, addrs...) \
> > > >        ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END
> > > > })
> > > >
> > > > /* Load an i2c module and return an initialized v4l2_subdev struct.
> > > >   Only call request_module if module_name != NULL.
> > > >   The client_type argument is the name of the chip that's on the
> > > > adapter. */
> > > > struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device
> > > > *v4l2_dev, struct i2c_adapter *adapter,
> > > >                const char *module_name, const char *client_type,
> > > >                int irq, void *platform_data,
> > > >                u8 addr, const unsigned short *addrs);
> > > >
> > > > static inline struct v4l2_subdev *v4l2_i2c_new_subdev(
> > > >                struct v4l2_device *v4l2_dev,
> > > >                struct i2c_adapter *adapter,
> > > >                const char *module_name, const char *client_type,
> > > >                u8 addr, const unsigned short *addrs)
> > > > {
> > > >        return v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter,
> > > > module_name, client_type, 0, NULL, addr, addrs); }
> > > >
> > > > #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> > > > struct i2c_board_info;
> > > >
> > > > struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device
> > > > *v4l2_dev, struct i2c_adapter *adapter, const char *module_name,
> > > > struct i2c_board_info *info, const unsigned short *addrs); #endif
> > > >
> > > > Regards,
> > > >
> > > >        Hans
> > >
> > > I've cloned your tree and took a look at your code. Well, looks like
> > > the proper way to do this change.
> > > I didn't take this approach because it touchs other drivers. However,
> > > concentrating the code  in only one
> > > function is better. I also saw that you have fixed the kernel version
> > > check in the v4l2_device_unregister
> > > function. Great!
> > >
> > > I will resend my series without this patch. I will rebase it on top
> > > of your subdev tree so the new api
> > > can be used straight. Is that ok?
> >
> > Yes, sure. Just be aware that there may be some small changes to my
> > patch based on feedback I get. But it is a good test anyway of this API
> > to see if it works well for you.
>
> Eduardo,
>
> Let's analyze and merge your changes using the current development tree.
> If you think that Hans approach is better (I haven't analyzed it yet),
> then it can later be converted to the new approach

If you really are opposed to my changes, then I need to look at these 
patches again since they need to be modified a fair amount. They will have 
to touch the core subdev API anyway, so let's do it right rather than 
hacking in this new functionality and having to change it again in 2.6.32.

If something is wrong, then let's just fix it instead of trying to hack it 
in. That only increases the chances of more errors. After implementing my 
changes I came to realize that it is a much cleaner approach.

One alternative that I would be OK with is to wait with this until the 
2.6.31 window closes. But then Eduardo's driver won't make 2.6.31 either.

BTW, Eduardo isn't the only one who needs these changes. It crops up 
whenever you deal with embedded devices. So please let us just fix this 
part of the API.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
