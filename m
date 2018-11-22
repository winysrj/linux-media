Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57666 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732583AbeKWAZl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 19:25:41 -0500
Date: Thu, 22 Nov 2018 15:46:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: ning.a.zhang@intel.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: is it possible to use single IOCTL to setup media pipeline?
Message-ID: <20181122134614.ylarnadgkqu7vxjf@valkosipuli.retiisi.org.uk>
References: <1542855107.1288.32.camel@intel.com>
 <CAAFQd5CSXQw2Nk7TMij4qQx6V5diLg8LpuSKOrZG86cWo3vKxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5CSXQw2Nk7TMij4qQx6V5diLg8LpuSKOrZG86cWo3vKxg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thu, Nov 22, 2018 at 04:06:36PM +0900, Tomasz Figa wrote:
> Hi Ning,
> 
> On Thu, Nov 22, 2018 at 11:52 AM Zhang, Ning A <ning.a.zhang@intel.com> wrote:
> >
> > Hello everyone
> >
> > when we need to setup media pipeline, eg, for camera capture, media-ctl
> > needs to be called multiple time to setup media link and subdev
> > formats, or similar code in a single application. this will use
> > multiple IOCTLs on "/dev/mediaX" and "/dev/v4l2-subdevY".
> >
> > to setup media pipeline in userspace requires to fully understanding
> > the topology of the media stack. but the fact is only media driver
> > developer could know how to setup media pipeline. each time driver
> > updates, this would break userspace application if application
> > engineers don't know this change.
> 
> That's obviously a bug in the driver. Kernel interfaces must not
> change in a way that are not compatible with the userspace.

Alternatively, this could result from fixing a bug in a driver. Or adding
features that were not previously supported.

In this case there are often no perfect solutions to address all the issues
at hand.

> 
> > In this case, if a IOCTL is designed
> > to setup media pipeline, no need to update applications, after driver
> > is updated.
> >
> > this will not only benefit for design a single IOCTL, this also helps
> > to hide the detail of media pipeline, by load a binary blob which holds
> > information about how to setup pipeline, or hide it in bootloader/ACPI
> > tables/device tree, etc.
> 
> Media pipeline configuration is specific to the use case. If you
> hardcode it in the driver or bootloader, the user will not be able to
> use any other use case than the hardcoded blob, which is unacceptable
> for Linux drivers.
> 
> Instead, it sounds like your userspace should be designed in a way
> that the media topology configuration is loaded from a configuration
> file that you could either get from your kernel driver developer or
> just maintain yourself based on any changes the media developers do.
> Of course that's unrelated to the backwards compatibility issue, which
> should not happen normally. The configuration file would be helpful
> for handling future extensions and new hardware platforms.
> 
> >
> > another benefit is save time for setup media pipeline, if there is a
> > PKI like "time for open camera". as my test, this will saves hundreds
> > of milliseconds.
> 
> For this problem, the proper solution would be to create an ioctl that
> can aggregate setting multiple parts of the topology in one go. For
> example, V4L2 has VIDIOC_S_CTRL for setting a control, but there is
> also VIDIOC_S_EXT_CTRLS, which lets you set multiple controls in one
> call. Something like VIDIOC_S_EXT_CTRLS for configuring the media
> topology would solve the performance problem.

There have been ideas of moving all IOCTL handling to the media device, in
a way that would allow issuing them in the same fashion than controls. This
was discussed in last year's media summit actually. I think this could be
done once the request API is otherwise working for e.g. camera devices. I
don't expect this to materialise in near (or even medium) term though.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
