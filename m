Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57714 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753306AbdJTMJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 08:09:16 -0400
Date: Fri, 20 Oct 2017 15:09:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Harald Dankworth <hardankw@cisco.com>, linux-media@vger.kernel.org,
        hansverk@cisco.com, tharvey@gateworks.com
Subject: Re: [PATCH 1/2] v4l-utils: do not query capabilities of sub-devices.
Message-ID: <20171020120913.yax7qkxsramvgcm3@valkosipuli.retiisi.org.uk>
References: <1508418555-8870-1-git-send-email-hardankw@cisco.com>
 <20171019145344.iucrcbx2buyu4xaa@valkosipuli.retiisi.org.uk>
 <ad956f0c-d3e9-2f3b-d3d7-41dcd362183a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad956f0c-d3e9-2f3b-d3d7-41dcd362183a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Oct 20, 2017 at 01:56:48PM +0200, Hans Verkuil wrote:
> On 19/10/17 16:53, Sakari Ailus wrote:
> > Hi Harald and Hans,
> > 
> > On Thu, Oct 19, 2017 at 03:09:15PM +0200, Harald Dankworth wrote:
> >> Find the major and minor numbers of the device. Check if the
> >> file /dev/dev/char/major:minor/uevent contains "DEVNAME=v4l-subdev".

/sys/dev/...

> >> If so, the device is a sub-device.
> >>
> >> Signed-off-by: Harald Dankworth <hardankw@cisco.com>
> >> Reviewed-by: Hans Verkuil <hansverk@cisco.com>
> > 
> > I wonder if this is the best way to obtain the information. I thought there
> > was an intent to add something to sysfs that wasn't based on device names.
> > This also hardcodes the sysfs path.
> 
> This is what we discussed on irc some time ago. And if /sys is mounted somewhere
> else, then you have bigger problems :-)

I remember the discussion but my recollection of the conclusion is slightly
different. :-)

Besides, sysfs could be still mounted elsewhere.

> 
> The device name in /sys comes from the driver and isn't changed by udev rules.
> So we can use it to determine if it is a subdev or not.
> 
> > Would udev provide anything useful in this respect?
> 
> Not all embedded systems use udev. I'd rather not depend on it, at least not for
> this utility.
> 
> The alternative to this is to add a QUERYCAP-like ioctl for subdevs, but my
> proposal for that has been repeatedly shot down.

Here's a new argument for that: in order to make sub-devices proper V4L2
devices there should be QUERYCAP support. It'd be the same IOCTL and the
same argument struct.

> 
> In the meantime we need *something* so you can use v4l2-ctl to query/get/set
> controls and the EDID for HDMI receivers (Tim Harvey needs this).
> 
> I would like to merge this soon. It can always be changed if we switch to another
> better method.

I agree, this won't break anything and can be improved later on without
affecting anything else.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
