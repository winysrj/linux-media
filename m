Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:47950 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbeH0Mcq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 08:32:46 -0400
Date: Mon, 27 Aug 2018 10:40:12 +0200
From: Helmut Grohne <helmut.grohne@intenta.de>
To: Pavel Machek <pavel@ucw.cz>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: V4L2 analogue gain contol
Message-ID: <20180827084012.ng4rb2npus65iutq@laureti-dev>
References: <20180822122441.7zxj4e5dczdzmo5m@laureti-dev>
 <20180826065209.GC25309@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20180826065209.GC25309@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, Aug 26, 2018 at 08:52:09AM +0200, Pavel Machek wrote:
> > Can we give more structure to the analogue gain as exposed by V4L2?
> > Ideally, I'd like to query a driver for the possible gain values if
> > there are few (say < 256) and their factors (which are often given in
> > data sheets). The nature of gains though is that they are often similar
> > to floating point numbers (2 ** exp * (1 + mant / precision)), which
> > makes it difficult to represent them using min/max/step/default.
> 
> Yes, it would be nice to have uniform controls for that. And it would
> be good if mapping to "ISO" sensitivity from digital photography existed.

Thank you very much for this pointer.

There is V4L2_CID_ISO_SENSITIVITY. It is an integer menu, which means
that I can introspect the available values. It is already used by
s5c73m3 and m5mols. That looks mostly like what I need. It makes no
provision on how the image is amplified, whether digital or analogue.
I'd need analogue gain only here.

Reading the platform/exynos4-is/fimc and the i2c/s5c73m3 driver, I get
the impression that the scaling is not in accordance with
Documentation/media/uapi/v4l/extended-controls.rst ("standard ISO values
multiplied by 1000") though. -> Adding the maintainers/supporters to Cc.

> > Would it be reasonable to add a new V4L2_CID_ANALOGUE_GAIN_MENU that
> > claims linearity and uses fixed-point numbers like
> > V4L2_CID_DIGITAL_GAIN? There already is the integer menu
> > V4L2_CID_AUTO_EXPOSURE_BIAS, but it also affects the exposure.
> 
> I'm not sure if linear scale is really appropriate. You can expect
> camera to do ISO100 or ISO200, but if your camera supports ISO480000,
> you don't really expect it to support ISO480100.

I may have been ambigue here. With "linear" I was not trying to imply
that cameras should support every possible value and maybe "linear" is
not the property I actually need.

What I need is a correspondence between gain value (the value you pass
to V4L2_CID_ANALOGUE_GAIN) and amplification factor (brightness increase
of the resulting image). A linear connection is the simplest of course,
but logarithmic works as well in principle.

My idea of using an integer menu here was that a significant number of
cameras have a low count of valid gain settings. For them, listing all
valid values may be a legitimate option. Indeed, that's what happened
for V4L2_CID_ISO_SENSITIVITY.

> ./drivers/media/i2c/et8ek8/et8ek8_driver.c already does that.
> 
> IOW logarithmic scale would be more appropriate; min/max would be
> nice, and step 

I'm sorry for missing this driver in the analysis. It certainly adds to
the picture.

Note however that simply logarithmic with a step will not be a
one-size-fits-all. Fixed point numbers do not map to a logarithmic scale
with fixed steps. You can achieve fewer "holes" in your representation,
but you won't get rid of them entirely.

In the majority of cases, you could represent the gain as a product of a
logarithmic and a linear scale each with fixed steps. Is that an option?

> > An important application is implementing a custom gain control when the
> > built-in auto exposure is not applicable.
> 
> Looking at et8ek8 again, perhaps that's the right solution? Userland
> just sets the gain, and the driver automatically selects best
> analog/digital gain combination.
> 
> /*
>  * This table describes what should be written to the sensor register
>   * for each gain value. The gain(index in the table) is in terms of
>    * 0.1EV, i.e. 10 indexes in the table give 2 time more gain [0] in
>     * the *analog gain, [1] in the digital gain
>      *
>       * Analog gain [dB] = 20*log10(regvalue/32); 0x20..0x100
>        */

That may work (even for just analogue gain), but it comes at a little
loss of flexibility. You stop exposing a number of gain values and
combinations. In some cases, you loose more than half of the valid
configurations.

Striking a balance between a simple and a flexible interface of course
is difficult. I'm not opposed to providing such a simple interface, but
I'd also like to retain the flexibility (with another and likely more
complex interface).

Given your reply, I see three significant alternatives to my proposal:

 * V4L2_CID_ISO_SENSITIVITY (even though it may use digital gain)

 * V4L2_CID_ANALOGUE_GAIN_ISO could be an integer menu control modeled
   after V4L2_CID_ISO_SENSITIVITY.

 * V4L2_CID_ANALOGUE_GAIN_LOG x + V4L2_CID_ANALOGUE_GAIN_LINEAR y such
   that the actual gain amplification value is 2 ** x * y (where x and y
   are each fixed point numbers with a to-be-determined fixed point).

I guess I'll try to work with V4L2_CID_ISO_SENSITIVITY.

Helmut
