Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42708 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750873AbcLHXFp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 18:05:45 -0500
Date: Fri, 9 Dec 2016 01:05:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com
Subject: Re: [PATCH v4l-utils v7 4/7] mediactl: Add media_device creation
 helpers
Message-ID: <20161208230507.GI16630@valkosipuli.retiisi.org.uk>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-5-git-send-email-j.anaszewski@samsung.com>
 <20161124121731.GF16630@valkosipuli.retiisi.org.uk>
 <9fb6265e-db41-21db-4cd6-7f14092b0920@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fb6265e-db41-21db-4cd6-7f14092b0920@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Thu, Dec 08, 2016 at 11:04:20PM +0100, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 11/24/2016 01:17 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >Thanks for the patchset.
> >
> >On Wed, Oct 12, 2016 at 04:35:19PM +0200, Jacek Anaszewski wrote:
> >>Add helper functions that allow for easy instantiation of media_device
> >>object basing on whether the media device contains v4l2 subdev with
> >>given file descriptor.
> >
> >Doesn't this work with video nodes as well? That's what you seem to be using
> >it for later on. And I think that's actually more useful.
> >
> >The existing implementation uses udev to look up devices. Could you use
> >libudev device enumeration API to find the media devices, and fall back to
> >sysfs if udev doesn't work? There seems to be a reasonable-looking example
> >here:
> >
> ><URL:http://stackoverflow.com/questions/25361042/how-to-list-usb-mass-storage-devices-programatically-using-libudev-in-linux>
> 
> Actually I am calling media_get_devname_udev() at first and falling back
> to sysfs similarly as it is accomplished in media_enum_entities().
> Is there any specific reason for which I should use libudev device
> enumeration API in media_device_new_by_subdev_fd()?

Yes. You rely on the API udev provides; the sysfs implementation is just a
fallback in case udev isn't available in the system. I guess it'd mostly
work but, for instance, you assume sysfs is found under /sys. The sysfs
itself isn't one of the most stable APIs either. Udev is a simply better
option when it's there.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
