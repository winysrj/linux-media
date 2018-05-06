Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33558 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751187AbeEFMsL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 08:48:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 0/8] R-Car DU: Support CRC calculation
Date: Sun, 06 May 2018 15:48:24 +0300
Message-ID: <190704872.I3Z8hYgVki@avalon>
In-Reply-To: <20180505120513.59e05e93@vento.lan>
References: <20180428205027.18025-1-laurent.pinchart+renesas@ideasonboard.com> <5038283.TSNOrsSzts@avalon> <20180505120513.59e05e93@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Saturday, 5 May 2018 18:05:13 EEST Mauro Carvalho Chehab wrote:
> Em Sat, 05 May 2018 17:06:50 +0300 Laurent Pinchart escreveu:
> > On Thursday, 3 May 2018 16:45:36 EEST Daniel Vetter wrote:
> >> On Thu, May 3, 2018 at 2:06 PM, Laurent Pinchart wrote:
> >>> Hi Dave,
> >>> 
> >>> Ping ?
> >> 
> >> Not aware of any crc core work going on in drm, so has my ack.
> > 
> > Thank you.
> > 
> >> Worst case we do a topic branch or something like that (since I guess
> >> you'll do a pull request anyway on the v4l side).
> > 
> > That would unfortunately not be possible, as Mauro cherry-picks patches
> > instead of merging pull requests. In rare cases I can ask for a
> > pull-request to be merged as-is, but it's too late in this case as the
> > previous pull request that this series is based on has been
> > cherry-picked, not merged.
> 
> I probably missed something, but I fail to see what's the problem.
> 
> If DRM needs a patch that was already merged on our tree, I can gladly
> create a stable branch/tag for it - well, media master branch is stable,
> but I can add a tag there just after the patch DRM needs, in order
> to avoid them to merge from us at some random point.
> 
> If otherwise we need a patch applied at DRM, they can do the same:
> create a branch/tag, and I can pull from it.

Well, my assumption is that Dave would rather not pull the whole linux-media 
tree in the DRM tree. That's easily prevented when handling pull requests 
through a merge instead of a cherry-pick operation, in that case I can just 
base a patch series on top of -rc1 and send a pull request to both of you. The 
linux-media and DRM tree will merge cleanly in Linus' tree as they will both 
contain the same branch.

-- 
Regards,

Laurent Pinchart
