Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1659 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZHaUnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 16:43:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: Behavior of ENUM_STD/G_STD ioctl
Date: Mon, 31 Aug 2009 22:43:50 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <19F8576C6E063C45BE387C64729E73940436A4A9FF@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436A4A9FF@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908312243.50089.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 31 August 2009 20:26:29 Hiremath, Vaibhav wrote:
> Hi,
> 
> I am working on OMAP3517 which has CCDC module which is almost similar to Davinci (DM6446). I have ported davinci capture driver (Submitted by Murali) to OMAP3517, and I am almost done with it, except some hardware related issues (which requires some follow-ups with HW team). 
> 
> During this I came across one observation, in vpfe_camera.c file which is bridge driver assumes the default standard without looking/referring to underneath sub-device (It choose index 0 in the v4l2_std array maintained by bridge driver). If I understand correctly as per V4L2 Spec, the driver does not need to implement enum_std/g_std callback functions, since V4L2 layer handles this and returns these fields respectively.

enum_std is handled by the core based on the tvnorms field. I strongly
recommend implementing g_std at all times rather than using the default g_std
handling. The v4l core is not smart enough to know that video and vbi device
nodes share the same std, so changing the std on a video node will leave it
unchanged on the vbi node. Much better to do it yourself.

So don't set current_norm and supply a g_std instead.

> 
> Now the question I have here is, how enum_std/g_std, to be more specific tvnorm/current_norm should be handled by driver?
> 
> 1) During probe (or open) bridge driver should get the current standard which is being active from the underneath sub-device and update the fields tvnorm/current_norm accordingly. After that whenever application call enum_std/g_std the V4L2 layer can handle it and for s_std anyway bridge driver passing it to sub device.
> 
> 2) Application must call s_std and that's where all the path will get synchronized (what sub-device has with what V4L2 layer has against bridge driver)
> 
> I believe driver should follow option 1, especially in our case (TVP5146 video decoder) where it has a capability to lock the signal and return the status of detected standard.
> 
> Can anybody conform how this should be handled?

There is no common method to decide on the initial standard. In many cases the
hardware is standard specific: i.e. it either supports PAL/SECAM or NTSC. This
is normally decided by the tuner since most tuners are either PAL/SECAM or NTSC
but not both. In that case you pick NTSC-M or PAL-BGH as initial standard,
depending on the installed tuner.

If there is no tuner or if it is a world-wide tuner, then most just pick a
standard. Generally based on whether the developer lives in the US or in
Europe :-)

I don't believe that any driver attempts to query the standard on an input,
but that would be OK too, although it is perhaps a bit over the top. And if
it doesn't find a signal there then you still need to make a basically random
choice.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
