Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43270 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab3BPNeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 08:34:25 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so2251789eek.1
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2013 05:34:23 -0800 (PST)
Message-ID: <511F8B11.7070600@googlemail.com>
Date: Sat, 16 Feb 2013 14:35:13 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.9] bttv: v4l2-compliance fixes
References: <201302151115.24037.hverkuil@xs4all.nl> <511EA3F7.6010508@googlemail.com> <201302152238.59841.hverkuil@xs4all.nl>
In-Reply-To: <201302152238.59841.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.02.2013 22:38, schrieb Hans Verkuil:
> On Fri February 15 2013 22:09:11 Frank Schäfer wrote:
>> Am 15.02.2013 11:15, schrieb Hans Verkuil:
>>> This pull request is identical to the REVIEWv2 patch series I posted earlier:
>>>
>>> http://www.spinics.net/lists/linux-media/msg59944.html
>>>
>>> The only change (besides rebasing) is that patch 04/19 was moved to the end
>>> of the patch series. More about that patch below.
>>>
>>> This patch series updates bttv and tda7432 (a prerequisite of bttv) to the
>>> latest v4l2 frameworks, except for vb2 (as usual). Conversion to vb2 is
>>> something for the future.
>>>
>>> This patch series has been tested with the following bttv cards:
>>>
>>> Simple gpio-audio-based bttv card types:
>>>
>>> 39, 77, 41, 33
>>>
>>> msp34xx based card types:
>>>
>>> 10 (with msp3410d)
>>> 1 (with msp3410c)
>>>
>>> tvaudio based card types:
>>>
>>> 40 (with tda7432, tea6420 and tda9850)
>>>
>>> The last one is now finally working. I doubt audio has worked at all in the
>>> last few years for that card. I'm pretty pleased about this to be honest :-)
>>>
>>> It turns out that the frequency handling in the current driver is partially
>>> broken (see this thread:
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg58548.html). This
>>> is now fixed as a consequence of these compliancy patches. It's something
>>> v4l2-compliance found immediately, so this once again shows the importance of
>>> using v4l2-compliance to test fixes.
>>>
>>> While most patches are pretty standard for such conversions the last patch
>>> needs some more background:
>>>
>>> The current driver does not implement enumaudio (so apps cannot tell that
>>> audio inputs are present), it does not set V4L2_CAP_AUDIO, nor does it set
>>> audioset when calling ENUM_INPUT. And G_AUDIO doesn't set the stereo flag
>>> either. So these g/s_audio ioctls are quite pointless and misleading.
>>> Especially since some surveillance boards do not have audio at all.
>>>
>>> So I decided to remove them. But after a question about this from Frank
>>> Schäfer I investigated what would be needed to correctly implement
>>> s/g/enumaudio. So I made a second bttv branch which is identical to this
>>> one, except that the last patch is replaced by two new patches adding
>>> proper s/g/enumaudio support:
>>>
>>> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/bttv-audio
>>>
>>> However, this patch relies on the audio_inputs field (currently commented out)
>>> of the card definition, and I have serious doubts about the reliability of
>>> that field. A wrong number is not a problem in itself as audio will remain
>>> working, it is just that ENUMAUDIO will give wrong results.
>>>
>>> So there are three options:
>>>
>>> 1) keep the current situation: i.e. apply just the first 18 patches and skip
>>>    the last. I'm not in favor of this myself.
>>>
>>> 2) remove the g/s_audio ioctls. At least this makes the driver consistent
>>>    with the V4L2 API. And adding the enumaudio support can always be done
>>>    later.
>>>
>>> 3) use the bttv-audio branch and implement proper enumaudio support and just
>>>    accept that enumaudio can return incorrect results if the card definition
>>>    is wrong.
>>>
>>> I am undecided which of options 2 or 3 is better. I'm leaning slightly towards
>>> option 2, but there is much to be said for 3 as well. So I am leaving it to
>>> you, Mauro, since you are the bttv maintainer anyway :-)
>>>
>>> Regards,
>>>
>>>         Hans
>> Hi Hans,
>>
>> I have tested the bttv-audio patches a few minutes ago with the
>> Hauppauge WinTV Theatre (card 10) and g/s_audio works as expected.
>> Audio line-in works fine, but I noticed that it also works fine with
>> kernel 3.7.8 ?!
> Why wouldn't it?

Sorry, my fault... too many devices ;).
I tested a saa7134 device (AverMedia 303P) a few weeks ago and the audio
line-in didn't work for THIS device....

