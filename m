Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44645 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751035AbeCZLeI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 07:34:08 -0400
Date: Mon, 26 Mar 2018 14:34:05 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        acourbot@chromium.org
Subject: Re: [RFC v2 01/10] media: Support variable size IOCTL arguments
Message-ID: <20180326113404.meodlzurveucgz3i@paasikivi.fi.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
 <1521839864-10146-2-git-send-email-sakari.ailus@linux.intel.com>
 <20180326074742.433ab8f1@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326074742.433ab8f1@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Mar 26, 2018 at 07:47:42AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 23 Mar 2018 23:17:35 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > Maintain a list of supported IOCTL argument sizes and allow only those in
> > the list.
> > 
> > As an additional bonus, IOCTL handlers will be able to check whether the
> > caller actually set (using the argument size) the field vs. assigning it
> > to zero. Separate macro can be provided for that.
> > 
> > This will be easier for applications as well since there is no longer the
> > problem of setting the reserved fields zero, or at least it is a lesser
> > problem.
> 
> Patch makes sense to me, but I have a few comments on it.
> 
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/media-device.c | 65 ++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 59 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 35e81f7..da63da1 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -387,22 +387,36 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
> >  /* Do acquire the graph mutex */
> >  #define MEDIA_IOC_FL_GRAPH_MUTEX	BIT(0)
> >  
> > -#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
> > +#define MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz, from_user, to_user)	\
> >  	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
> >  		.cmd = MEDIA_IOC_##__cmd,				\
> >  		.fn = (long (*)(struct media_device *, void *))func,	\
> >  		.flags = fl,						\
> > +		.alt_arg_sizes = alt_sz,				\
> >  		.arg_from_user = from_user,				\
> >  		.arg_to_user = to_user,					\
> >  	}
> >  
> > -#define MEDIA_IOC(__cmd, func, fl)					\
> > -	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
> > +#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
> > +	MEDIA_IOC_SZ_ARG(__cmd, func, fl, NULL, from_user, to_user)
> > +
> > +#define MEDIA_IOC_SZ(__cmd, func, fl, alt_sz)			\
> > +	MEDIA_IOC_SZ_ARG(__cmd, func, fl, alt_sz,		\
> > +			 copy_arg_from_user, copy_arg_to_user)
> > +
> > +#define MEDIA_IOC(__cmd, func, fl)				\
> > +	MEDIA_IOC_ARG(__cmd, func, fl,				\
> > +		      copy_arg_from_user, copy_arg_to_user)
> 
> Please add some comments to those macros (specially the first one,
> as the names of the values are too short to help identifying what
> they are.

Ack.

> 
> >  
> >  /* the table is indexed by _IOC_NR(cmd) */
> >  struct media_ioctl_info {
> >  	unsigned int cmd;
> >  	unsigned short flags;
> > +	/*
> > +	 * Sizes of the alternative arguments. If there are none, this
> > +	 * pointer is NULL.
> > +	 */
> > +	const unsigned short *alt_arg_sizes;
> >  	long (*fn)(struct media_device *dev, void *arg);
> >  	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
> >  	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
> > @@ -416,6 +430,42 @@ static const struct media_ioctl_info ioctl_info[] = {
> >  	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
> >  };
> >  
> > +#define MASK_IOC_SIZE(cmd) \
> > +	((cmd) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))
> 
> This should be, instead at:
> 	include/uapi/asm-generic/ioctl.h
> 
> The patch series adding it there should also touch the other usecases
> for _IOC_SIZEMASK (evdev.c, phantom.c, v4l2-ioctl.c).

It seems there's already IOCSIZE_MASK which is already used elsewhere in
the kernel:

#define IOCSIZE_MASK    (_IOC_SIZEMASK << _IOC_SIZESHIFT)

I'll switch to that instead.

> 
> > +
> > +static inline long is_valid_ioctl(unsigned int cmd)
> 
> Please rename from "cmd" to "user_cmd", in order to make it
> clearer that it contains the value passed by userspace.

Done.

> 
> > +{
> > +	const struct media_ioctl_info *info = ioctl_info;
> > +	const unsigned short *alt_arg_sizes;
> > +
> > +	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info))
> > +		return -ENOIOCTLCMD;
> > +
> > +	info += _IOC_NR(cmd);
> > +
> > +	if (info->cmd == cmd)
> > +		return 0;
> 
> Please revert it:
> 	if (user_cmd == info->cmd)
> 		return 0

Agreed.

> 
> As we're validating if the userspace ioctl code makes sense,
> and not the reverse.
> 
> Please add the check if alt_arg_sizes is defined here:
> 
> 	alt_arg_sizes = info->alt_arg_sizes;
> 	if (!alt_arg_sizes)
> 		return -ENOIOCTLCMD;

I'll move the assignment to the beginning of the loop at the same time to
make the code cleaner.

