Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56360 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2FGRwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 13:52:41 -0400
Received: by eeit10 with SMTP id t10so338340eei.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2012 10:52:40 -0700 (PDT)
Message-ID: <4FD0EA64.5020602@gmail.com>
Date: Thu, 07 Jun 2012 19:52:36 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
MIME-Version: 1.0
To: Erik Gilling <konkers@android.com>
CC: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org
Subject: Re: Synchronization framework
References: <4FD06C91.6020507@gmail.com> <CACSP8SjyhBsCf7hnyO3AGnNge967jWHpkyfDyrEmkgdnp60_iA@mail.gmail.com>
In-Reply-To: <CACSP8SjyhBsCf7hnyO3AGnNge967jWHpkyfDyrEmkgdnp60_iA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Erik,

Op 07-06-12 19:35, Erik Gilling schreef:
> On Thu, Jun 7, 2012 at 1:55 AM, Maarten Lankhorst
> <m.b.lankhorst@gmail.com> wrote:
>> I haven't looked at intel and amd, but from a quick glance
>> it seems like they already implement fencing too, so just
>> some way to synch up the fences on shared buffers seems
>> like it could benefit all graphics drivers and the whole
>> userspace synching could be done away with entirely.
> It's important to have some level of userspace API so that GPU
> generated graphics can participate in the graphics pipeline.  Think of
> the case where you have a software video codec streaming textures into
> the GPU.  It needs to know when the GPU is done with those textures so
> it can reuse the buffer.
>
In the graphics case this problem already has to be handled without
dma-buf, so adding any extra synchronization api for userspace
that is only used when the bo is shared is a waste.

I do agree you need some way to synch userspace though, but I
think adding a new api for userspace is not the way to go.

Cheers,
Maarten

PS: re-added cc's that seem to have fallen off from your mail.
