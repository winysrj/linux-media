Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3955 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdCQOXI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 10:23:08 -0400
Date: Fri, 17 Mar 2017 16:09:51 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: "Sharma, Shashank" <shashank.sharma@intel.com>,
        Local user for Liviu Dudau <liviu.dudau@arm.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mihail.atanassov@arm.com,
        "Cyr, Aric" <Aric.Cyr@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: DRM Atomic property for color-space conversion
Message-ID: <20170317140951.GT31595@intel.com>
References: <20170131155541.GF11506@e106950-lin.cambridge.arm.com>
 <20170316140725.GF31595@intel.com>
 <0cff6bab-7593-d3d2-f3b5-71dc21669dab@intel.com>
 <20170316143059.GG31595@intel.com>
 <20170316143721.GN6268@e110455-lin.cambridge.arm.com>
 <f806a38d-f52c-0cf2-bee6-582f1a35d312@intel.com>
 <20170316155501.GA25006@e106950-lin.cambridge.arm.com>
 <fc590903-a88e-d2c2-968f-26d59963caba@intel.com>
 <20170316173656.GI31595@intel.com>
 <20170317103313.GA2090@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170317103313.GA2090@e106950-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 17, 2017 at 10:33:15AM +0000, Brian Starkey wrote:
> Hi Ville,
> 
> On Thu, Mar 16, 2017 at 07:36:56PM +0200, Ville Syrjälä wrote:
> >On Thu, Mar 16, 2017 at 07:05:12PM +0200, Sharma, Shashank wrote:
> >> On 3/16/2017 5:55 PM, Brian Starkey wrote:
> >> > On Thu, Mar 16, 2017 at 05:14:07PM +0200, Sharma Shashank wrote:
> >> >> On 3/16/2017 4:37 PM, Local user for Liviu Dudau wrote:
> >> >>> On Thu, Mar 16, 2017 at 04:30:59PM +0200, Ville Syrjälä wrote:
> >> >>>> On Thu, Mar 16, 2017 at 04:20:29PM +0200, Sharma, Shashank wrote:
> >> >>>>> On 3/16/2017 4:07 PM, Ville Syrjälä wrote:
> 
> [snip]
> 
> >> >>>>>>
> >> >>>>>> So what we might need is something like:
> >> >>>>>> enum YCBCR_TO_RGB_CSC
> >> >>>>>>   * YCbCr BT.601 limited to RGB BT.709 full
> >> >>>>>>   * YCbCr BT.709 limited to RGB BT.709 full <this would be the
> >> >>>>>> likely default value IMO>
> >> >>>>>>   * YCbCr BT.601 limited to RGB BT.2020 full
> >> >>>>>>   * YCbCr BT.709 limited to RGB BT.2020 full
> >> >>>>>>   * YCbCr BT.2020 limited to RGB BT.2020 full
> >> >>>>>>
> >> >>>>>> And thanks to BT.2020 we'll need a RGB->RGB CSC property as well.
> >> >>>>>> Eg:
> >> >>>>>> enum RGB_TO_RGB_CSC
> >> >>>>>>   * bypass (or separate 709->709, 2020->2020?) <this would be the
> >> >>>>>> default>
> >> >>>>>>   * RGB BT.709 full to RGB BT.2020 full
> >> >
> >> > I like this approach, from a point of view of being explicit and
> >> > discoverable by userspace. It also happens to map quite nicely to our
> >> > hardware... we have a matrix before degamma, so we could do a
> >> > CSC + Gamut conversion there in one go, which is apparently not 100%
> >> > mathematically correct, but in general is good enough.
> >> >
> >> > ... however having talked this over a bit with someone who understands
> >> > the detail a lot better than me, it sounds like the "correct" thing to
> >> > do as per the spec is:
> >> >
> >> > CSC -> DEGAMMA -> GAMUT
> >> >
> >> > e.g.
> >> >
> >> > YCbCr bt.601 limited to RGB bt.601 full -> degamma ->
> >> >     RGB bt.601 full to RGB bt.709 full
> >> >
> >> > So that sounds like what we need to support in the API, and also
> >> > sounds more like the "separate properties" approach.
> >> I agree.
> >> >
> >> >>>>>>
> >> >>>>>> Alternatives would involve two properties to define the input and
> >> >>>>>> output
> >> >>>>>> from the CSC separately, but then you lose the capability to see
> >> >>>>>> which
> >> >>>>>> combinations are actually supoorted.
> >> >>>>> I was thinking about this too, or would it make more sense to
> >> >>>>> create two
> >> >>>>> properties:
> >> >>>>> - one for gamut mapping (cases like RGB709->RGB2020)
> >> >>>>> - other one for Color space conversion (cases lile YUV 709 -> RGB
> >> >>>>> 709)
> >> >>>>>
> >> >>>>> Gamut mapping can represent any of the fix function mapping,
> >> >>>>> wereas CSC
> >> >>>>> can bring up any programmable matrix
> >> >>>>>
> >> >>>>> Internally these properties can use the same HW unit or even same
> >> >>>>> function.
> >> >>>>> Does it sound any good ?
> >> >
> >> > It seems to me that actually the two approaches can be combined into
> >> > the same thing:
> >> >  * We definitely need a YCbCr-to-RGB conversion before degamma
> >> >    (for converting YUV data to RGB, in some flavour)
> >> >  * We definitely need an RGB-to-RGB conversion after gamma to handle
> >> >    709 layers blended with Rec.2020.
> >> > The exact conversion each of those properties represents (CSC + gamut,
> >> > CSC only, gamut only) can be implicit in the enum name.
> >> >
> >> > For hardware which has a fixed-function CSC before DEGAMMA with a
> >> > matrix after DEGAMMA, I'd expect to see something like below. None of
> >> > the YCBCR_TO_RGB_CSC values include a gamut conversion, because that
> >> > is instead exposed with the RGB_TO_RGB_CSC property (which represents
> >> > the hardware matrix)
> >> >
> >> > YCBCR_TO_RGB_CSC (before DEGAMMA):
> >> >     YCbCr BT.601 limited to RGB BT.601 full
> >> >     YCbCr BT.709 limited to RGB BT.709 full
> >> >     YCbCr BT.2020 limited to RGB BT.2020 full
> >> >
> >> > RGB_TO_RGB_CSC (after DEGAMMA):
> >> >     RGB BT.601 full to RGB BT.709 full
> >> >     RGB BT.709 full to RGB BT.2020 full
> >> >
> >> >
> >> > On the other hand, on hardware which does a CSC + Gamut conversion in
> >> > one go, before DEGAMMA (like ours), you might have:
> >> >
> >> > YCBCR_TO_RGB_CSC (before DEGAMMA):
> >> >     YCbCr BT.601 limited to RGB BT.601 full
> >> >     YCbCr BT.601 limited to RGB BT.709 full
> >> >     YCbCr BT.709 limited to RGB BT.709 full
> >> >     YCbCr BT.2020 limited to RGB BT.2020 full
> >> >
> >> > RGB_TO_RGB_CSC (after DEGAMMA):
> >> >     Not supported
> >> >
> >> > Userspace can parse the two properties to figure out its options to
> >> > get from desired input -> desired output. It is perhaps a little
> >> > verbose, but it's descriptive and flexible.
> >> >
> >> Seems to be a good idea, Ville ?
> >
> >Looks pretty sane to me.
> >
> >Though how we'll do the degamma/gamma is rather unclear still.
> >
> >I think we might be looking at two variants of hardware:
> >- A fully programmable one with separate stages:
> >  csc -> degamma -> gamut -> gamma
> >- A totally fixed one with just a few different variants
> >  of the pipeline baked into the hardware
> >
> >If we want to expose the gamma/degamma to the user, how exactly are we
> >going to do that with the latter form or hardware. I guess we could
> >specify that if the degamma property is not exposed, there will be an
> >implicit degamma stage between the two csc and gamut. And if it is
> >exposed the output from the first csc is non-linear and thus needs
> >the degamma programmed to make it so before the gamut mapping.
> >
> >And perhaps a similar rule could work for the gamma; If it's present
> >the output from the gamut mapping is expected to be linear, and
> >otherwise non-linear. Not quite sure about this. In fact I don't yet
> >know what our hardware would output from the end of the fixed pipeline.
> 
> I don't really like the implicit nature of that, and I also don't
> think it fits with practical use-cases - for instance on current
> Android, blending is assumed to be done with non-linear data, so an
> implicit linearisation doesn't fit with that.