>
>> I also noticed that audio balance (msp34xx control) doesn't work for the
>> the left side and the sound is always mono (also for radio),
>> but I assume the problem is my self-made
>> mini-DIN-to-lini-in-Adapter-cable (this card has surround sound)...
> I've tested it with my WinTv Theatre and the balance works fine with a proper
> cable :-)

Ok... :-)
I used the following description to built my adapter cable:
http://www.vdr-wiki.de/wiki/index.php/Kabelpeitsche

But it seems the WinTV Theatre uses a slightly different pin assignment
and I'm using both right channels...
Hmm... if you find a free minute, could you check which pins of the
mini-DIN-connector of your cable are used for left and right audio (I
don't care about the others) ?

>
>> Some things that need to be fixed for this card (mute on stop/close,
>> colokiller control, BE video formats, ...),
> Can you elaborate on the mute and BE video formats? Colorkiller doesn't work,
> I've noticed the same thing.

As far as I understand, audio should be muted when capturing is stopped
/ the device is closed.
(I assume shutting down the tuner would be even better, but no idea if
it is possible).
Otherwise users can still hear the last radio or TV channel.
Btw: it's not clear to me how "auto mute" is supposed to work. All I
noticed is, that it mutes audio when switching between the (video)
inputs (without activating the "mute" checkbox ?!).

What I forgot to mention is, that the audio controls (bass, trebble,
volume, balance) seem to have no effect on "Line-In".


Concerning the BE formats: I tested with qv4l2 in raw mode only, but
with the formats

RGBQ - 15 bpp RGB, be
RGBR - 16 bpp RGB, be
RGB4 - 32 bpp RGB, be

the picture looks like this:
http://imageshack.us/photo/my-images/24/rgbq.png/
http://imageshack.us/photo/my-images/805/rgbr.png/
http://imageshack.us/photo/my-images/6/rgb4n.png/


Anyway - these are no regressions, so there is no reason to delay your
patches.

Regards,
Frank

>> but these are separate
>> issues not related to this patch series.
>> So feel free to add "Tested-by" (if anybody cares).
> Thanks!
>
> 	Hans
>
>> Regards,
>> Frank
>>
>>
>>
>>
>>> The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:
>>>
>>>   [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) (2013-02-13 18:05:29 -0200)
>>>
>>> are available in the git repository at:
>>>
>>>   git://linuxtv.org/hverkuil/media_tree.git bttv
>>>
>>> for you to fetch changes up to b26d6e39030e6ca2812bc8a818645169e6783ec9:
>>>
>>>   bttv: remove g/s_audio since there is only one audio input. (2013-02-15 10:56:48 +0100)
>>>
>>> ----------------------------------------------------------------
>>> Hans Verkuil (19):
>>>       bttv: fix querycap and radio v4l2-compliance issues.
>>>       bttv: add VIDIOC_DBG_G_CHIP_IDENT
>>>       bttv: fix ENUM_INPUT and S_INPUT
>>>       bttv: disable g/s_tuner and g/s_freq when no tuner present, fix return codes.
>>>       bttv: set initial tv/radio frequencies
>>>       bttv: G_PARM: set readbuffers.
>>>       bttv: fill in colorspace.
>>>       bttv: fill in fb->flags for VIDIOC_G_FBUF
>>>       bttv: fix field handling inside TRY_FMT.
>>>       tda7432: convert to the control framework
>>>       bttv: convert to the control framework.
>>>       bttv: add support for control events.
>>>       bttv: fix priority handling.
>>>       bttv: use centralized std and implement g_std.
>>>       bttv: there may be multiple tvaudio/tda7432 devices.
>>>       bttv: fix g_tuner capabilities override.
>>>       bttv: fix try_fmt_vid_overlay and setup initial overlay size.
>>>       bttv: do not switch to the radio tuner unless it is accessed.
>>>       bttv: remove g/s_audio since there is only one audio input.
>>>
>>>  drivers/media/i2c/tda7432.c           |  276 +++++++---------
>>>  drivers/media/i2c/tvaudio.c           |    2 +-
>>>  drivers/media/pci/bt8xx/bttv-cards.c  |   19 +-
>>>  drivers/media/pci/bt8xx/bttv-driver.c | 1144 ++++++++++++++++++++++++++++---------------------------------------
>>>  drivers/media/pci/bt8xx/bttv.h        |    3 +
>>>  drivers/media/pci/bt8xx/bttvp.h       |   31 +-
>>>  include/media/v4l2-chip-ident.h       |    8 +
>>>  include/uapi/linux/v4l2-controls.h    |    5 +
>>>  8 files changed, 632 insertions(+), 856 deletions(-)

