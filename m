Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:37641 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbeIUNOR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 09:14:17 -0400
Date: Fri, 21 Sep 2018 09:23:37 +0200
From: Helmut Grohne <helmut.grohne@intenta.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <snawrocki@kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        "ping-chung.chen@intel.com" <ping-chung.chen@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "andy.yeh@intel.com" <andy.yeh@intel.com>,
        "jim.lai@intel.com" <jim.lai@intel.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
Message-ID: <20180921072337.axxyy2cmvgkqrkci@laureti-dev>
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com>
 <CANEJEGvZn7oSdtYcwb4qxqiys1_y6GPh+1fZUfdejg2ztSsRmw@mail.gmail.com>
 <4e3e21d3-21f7-48eb-7672-f157c1a4fdcc@kernel.org>
 <2739140.4VmFsgKfYj@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2739140.4VmFsgKfYj@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2018 at 11:00:26PM +0200, Laurent Pinchart wrote:
> On Thursday, 20 September 2018 23:16:47 EEST Sylwester Nawrocki wrote:
> > On 09/20/2018 06:49 PM, Grant Grundler wrote:
> > > On Thu, Sep 20, 2018 at 1:52 AM Tomasz Figa wrote:
> > >> We have a problem here. The sensor supports only a discrete range of
> > >> values here - {1, 2, 4, 8, 16} (multiplied by 256, since the value is
> > >> fixed point). This makes it possible for the userspace to set values
> > >> that are not allowed by the sensor specification and also leaves no
> > >> way to enumerate the supported values.

I'm not sure I understand this correctly. Tomasz appears to imply here
that the number of actually supported gain values is 5.

> > I'm not sure if it's best approach but I once did something similar for
> > the ov9650 sensor. The gain was fixed point 10-bits value with 4 bits
> > for fractional part. The driver reports values multiplied by 16. See
> > ov965x_set_gain() function in drivers/media/i2c/ov9650.c and "Table 4-1.
> > Total Gain to Control Bit Correlation" in the OV9650 datasheet for details.
> > The integer menu control just seemed not suitable for 2^10 values.

As long as values scale linearly (as is the case for fixed point
numbers) that seems like a reasonable approach to me. That assumption
appears to not hold for imx208 where the values scale exponentially.

> I've had a similar discussion on IRC recently with Helmut, who posted a nice 
> summary of the problem on the mailing list (see https://www.mail-archive.com/
> linux-media@vger.kernel.org/msg134502.html). This is a known issue, and while 
> I proposed the same approach, I understand that in some cases userspace may 
> need to know exactly what values are acceptable. In such a case, however, I 
> would expect userspace to have knowledge of the particular sensor model, so 
> the information may not need to come from the kernel.

A big reason to use V4L2 is to abstract hardware. Having to know what
sensor model you use runs counter that goal. Indeed, gain (whether
digital or analogue) can be abstracted in principle. I see little reason
to not do that.

> > Now the gain control has range 16...1984 out of which only 1024 values
> > are valid. It might not be best approach for a GUI but at least the driver
> > exposes mapping of all valid values, which could be enumerated with
> > VIDIOC_TRY_EXT_CTRLS if required, without a need for a driver-specific
> > user space code.

If you have very many values, a reasonable compromise could be reducing
the precision. If you try to represent a floating point number, values
with higher exponent will have larger "gaps" when represented as
integers for v4l2. A compromise could be increasing the step size and
thus removing a few of the gains with lower exponent.

> > >> I can see two solutions here:
> > >> 
> > >> 1) Define the control range from 0 to 4 and treat it as an exponent of
> > >> 2, so that the value for the sensor becomes (1 << val) * 256.
> > >> (Suggested by Sakari offline.)
> > >> 
> > >> This approach has the problem of losing the original unit (and scale)
> > >> of the value.

This approach is the one where users will need to know which sensor they
talk to. The one where the hardware abstraction happens in userspace.
Can we please not do that?

> > >> 2) Use an integer menu control, which reports only the supported
> > >> discrete values - {1, 2, 4, 8, 16}.

That's what I ended up doing, though I kinda deferred the problem as I
started using V4L2_CID_ISO_SENSITIVITY, which is an integer menu but not
exactly the right one. My choice will backfire once I submit the driver
though that'll still take a little while.

> > >> With this approach, userspace can enumerate the real gain values, but
> > >> we would either need to introduce a new control (e.g.
> > >> V4L2_CID_DIGITAL_GAIN_DISCRETE) or abuse the specification and
> > >> register V4L2_CID_DIGITAL_GAIN as an integer menu.
> > >> 
> > >> Any opinions or better ideas?

Abusing the specification sounds like it would break userspace. I'd
avoid doing that.

We do have a history of adding "duplicate" CIDs for gaining a better
specification. For instance, there is V4L2_CID_EXPOSURE (unspecified)
and then there came V4L2_CID_EXPOSURE_ABSOLUTE (unit 100 µs).
V4L2_CID_GAIN got split into V4L2_CID_ANALOGUE_GAIN and
V4L2_CID_DIGITAL_GAIN. Further splitting that into integer menu variants
of analogue and digital gain seems reasonable to me.

If doing so, I suggest using the following rules (up to discussion):
 * Drivers must not provide both the integer menu and an integer control
   for a single gain.
 * Define which value means "no amplification". For
   V4L2_CID_DIGITAL_GAIN this was defined as 0x100. Keeping that could
   be reasonable, but V4L2_CID_ANALOGUE_GAIN presently leavs that
   undefined.
 * If a gain is linear, use the integer control.
 * If it is non-linear and has fewer than X (1025?) values, use the
   integer menu.
 * Otherwise use the integer control. Either increase step or choose the
   best supported value approximating the user request.

I think that precise rules help both driver writers and users of these
controls.

If an integer menu for V4L2_CID_ANALOGUE_GAIN is being added, I will use
it.

> > > My $0.02: leave the user UI alone - let users specify/select anything
> > > in the range the normal API or UI allows. But have sensor specific
> > > code map all values in that range to values the sensor supports. Users
> > > will notice how it works when they play with it.  One can "adjust" the
> > > mapping so it "feels right".

Actual users trying to fiddle with these values are not the only
consumers. Beware that algorithms may want to do so as well and
algorithms want to know which values are valid in advance.

Hope this helps. It might be raising more questions beyond the scope of
imx208 though.

Helmut
