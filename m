Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2FLHVv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 03:21:51 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5C7LoE3008116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 03:21:50 -0400
Received: from shalem.localdomain (vpn1-5-62.ams2.redhat.com [10.36.5.62])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q5C7LmoS022857
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 03:21:50 -0400
Message-ID: <4FD6EE20.7080504@redhat.com>
Date: Tue, 12 Jun 2012 09:22:08 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [git:v4l-utils/master] libv4l: Move dev ops to libv4lconvert
References: <E1SeAp3-0005Xk-Ue@www.linuxtv.org>
In-Reply-To: <E1SeAp3-0005Xk-Ue@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/11/2012 09:59 PM, Gregor Jasny wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/v4l-utils.git tree:
>
> Subject: libv4l: Move dev ops to libv4lconvert
> Author:  Gregor Jasny <gjasny@googlemail.com>
> Date:    Mon Jun 11 21:59:25 2012 +0200
>
> As discussed with Hans de Goede, this patch moves the plugin dev-ops
> structure to libv4lconvert. It was also renamed to libv4l_dev_ops.
>
> As a positive side effect we restored SONAME compatibility with
> the 0.8.x releases.

Nice, good work!

So I guess it is about time for a 0.10 release?

Before doing a 0.10 release I would like to revisit the plugin API and mmap
issue though. I've made a 180 wrt my opinion on this, and I think it would
be good to have mmap in the plugin API to allow plugins to intercept it if
they want (so that we can do ie a an IEEE1394 converter plugin like
http://dv4l.berlios.de/)

The mmap callbacks would be optional, so a not interested plugin does not need
to worry about them.

Here is what I wrote on this before:

The problem with mmap is that we've 3 kinds of mmap buffers:

1) Real mmap-ed device buffers,
    used directly by the app in the no conversion path.
2) Faked mmap-ed device buffers,
    seen by the app when doing conversion, this is basically
    convert_mmap_buf, IMHO if we add mmap plugin ops, the
    mmap / munmap of convert_mmap_buf should not go through
    it, is is basically just a malloc/free, but done through
    mmap to make sure we get the right alignment, etc.
3) memory not managed by v4l at all, this happens only
    in the munmap call, when used in combination with LD_PRELOAD
    note that currently in v4l2_munmap, the code paths for 1 & 3
    are the same. If we allow plugins to intercept the munmap call
    (and make no further changes) then the plugin will get the
    munmap call and if the memory is not owned by the plugin it
    should do a SYS_MUNMAP instead!!

So if we keep using the real mmap / munmap for the fake buffers (2),
then the only problem is that when used with LD_PRELOAD (ie skype),
the plugin can get munmap calls for memory it never returned from
mmap. I suggest we document this, as well as that in this case
the plugin should forward the call to SYS_MUNMAP.

Regards,

Hans
