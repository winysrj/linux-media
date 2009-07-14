Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42230 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbZGNHSc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 03:18:32 -0400
Message-ID: <4A5C3FAB.8@redhat.com>
Date: Tue, 14 Jul 2009 10:19:55 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Control IOCTLs handling
References: <A69FA2915331DC488A831521EAE36FE40144E4B70A@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40144E4B70A@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/13/2009 08:21 PM, Karicheri, Muralidharan wrote:
> Hi,
>
> I need to implement some controls for my driver and would like to understand the control ioctl framework available today. I am not very sure how the control ioctls are to be implemented and it is not well defined in the specification. I have provided below my understanding of the below set of controls. I would like to hear what you think about the same.
>
> I see following controls defined for adjusting brightness, contrast etc.
>
> V4L2_CID_BRIGHTNESS	integer	Picture brightness, or more precisely, the black level.
> V4L2_CID_CONTRAST	integer	Picture contrast or luma gain.
> V4L2_CID_SATURATION	integer	Picture color saturation or chroma gain.
> V4L2_CID_HUE	integer	Hue or color balance.
>
> I think these controls refer to the YUV color space. Y (luma) and UV (chroma) signals will be modified by above controls.
>

Ack.

> V4L2_CID_DO_WHITE_BALANCE	button	This is an action control. When set (the value is ignored), the device will do a white balance and then hold the current setting. Contrast this with the boolean V4L2_CID_AUTO_WHITE_BALANCE, which, when activated, keeps adjusting the white balance.
> V4L2_CID_RED_BALANCE	integer	Red chroma balance.
> V4L2_CID_BLUE_BALANCE	integer	Blue chroma balance.
>
> My understanding is these controls are applied to RGB color space. V4L2_CID_AUTO_WHITE_BALANCE is applicable where hardware is capable of adjusting the wb automatically. But V4L2_CID_DO_WHITE_BALANCE is used in conjunction with V4L2_CID_RED_BALANCE&  V4L2_CID_BLUE_BALANCE.
 > i.e application set these values and they take effect when V4L2_CID_DO_WHITE_BALANCE is issued. So driver hold onto the current values until another set of above commands are issued.

Erm, no, V4L2_CID_DO_WHITE_BALANCE is for hardware whitebalance too, but means do hardware whitebalance once and then hold the
current correction factors. It is a really weird control, and I don't know if we haven drivers using it, it is best ignored.

The V4L2_CID_RED_BALANCE controls are meant to be appplied immediately.

>
> But one question I have is (if the above is correct), why there is no V4L2_CID_GREEN_BALANCE ??
>

I guess these controls were introduced for some hardware which had a fixed green gain ?

> I don't see any control IDs available for Bayer RGB color space.
>
> In our video hardware, there is a set of Gain values that can be applied to the Bayer RGB data. We can apply them individually to R, Gr, Gb or B color components. So I think we need to have 4 more controls defined for doing white balancing in the Bayer RGB color space that is applicable for sensors (like MT9T031) and image tuning hardware like the VPFE CCDC&  IPIPE.
>
> Define following new controls for these in Bayer RGB color space White Balance (WB) controls??
>
> V4L2_CID_BAYER_RED_BALANCE	integer	Bayer Red balance.
> V4L2_CID_BAYER_BLUE_BALANCE	integer	Bayer Blue balance.
> V4L2_CID_BAYER_GREEN_R_BALANCE	integer	Bayer Gr balance.
> V4L2_CID_BAYER_GREEN_B_BALANCE	integer	Bayer Gb balance.
>
> There is also an offset value defined per color which is like adjusting the black level in the video image data. It is subtracted from the image byte.
> What you call this ? Should we define a new control, V4l2_CID_BAYER_OFFSET ??	
>

I can't help but wonder if we should export all these as controls. One can probably export about 90% of the registers of a sensor as controls,
but then why write a driver at all, why not just give the user an application to set the registers himself them ?

When it comes to controls, less is more IMHO.

So the question is can't we give these registers a sensible default setting and leave it at that?

And currently the answer to that is yes, there currently are 2 ways to do whitebalance for sensors
under Linux:
1) The sensor does it in hardware (using per color gains like above)
2) libv4l does whitebalancing in software, in this case case a software gain is used as we can
    control that very precisely and libv4l does not know the exact gain factor (and has no way to find
    out) of per color gains exported through controls, so we just apply a software per color gain,
    which we can control exactly.

So currently the best thing todo is, either:
a) make the sensor do hardware whitebalance if it can (much prefered), or:
b) set all the per color gains in their default / middle position and handle
    the whitebalancing fully in software.

This applies even more to the per color offset's, I really see little use in exporting this to the
end-user.

You should look at controls as knobs the end user may want to tweak, if it is not something the end-user
could want to / should tweak it should not be a control.

Regards,

Hans
