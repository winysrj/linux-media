Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:33733 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbeBIGB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 01:01:27 -0500
Received: by mail-wr0-f181.google.com with SMTP id s5so7051912wra.0
        for <linux-media@vger.kernel.org>; Thu, 08 Feb 2018 22:01:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f19fd00d-66fb-a4a2-295b-d4bfae3b4e51@xs4all.nl>
References: <1518043367-11531-1-git-send-email-tharvey@gateworks.com>
 <1518043367-11531-7-git-send-email-tharvey@gateworks.com> <f19fd00d-66fb-a4a2-295b-d4bfae3b4e51@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 8 Feb 2018 22:01:25 -0800
Message-ID: <CAJ+vNU1CTUQ9EFiV09XeihSHeAMw3C=0JYFL+NPM=DOTTrAP4w@mail.gmail.com>
Subject: Re: [PATCH v9 6/8] media: i2c: Add TDA1997x HDMI receiver driver
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

On Thu, Feb 8, 2018 at 7:06 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Tim,
>
> I was so hoping I could make a pull request for this, but I still found
> problems with g/s/query_dv_timings.
>
> I strongly suspect that v4l2-compliance would fail if you boot up the system
> *without* a source connected.
>
> And I discovered that I was missing additional checks in the timings tests
> for v4l2-compliance that would have found the same issue if run with a source
> connected. I've fixed and committed those tests now. I'll also try to test
> that a S_DV_TIMINGS calls updates the format.
>
> Details below:
>
> On 02/07/18 23:42, Tim Harvey wrote:
>> +struct tda1997x_state {
>
> ...
>
>> +     struct v4l2_dv_timings timings;
>> +     const struct v4l2_dv_timings *detected_timings;
>
> ...
>
>> +/* Configure frame detection window and VHREF timing generator */
>> +static int
>> +tda1997x_configure_vhref(struct v4l2_subdev *sd)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +     const struct v4l2_bt_timings *bt;
>> +     int width, lines;
>> +     u16 href_start, href_end;
>> +     u16 vref_f1_start, vref_f2_start;
>> +     u8 vref_f1_width, vref_f2_width;
>> +     u8 field_polarity;
>> +     u16 fieldref_f1_start, fieldref_f2_start;
>> +     u8 reg;
>> +
>> +     if (!state->detected_timings)
>> +             return -EINVAL;
>
> Why this test? Who cares if there are no detected timings? It's certainly
> not a failure. S_DV_TIMINGS should succeed regardless of whether there is
> a signal or not and regardless of the current detected timings.
>

good point. Both tda1997x_configure_vhref() and
tda1997x_configure_csc() should never return an error - I'll change
that.

>> +     bt = &state->detected_timings->bt;
>
> Ouch. The timings passed in with S_DV_TIMINGS should be used.
>
> Just use state->timings here, not detected_timings.

Ok. I was thinking the VHREF generator responsible for output timings
to the SoC should always match the input source but changing it async
like that could mess with userspace buffers and the like so even
though the output will be 'wrong' after a resolution change I get that
I need to wait for userspace to come along and query then set the new
resolution.

>
>> +     href_start = bt->hbackporch + bt->hsync + 1;
>> +     href_end = href_start + bt->width;
>> +     vref_f1_start = bt->height + bt->vbackporch + bt->vsync +
>> +                     bt->il_vbackporch + bt->il_vsync +
>> +                     bt->il_vfrontporch;
>> +     vref_f1_width = bt->vbackporch + bt->vsync + bt->vfrontporch;
>> +     vref_f2_start = 0;
>> +     vref_f2_width = 0;
>> +     fieldref_f1_start = 0;
>> +     fieldref_f2_start = 0;
>> +     if (bt->interlaced) {
>> +             vref_f2_start = (bt->height / 2) +
>> +                             (bt->il_vbackporch + bt->il_vsync - 1);
>> +             vref_f2_width = bt->il_vbackporch + bt->il_vsync +
>> +                             bt->il_vfrontporch;
>> +             fieldref_f2_start = vref_f2_start + bt->il_vfrontporch +
>> +                                 fieldref_f1_start;
>> +     }
>> +     field_polarity = 0;
>> +
>> +     width = V4L2_DV_BT_FRAME_WIDTH(bt);
>> +     lines = V4L2_DV_BT_FRAME_HEIGHT(bt);
>> +
>> +     /*
>> +      * Configure Frame Detection Window:
>> +      *  horiz area where the VHREF module consider a VSYNC a new frame
>> +      */
>> +     io_write16(sd, REG_FDW_S, 0x2ef); /* start position */
>> +     io_write16(sd, REG_FDW_E, 0x141); /* end position */
>> +
>> +     /* Set Pixel And Line Counters */
>> +     if (state->chip_revision == 0)
>> +             io_write16(sd, REG_PXCNT_PR, 4);
>> +     else
>> +             io_write16(sd, REG_PXCNT_PR, 1);
>> +     io_write16(sd, REG_PXCNT_NPIX, width & MASK_VHREF);
>> +     io_write16(sd, REG_LCNT_PR, 1);
>> +     io_write16(sd, REG_LCNT_NLIN, lines & MASK_VHREF);
>> +
>> +     /*
>> +      * Configure the VHRef timing generator responsible for rebuilding all
>> +      * horiz and vert synch and ref signals from its input allowing auto
>> +      * detection algorithms and forcing predefined modes (480i & 576i)
>> +      */
>> +     reg = VHREF_STD_DET_OFF << VHREF_STD_DET_SHIFT;
>> +     io_write(sd, REG_VHREF_CTRL, reg);
>> +
>> +     /*
>> +      * Configure the VHRef timing values. In case the VHREF generator has
>> +      * been configured in manual mode, this will allow to manually set all
>> +      * horiz and vert ref values (non-active pixel areas) of the generator
>> +      * and allows setting the frame reference params.
>> +      */
>> +     /* horizontal reference start/end */
>> +     io_write16(sd, REG_HREF_S, href_start & MASK_VHREF);
>> +     io_write16(sd, REG_HREF_E, href_end & MASK_VHREF);
>> +     /* vertical reference f1 start/end */
>> +     io_write16(sd, REG_VREF_F1_S, vref_f1_start & MASK_VHREF);
>> +     io_write(sd, REG_VREF_F1_WIDTH, vref_f1_width);
>> +     /* vertical reference f2 start/end */
>> +     io_write16(sd, REG_VREF_F2_S, vref_f2_start & MASK_VHREF);
>> +     io_write(sd, REG_VREF_F2_WIDTH, vref_f2_width);
>> +
>> +     /* F1/F2 FREF, field polarity */
>> +     reg = fieldref_f1_start & MASK_VHREF;
>> +     reg |= field_polarity << 8;
>> +     io_write16(sd, REG_FREF_F1_S, reg);
>> +     reg = fieldref_f2_start & MASK_VHREF;
>> +     io_write16(sd, REG_FREF_F2_S, reg);
>> +
>> +     return 0;
>> +}
<snip>
>> +static void tda1997x_irq_sus(struct tda1997x_state *state, u8 *flags)
>> +{
>> +     struct v4l2_subdev *sd = &state->sd;
>> +     u8 reg, source;
>> +
>> +     source = io_read(sd, REG_INT_FLG_CLR_SUS);
>> +     io_write(sd, REG_INT_FLG_CLR_SUS, source);
>> +
>> +     if (source & MASK_MPT) {
>> +             /* reset MTP in use flag if set */
>> +             if (state->mptrw_in_progress)
>> +                     state->mptrw_in_progress = 0;
>> +     }
>> +
>> +     if (source & MASK_SUS_END) {
>> +             /* reset audio FIFO */
>> +             reg = io_read(sd, REG_HDMI_INFO_RST);
>> +             reg |= MASK_SR_FIFO_FIFO_CTRL;
>> +             io_write(sd, REG_HDMI_INFO_RST, reg);
>> +             reg &= ~MASK_SR_FIFO_FIFO_CTRL;
>> +             io_write(sd, REG_HDMI_INFO_RST, reg);
>> +
>> +             /* reset HDMI flags */
>> +             state->hdmi_status = 0;
>> +     }
>> +
>> +     /* filter FMT interrupt based on SUS state */
>> +     reg = io_read(sd, REG_SUS_STATUS);
>> +     if (((reg & MASK_SUS_STATUS) != LAST_STATE_REACHED)
>> +        || (source & MASK_MPT)) {
>> +             source &= ~MASK_FMT;
>> +     }
>> +
>> +     if (source & (MASK_FMT | MASK_SUS_END)) {
>> +             reg = io_read(sd, REG_SUS_STATUS);
>> +             if ((reg & MASK_SUS_STATUS) != LAST_STATE_REACHED) {
>> +                     v4l_err(state->client, "BAD SUS STATUS\n");
>> +                     return;
>> +             }
>> +
>> +             /* There is new activity, the status for HDCP repeater state */
>> +             state->state_c5_reached = 0;
>> +
>> +             /* Detect the new resolution */
>> +             if (!tda1997x_detect_std(state))
>> +                     v4l2_subdev_notify_event(&state->sd, &tda1997x_ev_fmt);
>
> Why detect a new resolution here? That only need to be done when the user
> calls query_dv_timings. Just send the event unconditionally to tell userspace
> that the resolution changed.
>

Right - don't need to do 'anything' with the new detected timings
until the user asks about them. I get it now.

>> +     }
>> +}
>
> ...
>
>> +/* -----------------------------------------------------------------------------
>> + * v4l2_subdev_video_ops
>> + */
>> +
>> +static int
>> +tda1997x_g_input_status(struct v4l2_subdev *sd, u32 *status)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +
>> +     mutex_lock(&state->lock);
>> +     if (state->detected_timings)
>
> What this actually tests if the driver was able to detect a valid signal
> and lock to it.
>
> In practice you have three possible outcomes:
>
> - There is no HDMI signal at all: return V4L2_IN_ST_NO_SIGNAL
> - There is a signal, but the receiver could not lock to it: return V4L2_IN_ST_NO_SYNC
> - There is a signal, and the receiver could lock: return 0.
>
> Just because this returns 0, doesn't mean that QUERY_DV_TIMINGS will succeed.
> There may be other constraints (e.g. the driver doesn't support certain formats
> such as interlaced) that can cause QUERY_DV_TIMINGS to return an error, even
> though the receiver could sync.
>
> Usually the hardware has some bits that tell whether there is a signal
> (usually the TMDS clock) and whether it could sync or not (H and V syncs).
>
> That's really all you need to test here.

