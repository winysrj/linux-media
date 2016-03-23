Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33944 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbcCWPdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 11:33:00 -0400
Received: by mail-wm0-f51.google.com with SMTP id p65so238864054wmp.1
        for <linux-media@vger.kernel.org>; Wed, 23 Mar 2016 08:33:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160323115659.GF21717@nuc-i3427.alporthouse.com>
References: <CAO_48GGT48RZaLjg9C+51JyPKzYkkDCFCTrMgfUB+PxQyV8d+Q@mail.gmail.com>
	<1458546705-3564-1-git-send-email-daniel.vetter@ffwll.ch>
	<CANq1E4S0skXbWBOv2bgVddLmZXZE6B7es=+NHKDuJehggnzSvw@mail.gmail.com>
	<20160321171405.GP28483@phenom.ffwll.local>
	<CANq1E4S4_vmCcPZJwpHkfOYuDe3boHCsYGW8q0U4=+tLui+QYg@mail.gmail.com>
	<20160323115659.GF21717@nuc-i3427.alporthouse.com>
Date: Wed, 23 Mar 2016 16:32:59 +0100
Message-ID: <CANq1E4SFPMoE4G4XARFLyEH40OOZnR2v_PQD4=ps3KBvVXUHpA@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Update docs for SYNC ioctl
From: David Herrmann <dh.herrmann@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
	David Herrmann <dh.herrmann@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Tiago Vignatti <tiago.vignatti@intel.com>,
	=?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	devel@driverdev.osuosl.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Wed, Mar 23, 2016 at 12:56 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, Mar 23, 2016 at 12:30:42PM +0100, David Herrmann wrote:
>> My question was rather about why we do this? Semantics for EINTR are
>> well defined, and with SA_RESTART (default on linux) user-space can
>> ignore it. However, looping on EAGAIN is very uncommon, and it is not
>> at all clear why it is needed?
>>
>> Returning an error to user-space makes sense if user-space has a
>> reason to react to it. I fail to see how EAGAIN on a cache-flush/sync
>> operation helps user-space at all? As someone without insight into the
>> driver implementation, it is hard to tell why.. Any hints?
>
> The reason we return EAGAIN is to workaround a deadlock we face when
> blocking on the GPU holding the struct_mutex (inside the client's
> process), but the GPU is dead. As our locking is very, very coarse we
> cannot restart the GPU without acquiring the struct_mutex being held by
> the client so we wake the client up and tell them the resource they are
> waiting on (the flush of the object from the GPU into the CPU domain) is
> temporarily unavailable. If they try to immediately wait upon the ioctl
> again, they are blocked waiting for the reset to occur before they may
> complete their flush. There are a few other possible deadlocks that are
> also avoided with EAGAIN (again, the issue is more or less the lack of
> fine grained locking).

...so you hijacked EAGAIN for all DRM ioctls just for a driver
workaround? EAGAIN is universally used to signal the caller about a
blocking resource. It is very much linked to O_NONBLOCK. Why not use
EBUSY, ECANCELED, ECOMM, EDEADLOCK, EIO, EL3RST, ...

Anyhow, I guess that ship has sailed. But just mentioning EAGAIN in a
kernel-doc is way to vague for user-space to figure out they should
loop on it.

Thanks
David
