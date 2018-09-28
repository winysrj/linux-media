Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53162 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbeI1UNT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 16:13:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helmut Grohne <helmut.grohne@intenta.de>
Cc: Sylwester Nawrocki <snawrocki@kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        "ping-chung.chen@intel.com" <ping-chung.chen@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "andy.yeh@intel.com" <andy.yeh@intel.com>,
        "jim.lai@intel.com" <jim.lai@intel.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
Date: Fri, 28 Sep 2018 16:49:38 +0300
Message-ID: <2841198.gTOBNDXT1f@avalon>
In-Reply-To: <20180921072337.axxyy2cmvgkqrkci@laureti-dev>
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com> <2739140.4VmFsgKfYj@avalon> <20180921072337.axxyy2cmvgkqrkci@laureti-dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helmut,

On Friday, 21 September 2018 10:23:37 EEST Helmut Grohne wrote:
> On Thu, Sep 20, 2018 at 11:00:26PM +0200, Laurent Pinchart wrote:
> > On Thursday, 20 September 2018 23:16:47 EEST Sylwester Nawrocki wrote:
> >> On 09/20/2018 06:49 PM, Grant Grundler wrote:
> >>> On Thu, Sep 20, 2018 at 1:52 AM Tomasz Figa wrote:
> >>>> We have a problem here. The sensor supports only a discrete range of
> >>>> values here - {1, 2, 4, 8, 16} (multiplied by 256, since the value is
> >>>> fixed point). This makes it possible for the userspace to set values
> >>>> that are not allowed by the sensor specification and also leaves no
> >>>> way to enumerate the supported values.
>=20
> I'm not sure I understand this correctly. Tomasz appears to imply here
> that the number of actually supported gain values is 5.
>=20
> >> I'm not sure if it's best approach but I once did something similar for
> >> the ov9650 sensor. The gain was fixed point 10-bits value with 4 bits
> >> for fractional part. The driver reports values multiplied by 16. See
> >> ov965x_set_gain() function in drivers/media/i2c/ov9650.c and "Table 4-=
1.
> >> Total Gain to Control Bit Correlation" in the OV9650 datasheet for
> >> details. The integer menu control just seemed not suitable for 2^10
> >> values.
>=20
> As long as values scale linearly (as is the case for fixed point
> numbers) that seems like a reasonable approach to me. That assumption
> appears to not hold for imx208 where the values scale exponentially.

