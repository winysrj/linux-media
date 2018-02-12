Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:39447 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932644AbeBLW14 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 17:27:56 -0500
Received: by mail-wm0-f48.google.com with SMTP id b21so12712734wme.4
        for <linux-media@vger.kernel.org>; Mon, 12 Feb 2018 14:27:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cf5c51f4-ca86-e468-ba16-d47d224a2428@xs4all.nl>
References: <1518157956-14220-1-git-send-email-tharvey@gateworks.com>
 <1518157956-14220-7-git-send-email-tharvey@gateworks.com> <cf5c51f4-ca86-e468-ba16-d47d224a2428@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 12 Feb 2018 14:27:53 -0800
Message-ID: <CAJ+vNU0ZCamOaJ2dZ_jisxcLFrUCTtajdvabBsHgpuedCVFbyw@mail.gmail.com>
Subject: Re: [PATCH v10 6/8] media: i2c: Add TDA1997x HDMI receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 9, 2018 at 12:08 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Tim,
>
> We're almost there. Two more comments:
>
> On 02/09/2018 07:32 AM, Tim Harvey wrote:
>> +static int
>> +tda1997x_detect_std(struct tda1997x_state *state,
>> +                 struct v4l2_dv_timings *timings)
>> +{
>> +     struct v4l2_subdev *sd = &state->sd;
>> +     u32 vper;
>> +     u16 hper;
>> +     u16 hsper;
>> +     int i;
>> +
>> +     /*
>> +      * Read the FMT registers
>> +      *   REG_V_PER: Period of a frame (or two fields) in MCLK(27MHz) cycles
>> +      *   REG_H_PER: Period of a line in MCLK(27MHz) cycles
>> +      *   REG_HS_WIDTH: Period of horiz sync pulse in MCLK(27MHz) cycles
>> +      */
>> +     vper = io_read24(sd, REG_V_PER) & MASK_VPER;
>> +     hper = io_read16(sd, REG_H_PER) & MASK_HPER;
>> +     hsper = io_read16(sd, REG_HS_WIDTH) & MASK_HSWIDTH;
>> +     if (!vper || !hper || !hsper)
>> +             return -ENOLINK;
>
> See my comment for g_input_status below. This condition looks more like a
> ENOLCK.
>
> Or perhaps it should be:
>
>         if (!vper && !hper && !hsper)
>                 return -ENOLINK;
>         if (!vper || !hper || !hsper)
>                 return -ENOLCK;
>
> I would recommend that you test a bit with no signal and a bad signal (perhaps
> one that uses a pixelclock that is too high for this device?).

I can't figure out how to produce a signal that can't be locked onto
with what I have available.

>
>> +     v4l2_dbg(1, debug, sd, "Signal Timings: %u/%u/%u\n", vper, hper, hsper);
>> +
>> +     for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
>> +             const struct v4l2_bt_timings *bt;
>> +             u32 lines, width, _hper, _hsper;
>> +             u32 vmin, vmax, hmin, hmax, hsmin, hsmax;
>> +             bool vmatch, hmatch, hsmatch;
>> +
>> +             bt = &v4l2_dv_timings_presets[i].bt;
>> +             width = V4L2_DV_BT_FRAME_WIDTH(bt);
>> +             lines = V4L2_DV_BT_FRAME_HEIGHT(bt);
>> +             _hper = (u32)bt->pixelclock / width;
>> +             if (bt->interlaced)
>> +                     lines /= 2;
>> +             /* vper +/- 0.7% */
>> +             vmin = ((27000000 / 1000) * 993) / _hper * lines;
>> +             vmax = ((27000000 / 1000) * 1007) / _hper * lines;
>> +             /* hper +/- 1.0% */
>> +             hmin = ((27000000 / 100) * 99) / _hper;
>> +             hmax = ((27000000 / 100) * 101) / _hper;
>> +             /* hsper +/- 2 (take care to avoid 32bit overflow) */
>> +             _hsper = 27000 * bt->hsync / ((u32)bt->pixelclock/1000);
>> +             hsmin = _hsper - 2;
>> +             hsmax = _hsper + 2;
>> +
>> +             /* vmatch matches the framerate */
>> +             vmatch = ((vper <= vmax) && (vper >= vmin)) ? 1 : 0;
>> +             /* hmatch matches the width */
>> +             hmatch = ((hper <= hmax) && (hper >= hmin)) ? 1 : 0;
>> +             /* hsmatch matches the hswidth */
>> +             hsmatch = ((hsper <= hsmax) && (hsper >= hsmin)) ? 1 : 0;
>> +             if (hmatch && vmatch && hsmatch) {
>> +                     *timings = v4l2_dv_timings_presets[i];
>> +                     v4l2_print_dv_timings(sd->name, "Detected format: ",
>> +                                           timings, false);
>> +                     return 0;
>> +             }
>> +     }
>> +
>> +     v4l_err(state->client, "no resolution match for timings: %d/%d/%d\n",
>> +             vper, hper, hsper);
>> +     return -EINVAL;
>> +}
>
> -EINVAL isn't the correct error code here. I would go for -ERANGE. It's not
> perfect, but close enough.
>
> -EINVAL indicates that the user filled in wrong values, but that's not the
> case here.

