Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:32851 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753056AbdCPOel (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 10:34:41 -0400
Date: Thu, 16 Mar 2017 16:30:59 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: "Sharma, Shashank" <shashank.sharma@intel.com>
Cc: Brian Starkey <brian.starkey@arm.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mihail.atanassov@arm.com,
        liviu.dudau@arm.com
Subject: Re: DRM Atomic property for color-space conversion
Message-ID: <20170316143059.GG31595@intel.com>
References: <20170127172324.GB12018@e106950-lin.cambridge.arm.com>
 <20170130133513.GO31595@intel.com>
 <20170131123329.GB24500@e106950-lin.cambridge.arm.com>
 <20170131151546.GT31595@intel.com>
 <20170131155541.GF11506@e106950-lin.cambridge.arm.com>
 <20170316140725.GF31595@intel.com>
 <0cff6bab-7593-d3d2-f3b5-71dc21669dab@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0cff6bab-7593-d3d2-f3b5-71dc21669dab@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 16, 2017 at 04:20:29PM +0200, Sharma, Shashank wrote:
> Regards
> 
> Shashank
> 
> 
> On 3/16/2017 4:07 PM, Ville Syrjälä wrote:
> > On Tue, Jan 31, 2017 at 03:55:41PM +0000, Brian Starkey wrote:
> >> On Tue, Jan 31, 2017 at 05:15:46PM +0200, Ville Syrjälä wrote:
> >>> On Tue, Jan 31, 2017 at 12:33:29PM +0000, Brian Starkey wrote:
> >>>> Hi,
> >>>>
> >>>> On Mon, Jan 30, 2017 at 03:35:13PM +0200, Ville Syrjälä wrote:
> >>>>> On Fri, Jan 27, 2017 at 05:23:24PM +0000, Brian Starkey wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> We're looking to enable the per-plane color management hardware in
> >>>>>> Mali-DP with atomic properties, which has sparked some conversation
> >>>>>> around how to handle YCbCr formats.
> >>>>>>
> >>>>>> As it stands today, it's assumed that a driver will implicitly "do the
> >>>>>> right thing" to display a YCbCr buffer.
> >>>>>>
> >>>>>> YCbCr data often uses different gamma curves and signal ranges (e.g.
> >>>>>> BT.609, BT.701, BT.2020, studio range, full-range), so its desirable
> >>>>>> to be able to explicitly control the YCbCr to RGB conversion process
> >>>>>> from userspace.
> >>>>>>
> >>>>>> We're proposing adding a "CSC" (color-space conversion) property to
> >>>>>> control this - primarily per-plane for framebuffer->pipeline CSC, but
> >>>>>> perhaps one per CRTC too for devices which have an RGB pipeline and
> >>>>>> want to output in YUV to the display:
> >>>>>>
> >>>>>> Name: "CSC"
> >>>>>> Type: ENUM | ATOMIC;
> >>>>>> Enum values (representative):
> >>>>>> "default":
> >>>>>> 	Same behaviour as now. "Some kind" of YCbCr->RGB conversion
> >>>>>> 	for YCbCr buffers, bypass for RGB buffers
> >>>>>> "disable":
> >>>>>> 	Explicitly disable all colorspace conversion (i.e. use an
> >>>>>> 	identity matrix).
> >>>>>> "YCbCr to RGB: BT.709":
> >>>>>> 	Only valid for YCbCr formats. CSC in accordance with BT.709
> >>>>>> 	using [16..235] for (8-bit) luma values, and [16..240] for
> >>>>>> 	8-bit chroma values. For 10-bit formats, the range limits are
> >>>>>> 	multiplied by 4.
> >>>>>> "YCbCr to RGB: BT.709 full-swing":
> >>>>>> 	Only valid for YCbCr formats. CSC in accordance with BT.709,
> >>>>>> 	but using the full range of each channel.
> >>>>>> "YCbCr to RGB: Use CTM":*
> >>>>>> 	Only valid for YCbCr formats. Use the matrix applied via the
> >>>>>> 	plane's CTM property
> >>>>>> "RGB to RGB: Use CTM":*
> >>>>>> 	Only valid for RGB formats. Use the matrix applied via the
> >>>>>> 	plane's CTM property
> >>>>>> "Use CTM":*
> >>>>>> 	Valid for any format. Use the matrix applied via the plane's
> >>>>>> 	CTM property
> >>>>>> ... any other values for BT.601, BT.2020, RGB to YCbCr etc. etc. as
> >>>>>> they are required.
> >>>>> Having some RGB2RGB and YCBCR2RGB things in the same property seems
> >>>>> weird. I would just go with something very simple like:
> >>>>>
> >>>>> YCBCR_TO_RGB_CSC:
> >>>>> * BT.601
> >>>>> * BT.709
> >>>>> * custom matrix
> >>>>>
> >>>> I think we've agreed in #dri-devel that this CSC property
> >>>> can't/shouldn't be mapped on-to the existing (hardware implementing
> >>>> the) CTM property - even in the case of per-plane color management -
> >>>> because CSC needs to be done before DEGAMMA.
> >>>>
> >>>> So, I'm in favour of going with what you suggested in the first place:
> >>>>
> >>>> A new YCBCR_TO_RGB_CSC property, enum type, with a list of fixed
> >>>> conversions. I'd drop the custom matrix for now, as we'd need to add
> >>>> another property to attach the custom matrix blob too.
> >>>>
> >>>> I still think we need a way to specify whether the source data range
> >>>> is broadcast/full-range, so perhaps the enum list should be expanded
> >>>> to all combinations of BT.601/BT.709 + broadcast/full-range.
> >>> Sounds reasonable. Not that much full range YCbCr stuff out there
> >>> perhaps. Well, apart from jpegs I suppose. But no harm in being able
> >>> to deal with it.
> >>>
> >>>> (I'm not sure what the canonical naming for broadcast/full-range is,
> >>>> we call them narrow and wide)
> >>> We tend to call them full vs. limited range. That's how our
> >>> "Broadcast RGB" property is defined as well.
> >>>
> >> OK, using the same ones sounds sensible.
> >>
> >>>>> And trying to use the same thing for the crtc stuff is probably not
> >>>>> going to end well. Like Daniel said we already have the
> >>>>> 'Broadcast RGB' property muddying the waters there, and that stuff
> >>>>> also ties in with what colorspace we signal to the sink via
> >>>>> infoframes/whatever the DP thing was called. So my gut feeling is
> >>>>> that trying to use the same property everywhere will just end up
> >>>>> messy.
> >>>> Yeah, agreed. If/when someone wants to add CSC on the output of a CRTC
> >>>> (after GAMMA), we can add a new property.
> >>>>
> >>>> That makes me wonder about calling this one SOURCE_YCBCR_TO_RGB_CSC to
> >>>> be explicit that it describes the source data. Then we can later add
> >>>> SINK_RGB_TO_YCBCR_CSC, and it will be reasonably obvious that its
> >>>> value describes the output data rather than the input data.
> >>> Source and sink have a slight connotation in my mind wrt. the box that
> >>> produces the display signal and the box that eats the signal. So trying
> >>> to use the same terms to describe the internals of the pipeline inside
> >>> the "source box" migth lead to some confusion. But we do probably need
> >>> some decent names for these to make the layout of the pipeline clear.
> >>> Input/output are the other names that popped to my mind but those aren't
> >>> necessarily any better. But in the end I think I could live with whatever
> >>> names we happen to pick, as long as we document the pipeline clearly.
> >>>
> >>> Long ago I did wonder if we should just start indexing these things
> >>> somehow, and then just looking at the index should tell you the order
> >>> of the operations. But we already have the ctm/gamma w/o any indexes so
> >>> that idea probably isn't so great anymore.
> >>>
> >>>> I want to avoid confusion caused by ending up with two
> >>>> {CS}_TO_{CS}_CSC properties, where one is describing the data to the
> >>>> left of it, and the other describing the data to the right of it, with
> >>>> no real way of telling which way around it is.
> >>> Not really sure what you mean. It should always be
> >>> <left>_to_<right>_csc.
> >> Agreed, left-to-right. But for instance on a CSC property representing
> >> a CRTC output CSC (just before hitting the connector), which happens
> >> to be converting RGB to YCbCr:
> >>
> >> CRTC -> GAMMA -> RGB_TO_YCBCR_CSC
> >>
> >> ...the enum value "BT.601 Limited" means that the data on the *right*
> >> of RGB_TO_YCBCR_CSC is "BT.601 Limited"
> >>
> >> On the other hand for a CSC on the input of a plane, which happens to
> >> be converting YCbCr to RGB:
> >>
> >> RAM -> YCBCR_TO_RGB_CSC -> DEGAMMA
> >>
> >> ...the enum value "BT.601 Limited" means that the data on the *left*
> >> of YCBCR_TO_RGB_CSC is "BT.601 Limited".
> >>
> >> Indicating in the property name whether its value is describing the
> >> data on the left or the right is needed (and I don't think inferring
> >> that "it's always the YCBCR one" is the correct approach).
> >>
> >> In my example above, "SOURCE_xxx" would mean the enum value is
> >> describing the "source" data (i.e. the data on the left) and
> >> "SINK_xxx" would mean the enum value is describing the "sink" data
> >> (i.e. the data on the right). This doesn't necessarily need to infer a
> >> particular point in the pipeline.
> > Right, so I guess you want the values to be named "<a> to <b>" as well?
> > Yes, I think we'll be wanting that as well.
> >
> > So what we might need is something like:
> > enum YCBCR_TO_RGB_CSC
> >   * YCbCr BT.601 limited to RGB BT.709 full
> >   * YCbCr BT.709 limited to RGB BT.709 full <this would be the likely default value IMO>
> >   * YCbCr BT.601 limited to RGB BT.2020 full
> >   * YCbCr BT.709 limited to RGB BT.2020 full
> >   * YCbCr BT.2020 limited to RGB BT.2020 full
> >
> > And thanks to BT.2020 we'll need a RGB->RGB CSC property as well. Eg:
> > enum RGB_TO_RGB_CSC
> >   * bypass (or separate 709->709, 2020->2020?) <this would be the default>
> >   * RGB BT.709 full to RGB BT.2020 full
> >
> > Alternatives would involve two properties to define the input and output
> > from the CSC separately, but then you lose the capability to see which
> > combinations are actually supoorted.
> I was thinking about this too, or would it make more sense to create two 
> properties:
> - one for gamut mapping (cases like RGB709->RGB2020)
> - other one for Color space conversion (cases lile YUV 709 -> RGB 709)
> 
> Gamut mapping can represent any of the fix function mapping, wereas CSC 
> can bring up any programmable matrix
> 
> Internally these properties can use the same HW unit or even same function.
> Does it sound any good ?

It's certainly possible. One problem is that we can't inform userspace
upfront which combinations are supported. Whether that's a real problem
I'm not sure. With atomic userspace can of course check upfront if
something can be done or not, but the main problem is then coming up
with a fallback strategy that doesn't suck too badly.

Anyways, I don't think I have any strong favorites here. Would be nice
to hear what everyone else thinks.

-- 
Ville Syrjälä
Intel OTC
