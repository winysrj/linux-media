Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48154 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeEEPFT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 11:05:19 -0400
Date: Sat, 5 May 2018 12:05:13 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 0/8] R-Car DU: Support CRC calculation
Message-ID: <20180505120513.59e05e93@vento.lan>
In-Reply-To: <5038283.TSNOrsSzts@avalon>
References: <20180428205027.18025-1-laurent.pinchart+renesas@ideasonboard.com>
        <4411331.L07MOrSnxD@avalon>
        <CAKMK7uG_WBvAaRDy9Co=LLa6cUcLTuWYNu7ABkUxs-NzEXNRew@mail.gmail.com>
        <5038283.TSNOrsSzts@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 05 May 2018 17:06:50 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Daniel,
> 
> (CC'ing Mauro)
> 
> On Thursday, 3 May 2018 16:45:36 EEST Daniel Vetter wrote:
> > On Thu, May 3, 2018 at 2:06 PM, Laurent Pinchart wrote:  
> > > Hi Dave,
> > > 
> > > Ping ?  
> > 
> > Not aware of any crc core work going on in drm, so has my ack.  
> 
> Thank you.
> 
> > Worst case we do a topic branch or something like that (since I guess you'll
> > do a pull request anyway on the v4l side).  
> 
> That would unfortunately not be possible, as Mauro cherry-picks patches 
> instead of merging pull requests. In rare cases I can ask for a pull-request 
> to be merged as-is, but it's too late in this case as the previous pull 
> request that this series is based on has been cherry-picked, not merged.

I probably missed something, but I fail to see what's the problem.

If DRM needs a patch that was already merged on our tree, I can gladly
create a stable branch/tag for it - well, media master branch is stable,
but I can add a tag there just after the patch DRM needs, in order
to avoid them to merge from us at some random point.

If otherwise we need a patch applied at DRM, they can do the same:
create a branch/tag, and I can pull from it.

Thanks,
Mauro
