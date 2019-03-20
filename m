Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55EAC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 11:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76B9C2146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 11:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553082167;
	bh=yuL/Vuqj4ABjxlndiwneL00LJS4JtyIqE4FL6BUEBDw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=H5+4j3pJIivOnUHo6jApW8dOOW/4pprkqvEh6jDlSIU3X3Ig8o9zqiaFp7I9ymPw0
	 8Rd3PUcosyF6ls54CRKAO2xHkyqfzIQS4FtaGvyxTH4rfYa46WGhcGcT78UR/e2/X7
	 c20ScFlRZEtCWbRZdKMpe+ym4zUanrOBW3ZmRV4s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfCTLmr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 07:42:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:57484 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfCTLmq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 07:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vn5h7VfoIPUmUfO+rqLoIiub853GydZW6LaAcL5o3zQ=; b=hTiIOW5QKM8vxpChbpPoDAr872
        i0LRlahCFstvlU3V/lsd1eUrvmBmJcrJj+VMwFQV9mbkxUgTG6XzFowFYEynvopXrpjYK2bGZkxzs
        fjKAyAGeEoWHxDTtD5an/bdPy5dPVSXe0yDZRVrrBR1dN1C/egKsRK8YXi42cJaQCUHRIPRopoNa/
        MhBP/LWWGJRys8dBwL755JcZqxBHIKF9Hd6fQopDPUqhdluenGISZci54Nz0Erz16MJGrvdsOEPvY
        02w4JHahMsQtKitcQl5q4IqzcAZG/yy51kWxWguZs9N2u0vmEv2/Zh2mNzZMesjEkX7vJtbJGMoxr
        /Op+PJsg==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6ZcJ-0004UX-El; Wed, 20 Mar 2019 11:42:44 +0000
Date:   Wed, 20 Mar 2019 08:42:39 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org,
        helen.koike@collabora.com, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH v5 02/23] videodev2.h: add
 V4L2_BUF_CAP_REQUIRES_REQUESTS
Message-ID: <20190320084239.7e58aa05@coco.lan>
In-Reply-To: <ca97c48b-3b7f-3c97-ec19-54469604fe79@xs4all.nl>
References: <20190306211343.15302-1-dafna3@gmail.com>
        <20190306211343.15302-3-dafna3@gmail.com>
        <20190320071112.4ed71c54@coco.lan>
        <ca97c48b-3b7f-3c97-ec19-54469604fe79@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 20 Mar 2019 11:39:47 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 3/20/19 11:11 AM, Mauro Carvalho Chehab wrote:
> > Em Wed,  6 Mar 2019 13:13:22 -0800
> > Dafna Hirschfeld <dafna3@gmail.com> escreveu:
> >   
> >> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >>
> >> Add capability to indicate that requests are required instead of
> >> merely supported.  
> > 
> > Not sure if I liked this patch, and for sure it lacks a lot of documentation:
> > 
> > First of all, the patch description doesn't help. For example, it doesn't
> > explain or mention any use case example that would require (instead of
> > merely support) a request.  
> 
> Stateless codecs require the use of requests (i.e. they can't function without
> this).
> 
> However, right now every driver has to check for this and return an error when
> an attempt is made to stream without requests.
> 
> And userspace has no way of knowing whether requests are required by the driver
> as opposed to being optional.
> 
> That's what this attempts to do: show to userspace that requests are required,
> and add a vb2 flag that will force the core to check this so drivers do not need
> to test for it.
> 
> Currently the only drivers that would need this are cedrus and vicodec.

I see. Please add a comment like that at this patch's description.

