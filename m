Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37646 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753138AbdJQKOX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 06:14:23 -0400
Date: Tue, 17 Oct 2017 13:14:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: vb2: unify calling of set_page_dirty_lock
Message-ID: <20171017101420.5a5cvyhkadmcqgfy@valkosipuli.retiisi.org.uk>
References: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
 <1507650010.2784.11.camel@ndufresne.ca>
 <20171015204014.2awhhygw6hi3lxas@valkosipuli.retiisi.org.uk>
 <1508108964.4502.6.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1508108964.4502.6.camel@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 15, 2017 at 07:09:24PM -0400, Nicolas Dufresne wrote:
> Le dimanche 15 octobre 2017 à 23:40 +0300, Sakari Ailus a écrit :
> > Hi Nicolas,
> > 
> > On Tue, Oct 10, 2017 at 11:40:10AM -0400, Nicolas Dufresne wrote:
> > > Le mardi 29 août 2017 à 14:26 +0300, Stanimir Varbanov a écrit :
> > > > Currently videobuf2-dma-sg checks for dma direction for
> > > > every single page and videobuf2-dc lacks any dma direction
> > > > checks and calls set_page_dirty_lock unconditionally.
> > > > 
> > > > Thus unify and align the invocations of set_page_dirty_lock
> > > > for videobuf2-dc, videobuf2-sg  memory allocators with
> > > > videobuf2-vmalloc, i.e. the pattern used in vmalloc has been
> > > > copied to dc and dma-sg.
> > > 
> > > Just before we go too far in "doing like vmalloc", I would like to
> > > share this small video that display coherency issues when rendering
> > > vmalloc backed DMABuf over various KMS/DRM driver. I can reproduce
> > > this
> > > easily with Intel and MSM display drivers using UVC or Vivid as
> > > source.
> > > 
> > > The following is an HDMI capture of the following GStreamer
> > > pipeline
> > > running on Dragonboard 410c.
> > > 
> > >     gst-launch-1.0 -v v4l2src device=/dev/video2 ! video/x-
> > > raw,format=NV16,width=1280,height=720 ! kmssink
> > >     https://people.collabora.com/~nicolas/vmalloc-issue.mov
> > > 
> > > Feedback on this issue would be more then welcome. It's not clear
> > > to me
> > > who's bug is this (v4l2, drm or iommu). The software is unlikely to
> > > be
> > > blamed as this same pipeline works fine with non-vmalloc based
> > > sources.
> > 
> > Could you elaborate this a little bit more? Which Intel CPU do you
> > have
> > there?
> 
> I have tested with Skylake and Ivy Bridge and on Dragonboard 410c
> (Qualcomm APQ8016 SoC) (same visual artefact)

I presume kmssink draws on the display. Which GPU did you use?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
