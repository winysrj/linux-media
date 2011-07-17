Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab1GQVJx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 17:09:53 -0400
Message-ID: <4E234FEF.6000204@redhat.com>
Date: Sun, 17 Jul 2011 23:11:11 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, mchehab@redhat.com, pawel@osciak.com
Subject: Re: [PATCH 1/2] libv4l2: add implicit conversion from single- to
 multi-plane api
References: <1309944253-11703-1-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1309944253-11703-1-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/06/2011 11:24 AM, Tomasz Stanislawski wrote:
> This patch add implicit conversion of single plane variant of ioctl to
> multiplane variant. The conversion is performed only in case if a driver
> implements only mplane api. The conversion is done by substituting SYS_IOCTL
> with a wrapper that converts single plane call to their mplane analogs.
> Function v4l2_fd_open was revised to work correctly with the wrapper.
>
> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>

Thanks for the patch, I like the general idea, but I'm not completely
happy with the implementation.

I think overloading SYS_ioctl is not such a great idea, since this won't
work for calls made by libv4lconvert, unless we export it from libv4l2
and use it in libv4lconvert too, which is quite ugly from an ABI pov.

This is also problematic in the light of the upcoming plugin support
(which just landed in v4l-utils git). Notice how that has replaced
SYS_ioctl with dev_ops->ioctl, so that plugins can intercept ioctls.

Actually the plugni support should make doing this more easy wrt
libv4lconvert, since libv4lconvert now uses dev_ops->ioctl too.

I think this can and should be handled in the following way, with a
2 patch patch-set:

Patch1: Make the dev_ops member of v4l2_dev_info a struct rather
then a pointer to a struct (and adjust v4l_plugin_init accordingly).

Patch2: If one of the devices in question is detected the original
dev_ops->ioctl should be saved in v4l2_dev_info and be replaced with
the proposed wrapper, which then calls the saved original in cases
where it now calls SYS_ioctl.

Regards,

Hans




