Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.melag.de ([217.6.74.107]:43213 "EHLO mail.melag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbbEHJBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2015 05:01:07 -0400
Message-ID: <554C79F7.2080308@melag.de>
Date: Fri, 8 May 2015 10:55:19 +0200
From: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Thierry Reding <treding@nvidia.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Clark <robdclark@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Subject: Re: [RFC] How implement Secure Data Path ?
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com> <20150505175405.2787db4b@lxorguk.ukuu.org.uk> <20150506083552.GF30184@phenom.ffwll.local> <20150506091919.GC16325@ulmo.nvidia.com> <20150506131532.GC30184@phenom.ffwll.local> <20150507132218.GA24541@ulmo.nvidia.com> <20150507135212.GD30184@phenom.ffwll.local> <20150507174003.2a5b42e6@lxorguk.ukuu.org.uk> <20150508083735.GB15256@phenom.ffwll.local>
In-Reply-To: <20150508083735.GB15256@phenom.ffwll.local>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.05.2015 um 10:37 schrieb Daniel Vetter:

> dma-buf user handles are fds, which means anything allocated can be passed
> around nicely already. The question really is whether we'll have one ioctl
> on top of a special dev node or a syscall. I thought that in these cases
> where the dev node is only ever used to allocate the real thing, a syscall
> is the preferred way to go.

I'd generally prefer a /dev node instead of syscall, as they can be
dynamically allocated (loaded as module, etc), which in turn offers more
finer control (eg. for containers, etc). One could easily replace the
it with its own implementation (w/o patching the kernel directly and
reboot it).

Actually, I'm a bit unhappy with the syscall inflation, in fact I'm
not even a big friend of ioctl's - I'd really prefer the Plan9 way :p

>> I guess the same kind of logic as with GEM (except preferably without
>> the DoS security holes) applies as to why its useful to have handles to
>> the DMA buffers.
>
> We have handles (well file descriptors) to dma-bufs already, I'm a bit
> confused what you mean?

Just curious (as I'm pretty new to this area): how to GEM objects and
dma-bufs relate to each other ? Is it possible to directly exchange
buffers between GPUs, VPUs, IPUs, FBs, etc ?


cu
--
Enrico Weigelt, metux IT consult
+49-151-27565287
MELAG Medizintechnik oHG Sitz Berlin Registergericht AG Charlottenburg HRA 21333 B

Wichtiger Hinweis: Diese Nachricht kann vertrauliche oder nur für einen begrenzten Personenkreis bestimmte Informationen enthalten. Sie ist ausschließlich für denjenigen bestimmt, an den sie gerichtet worden ist. Wenn Sie nicht der Adressat dieser E-Mail sind, dürfen Sie diese nicht kopieren, weiterleiten, weitergeben oder sie ganz oder teilweise in irgendeiner Weise nutzen. Sollten Sie diese E-Mail irrtümlich erhalten haben, so benachrichtigen Sie bitte den Absender, indem Sie auf diese Nachricht antworten. Bitte löschen Sie in diesem Fall diese Nachricht und alle Anhänge, ohne eine Kopie zu behalten.
Important Notice: This message may contain confidential or privileged information. It is intended only for the person it was addressed to. If you are not the intended recipient of this email you may not copy, forward, disclose or otherwise use it or any part of it in any form whatsoever. If you received this email in error please notify the sender by replying and delete this message and any attachments without retaining a copy.
