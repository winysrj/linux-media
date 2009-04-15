Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:51841 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZDOG70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 02:59:26 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2972873rvb.1
        for <linux-media@vger.kernel.org>; Tue, 14 Apr 2009 23:59:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904150824.58463.hverkuil@xs4all.nl>
References: <5e9665e10904091450u3e70cda8w9e1d57e45365a32b@mail.gmail.com>
	 <200904141650.59580.hverkuil@xs4all.nl>
	 <5e9665e10904142310l1e8d7ea0r355125970fbb038a@mail.gmail.com>
	 <200904150824.58463.hverkuil@xs4all.nl>
Date: Wed, 15 Apr 2009 15:59:25 +0900
Message-ID: <5e9665e10904142359t12959352te685240b26ccb95d@mail.gmail.com>
Subject: Re: [RFC] White Balance control for digital camera
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	g.liakhovetski@gmx.de, Jean-Francois Moine <moinejf@free.fr>,
	laurent.pinchart@skynet.be,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you Hans.

I'll see how to use V4L2_CTRL_FLAG_UPDATE and _INACTIVE.
Cheers,

Nate

On Wed, Apr 15, 2009 at 3:24 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Wednesday 15 April 2009 08:10:58 Dongsoo, Nathaniel Kim wrote:
>> Hello Hans,
>>
>> On Tue, Apr 14, 2009 at 11:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > On Tuesday 14 April 2009 13:54:02 Mauro Carvalho Chehab wrote:
>> >> On Fri, 10 Apr 2009 06:50:32 +0900
>> >>
>> >> "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com> wrote:
>> >> > Hello everyone,
>> >> >
>> >> > I'm posting this RFC one more time because it seems to everyone has
>> >> > been forgot this, and I'll be appreciated if any of you who is
>> >> > reading this mailing list give me comment.
>> >> >
>> >> > I'm adding some choices for you to make it easier. (even the option
>> >> > for that this is a pointless discussion)
>> >> >
>> >> >
>> >> >
>> >> > I've got a big question popping up handling white balance with
>> >> > V4L2_CID_WHITE_BALANCE_TEMPERATURE CID.
>> >> >
>> >> > Because in digital camera we generally control over user interface
>> >> > with pre-defined white balance name. I mean, user controls white
>> >> > balance with presets not with kelvin number.
>> >> > I'm very certain that TEMPERATURE CID is needed in many of video
>> >> > capture devices, but also 100% sure that white balance preset
>> >> > control is also necessary for digital cameras.
>> >> > How can we control white balance through preset name with existing
>> >> > V4L2 API?
>> >> >
>> >> > For now, I define preset names in user space with supported color
>> >> > temperature preset in driver like following.
>> >> >
>> >> > #define MANUAL_WB_TUNGSTEN 3000
>> >> > #define MANUAL_WB_FLUORESCENT 4000
>> >> > #define MANUAL_WB_SUNNY 5500
>> >> > #define MANUAL_WB_CLOUDY 6000
>> >> >
>> >> > and make driver to handle those presets like this. (I split in
>> >> > several ranges to make driver pretend to be generic)
>> >> >
>> >> > case V4L2_CID_WHITE_BALANCE_TEMPERATURE:
>> >> >                if (vc->value < 3500) {
>> >> >                        /* tungsten */
>> >> >                        err = ce131f_cmds(c, ce131f_wb_tungsten);
>> >> >                } else if (vc->value < 4100) {
>> >> >                        /* fluorescent */
>> >> >                        err = ce131f_cmds(c, ce131f_wb_fluorescent);
>> >> >                } else if (vc->value < 6000) {
>> >> >                        /* sunny */
>> >> >                        err = ce131f_cmds(c, ce131f_wb_sunny);
>> >> >                } else if (vc->value < 6500) {
>> >> >                        /* cloudy */
>> >> >                        err = ce131f_cmds(c, ce131f_wb_cloudy);
>> >> >                } else {
>> >> >                        printk(KERN_INFO "%s: unsupported kelvin
>> >> > range\n", __func__);
>> >> >                }
>> >> >                ......
>> >> >
>> >> > I think this way seems to be ugly. Don't you think that another CID
>> >> > is necessary to handle WB presets?
>> >> > Because most of mobile camera modules can't make various color
>> >> > temperatures in expecting kelvin number with user parameter.
>> >> >
>> >> > So, here you are some options you can chose to give your opinion.(or
>> >> > you can make your own opinion)
>> >> >
>> >> > (A). Make a new CID to handle well known white balance presets
>> >> > Like V4L2_CID_WHITE_BALANCE_PRESET for CID and enum values like
>> >> > following for value
>> >> >
>> >> > enum v4l2_whitebalance_presets {
>> >> >      V4L2_WHITEBALANCE_TUNGSTEN  = 0,
>> >> >      V4L2_WHITEBALANCE_FLUORESCENT,
>> >> >      V4L2_WHITEBALANCE_SUNNY,
>> >> >      V4L2_WHITEBALANCE_CLOUDY,
>> >> > ....
>> >> >
>> >> > (B). Define well known kelvin number in videodev2.h as preset name
>> >> > and share with user space
>> >> > Like following
>> >> >
>> >> > #define V4L2_WHITEBALANCE_TUNGSTEN 3000
>> >> > #define V4L2_WHITEBALANCE_FLUORESCENT 4000
>> >> > #define V4L2_WHITEBALANCE_SUNNY 5500
>> >> > #define V4L2_WHITEBALANCE_CLOUDY 6000
>> >> >
>> >> > and use those defined values with V4L2_CID_WHITE_BALANCE_TEMPERATURE
>> >> >
>> >> > urgh.....
>> >> >
>> >> > (C). Leave it alone. It's a pointless discussion. we are good with
>> >> > existing WB API.
>> >> > (really?)
>> >> >
>> >> >
>> >> > I'm very surprised about this kind of needs were not issued yet.
>> >>
>> >> I vote for (B). This is better than creating another user control for
>> >> something that were already defined. The drivers that don't support
>> >> specifying the color temperature, in Kelvin should round to the
>> >> closest supported value, and return the proper configured value when
>> >> questioned.
>> >
>> > I'm going with A. My reasoning is that presets 1) differ per device, 2)
>> > will normally be better tested than a random temperature value.
>>
>> I totally agree with you.
>>
>> > Remember that the control API is meant to export the options that the
>> > device supports to the application. So the presets cannot be defined as
>> > macros but must really come from the device driver. An application can
>> > then show the available presets to the user.
>> >
>> > I wonder if these two aren't mutually exclusive: you either can use any
>> > value, or only use presets.
>>
>> Don't worry about that. Generally, it is possible to use both of them
>> if they are supported by device. I mean, if device supports kelvin,
>> you can control WB with kelvin value. And if device is supports
>> presets, you can control WB with them also.
>> Difference between them should be a optimization in quality of WB
>> controlled Image. Because even though kelvin temperature is the key of
>> controlling white balance, there could be another factor to make a
>> batter white balance for some specific circumstances.
>> So, white balance presets are containing a optimized white balance
>> control from sensor manufacturer.
>> One thing should be taken carefully when we are making a new control
>> for white balance preset. Which is like following case:
>>
>> Set sensor white balance to "daylight" preset. + make some change with
>> kelvin temperature with white balance control = Sensor is not exactly
>> in "daylight" white balance preset status.
>>
>> So if device is supporting both of ways to control white balance, we
>> should make driver to care about the relationship and status between
>> both controls.
>
> If you have both, then the preset control must have a 'Manual' preset. And
> setting the preset control to a non-manual preset has the effect of also
> updating the WB kelvin value. That way the application can read back the
> precise kelvin value used. This is even useful when the driver only
> supports presets.
>
> Note that the application can tell relationships like this from the
> V4L2_CTRL_FLAG_UPDATE and _INACTIVE flags. It's used as well in the
> complicated MPEG control handling (see cx2341x.c).
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
