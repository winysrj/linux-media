Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44091 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2JIPpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 11:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <201210091138.39054.hverkuil@xs4all.nl>
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net>
 <201210081130.28233.hverkuil@xs4all.nl> <507313FD.6050507@convergeddevices.net>
 <201210091138.39054.hverkuil@xs4all.nl>
From: halli manjunatha <hallimanju@gmail.com>
Date: Tue, 9 Oct 2012 10:45:32 -0500
Message-ID: <CAMT6PyfyfP3ppONHhbp_UxNHrJtEY6akR+_CEmP9CirR=ihr3A@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] Add a V4L2 driver for SI476X MFD
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andrey Smirnov <andrey.smirnov@convergeddevices.net>,
	mchehab@redhat.com, sameo@linux.intel.com,
	broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 9, 2012 at 4:38 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Note: I'm CC-ing Halli. Halli, can you take a look at the proposed controls?
>
> On Mon 8 October 2012 19:57:17 Andrey Smirnov wrote:
>> On 10/08/2012 02:30 AM, Hans Verkuil wrote:
>> > On Sat October 6 2012 03:55:01 Andrey Smirnov wrote:
>> >> This commit adds a driver that exposes all the radio related
>> >> functionality of the Si476x series of chips via the V4L2 subsystem.
>> >>
>> >> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
>> >> ---
>> >>  drivers/media/radio/Kconfig        |   17 +
>> >>  drivers/media/radio/Makefile       |    1 +
>> >>  drivers/media/radio/radio-si476x.c | 1153 ++++++++++++++++++++++++++++++++++++
>> >>  3 files changed, 1171 insertions(+)
>> >>  create mode 100644 drivers/media/radio/radio-si476x.c
>> >>
>> >> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
>> >> index 8090b87..3c79d09 100644
>> >> --- a/drivers/media/radio/Kconfig
>> >> +++ b/drivers/media/radio/Kconfig
>
> <snip>
>
>> >> +static const struct v4l2_ctrl_config si476x_ctrls[] = {
>> >> +  /*
>> >> +     Tuning parameters
>> >> +     'max tune errors' is shared for both AM/FM mode of operation
>> >> +  */
>> >> +  {
>> >> +          .ops    = &si476x_ctrl_ops,
>> >> +          .id     = SI476X_CID_RSSI_THRESHOLD,
>> >> +          .name   = "valid rssi threshold",
>> >> +          .type   = V4L2_CTRL_TYPE_INTEGER,
>> >> +          .min    = -128,
>> >> +          .max    = 127,
>> >> +          .step   = 1,
>> >> +  },
>> >> +  {
>> >> +          .ops    = &si476x_ctrl_ops,
>> >> +          .id     = SI476X_CID_SNR_THRESHOLD,
>> >> +          .type   = V4L2_CTRL_TYPE_INTEGER,
>> >> +          .name   = "valid snr threshold",
>> >> +          .min    = -128,
>> >> +          .max    = 127,
>> >> +          .step   = 1,
>> >> +  },
>> >> +  {
>> >> +          .ops    = &si476x_ctrl_ops,
>> >> +          .id     = SI476X_CID_MAX_TUNE_ERROR,
>> >> +          .type   = V4L2_CTRL_TYPE_INTEGER,
>> >> +          .name   = "max tune errors",
>> >> +          .min    = 0,
>> >> +          .max    = 126 * 2,
>> >> +          .step   = 2,
>> >> +  },
>> >> +  /*
>> >> +     Region specific parameters
>> >> +  */
>> >> +  {
>> >> +          .ops    = &si476x_ctrl_ops,
>> >> +          .id     = SI476X_CID_HARMONICS_COUNT,
>> >> +          .type   = V4L2_CTRL_TYPE_INTEGER,
>> >> +          .name   = "count of harmonics to reject",
>> >> +          .min    = 0,
>> >> +          .max    = 20,
>> >> +          .step   = 1,
>> >> +  },
>> >> +  {
>> >> +          .ops    = &si476x_ctrl_ops,
>> >> +          .id     = SI476X_CID_DEEMPHASIS,
>> >> +          .type   = V4L2_CTRL_TYPE_MENU,
>> >> +          .name   = "de-emphassis",
>> >> +          .qmenu  = deemphasis,
>> >> +          .min    = 0,
>> >> +          .max    = ARRAY_SIZE(deemphasis) - 1,
>> >> +          .def    = 0,
>> >> +  },
>> > I think most if not all of the controls above are candidates for turning into
>> > standardized controls. I recommend that you make a proposal (RFC) for this.
>> >
>> > This may be useful as well:
>> >
>> > http://lists-archives.com/linux-kernel/27641304-radio-fixes-and-new-features-for-fm.html
>> >
>> > This patch series contains a standardized DEEMPHASIS control.
>> > Note that this patch series is outdated, but patch 2/5 is OK.
>>
>> So do you want me to take that patch and make it the part of this patch
>> set or do you want me to create a separate RFC with a patch set that
>> contains all those controls?
>
> No, that was just FYI. I've asked Halli Manjunatha, the author of that patch
> series to make a new version that can be upstreamed. The reason it was stalled
> was due to a long discussion at the time how to implement multiple frequency
> bands, but now that that has been resolved this patch series can move forward
> as well.
>
>>
>> Just to give some description:
>>
>> SI476X_CID_RSSI_THRESHOLD, SI476X_CID_SNR_THRESHOLD,
>> SI476X_CID_MAX_TUNE_ERROR are used to determine at which level of SNR,
>> RSSI the station station should be considered valid and what margin of
>> error is to be used(SI476X_CID_MAX_TUNE_ERROR) for those parameters.
>
> I know that other devices (wl128x) also have similar SNR, RSSI functionality.
> Halli, can you check if it would make sense to have generic controls for this?

Yes, since depending on RSSI_THRESHOLD value driver has to decide
whether its a good channel or not or whether to consider the RDS data
coming from that channel valid

So I do recommend that we need to have these as generic controls
>
>> SI476X_CID_HARMONICS_COUNT is the amount of AC grid noise harmonics
>> build-in hardware(or maybe FW) will try to filter out in AM mode.
>
> I don't really know whether this is chip specific or not. Halli, do you
> have any input on this?

Seems like chip specific to me, for instant TI's FM chip-sets doesn't
have a control for ignoring HARMONICS but as Smirnov says his chip set
has these controls so in that case its better to include these in RFC
so that people can have a look in to it.
>
>> It seems to me that the controls described above are quite chip specific
>> should I also include them in the RFC?
>
> Let's wait what Halli says, but yes, it should be included in the RFC: we
> want to know if this should be standardized or not, so it's good to
> mention it so people are aware of this.
>
>> >> +  {
>> >> +          .ops    = &si476x_ctrl_ops,
>> >> +          .id     = SI476X_CID_RDS_RECEPTION,
>> >> +          .type   = V4L2_CTRL_TYPE_BOOLEAN,
>> >> +          .name   = "rds",
>> >> +          .min    = 0,
>> >> +          .max    = 1,
>> >> +          .step   = 1,
>> >> +  },
>> > If this control returns whether or not RDS is detected, then this control
>> > should be removed. VIDIOC_G_TUNER will return that information in rxsubchans.
>>
>> This control allows to turn on/off RDS processing on the radio chip
>> itself. In IRQ mode in decreases the amount of
>> IRQs generated by the chip. And in polling(no-IRQ) mode it decreases I2C
>> traffic significantly(We've had a run of the boards that had
>> 4-tuners on a single I2C bus, working in polling mode).
>
> Ah, so this turns RDS reception on or off. You are right, there is no method
> turning this on or off for receivers, only for transmitters.
>
> This should definitely be standardized. Ideally it should be possible to set
> this through VIDIOC_S_TUNER, but there isn't any field that can be used for
> that. It's possible to add a field, but should we do that just for this?
> I'm leaning towards a control.
>
> An alternative is to only turn on RDS processing if read() or poll() is called.
> But you might not be able to detect the presence of the RDS channel if RDS
> processing is turned off as well, or can you?
>
> Regards,
>
>         Hans



-- 
Regards
Halli
