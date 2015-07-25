Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38781 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754925AbbGYWNQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2015 18:13:16 -0400
Date: Sun, 26 Jul 2015 01:12:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, j.anaszewski@samsung.com
Subject: Re: [PATCH 1/1] v4l: subdev: Serialise open and release internal ops
Message-ID: <20150725221243.GE12092@valkosipuli.retiisi.org.uk>
References: <1437581650-1422-1-git-send-email-sakari.ailus@linux.intel.com>
 <55B20076.6090809@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55B20076.6090809@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jul 24, 2015 at 11:08:06AM +0200, Hans Verkuil wrote:
> Hi Sakari,
> 
> On 07/22/2015 06:14 PM, Sakari Ailus wrote:
> > By default, serialise open and release internal ops using a mutex.
> > 
> > The underlying problem is that a large proportion of the drivers do use
> > v4l2_fh_is_singular() in their open() handlers (struct
> > v4l2_subdev_internal_ops). v4l2_subdev_open(), .open file operation handler
> > of the V4L2 sub-device framework, calls v4l2_fh_add() which adds the file
> > handle to the list of open file handles of the device. Later on in the
> > open() handler of the sub-device driver uses v4l2_fh_is_singular() to
> > determine whether it was the file handle which was first opened. The check
> > may go wrong if the device was opened by multiple process closely enough in
> > time.
> 
> I don't like this patch for a few reasons: first of all it makes open/close
> different from the open/close handling for normal v4l2 drivers. The decision
> was made to use a core lock to serialize ioctls, but not the file operations.
> 
> The reason was that not all file operations need to take a lock, and that
> drivers often need to do special things in the open/close anyway and using
> the core lock for this caused more headaches than it solved.
> 
> I think we need to stick to the same scheme here. Note that I wouldn't mind
> introducing a serialization lock for subdev ioctls. There isn't one at the
> moment, and I think that that will simplify locking for subdevs, just as it
> did for non-subdev drivers.
> 
> The second problem is that this depends on a new flag which is fairly ugly.
> 
> Drivers should just take a lock before calling fh_add and fh_singular.

The sub-device drivers cannot take the lock since the open/close handlers
often perform actions that themselves require serialisation. The
v4l2_subdev_fh is already initialised and added by the framework before the
driver has a chance to do anything.

> 
> Things can be simplified a bit with the v4l2-fh functions: I think it makes
> sense if v4l2_fh_add and v4l2_fh_del both return a bool which is true if it
> was the first or last filehandle.
> 
> That way you can just do:
> 
> 	mutex_lock(&lock);
> 	if (v4l2_fh_add()) {
> 		...
> 	}
> 	mutex_unlock(&lock);
> 
> Same with v4l2_fh_del().

This does not work for sub-devices. For video devices it does.

> 
> While we're at it: v4l2_fh_is_singular(_file) should return a bool, not an int.

Agreed. I think it was written in an era when people didn't think bool
existed. :-)

> 
> Hmm, let me make a patch series for these fh changes, shouldn't be too difficult.

I'll review it.

I think the API change (return singularity from v4l2_fh_add() and
v4l2_fh_release()) is good IMO). I might even consider removing
v4l2_fh_is_singular() or at least deprecate it since it begs misuse in form
of completely ignoring proper serialisation, and it's also made redundant.

Also, your patchset does not address the problem on sub-device drivers.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