> 
> As the remaining code is not needed if user_cmd != info_cmd.
> 
> > +
> > +	/*
> > +	 * Verify that the size-dependent patch of the IOCTL command
> > +	 * matches and that the size does not exceed the principal
> > +	 * argument size.
> > +	 */
> 
> what do you mean by "principal argument size"? I guess what you're
> meaning here is the "argument size of the latest version" with is
> always bigger than the previous version. If so, make it clear.

Correct.

> 
> I would write it as something like:
> 
> 	/*
> 	 * As the ioctl passed by userspace doesn't match the current
> 	 * one, and there are alternate sizes for thsi ioctl, 
> 	 * we need to check if the ioctl code is correct.
> 	 *
> 	 * Validate that the ioctl code passed by userspace matches the
> 	 * Kernel definition with regards to its number, type and dir.
> 	 * Also checks if the size is not bigger than the one defined
> 	 * by the latest version of the ioctl.

The number has been already validated earlier. I think this is a quote
thorough explanation of what is not really that complicated. What would you
think of the following?

	/*
	 * Variable size IOCTL argument support allows using either the latest
	 * variant of the IOCTL argument struct or an earlier version. Check
	 * that the size-independent portions of the IOCTL command match and
	 * that the size matches with one of the alternative sizes that
	 * represent earlier revisions of the argument struct.
	 */

> 	 */
> 
> > +	if (MASK_IOC_SIZE(info->cmd) != MASK_IOC_SIZE(cmd)
> > +	    || _IOC_SIZE(info->cmd) < _IOC_SIZE(cmd))
> > +		return -ENOIOCTLCMD;
> 
> I would invert the check: what we want do to is to check if whatever
> userspace passes is valid. So, better to place user_cmd as the first
> arguments at the check, e. g.: 
> 
> 	if (MASK_IOC_SIZE(user_cmd) != MASK_IOC_SIZE(info->cmd)
> 	    ||  _IOC_SIZE(user_cmd) > _IOC_SIZE(info->cmd))
> 		return -ENOIOCTLCMD;

Agreed.

> 
> > +
> > +	alt_arg_sizes = info->alt_arg_sizes;
> > +	if (!alt_arg_sizes)
> > +		return -ENOIOCTLCMD;
> 
> As said before, this check should happen earlier.
> 
> > +
> > +	for (; *alt_arg_sizes; alt_arg_sizes++)
> > +		if (_IOC_SIZE(cmd) == *alt_arg_sizes)
> > +			return 0;
> > +
> > +	return -ENOIOCTLCMD;
> > +}
> > +
> >  static long media_device_ioctl(struct file *filp, unsigned int cmd,
> >  			       unsigned long __arg)
> >  {
> > @@ -426,9 +476,9 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
> >  	char __karg[256], *karg = __karg;
> >  	long ret;
> >  
> > -	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info)
> > -	    || ioctl_info[_IOC_NR(cmd)].cmd != cmd)
> > -		return -ENOIOCTLCMD;
> > +	ret = is_valid_ioctl(cmd);
> > +	if (ret)
> > +		return ret;
> >  
> >  	info = &ioctl_info[_IOC_NR(cmd)];
> >  
> > @@ -444,6 +494,9 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
> >  			goto out_free;
> >  	}
> >  
> > +	/* Set the rest of the argument struct to zero */
> > +	memset(karg + _IOC_SIZE(cmd), 0, _IOC_SIZE(info->cmd) - _IOC_SIZE(cmd));
> > +
> >  	if (info->flags & MEDIA_IOC_FL_GRAPH_MUTEX)
> >  		mutex_lock(&dev->graph_mutex);
> >  
> 
> 
> 

After the changes I've done, the function would look like this. I also
added a comment on the check for alt_arg_sizes.

static inline long is_valid_ioctl(unsigned int user_cmd)
{
	const struct media_ioctl_info *info = ioctl_info;
	const unsigned short *alt_arg_sizes;

	if (_IOC_NR(user_cmd) >= ARRAY_SIZE(ioctl_info))
		return -ENOIOCTLCMD;

	info += _IOC_NR(user_cmd);

	if (user_cmd == info->cmd)
		return 0;

	/*
	 * There was no exact match between the user-passed IOCTL command and
	 * the definition. Are there earlier revisions of the argument struct
	 * available?
	 */
	if (!info->alt_arg_sizes)
		return -ENOIOCTLCMD;

	/*
	 * Variable size IOCTL argument support allows using either the latest
	 * revision of the IOCTL argument struct or an earlier version. Check
	 * that the size-independent portions of the IOCTL command match and
	 * that the size matches with one of the alternative sizes that
	 * represent earlier revisions of the argument struct.
	 */
	if (user_cmd & ~IOCSIZE_MASK != info->cmd & ~IOCSIZE_MASK)
	    || _IOC_SIZE(user_cmd) < _IOC_SIZE(info->cmd))
		return -ENOIOCTLCMD;

	for (alt_arg_sizes = info->alt_arg_sizes; *alt_arg_sizes;
	     alt_arg_sizes++)
		if (_IOC_SIZE(user_cmd) == *alt_arg_sizes)
			return 0;

	return -ENOIOCTLCMD;
}


-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
