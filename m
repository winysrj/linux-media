Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:48167 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbbDARBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2015 13:01:22 -0400
Message-ID: <551C2444.2030407@xs4all.nl>
Date: Wed, 01 Apr 2015 19:00:52 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: v4l2-compliance question
References: <CALzAhNWSH9Y8Zepn4BpbDJ14cr5+KjhWbWwqDKoVQWs6g0zxvQ@mail.gmail.com>
In-Reply-To: <CALzAhNWSH9Y8Zepn4BpbDJ14cr5+KjhWbWwqDKoVQWs6g0zxvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/01/2015 06:45 PM, Steven Toth wrote:
> Hans,
> 
> struct v4l2_capability has a version field described as:
> 
> __u32version
> 
> "Version number of the driver.
> 
> Starting on kernel 3.1, the version reported is provided per V4L2
> subsystem, following the same Kernel numberation scheme. However, it
> should not always return the same version as the kernel, if, for
> example, an stable or distribution-modified kernel uses the V4L2 stack
> from a newer kernel.
> 
> The version number is formatted using the KERNEL_VERSION() macro..."
> 
> fail_on_test((vcap.version >> 16) < 3);
> 
> I have a driver that returns 0x00010703 and thus fails v4l2-compliance.
> 
> My read on the documentation is that the major doesn't have to be 3 or
> higher, it doesn't specially call that out.

Drivers should not set the version field at all. Instead the v4l2 core will
set it. If you compiled the driver as part of a kernel, then the version will
be set with the kernel version, if you used the media_build compat build,
then it will be set to the kernel version of the media_tree.git repo.

In both cases the major number will be >= 3.

Note that v4l2-compliance doesn't just check compliance to the spec, but
also whether a driver is using the right internal frameworks. So the checks
are actually more strict than the spec.

Regards,

	Hans
