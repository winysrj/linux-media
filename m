Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49619 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaGGR14 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jul 2014 13:27:56 -0400
Received: by mail-oa0-f53.google.com with SMTP id l6so4873642oag.26
        for <linux-media@vger.kernel.org>; Mon, 07 Jul 2014 10:27:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140702053758.GA7578@kroah.com>
References: <20140701103432.12718.82795.stgit@patser> <20140702053758.GA7578@kroah.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 7 Jul 2014 22:57:35 +0530
Message-ID: <CAO_48GGkhB3wQwcW=DpDR4zO7k8-2tm_aynsDxZ5Q72ffwtx=A@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Updated fence patch series
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Colin Cross <ccross@google.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On 2 July 2014 11:07, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 01, 2014 at 12:57:02PM +0200, Maarten Lankhorst wrote:
>> So after some more hacking I've moved dma-buf to its own subdirectory,
>> drivers/dma-buf and applied the fence patches to its new place. I believe that the
>> first patch should be applied regardless, and the rest should be ready now.
>> :-)
>>
>> Changes to the fence api:
>> - release_fence -> fence_release etc.
>> - __fence_init -> fence_init
>> - __fence_signal -> fence_signal_locked
>> - __fence_is_signaled -> fence_is_signaled_locked
>> - Changing BUG_ON to WARN_ON in fence_later, and return NULL if it triggers.
>>
>> Android can expose fences to userspace. It's possible to make the new fence
>> mechanism expose the same fences to userspace by changing sync_fence_create
>> to take a struct fence instead of a struct sync_pt. No other change is needed,
>> because only the fence parts of struct sync_pt are used. But because the
>> userspace fences are a separate problem and I haven't really looked at it yet
>> I feel it should stay in staging, for now.
>
> Ok, that's reasonable.
>
> At first glance, this all looks "sane" to me, any objection from anyone
> if I merge this through my driver-core tree for 3.17?
>
Fwiw, Ack from me as well!
> thanks,
>
> greg k-h
Best regards,
~Sumit.
