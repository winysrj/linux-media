Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45463 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751073AbdFFHZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 03:25:54 -0400
Date: Tue, 6 Jun 2017 10:25:19 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 01/12] videodev2.h, v4l2-ioctl: add IPU3 meta buffer
 format
Message-ID: <20170606072519.GF15419@paasikivi.fi.intel.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-2-git-send-email-yong.zhi@intel.com>
 <CAAFQd5B6LiWgX+=-HJnO480FF-AXDa+UqtSs+SYUG=S+kGgNVg@mail.gmail.com>
 <CAAFQd5DpzAGBi_kevEBp05yC4ytM3Q8WU2owZucsE3AZ=s=OoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5DpzAGBi_kevEBp05yC4ytM3Q8WU2owZucsE3AZ=s=OoA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Tue, Jun 06, 2017 at 01:30:41PM +0900, Tomasz Figa wrote:
> Uhm, +Laurent. Sorry for the noise.
> 
> On Tue, Jun 6, 2017 at 1:30 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> > Hi Yong,
> >
> > On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> >> Add the IPU3 specific processing parameter format
> >> V4L2_META_FMT_IPU3_PARAMS and metadata formats
> >> for 3A and other statistics:
> >
> > Please see my comments inline.
> >
> >>
> >>   V4L2_META_FMT_IPU3_PARAMS
> >>   V4L2_META_FMT_IPU3_STAT_3A
> >>   V4L2_META_FMT_IPU3_STAT_DVS
> >>   V4L2_META_FMT_IPU3_STAT_LACE
> >>
> >> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++++
> >>  include/uapi/linux/videodev2.h       | 6 ++++++
> >>  2 files changed, 10 insertions(+)
> > [snip]
> >> +/* Vendor specific - used for IPU3 camera sub-system */
> >> +#define V4L2_META_FMT_IPU3_PARAMS      v4l2_fourcc('i', 'p', '3', 'p') /* IPU3 params */
> >> +#define V4L2_META_FMT_IPU3_STAT_3A     v4l2_fourcc('i', 'p', '3', 's') /* IPU3 3A statistics */
> >> +#define V4L2_META_FMT_IPU3_STAT_DVS    v4l2_fourcc('i', 'p', '3', 'd') /* IPU3 DVS statistics */
> >> +#define V4L2_META_FMT_IPU3_STAT_LACE   v4l2_fourcc('i', 'p', '3', 'l') /* IPU3 LACE statistics */
> >
> > We had some discussion about this with Laurent and if I remember
> > correctly, the conclusion was that it might make sense to define one
> > FourCC for a vendor specific format, ('v', 'n', 'd', 'r') for example,
> > and then have a V4L2-specific enum within the v4l2_pix_format(_mplane)
> > struct that specifies the exact vendor data type. It seems saner than
> > assigning a new FourCC whenever a new hardware revision comes out,
> > especially given that FourCCs tend to be used outside of the V4L2
> > world as well and being kind of (de facto) standardized (with existing
> > exceptions, unfortunately).

If we have four video nodes with different vendor specific formats, how does
the user tell the formats apart? I presume the user space could use the
entity names for instance, but that would essentially make them device
specific.

I'm not sure if there would be any harm from that in practice though: the
user will need to find the device nodes somehow and that will be very likely
based on e.g. entity names.

How should the documentation be arranged? The documentation is arranged by
fourccs currently; we'd probably need a separate section for vendor specific
formats. I think the device name should be listed there as well.

I'd like to have perhaps Hans's comment on that as well.

I don't really see a drawback in the current way of doing this either; we
may get a few new fourcc codes occasionally of which I'm not really worried
about. --- I'd rather ask why should there be an exception on how vendor
specific formats are defined. And if we do make an exception, then how do
you decide which one is and isn't vendor specific? There are raw bayer
format variants that are just raw bayer data but the pixels are arranged
differently (e.g. CIO2 driver).

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
