Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44331 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404967AbeKVRoy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 12:44:54 -0500
Received: by mail-yw1-f68.google.com with SMTP id h138-v6so1442814ywa.11
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2018 23:06:50 -0800 (PST)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id a72sm7652197ywh.42.2018.11.21.23.06.48
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Nov 2018 23:06:48 -0800 (PST)
Received: by mail-yw1-f54.google.com with SMTP id v8-v6so3256610ywh.6
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2018 23:06:48 -0800 (PST)
MIME-Version: 1.0
References: <1542855107.1288.32.camel@intel.com>
In-Reply-To: <1542855107.1288.32.camel@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 22 Nov 2018 16:06:36 +0900
Message-ID: <CAAFQd5CSXQw2Nk7TMij4qQx6V5diLg8LpuSKOrZG86cWo3vKxg@mail.gmail.com>
Subject: Re: is it possible to use single IOCTL to setup media pipeline?
To: ning.a.zhang@intel.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ning,

On Thu, Nov 22, 2018 at 11:52 AM Zhang, Ning A <ning.a.zhang@intel.com> wrote:
>
> Hello everyone
>
> when we need to setup media pipeline, eg, for camera capture, media-ctl
> needs to be called multiple time to setup media link and subdev
> formats, or similar code in a single application. this will use
> multiple IOCTLs on "/dev/mediaX" and "/dev/v4l2-subdevY".
>
> to setup media pipeline in userspace requires to fully understanding
> the topology of the media stack. but the fact is only media driver
> developer could know how to setup media pipeline. each time driver
> updates, this would break userspace application if application
> engineers don't know this change.

That's obviously a bug in the driver. Kernel interfaces must not
change in a way that are not compatible with the userspace.

> In this case, if a IOCTL is designed
> to setup media pipeline, no need to update applications, after driver
> is updated.
>
> this will not only benefit for design a single IOCTL, this also helps
> to hide the detail of media pipeline, by load a binary blob which holds
> information about how to setup pipeline, or hide it in bootloader/ACPI
> tables/device tree, etc.

Media pipeline configuration is specific to the use case. If you
hardcode it in the driver or bootloader, the user will not be able to
use any other use case than the hardcoded blob, which is unacceptable
for Linux drivers.

Instead, it sounds like your userspace should be designed in a way
that the media topology configuration is loaded from a configuration
file that you could either get from your kernel driver developer or
just maintain yourself based on any changes the media developers do.
Of course that's unrelated to the backwards compatibility issue, which
should not happen normally. The configuration file would be helpful
for handling future extensions and new hardware platforms.

>
> another benefit is save time for setup media pipeline, if there is a
> PKI like "time for open camera". as my test, this will saves hundreds
> of milliseconds.

For this problem, the proper solution would be to create an ioctl that
can aggregate setting multiple parts of the topology in one go. For
example, V4L2 has VIDIOC_S_CTRL for setting a control, but there is
also VIDIOC_S_EXT_CTRLS, which lets you set multiple controls in one
call. Something like VIDIOC_S_EXT_CTRLS for configuring the media
topology would solve the performance problem.

Best regards,
Tomasz
