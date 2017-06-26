Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45973 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751405AbdFZPgV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 11:36:21 -0400
Subject: Re: [PATCH v4 1/2] media: i2c: adv748x: add adv748x driver
To: kieran.bingham@ideasonboard.com,
        Kieran Bingham <kbingham@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.d0545e32d322ca1b939fa2918694173629e680eb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <865b71d4fcf6ce407a94a10d5dcb06944ddb6dcb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <07ad1ecd-a63e-3c94-87ad-4e1978759011@xs4all.nl>
 <530a839a-c828-b0cd-03de-858aa69d266c@ideasonboard.com>
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        niklas.soderlund@ragnatech.se
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dd9b6e40-a77b-20bf-e151-1c06ef9d61f6@xs4all.nl>
Date: Mon, 26 Jun 2017 17:36:18 +0200
MIME-Version: 1.0
In-Reply-To: <530a839a-c828-b0cd-03de-858aa69d266c@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/06/17 17:14, Kieran Bingham wrote:
> Hi Hans,
> 
> Thankyou for your review, and apologies for the delay - I was OoO last week.
> 
> 
> On 19/06/17 10:13, Hans Verkuil wrote:
>> On 06/13/2017 02:35 AM, Kieran Bingham wrote:
>>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>
>>> Provide support for the ADV7481 and ADV7482.
>>>
>>> The driver is modelled with 4 subdevices to allow simultaneous streaming
>>> from the AFE (Analog front end) and HDMI inputs though two CSI TX
>>> entities.
>>>
>>> The HDMI entity is linked to the TXA CSI bus, whilst the AFE is linked
>>> to the TXB CSI bus.
>>>
>>> The driver is based on a prototype by Koji Matsuoka in the Renesas BSP,
>>> and an earlier rework by Niklas Söderlund.
>>>
>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>
>>> ---
>>>
>>> v2:
>>>   - Implement DT parsing
>>>   - adv748x: Add CSI2 entity
>>>   - adv748x: Rework pad allocations and fmts
>>>   - Give AFE 8 input pads and move pad defines
>>>   - Use the enums to ensure pads are referenced correctly.
>>>   - adv748x: Rename AFE/HDMI entities
>>>     Now they are 'just afe' and 'just hdmi'
>>>   - Reorder the entity enum and structures
>>>   - Added pad-format for the CSI2 entities
>>>   - CSI2 s_stream pass through
>>>   - CSI2 control pass through (with link following)
>>>
>>> v3:
>>>   - dt: Extend DT documentation to specify interrupt mappings
>>>   - simplify adv748x_parse_dt
>>>   - core: Add banner to header file describing ADV748x variants
>>>   - Use entity structure pointers rather than global state pointers where
>>>     possible
>>>   - afe: Reduce indent on afe_status
>>>   - hdmi: Add error checking to the bt->pixelclock values.
>>>   - Remove all unnecessary pad checks: handled by core
>>>   - Fix all probe cleanup paths
>>>   - adv748x_csi2_probe() now fails if it has no endpoint
>>>   - csi2: Fix small oneliners for is_txa and get_remote_sd()
>>>   - csi2: Fix checkpatch warnings
>>>   - csi2: Fix up s_stream pass-through
>>>   - csi2: Fix up Pixel Rate passthrough
>>>   - csi2: simplify adv748x_csi2_get_pad_format()
>>>   - Remove 'async notifiers' from AFE/HDMI
>>>     Using async notifiers was overkill, when we have access to the
>>>     subdevices internally and can register them directly.
>>>   - Use state lock in control handlers and clean up s_ctrls
>>>   - remove _interruptible mutex locks
>>>
>>> v4:
>>>   - all: Convert hex 0xXX to lowercase
>>>   - all: Use defines instead of hardcoded register values
>>>   - all: Use regmap
>>>   - afe, csi2, hdmi: _probe -> _init
>>>   - afe, csi2, hdmi: _remove -> _cleanup
>>>   - afe, hdmi: Convert pattern generator to a control
>>>   - afe, hdmi: get/set-fmt refactor
>>>   - afe, hdmi, csi2: Convert to internal calls for pixelrate
>>>   - afe: Allow the AFE to configure the Input Select from DT
>>>   - afe: Reduce indent on adv748x_afe_status switch
>>>   - afe: Remove ununsed macro definitions AIN0-7
>>>   - afe: Remove extraneous control checks handled by core
>>>   - afe: Comment fixups
>>>   - afe: Rename error label
>>>   - afe: Correct control names on the SDP
>>>   - afe: Use AIN0-7 rather than AIN1-8 to match ports and MC pads
>>>   - core: adv748x_parse_dt references to nodes, and catch multiple
>>>     endpoints in a port.
>>>   - core: adv748x_dt_cleanup to simplify releasing DT nodes
>>>   - core: adv748x_print_info renamed to adv748x_identify_chip
>>>   - core: reorganise ordering of probe sequence
>>>   - core: No need for of_match_ptr
>>>   - core: Fix up i2c read/writes (regmap still on todo list)
>>>   - core: Set specific functions from the entities on subdev-init
>>>   - core: Use kzalloc for state instead of devm
>>>   - core: Improve probe error reporting
>>>   - core: Track unknown BIT(6) in tx{a,b}_power
>>>   - csi2: Improve adv748x_csi2_get_remote_sd as adv748x_csi2_get_source_sd
>>>   - csi2: -EPIPE instead of -ENODEV
>>>   - csi2: adv_dbg, instead of adv_info
>>>   - csi2: adv748x_csi2_set_format fix
>>>   - csi2: remove async notifier and sd member variables
>>>   - csi2: register links from the CSI2
>>>   - csi2: create virtual channel helper function
>>>   - dt: Remove numbering from endpoints
>>>   - dt: describe ports and interrupts as optional
>>>   - dt: Re-tab
>>>   - hdmi: adv748x_hdmi_have_signal -> adv748x_hdmi_has_signal
>>>   - hdmi: fix adv748x_hdmi_read_pixelclock return checks
>>>   - hdmi: improve adv748x_hdmi_set_video_timings
>>>   - hdmi: Fix tmp variable as polarity
>>>   - hdmi: Improve adv748x_hdmi_s_stream
>>>   - hdmi: Clean up adv748x_hdmi_s_ctrl register definitions and usage
>>>   - hdmi: Fix up adv748x_hdmi_s_dv_timings with macro names for register
>>>   - hdmi: Add locking to adv748x_hdmi_g_dv_timings
>>>     writes and locking
>>>   - hdmi: adv748x_hdmi_set_de_timings function added to clarify DE writes
>>>   - hdmi: Use CP in control register naming to match component processor
>>>   - hdmi: clean up adv748x_hdmi_query_dv_timings()
>>>   - KConfig: Fix up dependency and capitalisation
>>>
>>>
>>>   Documentation/devicetree/bindings/media/i2c/adv748x.txt |  96 +-
>>
>> This should be a separate patch cross posted to the devicetree mailinglist.
>>
>>>   MAINTAINERS                                             |   6 +-
>>
>> This should also be a separate patch.
>>
>>>   drivers/media/i2c/Kconfig                               |  11 +-
>>>   drivers/media/i2c/Makefile                              |   1 +-
>>>   drivers/media/i2c/adv748x/Makefile                      |   7 +-
>>>   drivers/media/i2c/adv748x/adv748x-afe.c                 | 571 ++++++-
>>>   drivers/media/i2c/adv748x/adv748x-core.c                | 907 +++++++++-
>>>   drivers/media/i2c/adv748x/adv748x-csi2.c                | 323 +++-
>>>   drivers/media/i2c/adv748x/adv748x-hdmi.c                | 652 ++++++-
>>>   drivers/media/i2c/adv748x/adv748x.h                     | 415 ++++-
>>>   10 files changed, 2989 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt
>>>   create mode 100644 drivers/media/i2c/adv748x/Makefile
>>>   create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
>>>   create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
>>>   create mode 100644 drivers/media/i2c/adv748x/adv748x-csi2.c
>>>   create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
>>>   create mode 100644 drivers/media/i2c/adv748x/adv748x.h
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>>> b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
>>> new file mode 100644
>>> index 000000000000..b17f8983c992

