Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50162 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752859AbcFTRlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 13:41:05 -0400
Date: Mon, 20 Jun 2016 20:03:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	mchehab@osg.samsung.com
Subject: Re: [PATCH v2.1 5/5] media: Support variable size IOCTL arguments
Message-ID: <20160620170315.GK24980@valkosipuli.retiisi.org.uk>
References: <1462360855-23354-6-git-send-email-sakari.ailus@linux.intel.com>
 <1462403217-4584-1-git-send-email-sakari.ailus@linux.intel.com>
 <57642371.4010400@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57642371.4010400@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jun 17, 2016 at 06:21:05PM +0200, Hans Verkuil wrote:
> On 05/05/2016 01:06 AM, Sakari Ailus wrote:
> > Instead of checking for a strict size for the IOCTL arguments, place
> > minimum and maximum limits.
> > 
> > As an additional bonus, IOCTL handlers will be able to check whether the
> > caller actually set (using the argument size) the field vs. assigning it
> > to zero. Separate macro can be provided for that.
> > 
> > This will be easier for applications as well since there is no longer the
> > problem of setting the reserved fields zero, or at least it is a lesser
> > problem.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I think it is important to have exact matches instead of using a min-max
> range. Issues related to alignment problems on different architectures
> (32/64 bits, how padding in struct is handled, etc.) that could cause a
> different size should be caught by the validation check. Any size other
> than this discrete list of allowed sizes is an indication that something
> is seriously wrong on the kernel or userspace side.

Depending on how many fields are added to a new version of a struct, it may
end up that the size of a malformed user IOCTL still matches with a
different version of a struct. I don't think you benefit too much from such
a list, yet there will be a growing number of different versions of the
struct available. We could (and should) certainly hide them to another
header file though.

There's a cost, small but still a cost, in going through such a list to find
the right size.

The IOCTL arguments should always be packed, too, and follow sane field
alignment.

I have no strong opinion on the matter but would like to find an agreement
for the purpose of being able to rely on this functionality in the new
request and event IOCTLs.

> 
> If we get ioctls that have a variable-sized array at the end, then that
> should be signaled differently in the media_ioctl_info struct. We'll
> handle that when that happens.

Yes, we can add a flag for handling those when we get the first one.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