I think there's going to be an implicit linearization between the csc
and gamut mapping anyway. Otherwise it just wouldn't work correctly.
But whether the output from that gamut mapping is linear or not for
our hardware I don't know yet.

> I think it's much better to make sure each element in the pipeline is
> discoverable and configurable from userspace.
> 
> There's also the fact that we already have GAMMA/DEGAMMA properties
> with a defined interface and semantics.
> 
> Mali-DP falls in the "fully programmable" camp - we can use a
> programmable de-gamma curve in the plane pipeline, and for this, the
> existing DEGAMMA property is a good fit.
> 
> For not-programmable hardware, would a second "DEGAMMA_FIXED" property
> make sense, which is an enum type exposing what curves are supported?
> (with analogous GAMMA_FIXED as well)

Hmm. I suppose we could make it a bit more explicit like that.
Not sure how we'd specify those though. Just BT.709, BT.2020, etc. and
perhaps just something like 'Gamma 2.2' if it's a pure gamma curve?
Someone who is more familiar with the subject could probably propose
a better naming scheme.

> 
> Drivers should expose one or the other (but not both) for each
> gamma/degamma conversion the hardware implements.
> 
> -Brian
> 
> >
> >>
> >> - Shashank
> >> >>>> It's certainly possible. One problem is that we can't inform userspace
> >> >>>> upfront which combinations are supported. Whether that's a real
> >> >>>> problem
> >> >>>> I'm not sure. With atomic userspace can of course check upfront if
> >> >>>> something can be done or not, but the main problem is then coming up
> >> >>>> with a fallback strategy that doesn't suck too badly.
> >> >>>>
> >> >
> >> > The approach above helps limit the set exposed to userspace to be only
> >> > those which are supported - because devices which don't have separate
> >> > hardware for the two stages won't expose values for both.
> >> >
> >> >>>> Anyways, I don't think I have any strong favorites here. Would be nice
> >> >>>> to hear what everyone else thinks.
> >> >>> I confess to a lack of experience in the subject here, but what is
> >> >>> the more common
> >> >>> request coming from userspace: converting YUV <-> RGB but keeping
> >> >>> the gammut mapping
> >> >>> separate, or YUV (gammut x) <-> RGB (gammut y) ? In other words: I
> >> >>> can see the usefulness
> >> >>> of having an explicit way of decomposing the color mapping process
> >> >>> and control the
> >> >>> parameters, but how often do apps or compositors go through the
> >> >>> whole chain?
> >> >> Right now, more or less the interest is on the RGB->YUV conversion
> >> >> side, coz till now BT 2020 gamut was not in
> >> >> picture. REC 601 and 709 have very close gamuts, so it was ok to
> >> >> blend frames mostly without bothering about
> >> >> gamut, but going fwd, ones REC 2020 comes into picture, we need to
> >> >> bother about mapping gamuts too, else
> >> >> blending Rec709 buffers and Rec2020 buffers together would cause very
> >> >> visible gamut mismatch.
> >> >>
> >> >> So considering futuristic developments, it might be ok to consider
> >> >> both. Still, as Ville mentioned, it would be good
> >> >> to hear from other too.
> >> >>
> >> >
> >> > Yeah I agree that we definitely need to consider both for anything we
> >> > come up with now.
> >> >
> >> > Cheers,
> >> > Brian
> >> >
> >> >> - Shashank
> >> >>>
> >> >>> Best regards,
> >> >>> Liviu
> >> >>>
> >> >>>> --
> >> >>>> Ville Syrjälä
> >> >>>> Intel OTC
> >> >>
> >
> >-- 
> >Ville Syrjälä
> >Intel OTC

-- 
Ville Syrjälä
Intel OTC
