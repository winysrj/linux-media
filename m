Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2153 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3HSOwx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:52:53 -0400
Message-ID: <52123111.1050305@xs4all.nl>
Date: Mon, 19 Aug 2013 16:52:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	Martin Bugge <marbugge@cisco.com>
Subject: Re: [RFC PATCH 1/3] adv7842: add new video decoder driver.
References: <1376313239-19921-1-git-send-email-hverkuil@xs4all.nl> <1376313239-19921-2-git-send-email-hverkuil@xs4all.nl> <CAHG8p1CqONcw1LqTwNEZOpc_W8pL2rsH68UJRor2UbDb1fJ-Fg@mail.gmail.com>
In-Reply-To: <CAHG8p1CqONcw1LqTwNEZOpc_W8pL2rsH68UJRor2UbDb1fJ-Fg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2013 12:10 PM, Scott Jiang wrote:
>> +
>> +static int adv7842_g_mbus_fmt(struct v4l2_subdev *sd,
>> +                             struct v4l2_mbus_framefmt *fmt)
>> +{
>> +       struct adv7842_state *state = to_state(sd);
>> +
>> +       fmt->width = state->timings.bt.width;
>> +       fmt->height = state->timings.bt.height;
>> +       fmt->code = V4L2_MBUS_FMT_FIXED;
>> +       fmt->field = V4L2_FIELD_NONE;
>> +
>> +       if (state->mode == ADV7842_MODE_SDP) {
>> +               /* SPD block */
>> +               if (!(sdp_read(sd, 0x5A) & 0x01))
>> +                       return -EINVAL;
>> +               fmt->width = 720;
>> +               /* valid signal */
>> +               if (state->norm & V4L2_STD_525_60)
>> +                       fmt->height = 480;
>> +               else
>> +                       fmt->height = 576;
>> +               fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +               return 0;
>> +       }
>> +
> I believe someone use SDP mode to capture 480i instead of 480p.
> I think we can add a table to map adv7842 output setting and v4l format.

The driver as it stands only supports progressive output from the chip, because
that is all we support in our products (interlaced video conferencing? Nah, not
a good idea...).

I don't think I can easily test it (if at all!), so I leave this as an
exercise for the reader.

>> +static int adv7842_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
>> +{
>> +       struct adv7842_state *state = to_state(sd);
>> +
>> +       v4l2_dbg(1, debug, sd, "%s:\n", __func__);
>> +
>> +       if (state->mode != ADV7842_MODE_SDP)
>> +               return -ENODATA;
>> +
>> +       if (norm & V4L2_STD_ALL) {
>> +               state->norm = norm;
>> +               return 0;
>> +       }
>> +       return -EINVAL;
>> +}
> Why is there no hardware operation?
> 
> if (std == V4L2_STD_NTSC_443)
>                 val = 0x20;
> else if (std == V4L2_STD_PAL_60)
>                 val = 0x10;
> else if (std == V4L2_STD_PAL_Nc)
>                 val = 0x08;
> else if (std == V4L2_STD_PAL_M)
>                 val = 0x04;
> else if (std & V4L2_STD_NTSC)
>                 val = 0x02;
> else if (std & V4L2_STD_PAL)
>                 val = 0x01;
> else if (std & V4L2_STD_SECAM)
>                 val = 0x40;
> else
>                 return -EINVAL;
> /* force the digital core into a specific video standard */
> sdp_write(sd, 0x0, val);
> /* wait 100ms, otherwise color will be lost */
> msleep(100);
> state->std = std;
> return 0;

I checked with Martin Bugge who wrote this and the reason is that apparently forcing
the core to a specific standard will break the querystd functionality.

That said, this can definitely be improved by only forcing the standard when you start
streaming and reverting to the autodetect mode when streaming stops. QUERYSTD can return
-EBUSY when streaming is on.

I would prefer to do this in a separate patch later, though, as this will take some
time to implement and especially test.

Regards,

	Hans