makes sense. I don't have any decent documentation on the TMDS regs
used in tda1997x_read_activity_status but I can use the some other
things to determine this.

I don't see v4l2-subdev.c (or anything) ever calling g_input_status.
How do I test this?

>
>> +             *status = 0;
>> +     else
>> +             *status |= V4L2_IN_ST_NO_SIGNAL;
>> +     mutex_unlock(&state->lock);
>> +
>> +     return 0;
>> +};
>> +
>> +static int tda1997x_s_dv_timings(struct v4l2_subdev *sd,
>> +                             struct v4l2_dv_timings *timings)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +     int ret;
>> +
>> +     v4l_dbg(1, debug, state->client, "%s\n", __func__);
>> +     if (!timings)
>> +             return -EINVAL;
>
> These 'if (!timings)' tests are not needed and can be dropped here and
> elsewhere.

ok

>
>> +
>> +     if (v4l2_match_dv_timings(&state->timings, timings, 0, false))
>> +             return 0; /* no changes */
>> +
>> +     if (!v4l2_valid_dv_timings(timings, &tda1997x_dv_timings_cap,
>> +                                NULL, NULL))
>> +             return -ERANGE;
>> +
>> +     mutex_lock(&state->lock);
>> +     state->timings = *timings;
>> +     /* setup frame detection window and VHREF timing generator */
>> +     ret = tda1997x_configure_vhref(sd);
>> +     if (ret)
>> +             goto error;
>> +     /* configure colorspace conversion */
>> +     ret = tda1997x_configure_csc(sd);
>> +     if (ret)
>> +             goto error;
>> +     mutex_unlock(&state->lock);
>> +
>> +     return 0;
>> +
>> +error:
>> +     mutex_unlock(&state->lock);
>> +     return ret;
>> +}
>> +
>> +static int tda1997x_g_dv_timings(struct v4l2_subdev *sd,
>> +                              struct v4l2_dv_timings *timings)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +
>> +     v4l_dbg(1, debug, state->client, "%s\n", __func__);
>> +     if (!timings)
>> +             return -EINVAL;
>> +
>> +     mutex_lock(&state->lock);
>> +     *timings = state->timings;
>> +     mutex_unlock(&state->lock);
>> +
>> +     return 0;
>> +}
>> +
>> +static int tda1997x_query_dv_timings(struct v4l2_subdev *sd,
>> +                                  struct v4l2_dv_timings *timings)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +     int ret;
>> +
>> +     v4l_dbg(1, debug, state->client, "%s\n", __func__);
>> +     if (!timings)
>> +             return -EINVAL;
>> +
>> +     memset(timings, 0, sizeof(struct v4l2_dv_timings));
>> +     mutex_lock(&state->lock);
>> +     ret = tda1997x_detect_std(state);
>> +     if (!ret)
>> +             *timings = *state->detected_timings;
>
> I think you can just drop the 'detected_timings' field and just
> do tda1997x_detect_std(state, timings); here. That way you are not
> tempted to use 'detected_timings' in places where you shouldn't :-)