done

>
>> +static int
>> +tda1997x_g_input_status(struct v4l2_subdev *sd, u32 *status)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +     u32 vper;
>> +     u16 hper;
>> +     u16 hsper;
>> +
>> +     mutex_lock(&state->lock);
>> +     v4l2_dbg(1, debug, sd, "inputs:%d/%d\n",
>> +              state->input_detect[0], state->input_detect[1]);
>> +     if (state->input_detect[0] || state->input_detect[1])
>
> I'm confused. This device has two HDMI inputs?
>
> Does 'detecting input' equate to 'I see a signal and I am locked'?
> I gather from the irq function that sets these values that it is closer
> to 'I see a signal' and that 'I am locked' is something you would test
> by looking at the vper/hper/hsper.

The TDA19972 and/or TDA19973 has an A and B input but only a single
output. I'm not entirely clear if/how to select between the two and I
don't have proper documentation for the three chips.

The TDA19971 which I have on my board only has 1 input which is
reported as the 'A' input. I can likely nuke the stuff looking at the
B input and/or put some qualifiers around it but I didn't want to
remove code that was derived from some vendor code that might help
support the other chips in the future. So I would rather like to leave
the 'if A or B' stuff.

>
>> +             *status = 0;
>> +     else {
>> +             vper = io_read24(sd, REG_V_PER) & MASK_VPER;
>> +             hper = io_read16(sd, REG_H_PER) & MASK_HPER;
>> +             hsper = io_read16(sd, REG_HS_WIDTH) & MASK_HSWIDTH;
>> +             v4l2_dbg(1, debug, sd, "timings:%d/%d/%d\n", vper, hper, hsper);
>> +             if (!vper || !hper || !hsper)
>> +                     *status |= V4L2_IN_ST_NO_SYNC;
>> +             else
>> +                     *status |= V4L2_IN_ST_NO_SIGNAL;
>
> So if we have valid vper, hper and hsper, then there is no signal? That doesn't
> make sense.
>
> I'd expect to see something like this:
>
>         if (!input_detect[0] && !input_detect[1])
>                 // no signal
>         else if (!vper || !hper || !vsper)
>                 // no sync
>         else
>                 // have signal and sync

sure... reads a bit cleaner. I can't guarantee that any of
vper/hper/vsper will be 0 if a signal can't be locked onto without
proper documentation or ability to generate such a signal. I do know
if I yank the source I get non-zero random values and must rely on the
input_detect logic.

>
> I'm not sure about the precise meaning of input_detect, so I might be wrong about
> that bit.

ya... me either. I'm trying my hardest to get this driver up to shape
but the documentation I have is utter crap and I'm doing some guessing
as well as to what all the registers are and what the meaning of the
very obfuscated vendor code does.

would you object to detecting timings and displaying via v4l2_dbg when
a resolution change is detected (just not 'using' those timings for
anything?):

@@ -1384,6 +1386,7 @@ static void tda1997x_irq_sus(struct tda1997x_state *state,
 u8 *flags)
                        v4l_err(state->client, "BAD SUS STATUS\n");
                        return;
                }
+               if (debug)
+                              tda1997x_detect_std(state, NULL);
                /* notify user of change in resolution */
                v4l2_subdev_notify_event(&state->sd, &tda1997x_ev_fmt);
        }

@@ -1140,16 +1140,18 @@ tda1997x_detect_std(struct tda1997x_state *state,
                /* hsmatch matches the hswidth */
                hsmatch = ((hsper <= hsmax) && (hsper >= hsmin)) ? 1 : 0;
                if (hmatch && vmatch && hsmatch) {
-                       *timings = v4l2_dv_timings_presets[i];
                        v4l2_print_dv_timings(sd->name, "Detected format: ",
-                                             timings, false);
+                                             &v4l2_dv_timings_presets[i],
+                                             false);
+                       if (timings)
+                               *timings = v4l2_dv_timings_presets[i];
                        return 0;
                }
        }

It seems to make sense to me to be seeing a kernel message when
timings change and what they change to without having to query :)

Tim