> 
> >   
> >>
> >> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >> ---
> >>  Documentation/media/uapi/v4l/vidioc-reqbufs.rst | 4 ++++
> >>  include/uapi/linux/videodev2.h                  | 1 +
> >>  2 files changed, 5 insertions(+)
> >>
> >> diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
> >> index d7faef10e39b..d42a3d9a7db3 100644
> >> --- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
> >> +++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
> >> @@ -125,6 +125,7 @@ aborting or finishing any DMA in progress, an implicit
> >>  .. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
> >>  .. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
> >>  .. _V4L2-BUF-CAP-SUPPORTS-ORPHANED-BUFS:
> >> +.. _V4L2-BUF-CAP-REQUIRES-REQUESTS:
> >>  
> >>  .. cssclass:: longtable
> >>  
> >> @@ -150,6 +151,9 @@ aborting or finishing any DMA in progress, an implicit
> >>        - The kernel allows calling :ref:`VIDIOC_REQBUFS` while buffers are still
> >>          mapped or exported via DMABUF. These orphaned buffers will be freed
> >>          when they are unmapped or when the exported DMABUF fds are closed.
> >> +    * - ``V4L2_BUF_CAP_REQUIRES_REQUESTS``
> >> +      - 0x00000020
> >> +      - This buffer type requires the use of :ref:`requests <media-request-api>`.  
> > 
> > And the documentation here is really poor, as it doesn't explain what's
> > the API and drivers expected behavior with regards to this flag.
> > 
> > I mean, if, on a new driver, requests are mandatory, what happens if a
> > non-request-API aware application tries to use it?   
> 
> An error will be returned. And that error needs to be documented, I agree.

As discussed at the #v4l channel, EBADR error code seems to be an
appropriate error code for it. Please document it.

> 
> All this does is shift the check from the driver to the v4l2 core. It doesn't
> change anything for userspace, except that with this capability flag userspace
> can detect beforehand that requests are required.

Yeah, checking at the core makes sense.

> 
> > 
> > Another thing that concerns me a lot is that people might want to add it
> > to existing drivers. Well, if an application was written before the
> > addition of this driver, and request API become mandatory, such app
> > will stop working, if it doesn't use request API.
> > At very least, it should be mentioned somewhere that existing drivers
> > should never set this flag, as this would break it for existing
> > userspace apps.
> > 
> > Still, I would prefer to not have to add something like that.  
> 
> The only affected driver is the staging cedrus driver. And that will
> actually crash if you try to use it without requests.
> 
> If you look at patch 3 you'll see that it just sets the flag and doesn't
> remove any code that was supposed to check for use-without-requests.
> That's because there never was a check and the driver would just crash.
> 
> So we're safe here.

Making it mandatory for the cedrus driver makes sense, but no other
current driver should ever use it. 

The problem I see is that, as we advance on improving the requests API,
non-stateless-codec drivers may end supporting the request API. 
That's perfectly fine, but such other drivers should *never* be
changed to use V4L2_BUF_CAP_REQUIRES_REQUESTS. This also applies to any
new driver that it is not implementing a stateless codec.

Btw, as this seems to be a requirement only for stateless codec drivers,
perhaps we should (at least in Kernelspace) to use, instead, a
V4L2_BUF_CAP_STATELESS_CODEC_ONLY flag, with the V4L2 core would
translate it to V4L2_BUF_CAP_REQUIRES_REQUESTS before returning it to
userspace, and have a special #ifdef at the userspace header, in order
to prevent this flag to be set directly by a random driver.

> 
> I believe patches 1-3 make sense, but I also agree that the documentation
> and commit logs can be improved.
> 
> I can either respin with updated patches 1-3, or, if you still have concerns,
> drop 1-3 and repost the remainder of the series. But then I'll need to add
> checks against the use of the stateless vicodec decoder without requests in
> patch 21/23.

Whatever you prefer. If the remaining patches don't require it, you could
just tag the pull request as new and ping me on IRC. I'll review the remaining
ones, skipping the V4L2_BUF_CAP_REQUIRES_REQUESTS specific patches.

> 
> But this really doesn't belong in a driver. These checks should be done in the
> vb2 core.

Yeah, I agree.

> 
> Regards,
> 
> 	Hans
> 
> > 
> >   
> >>  
> >>  Return Value
> >>  ============
> >> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> >> index 1db220da3bcc..97e6a6a968ba 100644
> >> --- a/include/uapi/linux/videodev2.h
> >> +++ b/include/uapi/linux/videodev2.h
> >> @@ -895,6 +895,7 @@ struct v4l2_requestbuffers {
> >>  #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
> >>  #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
> >>  #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
> >> +#define V4L2_BUF_CAP_REQUIRES_REQUESTS	(1 << 5)
> >>  
> >>  /**
> >>   * struct v4l2_plane - plane info for multi-planar buffers  
> > 
> > 
> > 
> > Thanks,
> > Mauro
> >   
> 



Thanks,
Mauro
