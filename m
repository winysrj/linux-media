Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45327 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752435AbcLHNsU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 08:48:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH RFC] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN if not needed
Date: Thu, 08 Dec 2016 15:48:44 +0200
Message-ID: <1829741.hbPLF342SU@avalon>
In-Reply-To: <20161208114143.764bf2e0@vento.lan>
References: <d29a265da6e7d8d3a637f189b1cfc2736ec14757.1481186696.git.mchehab@s-opensource.com> <6901624.mh7Rsaovg8@avalon> <20161208114143.764bf2e0@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 08 Dec 2016 11:41:43 Mauro Carvalho Chehab wrote:
> Em Thu, 08 Dec 2016 15:02:28 +0200 Laurent Pinchart escreveu:
> > On Thursday 08 Dec 2016 10:53:33 Mauro Carvalho Chehab wrote:
> >> Em Thu, 08 Dec 2016 14:25:38 +0200 Laurent Pinchart escreveu:
> >>> On Thursday 08 Dec 2016 06:55:58 Mauro Carvalho Chehab wrote:
> >>>> changeset 460b6c0831cb ("[media] tvp5150: Add s_stream subdev
> >>>> operation support") added a logic that overrides
> >>>> TVP5150_CONF_SHARED_PIN setting, depending on the type of bus set via
> >>>> the .set_fmt() subdev callback.
> >>>> 
> >>>> This is known to cause trobules on devices that don't use a V4L2
> >>>> subdev devnode, and a fix for it was made by changeset 47de9bf8931e
> >>>> ("[media] tvp5150: Fix breakage for serial usage"). Unfortunately,
> >>>> such fix doesn't consider the case of progressive video inputs,
> >>>> causing chroma decoding issues on such videos, as it overrides not
> >>>> only the type of video output, but also other unrelated bits.
> >>>> 
> >>>> So, instead of trying to guess, let's detect if the device is set
> >>>> via a V4L2 subdev node or not. If not, just ignore the bogus logic.
> >>>> 
> >>>> Fixes: 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
> >>>> support") Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> >>>> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> >>>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
> >>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >>>> ---
> >>>> 
> >>>> Devin,
> >>>> 
> >>>> I didn't test this patch. As I explained on my previous e-mail, my
> >>>> current test scenario for analog TV inputs is not  ideal, as I lack
> >>>> progressive video and RF output testcases.
> >>>> 
> >>>> Could you please test if this will fix for you?
> >>>> 
> >>>> Laurent/Javier,
> >>>> 
> >>>> With regards to OMAP3, it would be good to try to reproduce the
> >>>> issues Devin noticed on your hardware, testing with both progressive
> >>>> and interlaced sources and checking if the chroma is being decoded
> >>>> properly or not with a NTSC signal.
> >>>> 
> >>>>  drivers/media/i2c/tvp5150.c                      | 7 ++++++-
> >>>>  drivers/media/platform/pxa_camera.c              | 1 +
> >>>>  drivers/media/platform/soc_camera/soc_mediabus.c | 1 +
> >>>>  include/media/v4l2-mediabus.h                    | 3 +++
> >>>>  4 files changed, 11 insertions(+), 1 deletion(-)
> >>> 
> >>> [snip]
> >>> 
> >>>> diff --git a/include/media/v4l2-mediabus.h
> >>>> b/include/media/v4l2-mediabus.h
> >>>> index 34cc99e093ef..8af6b96d628b 100644
> >>>> --- a/include/media/v4l2-mediabus.h
> >>>> +++ b/include/media/v4l2-mediabus.h
> >>>> @@ -70,11 +70,14 @@
> >>>>   * @V4L2_MBUS_BT656:	parallel interface with embedded
> >>>>   synchronisation, can
> >>>>   *			also be used for BT.1120
> >>>>   * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
> >>>> + * @V4L2_MBUS_UNKNOWN:	used to indicate that the device is not
> >>>> controlled
> >>>> + *			via a V4L2 subdev devnode interface
> >>> 
> >>> Please, don't. v4l2_mbus_type has nothing to do with subdev device
> >>> nodes. It identifies the type of physical bus used to carry video data.
> >> 
> >> As explained, for the devices that the regression was introduced,
> >> there's no way to control the physical bus, as it is hardwired.
> >> 
> >> For those devices, mbus_type is just an useless information.
> > 
> > But the fact that a field is not used in some cases is no excuse to abuse
> > it for something completely unrelated to its purpose.
> > 
> >> The problem that your patch introduced is that it now assumes that
> >> the mbus would be controlled via a V4L2 subdevice. This is a wrong
> >> assumption, and caused a regression.
> >> 
> >> So, we need a simple way to get rid of the broken code on those
> >> devices, and that's the simplest way.
> > 
> > We need a correct way to fix the problem, and this isn't the correct way.
> > 
> > > If you didn't like the name, we could, instead, call it as:
> > > V4L2_MBUS_CONTROLLED_BY_VIDEODEV, with actually tells more about it.
> > 
> > No, V4L2_MBUS_* has *nothing* to do with how the device is controlled.
> 
> Well then your patch is wrong, as it *does* control the device based
> on the value of V4L2_MBUS_*.

???

> Anyway, there's another way to handle it: check if the device is
> controlled via DT, enabling the new (IMHO broken - see below) behavior only
> if it has DT. That will fix the regression without affecting OMAP3.

A device is never "controlled via DT", there's no such thing. It can be 
described in and instantiated from DT, but certainly not controlled.

> Patch sent.
> 
> Btw, the current logic is IMHO crap, as it just override all bits of
> mbus, even the ones unrelated to bt656 setup at register TVP5150_MISC_CTL.

Of course it is, that's why it's a bug. The code should certainly not override 
unrelated bits.

> It also doesn't consider the other parts of the driver that change
> the init values for S-Video setup, and do different init depending
> on the version of the chipset (tvp5150 uses a different init than
> tvp5150am1).
> 
> It also overrides TVP5150_CONF_SHARED_PIN from its default without
> any good reason.
> 
> The right thing seems to touch only on the bits that control the
> output format, and read the setup for TVP5150_CONF_SHARED_PIN
> from DT.
> 
> >> ---
> >> 
> >> That's said, as OMAP3 support was added considering this code,
> >> if the progressive video bug is also present there, we could
> >> try some other solution, although, in such case, it is not a
> >> regression. Unfortunately, I don't have any OMAP3 hardware with
> >> tvp5151 to test.
> > 
> > I do, so I could test that.
> > 
> >> So, if nobody comes with another solution that would work for
> >> both cases, I'll likely send this regression fix to 4.10, as
> >> it is better than reverting the broken patch, as reverting it
> >> would cause regressions for OMAP3.
> > 
> > You're modifying the in-kernel V4L2 API as a hack to work around a bug.
> > Let's not do that.

-- 
Regards,

Laurent Pinchart

