Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33860 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753570AbdGCSkS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 14:40:18 -0400
Received: by mail-qk0-f196.google.com with SMTP id 91so24989021qkq.1
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 11:40:17 -0700 (PDT)
Date: Mon, 3 Jul 2017 15:40:14 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 00/12] V4L2 explicit synchronization support
Message-ID: <20170703184014.GC3337@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170630091815.3682484c@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170630091815.3682484c@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

2017-06-30 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Fri, 16 Jun 2017 16:39:03 +0900
> Gustavo Padovan <gustavo@padovan.org> escreveu:
> 
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Hi,
> > 
> > This adds support for Explicit Synchronization of shared buffers in V4L2.
> > It uses the Sync File Framework[1] as vector to communicate the fences
> > between kernel and userspace.
> > 
> > Explicit Synchronization allows us to control the synchronization of
> > shared buffers from userspace by passing fences to the kernel and/or 
> > receiving them from the the kernel.
> > 
> > Fences passed to the kernel are named in-fences and the kernel should wait
> > them to signal before using the buffer. On the other side, the kernel creates
> > out-fences for every buffer it receives from userspace. This fence is sent back
> > to userspace and it will signal when the capture, for example, has finished.
> > 
> > Signalling an out-fence in V4L2 would mean that the job on the buffer is done
> > and the buffer can be used by other drivers.
> > 
> > The first patch proposes an userspace API for fences, then on patch 2
> > we prepare to the addition of in-fences in patch 3, by introducing the
> > infrastructure on vb2 to wait on an in-fence signal before queueing the buffer
> > in the driver.
> > 
> > Patch 4 fix uvc v4l2 event handling and patch 5 configure q->dev for vivid
> > drivers to enable to subscribe and dequeue events on it.
> > 
> > Patches 6-7 enables support to notify BUF_QUEUED events, i.e., let userspace
> > know that particular buffer was enqueued in the driver. This is needed,
> > because we return the out-fence fd as an out argument in QBUF, but at the time
> > it returns we don't know to which buffer the fence will be attached thus
> > the BUF_QUEUED event tells which buffer is associated to the fence received in
> > QBUF by userspace.
> > 
> > Patches 8-9 add support to mark queues as ordered. Finally patches 10 and 11
> > add more fence infrastructure to support out-fences and finally patch 12 adds
> > support to out-fences.
> > 
> > Changelog are detailed in each patch.
> > 
> > Please review! Thanks.
> 
> Just reviewed the series. Most patches look good.
> 
> I have one additional concern: if the changes here won't cause any
> bad behaviors if fences is not available for some VB2 non V4L2 client.
> I'm actually thinking on this:
> 
> 	https://patchwork.linuxtv.org/patch/31613/
> 
> From what I saw, after this patch series, someone could try to 
> inconditionally open an out fences fd for a driver. Maybe this
> should be denied by default, enabling such feature only if the
> VB2 "client" (e. g. videobuf-v4l2) supports it.

Yes, I think we can just reject the request if this non-VB2 client
tries to use the arg flags for fences.

Gustavo