And it's often neither. For instance the MT9P031 has three gain stages.=20
Quoting the driver:

                /* Gain is controlled by 2 analog stages and a digital stag=
e.
                 * Valid values for the 3 stages are
                 *
                 * Stage                Min     Max     Step
                 * ------------------------------------------
                 * First analog stage   x1      x2      1
                 * Second analog stage  x1      x4      0.125
                 * Digital stage        x1      x16     0.125

The resulting gain is the product of the three.

> > I've had a similar discussion on IRC recently with Helmut, who posted a
> > nice summary of the problem on the mailing list (see
> > https://www.mail-archive.com/
> > linux-media@vger.kernel.org/msg134502.html). This is a known issue, and
> > while I proposed the same approach, I understand that in some cases
> > userspace may need to know exactly what values are acceptable. In such a
> > case, however, I would expect userspace to have knowledge of the
> > particular sensor model, so the information may not need to come from t=
he
> > kernel.
>=20
> A big reason to use V4L2 is to abstract hardware. Having to know what
> sensor model you use runs counter that goal. Indeed, gain (whether
> digital or analogue) can be abstracted in principle. I see little reason
> to not do that.

The purpose of V4L2 is to expose the features of the hardware device to=20
userspace, and we try to do so in an as much abstract as possible way. 100%=
=20
abstraction isn't feasible, there will always be small device-specific deta=
ils=20
that will break whatever abstraction we design. We should thus strive for a=
=20
good balance, abstracting the most common types of features, while avoiding=
=20
over-engineering an API that would then become unusable (both because it wo=
uld=20
be complex to use by applications, and implemented in subtly differently bu=
ggy=20
ways by drivers).

I don't think we'll reach an agreement here if we don't start talking about=
=20
real use cases. Would you have some to share ?

> >> Now the gain control has range 16...1984 out of which only 1024 values
> >> are valid. It might not be best approach for a GUI but at least the
> >> driver exposes mapping of all valid values, which could be enumerated
> >> with VIDIOC_TRY_EXT_CTRLS if required, without a need for a driver-
> >> specific user space code.
>=20
> If you have very many values, a reasonable compromise could be reducing
> the precision. If you try to represent a floating point number, values
> with higher exponent will have larger "gaps" when represented as
> integers for v4l2. A compromise could be increasing the step size and
> thus removing a few of the gains with lower exponent.

What if an application needs the precision ? Reducing it can cause issues i=
n=20
the 3A algorithms, including closed-loops stability problems. I think we=20
should expose the device features with as much precision and coverage as=20
possible. Hardcoding use case assumptions in the kernel drives us into a wa=
ll=20
sooner or later.

> >>>> I can see two solutions here:
> >>>>=20
> >>>> 1) Define the control range from 0 to 4 and treat it as an exponent
> >>>> of 2, so that the value for the sensor becomes (1 << val) * 256.
> >>>> (Suggested by Sakari offline.)
> >>>>=20
> >>>> This approach has the problem of losing the original unit (and scale)
> >>>> of the value.
>=20
> This approach is the one where users will need to know which sensor they
> talk to. The one where the hardware abstraction happens in userspace.
> Can we please not do that?

Let's talk about it based on real use cases.

> >>>> 2) Use an integer menu control, which reports only the supported
> >>>> discrete values - {1, 2, 4, 8, 16}.
>=20
> That's what I ended up doing, though I kinda deferred the problem as I
> started using V4L2_CID_ISO_SENSITIVITY, which is an integer menu but not
> exactly the right one. My choice will backfire once I submit the driver
> though that'll still take a little while.
>=20
> >>>> With this approach, userspace can enumerate the real gain values, but
> >>>> we would either need to introduce a new control (e.g.
> >>>> V4L2_CID_DIGITAL_GAIN_DISCRETE) or abuse the specification and
> >>>> register V4L2_CID_DIGITAL_GAIN as an integer menu.
> >>>>=20
> >>>> Any opinions or better ideas?
>=20
> Abusing the specification sounds like it would break userspace. I'd
> avoid doing that.
>=20
> We do have a history of adding "duplicate" CIDs for gaining a better
> specification. For instance, there is V4L2_CID_EXPOSURE (unspecified)
> and then there came V4L2_CID_EXPOSURE_ABSOLUTE (unit 100 =B5s).
> V4L2_CID_GAIN got split into V4L2_CID_ANALOGUE_GAIN and
> V4L2_CID_DIGITAL_GAIN. Further splitting that into integer menu variants
> of analogue and digital gain seems reasonable to me.
>=20
> If doing so, I suggest using the following rules (up to discussion):
>  * Drivers must not provide both the integer menu and an integer control
>    for a single gain.
>  * Define which value means "no amplification". For
>    V4L2_CID_DIGITAL_GAIN this was defined as 0x100. Keeping that could
>    be reasonable, but V4L2_CID_ANALOGUE_GAIN presently leavs that
>    undefined.

This could be reported as the control's default value.

>  * If a gain is linear, use the integer control.
>  * If it is non-linear and has fewer than X (1025?) values, use the
>    integer menu.

1024 ioctl calls to query the menu values ? :-( We need a better API than=20
that. I'm also concerned that it wouldn't be very usable by userspace. Havi=
ng=20
a list of supported values is one thing, making efficient use of it is=20
another. Again, use cases :-)

>  * Otherwise use the integer control. Either increase step or choose the
>    best supported value approximating the user request.
>=20
> I think that precise rules help both driver writers and users of these
> controls.
>=20
> If an integer menu for V4L2_CID_ANALOGUE_GAIN is being added, I will use
> it.

In this particular case I think splitting analog and digital gain makes sen=
se.=20
They are very different beasts at the hardware level, and need to be=20
controlled independently.

> >>> My $0.02: leave the user UI alone - let users specify/select anything
> >>> in the range the normal API or UI allows. But have sensor specific
> >>> code map all values in that range to values the sensor supports. Users
> >>> will notice how it works when they play with it.  One can "adjust" the
> >>> mapping so it "feels right".
>=20
> Actual users trying to fiddle with these values are not the only
> consumers. Beware that algorithms may want to do so as well and
> algorithms want to know which values are valid in advance.

I expect many algorithms to need a mathematical view of the valid values, n=
ot=20
just a list. What particular algorithms do you have in mind ?

> Hope this helps. It might be raising more questions beyond the scope of
> imx208 though.

=2D-=20
Regards,

Laurent Pinchart
