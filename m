Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:60947 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbeJASm3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 14:42:29 -0400
Date: Mon, 1 Oct 2018 14:04:56 +0200
From: Philippe De Muyter <phdm@macq.eu>
To: Helmut Grohne <helmut.grohne@intenta.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        "ping-chung.chen@intel.com" <ping-chung.chen@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "andy.yeh@intel.com" <andy.yeh@intel.com>,
        "jim.lai@intel.com" <jim.lai@intel.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
Message-ID: <20181001120456.GA13546@frolo.macqel>
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com> <2739140.4VmFsgKfYj@avalon> <20180921072337.axxyy2cmvgkqrkci@laureti-dev> <2841198.gTOBNDXT1f@avalon> <20181001105002.p6hvpbrjzzimi4rq@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181001105002.p6hvpbrjzzimi4rq@laureti-dev>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Oct 01, 2018 at 12:50:02PM +0200, Helmut Grohne wrote:
> Hi Laurent,
> 
> On Fri, Sep 28, 2018 at 03:49:38PM +0200, Laurent Pinchart wrote:
> > I don't think we'll reach an agreement here if we don't start talking about 
> > real use cases. Would you have some to share ?
> 
> Fair enough, but at that point, we very much disconnect from the imx208
> in the subject.
> 
> I'm working with a stereo camera. In that setup, you have two image
> sensors and infer a three dimensional structure from images captured at
> equal time points. For that to happen, it is important that the image
> sensors use the same settings. In particular, settings such as expoure
> and gain must match. That in turn means that you cannot use the
> automatic exposure mode that comes with your image sensor.
> 
> This is one reason for implementing exposure control outside of the
> image sensor. Typically you can categorize your parameters into three
> classes that affect the brightness of an image: aperture, shutter speed
> and some kind of gain. If you know the units of these parameters, you
> can estimate the effect of changing them on the resulting image.
> 
> The algorithm for controlling brightness can be quite generic if you
> know the units. V4L2_CID_EXPOSURE_ABSOLUTE is given in 100 µs. That
> tends to work well. Typically, you prefer increasing exposure over
> increasing gain to avoid noise. Similarly, you prefer increasing
> analogue gain over increasing digital gain. On the other hand, there is
> a limit on exposure to avoid motion blur. If an algorithm knows valid
> values for these parameters, it can produce settings independently of
> what concrete image sensor you use.
> 
> > > >>>> I can see two solutions here:
> > > >>>> 
> > > >>>> 1) Define the control range from 0 to 4 and treat it as an exponent
> > > >>>> of 2, so that the value for the sensor becomes (1 << val) * 256.
> > > >>>> (Suggested by Sakari offline.)
> > > >>>> 
> > > >>>> This approach has the problem of losing the original unit (and scale)
> > > >>>> of the value.
> > > 
> > > This approach is the one where users will need to know which sensor they
> > > talk to. The one where the hardware abstraction happens in userspace.
> > > Can we please not do that?
> > 
> > Let's talk about it based on real use cases.
> 
> So if you change your gain from 0 to 1, your image becomes roughly twice
> as bright. In the typical scenario that's too bright, so when increasing
> gain, you simultaneously decrease something else (e.g. exposure). But if
> you don't know the effect of your gain change, you cannot tell how much
> your exposure needs to be reduced. The only way out here is just doing
> it and reducing exposure afterwards. Users tend to not like the
> flickering resulting from this approach.
> 
> > >  * If it is non-linear and has fewer than X (1025?) values, use the
> > >    integer menu.
> > 
> > 1024 ioctl calls to query the menu values ? :-( We need a better API than 
> > that. I'm also concerned that it wouldn't be very usable by userspace. Having 
> > a list of supported values is one thing, making efficient use of it is 
> > another. Again, use cases :-)
> 
> You only need to query it once, but I'm not opposed to a better API
> either. I just don't think it is that important or urgent.
> 
> > I expect many algorithms to need a mathematical view of the valid values, not 
> > just a list. What particular algorithms do you have in mind ?
> 
> A very simple algorithm could go like this:
>  * Assume that exposure time and gain have a linear effect on the
>    brightness of a captured image. This tends to not hold exactly, but
>    close enough.
>  * Compare brightness of the previous frame with a target value.
>  * Compute the product of current exposure time and gain. Adapt the
>    product according to the brightness error.
>  * Distribute this product to exposure time and gain such that exposure
>    time is maximal below a user-defined limit and that gain is one of
>    the valid values.
> 
> All you need to know for using this besides V4L2_CID_EXPOSURE_ABSOLUTE,
> is the valid gain values.
> 

I agree with Helmut, and have exactly the same problem, even without stereo
involved.

But : V4L2_CID_EXPOSURE_ABSOLUTE unit is too high for the sensors I use,
which provides a exposure time of 15,625 us, that I often need to use.

one of my sensor provides an analog gain which can take the values 1, 1.5,
2, 3, 4, 6 and 8 and a digital gain which is a floating point number
with 2 bits for the exponent and 6 bits for the mantissa, giving values
from 1 to (1 + 63/64) * (1, 2, 4 or 8).  I currently combine them and
indicate the unit in the name of the control "gain (64th)", but a more
robust solution would be welcome.

the other sensor provides an analog gain which is expressed in tenth of dB
(cB ?) from 0 to 480. Clearly this is difficult to comunicate to the user app
using the current definition of V4L2_CID_GAIN.  I think I'd need to be able
to express that the gain of this sensor is exponential and that the unit is
0.1 dB.  If we admit that exponential gains will probably be expressed in dB,
that leaves us with the same problem as above : express that the unit is
not 1, but 0.1.  We could also define a V4L2_CID_EXPONENTIAL_GAIN, with unit
0.01 dB.

Best regards

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
