Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36450 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753019AbdFPIuK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 04:50:10 -0400
Date: Fri, 16 Jun 2017 11:49:35 +0300
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
Message-ID: <20170616084935.GJ12407@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-2-git-send-email-yong.zhi@intel.com>
 <CAAFQd5B6LiWgX+=-HJnO480FF-AXDa+UqtSs+SYUG=S+kGgNVg@mail.gmail.com>
 <CAAFQd5DpzAGBi_kevEBp05yC4ytM3Q8WU2owZucsE3AZ=s=OoA@mail.gmail.com>
 <20170606072519.GF15419@paasikivi.fi.intel.com>
 <1d067ac0-6265-4262-e59b-089d6055550b@xs4all.nl>
 <CAAFQd5CY7jUJEicQ79QLTYP65cWqMhtTXJvZD-VCnKN134Ypeg@mail.gmail.com>
 <CAAFQd5C1PQkMgu3QMJ=_J2-FCiUzVwGft6-U3JQRQNy4=1CgRg@mail.gmail.com>
 <20170616082510.GH12407@valkosipuli.retiisi.org.uk>
 <CAAFQd5CDG0QYDaD=4ono0Yahz+7+TJ_KLsc+K-bgN82yFr6qmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5CDG0QYDaD=4ono0Yahz+7+TJ_KLsc+K-bgN82yFr6qmg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Fri, Jun 16, 2017 at 05:35:52PM +0900, Tomasz Figa wrote:
> On Fri, Jun 16, 2017 at 5:25 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Tomasz,
> >
> > On Fri, Jun 16, 2017 at 02:52:07PM +0900, Tomasz Figa wrote:
> >> On Tue, Jun 6, 2017 at 7:09 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> >> > On Tue, Jun 6, 2017 at 5:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> >> On 06/06/17 09:25, Sakari Ailus wrote:
> >> >>> Hi Tomasz,
> >> >>>
> >> >>> On Tue, Jun 06, 2017 at 01:30:41PM +0900, Tomasz Figa wrote:
> >> >>>> Uhm, +Laurent. Sorry for the noise.
> >> >>>>
> >> >>>> On Tue, Jun 6, 2017 at 1:30 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> >> >>>>> Hi Yong,
> >> >>>>>
> >> >>>>> On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> >> >>>>>> Add the IPU3 specific processing parameter format
> >> >>>>>> V4L2_META_FMT_IPU3_PARAMS and metadata formats
> >> >>>>>> for 3A and other statistics:
> >> >>>>>
> >> >>>>> Please see my comments inline.
> >> >>>>>
> >> >>>>>>
> >> >>>>>>   V4L2_META_FMT_IPU3_PARAMS
> >> >>>>>>   V4L2_META_FMT_IPU3_STAT_3A
> >> >>>>>>   V4L2_META_FMT_IPU3_STAT_DVS
> >> >>>>>>   V4L2_META_FMT_IPU3_STAT_LACE
> >> >>>>>>
> >> >>>>>> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> >> >>>>>> ---
> >> >>>>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++++
> >> >>>>>>  include/uapi/linux/videodev2.h       | 6 ++++++
> >> >>>>>>  2 files changed, 10 insertions(+)
> >> >>>>> [snip]
> >> >>>>>> +/* Vendor specific - used for IPU3 camera sub-system */
> >> >>>>>> +#define V4L2_META_FMT_IPU3_PARAMS      v4l2_fourcc('i', 'p', '3', 'p') /* IPU3 params */
> >> >>>>>> +#define V4L2_META_FMT_IPU3_STAT_3A     v4l2_fourcc('i', 'p', '3', 's') /* IPU3 3A statistics */
> >> >>>>>> +#define V4L2_META_FMT_IPU3_STAT_DVS    v4l2_fourcc('i', 'p', '3', 'd') /* IPU3 DVS statistics */
> >> >>>>>> +#define V4L2_META_FMT_IPU3_STAT_LACE   v4l2_fourcc('i', 'p', '3', 'l') /* IPU3 LACE statistics */
> >> >>>>>
> >> >>>>> We had some discussion about this with Laurent and if I remember
> >> >>>>> correctly, the conclusion was that it might make sense to define one
> >> >>>>> FourCC for a vendor specific format, ('v', 'n', 'd', 'r') for example,
> >> >>>>> and then have a V4L2-specific enum within the v4l2_pix_format(_mplane)
> >> >>>>> struct that specifies the exact vendor data type. It seems saner than
> >> >>>>> assigning a new FourCC whenever a new hardware revision comes out,
> >> >>>>> especially given that FourCCs tend to be used outside of the V4L2
> >> >>>>> world as well and being kind of (de facto) standardized (with existing
> >> >>>>> exceptions, unfortunately).
> >> >>
> >> >> I can't remember that discussion
> >> >
> >> > I think that was just a casual chat between Lauren, me and few more guys.
> >> >
> >> >> although I've had other discussions with
> >> >> Laurent related to this on how to handle formats that have many variations
> >> >> on a theme.
> >> >>
> >> >> But speaking for this specific case I see no reason to do something special.
> >> >> There are only four new formats, which seems perfectly reasonable to me.
> >> >>
> >> >> I don't see the advantage of adding another layer of pixel formats. You still
> >> >> need to define something for this, one way or the other. And this way doesn't
> >> >> require API changes.
> >> >>
> >> >>> If we have four video nodes with different vendor specific formats, how does
> >> >>> the user tell the formats apart? I presume the user space could use the
> >> >>> entity names for instance, but that would essentially make them device
> >> >>> specific.
> >> >>
> >> >> Well, they are. There really is no way to avoid that.
> >> >>
> >> >>> I'm not sure if there would be any harm from that in practice though: the
> >> >>> user will need to find the device nodes somehow and that will be very likely
> >> >>> based on e.g. entity names.
> >> >>>
> >> >>> How should the documentation be arranged? The documentation is arranged by
> >> >>> fourccs currently; we'd probably need a separate section for vendor specific
> >> >>> formats. I think the device name should be listed there as well.
> >> >>
> >> >> There already is a separate section for metadata formats:
> >> >>
> >> >> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/meta-formats.html
> >> >>
> >> >> But perhaps that page should be organized by device. And with some more
> >> >> detailed information on how to find the video node (i.e. entity names).
> >> >>
> >> >>> I'd like to have perhaps Hans's comment on that as well.
> >> >>>
> >> >>> I don't really see a drawback in the current way of doing this either; we
> >> >>> may get a few new fourcc codes occasionally of which I'm not really worried
> >> >>> about. --- I'd rather ask why should there be an exception on how vendor
> >> >>> specific formats are defined. And if we do make an exception, then how do
> >> >>> you decide which one is and isn't vendor specific? There are raw bayer
> >> >>> format variants that are just raw bayer data but the pixels are arranged
> >> >>> differently (e.g. CIO2 driver).
> >> >>>
> >> >>
> >> >> For these unique formats I am happy with the way it is today. The problem
> >> >> is more with 'parameterized' formats. A simple example would be the 4:2:2
> >> >> interleaved YUV formats where you have four different ways of ordering the
> >> >> Y, U and V components. Right now we have four defines for that, but things
> >> >> get out of hand quickly when you have multiple parameters like that.
> >> >>
> >> >> Laurent and myself discussed that with NVidia some time ago, without
> >> >> reaching a clear conclusion. Mostly because we couldn't come up with an
> >> >> API that is simple enough.
> >> >
> >> > Actually I back off a bit. Still, it looks like we have a metadata
> >> > interface already, but it's limited to CAPTURE:
> >> >
> >> > https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/dev-meta.html#metadata
> >> >
> >> > Maybe we can also have V4L2_BUF_TYPE_META_OUTPUT and solve the problem
> >> > of private FourCCs (and possible collisions with rest of the world) by
> >> > restricting them to the V4L2_BUF_TYPE_META_* classes only?
> >>
> >> Any comments on this idea?
> >
> > Yes. I can submit a patch to add V4L2_BUF_TYPE_META_OUTPUT.
> 
> I think this would make sense, at least for consistency. And it's just
> more logical that a metadata queue is actually of a META type.
> 
> >
> > Even if a fourcc is specific to a driver, it needs to be defined in
> > videodev2.h as the others. Or some means is needed to make sure no
> > collisions will happen --- an easy solution is to keep them in the same
> > place. I think that even in this case we'll need a script that checks the
> > values in some point in the future.
> 
> There is one minor twist, though. FourCC is not something specific to
> V4L2, it's something that is supposed to have a wider understanding,
> across different frameworks/subsystems. Anyway, I don't think it's a
> bit problem for such specific things and even if we have a collision,
> it's unlikely that it happens within the same driver (or queue type),
> so we might be even able to deal with formats that have the same
> FourCC, based on the context they are used in.