done

>
>> +     mutex_unlock(&state->lock);
>> +
>> +     return ret;
>> +}
>> +
>> +static int tda1997x_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +
>> +     v4l_dbg(1, debug, state->client, "%s %d\n", __func__, enable);
>> +     mutex_lock(&state->lock);
>> +     if (!state->detected_timings)
>> +             v4l_dbg(1, debug, state->client, "Invalid HDMI signal\n");
>> +     mutex_unlock(&state->lock);
>> +
>> +     return 0;
>> +}
>
> I'd drop this. It isn't helpful.

done

>
>> +
>> +static const struct v4l2_subdev_video_ops tda1997x_video_ops = {
>> +     .g_input_status = tda1997x_g_input_status,
>> +     .s_dv_timings = tda1997x_s_dv_timings,
>> +     .g_dv_timings = tda1997x_g_dv_timings,
>> +     .query_dv_timings = tda1997x_query_dv_timings,
>> +     .s_stream = tda1997x_s_stream,
>> +};
>> +
>> +
>> +/* -----------------------------------------------------------------------------
>> + * v4l2_subdev_pad_ops
>> + */
>> +
>> +static int tda1997x_init_cfg(struct v4l2_subdev *sd,
>> +                          struct v4l2_subdev_pad_config *cfg)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +     struct v4l2_mbus_framefmt *mf;
>> +
>> +     mf = v4l2_subdev_get_try_format(sd, cfg, 0);
>> +     mf->code = state->mbus_codes[0];
>> +
>> +     return 0;
>> +}
>> +
>> +static int tda1997x_enum_mbus_code(struct v4l2_subdev *sd,
>> +                               struct v4l2_subdev_pad_config *cfg,
>> +                               struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +
>> +     v4l_dbg(1, debug, state->client, "%s %d/%d\n", __func__,
>> +             code->index, ARRAY_SIZE(state->mbus_codes));
>> +     if (code->index >= ARRAY_SIZE(state->mbus_codes))
>> +             return -EINVAL;
>> +
>> +     if (!state->mbus_codes[code->index])
>> +             return -EINVAL;
>> +
>> +     code->code = state->mbus_codes[code->index];
>> +
>> +     return 0;
>> +}
>> +
>> +static int tda1997x_fill_format(struct tda1997x_state *state,
>> +                             struct v4l2_mbus_framefmt *format)
>> +{
>> +     const struct v4l2_bt_timings *bt;
>> +
>> +     v4l_dbg(1, debug, state->client, "%s\n", __func__);
>> +
>> +     if (!state->detected_timings)
>> +             return -EINVAL;
>
> Ouch. Just drop this.
>
>> +
>> +     memset(format, 0, sizeof(*format));
>> +     bt = &state->detected_timings->bt;
>
> and use &state->timings.bt here. That is how the receiver is configured.
>
>> +     format->width = bt->width;
>> +     format->height = bt->height;
>> +     format->colorspace = state->colorimetry.colorspace;
>> +     format->field = (bt->interlaced) ?
>> +             V4L2_FIELD_SEQ_TB : V4L2_FIELD_NONE;
>> +
>> +     return 0;
>> +}
>
> The *only* time you need to care about the actual detected timings is when
> userspace calls QUERY_DV_TIMINGS. Never anywhere else.
>
> s_input_status is used to test some basics (do I have a signal, can I lock)
> but doesn't go 'in-depth'.
>
> If the interrupt routine detects a resolution change or it loses a stable
> signal, then it sends an event to userspace, but nothing else should change.
>
> Look at adv7604.c: the only time it attempts to detect the timings with
> read_stdi() is when called from query_dv_timings (and log_status for debugging).

ok - I get it. Finally sinking in I think!

v10 on the way.

Regards,

Tim
