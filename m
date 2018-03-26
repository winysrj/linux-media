Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48018 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750983AbeCZUhj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 16:37:39 -0400
Date: Mon, 26 Mar 2018 17:37:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: acourbot@chromium.org, linux-media@vger.kernel.org,
        tfiga@google.com, hverkuil@xs4all.nl
Subject: Re: [RFC v2.1 1/1] media: Support variable size IOCTL arguments
Message-ID: <20180326173733.380ba0a6@vento.lan>
In-Reply-To: <20180326200017.eipe7wze4fon7h7i@kekkonen.localdomain>
References: <1521839864-10146-2-git-send-email-sakari.ailus@linux.intel.com>
        <1522070604-3213-1-git-send-email-sakari.ailus@linux.intel.com>
        <20180326142834.264cf1d9@vento.lan>
        <20180326200017.eipe7wze4fon7h7i@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Mar 2018 23:00:17 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> On Mon, Mar 26, 2018 at 02:28:34PM -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 26 Mar 2018 16:23:24 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   
> > > Maintain a list of supported IOCTL argument sizes and allow only those in
> > > the list.
> > > 
> > > As an additional bonus, IOCTL handlers will be able to check whether the
> > > caller actually set (using the argument size) the field vs. assigning it
> > > to zero. Separate macro can be provided for that.
> > > 
> > > This will be easier for applications as well since there is no longer the
> > > problem of setting the reserved fields zero, or at least it is a lesser
> > > problem.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---
> > > Hi folks,
> > > 
> > > I've essentially addressed Mauro's comments on v2.
> > > 
> > > The code is only compile tested so far but the changes from the last
> > > tested version are not that big. There's still some uncertainty though.  
> > 
> > You should test it... I guess there is a bug on this version :-)
> > (see below)
> >   
> > > 
> > > since v2:
> > > 
> > > - Rework is_valid_ioctl based on the comments
> > > 
> > > 	- Improved comments,
> > > 	
> > > 	- Rename cmd as user_cmd, as this comes from the user
> > > 	
> > > 	- Check whether there are alternative argument sizes before any
> > > 	  checks on IOCTL command if there is no exact match
> > > 	  
> > > 	- Use IOCSIZE_MASK macro instead of creating our own
> > > 
> > > - Add documentation for macros declaring IOCTLs
> > > 
> > > 
> > >  drivers/media/media-device.c | 98 +++++++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 92 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > > index 35e81f7..279d740 100644
> > > --- a/drivers/media/media-device.c
> > > +++ b/drivers/media/media-device.c
> > > @@ -387,22 +387,65 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
> > >  /* Do acquire the graph mutex */
> > >  #define MEDIA_IOC_FL_GRAPH_MUTEX	BIT(0)
> > >  
> > > -#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
> > > +/**
> > > + * MEDIA_IOC_SZ_ARG - Declare a Media device IOCTL with alternative size and
> > > + *		      to_user/from_user callbacks
> > > + *
> > > + * @__cmd:	The IOCTL command suffix (without "MEDIA_IOC_")
> > > + * @func:	The handler function
> > > + * @fl:		Flags from @enum media_ioc_flags
> > > + * @alt_sz:	A 0-terminated list of alternative argument struct sizes.
> > > + * @from_user:	Function to copy argument struct from the user to the kernel
> > > + * @to_user:	Function to copy argument struct to the user from the kernel
> > > + */
> > > +#define MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz, from_user, to_user)	\
> > >  	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
> > >  		.cmd = MEDIA_IOC_##__cmd,				\
> > >  		.fn = (long (*)(struct media_device *, void *))func,	\
> > >  		.flags = fl,						\
> > > +		.alt_arg_sizes = alt_sz,				\
> > >  		.arg_from_user = from_user,				\
> > >  		.arg_to_user = to_user,					\
> > >  	}
> > >  
> > > -#define MEDIA_IOC(__cmd, func, fl)					\
> > > -	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
> > > +/**
> > > + * MEDIA_IOC_ARG - Declare a Media device IOCTL with to_user/from_user callbacks
> > > + *
> > > + * Just as MEDIA_IOC_SZ_ARG but without the alternative size list.
> > > + */  
> > 
> > Nitpick: either use:
> > 	/*
> > 	 *...
> > 	 */
> > 
> > or add the arguments to the macro there, as /** ... */ expects
> > the arguments. Same for other comments below.  
> 
> I think a regular comment would do. It's only used below.

Works for me.

