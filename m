Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49793 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2JJVCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 17:02:07 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so960259vbb.19
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2012 14:02:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121010191702.404edace@pyramind.ukuu.org.uk>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
Date: Wed, 10 Oct 2012 16:02:06 -0500
Message-ID: <CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
From: Rob Clark <rob@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Morell <rmorell@nvidia.com>, linaro-mm-sig@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 10, 2012 at 1:17 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 10 Oct 2012 08:56:32 -0700
> Robert Morell <rmorell@nvidia.com> wrote:
>
>> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
>> issue, and not really an interface".  The dma-buf infrastructure is
>> explicitly intended as an interface between modules/drivers, so it
>> should use EXPORT_SYMBOL instead.
>
> NAK. This needs at the very least the approval of all rights holders for
> the files concerned and all code exposed by this change.

Well, for my contributions to dmabuf, I don't object.. and I think
because we are planning to use dma-buf in userspace for dri3 /
dri-next, I think that basically makes it a userspace facing kernel
infrastructure which would be required for open and proprietary
drivers alike.  So I don't see much alternative to making this
EXPORT_SYMBOL().  Of course, IANAL.

BR,
-R

> Also I'd note if you are trying to do this for the purpose of combining
> it with proprietary code then you are still in my view as a (and the view
> of many other) rights holder to the kernel likely to be in breach
> of the GPL requirements for a derivative work. You may consider that
> formal notification of my viewpoint. Your corporate legal team can
> explain to you why the fact you are now aware of my view is important to
> them.
>
> Alan
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
