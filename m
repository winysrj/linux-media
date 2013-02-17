Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:38753 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab3BQMbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 07:31:08 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so2335491eek.20
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2013 04:31:06 -0800 (PST)
Message-ID: <5120CDBB.4020908@googlemail.com>
Date: Sun, 17 Feb 2013 13:31:55 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.9] bttv: v4l2-compliance fixes
References: <201302151115.24037.hverkuil@xs4all.nl> <201302152238.59841.hverkuil@xs4all.nl> <511F8B11.7070600@googlemail.com> <201302161445.07943.hverkuil@xs4all.nl>
In-Reply-To: <201302161445.07943.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<snip>

Am 16.02.2013 14:45, schrieb Hans Verkuil:
> On Sat February 16 2013 14:35:13 Frank Schäfer wrote:
>> Am 15.02.2013 22:38, schrieb Hans Verkuil:
>>> On Fri February 15 2013 22:09:11 Frank Schäfer wrote:
>>>> I also noticed that audio balance (msp34xx control) doesn't work for the
>>>> the left side and the sound is always mono (also for radio),
>>>> but I assume the problem is my self-made
>>>> mini-DIN-to-lini-in-Adapter-cable (this card has surround sound)...
>>> I've tested it with my WinTv Theatre and the balance works fine with a proper
>>> cable :-)
>> Ok... :-)
>> I used the following description to built my adapter cable:
>> http://www.vdr-wiki.de/wiki/index.php/Kabelpeitsche
>>
>> But it seems the WinTV Theatre uses a slightly different pin assignment
>> and I'm using both right channels...
>> Hmm... if you find a free minute, could you check which pins of the
>> mini-DIN-connector of your cable are used for left and right audio (I
>> don't care about the others) ?
> I don't have access to the cable at the moment (travelling), but ping me
> again in 10 days or so to remind me.

No problem.
Now, all I need is someone who reminds _me_... ;-)

>>>> Some things that need to be fixed for this card (mute on stop/close,
>>>> colokiller control, BE video formats, ...),
>>> Can you elaborate on the mute and BE video formats? Colorkiller doesn't work,
>>> I've noticed the same thing.
>> As far as I understand, audio should be muted when capturing is stopped
>> / the device is closed.
> True, unless it is the radio node.

Hmm...ok... why are radio devices handled diffrently ?

>
>> (I assume shutting down the tuner would be even better, but no idea if
>> it is possible).
>> Otherwise users can still hear the last radio or TV channel.
>> Btw: it's not clear to me how "auto mute" is supposed to work. All I
>> noticed is, that it mutes audio when switching between the (video)
>> inputs (without activating the "mute" checkbox ?!).
> I think the idea is that it mutes when there is no signal detected
> to prevent white noise.

Sounds plausible and matches the behavior I observed.

>> What I forgot to mention is, that the audio controls (bass, trebble,
>> volume, balance) seem to have no effect on "Line-In".
> That wouldn't surprise me at all. See the comment regarding msp3400
> routing in audio_mux().
>
>> Concerning the BE formats: I tested with qv4l2 in raw mode only, but
>> with the formats
>>
>> RGBQ - 15 bpp RGB, be
>> RGBR - 16 bpp RGB, be
>> RGB4 - 32 bpp RGB, be
>>
>> the picture looks like this:
>> http://imageshack.us/photo/my-images/24/rgbq.png/
>> http://imageshack.us/photo/my-images/805/rgbr.png/
>> http://imageshack.us/photo/my-images/6/rgb4n.png/
> I think those are actually bugs in libv4lconvert.

That was my second theory. :D

> I have patches for that that I still need to clean up and post.

Great !

> There is basically no big-endian
> support in libv4lconvert at the moment.

But why does it try to convert formats it doesn't support ?


Regards,
Frank

> Regards,
>
> 	Hans
>
>> Anyway - these are no regressions, so there is no reason to delay your
>> patches.
>>
>> Regards,
>> Frank
>>
>>>> but these are separate
>>>> issues not related to this patch series.
>>>> So feel free to add "Tested-by" (if anybody cares).
>>> Thanks!
>>>
>>> 	Hans
>>>
>>>> Regards,
>>>> Frank
>>>>
>>>>
>>>>
>>>>
>>>>> The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:
>>>>>
>>>>>   [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) (2013-02-13 18:05:29 -0200)
>>>>>
>>>>> are available in the git repository at:
>>>>>
>>>>>   git://linuxtv.org/hverkuil/media_tree.git bttv
>>>>>
>>>>> for you to fetch changes up to b26d6e39030e6ca2812bc8a818645169e6783ec9:
>>>>>
>>>>>   bttv: remove g/s_audio since there is only one audio input. (2013-02-15 10:56:48 +0100)
>>>>>
>>>>> ----------------------------------------------------------------
>>>>> Hans Verkuil (19):
>>>>>       bttv: fix querycap and radio v4l2-compliance issues.
>>>>>       bttv: add VIDIOC_DBG_G_CHIP_IDENT
>>>>>       bttv: fix ENUM_INPUT and S_INPUT
>>>>>       bttv: disable g/s_tuner and g/s_freq when no tuner present, fix return codes.
>>>>>       bttv: set initial tv/radio frequencies
>>>>>       bttv: G_PARM: set readbuffers.
>>>>>       bttv: fill in colorspace.
>>>>>       bttv: fill in fb->flags for VIDIOC_G_FBUF
>>>>>       bttv: fix field handling inside TRY_FMT.
>>>>>       tda7432: convert to the control framework
>>>>>       bttv: convert to the control framework.
>>>>>       bttv: add support for control events.
>>>>>       bttv: fix priority handling.
>>>>>       bttv: use centralized std and implement g_std.
>>>>>       bttv: there may be multiple tvaudio/tda7432 devices.
>>>>>       bttv: fix g_tuner capabilities override.
>>>>>       bttv: fix try_fmt_vid_overlay and setup initial overlay size.
>>>>>       bttv: do not switch to the radio tuner unless it is accessed.
>>>>>       bttv: remove g/s_audio since there is only one audio input.
>>>>>
>>>>>  drivers/media/i2c/tda7432.c           |  276 +++++++---------
>>>>>  drivers/media/i2c/tvaudio.c           |    2 +-
>>>>>  drivers/media/pci/bt8xx/bttv-cards.c  |   19 +-
>>>>>  drivers/media/pci/bt8xx/bttv-driver.c | 1144 ++++++++++++++++++++++++++++---------------------------------------
>>>>>  drivers/media/pci/bt8xx/bttv.h        |    3 +
>>>>>  drivers/media/pci/bt8xx/bttvp.h       |   31 +-
>>>>>  include/media/v4l2-chip-ident.h       |    8 +
>>>>>  include/uapi/linux/v4l2-controls.h    |    5 +
>>>>>  8 files changed, 632 insertions(+), 856 deletions(-)