> >   
> > > +#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
> > > +	MEDIA_IOC_SZ_ARG(__cmd, func, fl, NULL, from_user, to_user)
> > > +
> > > +/**
> > > + * MEDIA_IOC_ARG - Declare a Media device IOCTL with alternative argument struct
> > > + *		   sizes
> > > + *
> > > + * Just as MEDIA_IOC_SZ_ARG but without the callbacks to copy the data from the
> > > + * user space and back to user space.
> > > + */
> > > +#define MEDIA_IOC_SZ(__cmd, func, fl, alt_sz)			\
> > > +	MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz,		\
> > > +			 copy_arg_from_user, copy_arg_to_user)
> > > +
> > > +/**
> > > + * MEDIA_IOC_ARG - Declare a Media device IOCTL
> > > + *
> > > + * Just as MEDIA_IOC_SZ_ARG but without the alternative size list or the
> > > + * callbacks to copy the data from the user space and back to user space.
> > > + */
> > > +#define MEDIA_IOC(__cmd, func, fl)				\
> > > +	MEDIA_IOC_ARG(__cmd, func, fl,				\
> > > +		      copy_arg_from_user, copy_arg_to_user)
> > >  
> > >  /* the table is indexed by _IOC_NR(cmd) */
> > >  struct media_ioctl_info {
> > >  	unsigned int cmd;
> > >  	unsigned short flags;
> > > +	/*
> > > +	 * Sizes of the alternative arguments. If there are none, this
> > > +	 * pointer is NULL.
> > > +	 */
> > > +	const unsigned short *alt_arg_sizes;
> > >  	long (*fn)(struct media_device *dev, void *arg);
> > >  	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
> > >  	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
> > > @@ -416,6 +459,46 @@ static const struct media_ioctl_info ioctl_info[] = {
> > >  	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
> > >  };
> > >  
> > > +static inline long is_valid_ioctl(unsigned int user_cmd)
> > > +{
> > > +	const struct media_ioctl_info *info = ioctl_info;
> > > +	const unsigned short *alt_arg_sizes;
> > > +
> > > +	if (_IOC_NR(user_cmd) >= ARRAY_SIZE(ioctl_info))
> > > +		return -ENOIOCTLCMD;
> > > +
> > > +	info += _IOC_NR(user_cmd);
> > > +
> > > +	if (user_cmd == info->cmd)
> > > +		return 0;
> > > +
> > > +	/*
> > > +	 * There was no exact match between the user-passed IOCTL command and
> > > +	 * the definition. Are there earlier revisions of the argument struct
> > > +	 * available?
> > > +	 */
> > > +	if (!info->alt_arg_sizes)
> > > +		return -ENOIOCTLCMD;
> > > +
> > > +	/*
> > > +	 * Variable size IOCTL argument support allows using either the latest
> > > +	 * revision of the IOCTL argument struct or an earlier version. Check
> > > +	 * that the size-independent portions of the IOCTL command match and
> > > +	 * that the size matches with one of the alternative sizes that
> > > +	 * represent earlier revisions of the argument struct.
> > > +	 */
> > > +	if ((user_cmd & ~IOCSIZE_MASK) != (info->cmd & ~IOCSIZE_MASK)
> > > +	    || _IOC_SIZE(user_cmd) < _IOC_SIZE(info->cmd))
> > > +		return -ENOIOCTLCMD;  
> > 
> > I guess it should be, instead:
> > 
> > 	    || _IOC_SIZE(user_cmd) > _IOC_SIZE(info->cmd))
> > 
> > The hole idea is that the struct sizes used by ioctls can monotonically
> > increase as newer fields become needed, but never decrease.  
> 
> Oops, indeed. I'll send a new version...
> 
> > 
> > Assuming that, _IOC_SIZE(MEDIA_IOC_foo) will give the size of the
> > latest version of an ioctl supported by a given Kernel version,
> > while alt_arg_sizes will list smaller sizes from previous
> > Kernel versions that will also be accepted, in order to make it
> > backward-compatible with apps compiled against older Kernel headers.
> > 
> > However, if an application is compiled with a kernel newer than
> > the current one, it should fail, as an older Kernel doesn't know
> > how to handle the newer fields. So, it should be up to the userspace
> > app to add backward-compatible code if it needs to support older
> > Kernels.
> > 
> > (perhaps it should be worth adding a comment like the above
> > somewhere).  
> 
> Good point. I wonder if it'd be better to just handle this in the kernel
> and allow larges arguments as well. This would effectively be the same as
> we have right now, with a very large number of reserved fields.
> 
> We could not assume an application knowingly set a field that is present in
> a struct of which an older revision exists: all it takes is to compile the
> application in an environment which has the new definitions. Unless... we
> put the version to the struct name. But I don't like that, it makes IOCTL
> calls (and the documentation) quite ugly.
> 
> That'd also suggest the list of alternative sizes isn't very useful: even
> when we have reserved fields, we don't have any way of knowing whether an
> application intentionally set a field to zero or just left out initialising
> that particular field.
> 
> I wonder what Hans thinks...

No, it wouldn't be the same, at least for ioctls that sets something.

I mean, let's say that we end by adding a new field FOO to 
MEDIA_IOC_SETUP_LINK, that would affect the way it works, for
example, allowing it to set two or more links at once. 

If the Kernel handles such ioctl only to the parameters it knows,
it will set just the first link, discarding the rest of the ioctl.

I don't think that there's a safe way to allow an older Kernel to
support applications compiled for a new Kernel version.
So, I wouldn't even try to do it.

On the other hand, for an application, it is easy to check what's
the version of the Kernel/media controller and send a set of
MEDIA_IOC_SETUP_LINK_legacy per/link ioctls or the newer
MEDIA_IOC_SETUP_LINK_new depending on the Kernel version.

Thanks,
Mauro
