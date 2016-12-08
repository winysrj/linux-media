Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33702 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbcLHRuZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 12:50:25 -0500
Received: by mail-oi0-f50.google.com with SMTP id w63so460607122oiw.0
        for <linux-media@vger.kernel.org>; Thu, 08 Dec 2016 09:50:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3810287.F7IvM3IBCA@avalon>
References: <b47a9d956d740d63334bf0f07e6cfddd7f60e98b.1481204310.git.mchehab@s-opensource.com>
 <3555863.PStTa0BX6X@avalon> <20161208121608.1a95d3b6@vento.lan> <3810287.F7IvM3IBCA@avalon>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Thu, 8 Dec 2016 12:50:19 -0500
Message-ID: <CAGoCfiz3MNnt=8zZ5jHMQzZOyfNW_biSNU2iju4wROxQ4X=NBQ@mail.gmail.com>
Subject: Re: [PATCH] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN if
 not needed
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Laurent,

I tried out Mauro's latest patch (9:46am EST), and it appears to at
least partially address the issue, but still doesn't work.  In fact,
whereas before I was getting stable video with a chroma issue, with
the patch applied I'm now getting no video at all (i.e. tvtime is
completely blocked waiting for frames to arrive).

First off, a register dump does show that register 0x03 is now 0x6F,
so at least that part is working.  However, TVP5150_DATA_RATE_SEL,
(register 0x0D) is now being set to 0x40, whereas it needs to be set
to 0x47 to work properly.  Just to confirm, I started up tvtime and
fed the device the following command, at which point video started
rendering properly:

sudo v4l2-dbg --chip=subdev0 --set-register=0x0d 0x47

I'm not sitting in front of the datasheet right now so I cannot
suggest what the correct fix is, but at first glance it looks like the
first hunk of Mauro's patch isn't correct for em28xx devices.

Also worth noting for the moment I'm testing exclusively with
composite on the HVR-850.  Once we've got that working, I'll dig out
an s-video cable and make sure that is working too.

Cheers,

Devin


On Thu, Dec 8, 2016 at 10:22 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Thursday 08 Dec 2016 12:16:08 Mauro Carvalho Chehab wrote:
>> Em Thu, 08 Dec 2016 15:41:59 +0200 Laurent Pinchart escreveu:
>> > On Thursday 08 Dec 2016 11:38:34 Mauro Carvalho Chehab wrote:
>> > > changeset 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
>> > > support") added a logic that overrides TVP5150_CONF_SHARED_PIN setting,
>> > > depending on the type of bus set via the .set_fmt() subdev callback.
>> > >
>> > > This is known to cause trobules on devices that don't use a V4L2
>> > > subdev devnode, and a fix for it was made by changeset 47de9bf8931e
>> > > ("[media] tvp5150: Fix breakage for serial usage"). Unfortunately,
>> > > such fix doesn't consider the case of progressive video inputs,
>> > > causing chroma decoding issues on such videos, as it overrides not
>> > > only the type of video output, but also other unrelated bits.
>> > >
>> > > So, instead of trying to guess, let's detect if the device is set
>> > > via Device Tree. If not, just ignore the bogus logic.
>> >
>> > If you add a big [HACK] tag to the subject line, sure. I thought this
>> > would have been an occasion to fix the problem correctly :-(
>>
>> No, this is not a hack.
>>
>> It is a patch that restores the driver behavior that used to be
>> before adding DT support to the driver. Whatever DT-based drivers
>> need, it *should not* change the behavior for devices that don't
>> use DT.
>
> 1. This has nothing to do with DT, but with the addition of the s_stream()
> operation.
>
> 2. When I added s_stream() support the em28xx driver did not call s_stream(1).
> That has been changed by
>
> commit 13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d
> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Date:   Tue Jan 26 06:59:39 2016 -0200
>
>     [media] em28xx: fix implementation of s_stream
>
>     On em28xx driver, s_stream subdev ops was not implemented
>     properly. It was used only to disable stream, never enabling it.
>     That was the root cause of the regression when we added support
>     for s_stream on tvp5150 driver.
>
>     With that, we can get rid of the changes on tvp5150 side,
>     e. g. changeset 47de9bf8931e ('[media] tvp5150: Fix breakage for serial
> usage').
>
>     Tested video output on em2820+tvp5150 on WinTV USB2 and
>     video and/or vbi output on em288x+tvp5150 on HVR 950.
>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> 3. There's clearly a bug in the current implementation, and it needs to be
> fixed. That fact does not turn every attempt to address the bug into proper
> fixes by magic. Hacks remain hacks.
>
> 4. I'm working on a proper fix.
>
>> I agree with you that the patch is incomplete, as it doesn't
>> add any OF var that would allow DT to specify the values
>> to be used for TVP5150_CONF_SHARED_PIN and TVP5150_MISC_CTL,
>> and assumes that tvp5150, tvp5151 and tvp5150am1 will all use
>> the same values for TVP5150_MISC_CTL.
>>
>> In order to fix that, someone with a DT-based driver with tvp5150,
>> tvp5150am1 and/or tvp5151 would need to spend some time and test
>> the hardware with both interlaced and progressive video inputs.
>>
>> That's not me, as I don't have any hardware that meets such requirement.
>>
>> If someone ships me such hardware, I could work on it on my spare time.
>> Otherwise, then perhaps you could work on such patch - or we could ping
>> Javier on Monday and see if has time/interest to work on it (afaikt, he's
>> OOT the rest of this week).
>>
>> Anyway, with this patch applied, the one working on such fix won't need
>> to be concerned to cause new regressions on the non-DT drivers that use
>> this chip, with is, IMHO, a very good thing.
>>
>> Also, this patch is simple enough to be backported to -stable.
>>
>> What's missing here is a notice explaining what's left to be done,
>> like the one on the diff below.
>>
>> Regards,
>> Mauro
>>
>> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
>> index eb43ac7002d6..c9fd36998ac7 100644
>> --- a/drivers/media/i2c/tvp5150.c
>> +++ b/drivers/media/i2c/tvp5150.c
>> @@ -1057,6 +1057,17 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd,
>> int enable) if (!decoder->has_dt)
>>               return 0;
>>
>> +     /*
>> +      * FIXME: the logic below is hardcoded to work with some OMAP3
>> +      * hardware with tvp5151. As such, it hardcodes values for
>> +      * both TVP5150_CONF_SHARED_PIN and TVP5150_MISC_CTL, and ignores
>> +      * what was set before at the driver. Ideally, we should have
>> +      * DT nodes describing the setup, instead of hardcoding those
>> +      * values, and doing a read before writing values to
>> +      * TVP5150_MISC_CTL, but any patch adding support for it should
>> +      * keep DT backward-compatible.
>> +      */
>> +
>>       /* Output format: 8-bit 4:2:2 YUV with discrete sync */
>>       if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
>>               val = 0x0d;
>
> --
> Regards,
>
> Laurent Pinchart
>



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
