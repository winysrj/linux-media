Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34384 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751839AbcEDMcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 08:32:21 -0400
Date: Wed, 4 May 2016 15:31:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	mchehab@osg.samsung.com
Subject: Re: [PATCH v2 3/5] media: Refactor copying IOCTL arguments from and
 to user space
Message-ID: <20160504123146.GK26360@valkosipuli.retiisi.org.uk>
References: <1462360855-23354-1-git-send-email-sakari.ailus@linux.intel.com>
 <1462360855-23354-4-git-send-email-sakari.ailus@linux.intel.com>
 <5729EA0F.5080402@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5729EA0F.5080402@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, May 04, 2016 at 02:24:47PM +0200, Hans Verkuil wrote:
> Hi Sakari,
> 
> Thanks for working on this!
> 
> I've got one comment:
> 
> On 05/04/2016 01:20 PM, Sakari Ailus wrote:
> > Refactor copying the IOCTL argument structs from the user space and back,
> > in order to reduce code copied around and make the implementation more
> > robust.
> > 
> > As a result, the copying is done while not holding the graph mutex.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/media-device.c | 214 ++++++++++++++++++++++---------------------
> >  1 file changed, 110 insertions(+), 104 deletions(-)
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 9b5a88d..39fe07f 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> 
> <snip>
> 
> >  static long __media_device_ioctl(
> >  	struct file *filp, unsigned int cmd, void __user *arg,
> > -	const struct media_ioctl_info *info_array, unsigned int info_array_len)
> > +	const struct media_ioctl_info *info_array, unsigned int info_array_len,
> > +	unsigned int *max_arg_size)
> >  {
> >  	struct media_devnode *devnode = media_devnode_data(filp);
> >  	struct media_device *dev = to_media_device(devnode);
> >  	const struct media_ioctl_info *info;
> > +	char karg[media_ioctl_max_arg_size(info_array, info_array_len,
> > +					   max_arg_size)];
> 
> This isn't going to work. Sparse (and/or smatch) will complain about this. I recommend
> doing the same as videodev does: have a fixed array on the stack, and use kmalloc if
> more is needed.
> 
> I don't like the max_arg_size anyway :-)

Sparse might warn, yes, but it doesn't make the solution worse. :-)

That would leave it up to the developers to maintain the argument size sane.
Sure I can change this.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
