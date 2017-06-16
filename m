Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37552 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753219AbdFPJTt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 05:19:49 -0400
Date: Fri, 16 Jun 2017 12:19:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 01/12] videodev2.h, v4l2-ioctl: add IPU3 meta buffer
 format
Message-ID: <20170616091944.GL12407@valkosipuli.retiisi.org.uk>
References: <CAAFQd5B6LiWgX+=-HJnO480FF-AXDa+UqtSs+SYUG=S+kGgNVg@mail.gmail.com>
 <CAAFQd5DpzAGBi_kevEBp05yC4ytM3Q8WU2owZucsE3AZ=s=OoA@mail.gmail.com>
 <20170606072519.GF15419@paasikivi.fi.intel.com>
 <1d067ac0-6265-4262-e59b-089d6055550b@xs4all.nl>
 <CAAFQd5CY7jUJEicQ79QLTYP65cWqMhtTXJvZD-VCnKN134Ypeg@mail.gmail.com>
 <CAAFQd5C1PQkMgu3QMJ=_J2-FCiUzVwGft6-U3JQRQNy4=1CgRg@mail.gmail.com>
 <20170616082510.GH12407@valkosipuli.retiisi.org.uk>
 <CAAFQd5CDG0QYDaD=4ono0Yahz+7+TJ_KLsc+K-bgN82yFr6qmg@mail.gmail.com>
 <20170616084935.GJ12407@valkosipuli.retiisi.org.uk>
 <CAAFQd5DuQE5EyFejgVqsdEPgmcWmvU+7vRLC9Vwmkam4K8o6KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5DuQE5EyFejgVqsdEPgmcWmvU+7vRLC9Vwmkam4K8o6KA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 16, 2017 at 06:03:13PM +0900, Tomasz Figa wrote:
> On Fri, Jun 16, 2017 at 5:49 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Tomasz,
> >
> > On Fri, Jun 16, 2017 at 05:35:52PM +0900, Tomasz Figa wrote:
> >> On Fri, Jun 16, 2017 at 5:25 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> >> > Hi Tomasz,
> >> >
> >> > On Fri, Jun 16, 2017 at 02:52:07PM +0900, Tomasz Figa wrote:
> >> >> On Tue, Jun 6, 2017 at 7:09 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> >> >> Actually, there is one more thing, which would become possible with
> >> >> switching to different queue types. If we have a device with queues
> >> >> like this:
> >> >> - video input,
> >> >> - video output,
> >> >> - parameters,
> >> >> - statistics,
> >> >> they could all be contained within one video node simply exposing 4
> >> >> different queues. It would actually even allow an easy implementation
> >> >
> >> > The problem comes when you have multiple queues with the same type. I
> >> > actually once proposed that (albeit for a slightly different purposes:
> >> > streams) but the idea was rejected. It was decided to use separate video
> >> > nodes instead.
> >> >
> >> >> of mem2mem, given that for mem2mem devices opening a video node means
> >> >> creating a mem2mem context (while multiple video nodes would require
> >> >> some special synchronization to map contexts together, which doesn't
> >> >> exist as of today).
> >> >
> >> > V4L2 is very stream oriented and the mem2mem interface somewhat gets around
> >> > that. There are cases where at least partially changing per-frame
> >> > configuration is needed in streaming cases as well. The request API is
> >> > supposed to resolve these issues but it has become evident that the
> >> > implementation is far from trivial.
> >> >
> >> > I'd rather like to have a more generic solution than a number of
> >> > framework-lets that have their own semantics of the generic V4L2 IOCTLs that
> >> > only work with a particular kind of a device. Once there are new kind of
> >> > devices, we'd need to implement another framework-let to support them.
> >> >
> >> > Add a CSI-2 receiver to the ImgU device and we'll need again something very
> >> > different...
> >>
> >> I need to think if Request API alone is really capable of solving this
> >> problem, but if so, it would make sense indeed.
> >
> > What comes to this driver --- the request API could be beneficial, but the
> > driver does not strictly need it. If there were controls that would need to
> > be changed during streaming or if the device contained a CSI-2 receiver,
> > then it'd be more important to have the request API.
> 
> There is one use case, though, which can't be achieved easily with
> current model - processing images for two cameras at the same time.
> One could theoretically do all the S_FMT/S_WHATNOT magic every frame,
> to process the cameras in a round robin fashion, but I'm not sure if
> this would work really well in practice.

That's true --- having to wait for all the buffers before configuring the
formats would introduce some systematic delay which would decrease the total
throughput. I'm not sure how much that would be though. The number of IOCTLs
on each frame is big but then again IOCTLs are fast. The buffer memory isn't
affected in any case. Process scheduling will be required though.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