Then the application needs to know which one it would be. For device
specific formats this probably wouldn't be a big deal, but for more generic
ones it would definitely be a problem.

> 
> So, generally, agreed.
> 
> >
> >>
> >> Actually, there is one more thing, which would become possible with
> >> switching to different queue types. If we have a device with queues
> >> like this:
> >> - video input,
> >> - video output,
> >> - parameters,
> >> - statistics,
> >> they could all be contained within one video node simply exposing 4
> >> different queues. It would actually even allow an easy implementation
> >
> > The problem comes when you have multiple queues with the same type. I
> > actually once proposed that (albeit for a slightly different purposes:
> > streams) but the idea was rejected. It was decided to use separate video
> > nodes instead.
> >
> >> of mem2mem, given that for mem2mem devices opening a video node means
> >> creating a mem2mem context (while multiple video nodes would require
> >> some special synchronization to map contexts together, which doesn't
> >> exist as of today).
> >
> > V4L2 is very stream oriented and the mem2mem interface somewhat gets around
> > that. There are cases where at least partially changing per-frame
> > configuration is needed in streaming cases as well. The request API is
> > supposed to resolve these issues but it has become evident that the
> > implementation is far from trivial.
> >
> > I'd rather like to have a more generic solution than a number of
> > framework-lets that have their own semantics of the generic V4L2 IOCTLs that
> > only work with a particular kind of a device. Once there are new kind of
> > devices, we'd need to implement another framework-let to support them.
> >
> > Add a CSI-2 receiver to the ImgU device and we'll need again something very
> > different...
> 
> I need to think if Request API alone is really capable of solving this
> problem, but if so, it would make sense indeed.

What comes to this driver --- the request API could be beneficial, but the
driver does not strictly need it. If there were controls that would need to
be changed during streaming or if the device contained a CSI-2 receiver,
then it'd be more important to have the request API.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