<snip>

>>> +static int adv748x_afe_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
>>> +{
>>> +    struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>>> +    struct adv748x_state *state = adv748x_afe_to_state(afe);
>>> +    int ret;
>>> +
>>> +    mutex_lock(&state->mutex);
>>> +
>>> +    ret = adv748x_afe_set_video_standard(state, std);
>>> +    if (ret ==  0)
>>> +        afe->curr_norm = std;
>>
>> OK, so this is a bit of a problem: you are using V4L2_STD_ALL as an autodetect
>> mechanism, but that is not allowed by the V4L2 specification. Yes, some old
>> drivers do this and we don't dare to change that, but new drivers should not
>> attempt this. The standard set and reported by s_std and g_std must always
>> be precise, i.e. no mix of NTSC and PAL.
>>
>> Only QUERYSTD is allowed to detect the format.
> 
> So how about using V4L2_STD_UNKNOWN as the hint to autodetect and initialising
> to NTSC as you suggest in probe.

No, don't do that. The current standard must always be a valid non-0 standard. Ditto for
dv_timings for that matter. If it doesn't match with the actual detected signal then
ENUM_INPUT will set the corresponding error flag in struct v4l2_input.

All applications assume that g_std and g_dv_timings return valid values and they rely
on QUERYSTD and QUERY_DV_TIMINGS to obtain the detected std/timings.

> g_std will then always return either the initial value, a detected value, or
> unknown if no lock is available.
> 
> Although then, I'd almost prefer to initialise to V4L2_STD_UNKNOWN ...
> 
>>
>> So
>>
>>> +
>>> +    mutex_unlock(&state->mutex);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int adv748x_afe_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
>>> +{
>>> +    struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>>> +    struct adv748x_state *state = adv748x_afe_to_state(afe);
>>> +    int ret;
>>> +
>>> +    mutex_lock(&state->mutex);
>>> +
>>> +    if (afe->streaming) {
>>> +        ret = -EBUSY;
>>> +        goto unlock;
>>> +    }
>>> +
>>> +    /* Set auto detect mode */
>>> +    ret = adv748x_afe_set_video_standard(state, V4L2_STD_ALL);
> 
> I.e. - I'll set V4L2_STD_UNKNOWN here ...

No, don't. It's not the way it works.

> 
>>> +    if (ret)
>>> +        goto unlock;
>>> +
>>> +    msleep(100);
>>> +
>>> +    /* Read detected standard */
>>> +    ret = adv748x_afe_status(afe, NULL, std);
>>> +unlock:
>>> +    mutex_unlock(&state->mutex);
>>> +
>>> +    return ret;
>>> +}

<snip>

>>> +int adv748x_afe_init(struct adv748x_afe *afe)
>>> +{
>>> +    struct adv748x_state *state = adv748x_afe_to_state(afe);
>>> +    int ret;
>>> +    unsigned int i;
>>> +
>>> +    afe->input = 0;
>>> +    afe->streaming = false;
>>> +    afe->curr_norm = V4L2_STD_ALL;
>>
>> No. This must be a valid standard. Typically V4L2_STD_NTSC_M.
> 
> Wouldn't V4L2_STD_UNKNOWN be more reasonable at this stage?

No, you have to initialize this with a valid standard, and traditionally
this is NTSC_M. This also implies that the initial format is 720x480
to correspond with this standard.

<snip>

>>> +    if (on)
>>> +        return adv748x_write_regs(state, adv748x_power_up_txa_4lane);
>>> +    else
>>
>> 'else' isn't needed.
> 
> That's a shame - I think the code is more elegant (/symmetrical) this way - but
> no worries.
> Adapted. (same for the others)

I hate this extra else because it implies that there is a way that the 'if' part
can bypass the return and continue after the else. It's obvious in this case that
that can't happen, but in more complex code this isn't clear at all.

<snip>

>>> +static const struct v4l2_dv_timings_cap adv748x_hdmi_timings_cap = {
>>> +    .type = V4L2_DV_BT_656_1120,
>>> +    /* keep this initialization for compatibility with GCC < 4.4.6 */
>>> +    .reserved = { 0 },
>>> +    /* Min pixelclock value is unknown */
>>> +    V4L2_INIT_BT_TIMINGS(ADV748X_HDMI_MIN_WIDTH, ADV748X_HDMI_MAX_WIDTH,
>>> +                 ADV748X_HDMI_MIN_HEIGHT, ADV748X_HDMI_MAX_HEIGHT,
>>> +                 ADV748X_HDMI_MIN_PIXELCLOCK,
>>> +                 ADV748X_HDMI_MAX_PIXELCLOCK,
>>> +                 V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
>>> +                 V4L2_DV_BT_CAP_INTERLACED |
>>
>> Has interlaced been tested?
> 
> No ...
>  /me ponders if the kit I have can be easily configured to test this.
> 
> Is it better to remove the cap until tested ?

Yes. Interlaced is tricky, so in general it should only be enabled if you have
actually tested it. The chances of doing this right without testing are pretty
slim in my experience.

<snip>

>>> +    v4l2_ctrl_new_std(&hdmi->ctrl_hdl, &adv748x_hdmi_ctrl_ops,
>>> +              V4L2_CID_HUE, ADV748X_CP_HUE_MIN,
>>> +              ADV748X_CP_HUE_MAX, 1, ADV748X_CP_HUE_DEF);
>>
>> You should implement the V4L2_CID_DV_RX_POWER_PRESENT control as well,
>> once interrupts are working.
>>
>> Perhaps add a comment as a reminder?
> 
> I have a separate patch where I've started looking at interrupts, but I've put a
> comment in here too.
> 
> Is this just to provide connection hotplug events to userspace?

Not a hotplug event, it's a receiver, so it sets the hotplug itself. This tests for
the 5V pin to become high when a source is connected. Sort of the inverse of the
hotplug pin.

And yes, userspace wants/needs to know this.

Regards,

	Hans
