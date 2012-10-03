Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39019 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab2JCMi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 08:38:59 -0400
Received: by vcbfo13 with SMTP id fo13so8172873vcb.19
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2012 05:38:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506AD9A9.3090506@gmail.com>
References: <503f7244.1180cd0a.7c47.ffffed02SMTPIN_ADDED@mx.google.com>
	<506AD9A9.3090506@gmail.com>
Date: Wed, 3 Oct 2012 14:38:58 +0200
Message-ID: <CAF6AEGsOURL56B+sy5BJ6VD8P3njEkrjkC8+J3NY4H8tyBUXdA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] New dma_buf -> EGLImage EGL extension
From: Rob Clark <rob.clark@linaro.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Tom Cooksey <tom.cooksey@arm.com>, mesa-dev@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	Jesse Barker <jesse.barker@linaro.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 2, 2012 at 2:10 PM, Maarten Lankhorst
<m.b.lankhorst@gmail.com> wrote:
> How do you want to deal with the case where Y' and CbCr are different hardware buffers?
> Could some support for 2d arrays be added in case Y' and CbCr are separated into top/bottom fields?
> How are semi-planar/planar formats handled that have a different width/height for Y' and CbCr? (YUV420)

The API works (AFAIU) like drm addfb2 ioctl, take I420 for example,
you could either do:

  single buffer:
     fd0 = fd
     offset0 = 0
     pitch0 = width
     fd1 = fd
     offset1 = width * height
     pitch1 = width / 2
     fd2 = fd
     offset2 = offset1 + (width / height / 4)
     pitch2 = width / 2

  multiple buffers:
     offset0 = offset1 = offset2 = 0
     fd0 = fd_luma
     fd1 = fd_u
     fd2 = fd_v
     ... and so on

for interlaced/stereo.. is sticking our heads in sand an option?  :-P

You could get lots of permutations for data layout of fields between
interlaced and stereo.  One option might be to ignore and let the user
create two egl-images and deal with blending in the shader?

BR,
-R
