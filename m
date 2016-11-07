Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32829
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752038AbcKGUQs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 15:16:48 -0500
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
        Shuah Khan <shuahkh@osg.samsung.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <6101f959-f8a9-eaca-b015-91161c04cb87@osg.samsung.com>
Date: Mon, 7 Nov 2016 13:16:45 -0700
MIME-Version: 1.0
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 08/26/2016 05:43 PM, Sakari Ailus wrote:
> Hi folks,
> 
> This is the third version of the RFC set to fix referencing in media
> devices.
> 
> The lifetime of the media device (and media devnode) is now bound to that
> of struct device embedded in it and its memory is only released once the
> last reference is gone: unregistering is simply unregistering, it no
> longer should release memory which could be further accessed.
>                                                                                 
> A video node or a sub-device node also gets a reference to the media
> device, i.e. the release function of the video device node will release
> its reference to the media device. The same goes for file handles to the
> media device.
>                                                                                 
> As a side effect of this is that the media device, it is allocate together
> with the media devnode. The driver may also rely its own resources to the
> media device. Alternatively there's also a priv field to hold drivers
> private pointer (for container_of() is an option in this case). We could
> drop one of these options but currently both are possible.
>                                                                                 
> I've tested this by manually unbinding the omap3isp platform device while
> streaming. Driver changes are required for this to work; by not using
> dynamic allocation (i.e. media_device_alloc()) the old behaviour is still
> supported. This is still unlikely to be a grave problem as there are not
> that many device drivers that support physically removable devices. We've
> had this problem for other devices for many years without paying much
> notice --- that doesn't mean I don't think at least drivers for removable
> devices shouldn't be changed as part of the set later on, I'd just like to
> get review comments on the approach first.
>                                                                                 
> The three patches that originally partially resolved some of these issues
> are reverted in the beginning of the set. I'm still posting this as an RFC
> mainly since the testing is somewhat limited so far.

The main difference between the approach taken in these 3 reverted fixes and
this RFC series is as follows:

Reverted fixes:
- Fix the lifetime problem with the media devnode by dynamically allocating
  devnode instead of media_device. One of the main considerations to this
  approach is to isolate the changes in media core and avoid changes to
  drivers.
- I tested these fixes extensively and added selftests and README file for
  the regression tests. I haven't seen any problems after these fixes went
  in while physically removing au0828 device, em028xx, and uvcvideo

This RFC series:
- Dynamically allocates media_device
- This approach requires changes to drivers. It would be wise to not require
  churn to driver code and fix the problem in media-core.

Do you have information on the problems that still remain with the above fixes
in place? These fixes went into 4.8 is I recall correctly. Could you please
send us the list of problems and dmesg for the problems you found with the
above fixes and how this RFC series addresses them.

Can these problems be fixed without needing to change the approach in the
reverted patches?

I have a patch series on top of the fixes this RFC series is reverting
to allocate media_device only in the cases where sharing media device
is necessary. e.g: au0828 and snd-usb-audio.

Media Device Allocator API
https://www.mail-archive.com/linux-media@vger.kernel.org/msg98793.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg97779.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg97704.html

This series has been reviewed. The work I did to change snd-usb-audio to
use Media Controller API to coordinate access to resources with au0828
is dependent on the above patch series.

snip

> The to-do list includes changes to drivers that can be physically removed.
> Drivers not using the new API can mostly ignore these changes, albeit
> media_device_init() now grabs a reference to struct device of the media
> device which must be released.
> 

As I mentioned earlier, requiring changes to drivers there by exposing
the fix to all drivers is a problem with this RFC series. I would like
to understand the reasons why the current approach to allocate media
devnode and limit the changes to media-ocre doesn't work and also the
reasons why problems if any can't be fixed on top of these fixes.

I have a patch series on top of the fixes this RFC series is reverting
to allocate media_device only in the cases where sharing media device
is necessary. e.g: au0828 and snd-usb-audio.

Media Device Allocator API
https://www.mail-archive.com/linux-media@vger.kernel.org/msg98793.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg97779.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg97704.html

This series has been reviewed and pending at the moment because this
RFC series takes a different approach and reverts patches that the
above work depends on. The work I did to change snd-usb-audio to use
Media Controller API to coordinate access to resources with au0828
is dependent on the above patch series.

My work is kind of in the limbo now because of the conflict between the
two approaches and that my snd-usb-audio work depends on all of this.
Audio maintainer is waiting for snd-usb-audio patches to go in first and
use that work as a reference for changing other audio drivers to use the
Media Controller API.

I am hoping a reach consensus and move forward.

thanks,
-- Shuah
