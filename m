Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4847 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbZFNLhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 07:37:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv7 0/9] FM Transmitter (si4713) and another changes
Date: Sun, 14 Jun 2009 13:37:20 +0200
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141337.20665.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 June 2009 19:30:31 Eduardo Valentin wrote:
> Hello all,
> 
>   I'm resending the FM transmitter driver and the proposed changes in
> v4l2 api files in order to cover the fmtx extended controls class.
> 
>   Difference from version #6 is that now I've added added lots of comments
> made by Hans. Here is a list of changes:
> - Reduce card type string
> - Remove unused ext controls
> - Remove s/g_audio and add s/g_audout and enumaudout
> - remove g/s_input
> - remove s/g_tuner and add s/g_modulator on subdev and platform driver
> - reduce function names
> - Update documentation
> - remove a few unused and empty lines
> - remove sysfs interface
> - rename dev_to_v4l2 to si4713_to_v4l2 (and vice-versa) macros
> - Remove disabled controls
> - Add string support
> - remove v4l2_i2c_driver_data
> - Join si4713.c with si4713-subdev.c
> - move platform data to include/media
> - update documentation
> 
> And now this series is based on two of Hans' trees:
> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-subdev2.
> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-str.
> 
> The first tree has refactoring of v4l2 i2c helper functions. The second
> one has string support for extended controls, which is used in this driver.
> 
>   So, now the series includes changes to add the new v4l2
> FMTX extended controls (and its documetation) and si4713 i2c and platform
> drivers (and its documentation as well). Besides that, there is also
> a patch to add g_modulator to v4l2-subdev and a patch to add support
> for fm tx class in v4l2-ctl util.
> 
>   In the TODO list there are two things:
> i. the signal level measurement property is missing.
> ii. Re-factor the driver so all that get/set internal functions are removed.
> 
>   I believe those TODO's can be done later on, if there is still time to get
> this driver merged into this window. But of course, this is my opinion,
> I will understand also if you ask to do them before merge it.

I think the refactoring should be done first. I don't believe it is that much
work and experience shows that it is better to do this right away while you are
still motivated :-)

The string control support should not go into 2.6.31. I would like to do that
only in the v4l-dvb tree (so it will appear in 2.6.32) since I want to give that
a bit more time to mature. I implemented it very quickly and I do not feel
comfortable queueing this for 2.6.31.

In addition it is still unclear if Mauro will merge my v4l-dvb-subdev2 tree for
2.6.31. I hope so, since otherwise it will hamper the development of this and
other embedded platforms.

I also need to add a new V4L2_CAP_MODULATOR (which needs a review as well).

And finally I realized that we need to add some v4l2_modulator capabilities
for the RDS encoder similar to the upcoming v4l2_tuner RDS capabilities as
is described in this RFC:

http://www.mail-archive.com/linux-media%40vger.kernel.org/msg02498.html

I haven't had time to implement this RFC and I know that is not going to make
2.6.31. It's now almost at the top of my TODO list, so it should go in soon
(pending unforeseen circumstances).

As a result of rereading this RFC I also started to wonder about whether
the si4713 supports the MMBS functionality. Do you know anything about that?

Taken all together I think that 2.6.31 is probably not feasible. If it was
another two weeks until the merge window, then it would. But the merge window
is already open, and there are just too many little TODOs for this driver. And
it's also a new API, so we need to be more careful than usual.

Regards,

	Hans

> 
>   With these series, the driver is now functional through the v4l2 extended
> controls changes. Here is an output of v4l2-ctl:
>  # v4l2-ctl -d /dev/radio0 -l --all
> Driver Info:
>         Driver name   : radio-si4713
>         Card type     : Silicon Labs Si4713 Modulator
>         Bus info      : 
>         Driver version: 0
>         Capabilities  : 0x00080000
>                 Modulator
> Audio output: 0 (FM Modulator Audio Out)
> Frequency: 1552000 (97000.000000 MHz)
> Video Standard = 0x00000000
> Modulator:
>         Name                 : FM Modulator
>         Capabilities         : 62.5 Hz stereo 
>         Frequency range      : 76.0 MHz - 108.0 MHz
>         Available subchannels: mono stereo 
> 
> User Controls
> 
>                            mute (bool) : default=1 value=0
> 
> FM Radio Modulator Controls
> 
>             rds_feature_enabled (bool) : default=1 value=1
>                  rds_program_id (int)  : min=0 max=65535 step=1 default=0 value=0
>                rds_program_type (int)  : min=0 max=31 step=1 default=0 value=0
>                     rds_ps_name (str)  : value='Si4713  ' len=8
> ' len=9          rds_radio_text (str)  : value='Si4713  
>   audio_limiter_feature_enabled (bool) : default=1 value=1
>      audio_limiter_release_time (int)  : min=250 max=102390 step=50 default=5010 value=5010 flags=slider
>         audio_limiter_deviation (int)  : min=0 max=90000 step=10 default=66250 value=66250 flags=slider
> audio_compression_feature_enabl (bool) : default=1 value=1
>          audio_compression_gain (int)  : min=0 max=20 step=1 default=15 value=15 flags=slider
>     audio_compression_threshold (int)  : min=-40 max=0 step=1 default=-40 value=-40 flags=slider
>   audio_compression_attack_time (int)  : min=0 max=5000 step=500 default=0 value=2000 flags=slider
>  audio_compression_release_time (int)  : min=100000 max=1000000 step=100000 default=1000000 value=1000000 flags=slider
>      pilot_tone_feature_enabled (bool) : default=1 value=1
>            pilot_tone_deviation (int)  : min=0 max=90000 step=10 default=6750 value=6750 flags=slider
>            pilot_tone_frequency (int)  : min=0 max=19000 step=1 default=19000 value=19000 flags=slider
>           pre_emphasis_settings (menu) : min=0 max=2 default=1 value=1
>                tune_power_level (int)  : min=0 max=120 step=1 default=88 value=120 flags=slider
>          tune_antenna_capacitor (int)  : min=0 max=191 step=1 default=0 value=68 flags=slider
> 
> 
>   Again, comments are welcome.
> 
> BR,
> 
> Eduardo Valentin (9):
>   v4l2-subdev.h: Add g_modulator callbacks to subdev api
>   v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX controls
>   v4l2: video device: Add FM_TX controls default configurations
>   v4l2-ctl: Add support for FM TX controls
>   v4l2-spec: Add documentation description for FM TX extended control
>     class
>   FMTx: si4713: Add files to add radio interface for si4713
>   FMTx: si4713: Add files to handle si4713 i2c device
>   FMTx: si4713: Add Kconfig and Makefile entries
>   FMTx: si4713: Add document file
> 
>  linux/Documentation/video4linux/si4713.txt |  137 ++
>  linux/drivers/media/radio/Kconfig          |   22 +
>  linux/drivers/media/radio/Makefile         |    2 +
>  linux/drivers/media/radio/radio-si4713.c   |  325 ++++
>  linux/drivers/media/radio/si4713-i2c.c     | 2813 ++++++++++++++++++++++++++++
>  linux/drivers/media/radio/si4713-i2c.h     |  226 +++
>  linux/drivers/media/video/v4l2-common.c    |   50 +
>  linux/include/linux/videodev2.h            |   34 +
>  linux/include/media/si4713.h               |   40 +
>  linux/include/media/v4l2-subdev.h          |    2 +
>  v4l2-apps/util/v4l2-ctl.cpp                |   36 +
>  v4l2-spec/Makefile                         |    1 +
>  v4l2-spec/biblio.sgml                      |   10 +
>  v4l2-spec/controls.sgml                    |  205 ++
>  14 files changed, 3903 insertions(+), 0 deletions(-)
>  create mode 100644 linux/Documentation/video4linux/si4713.txt
>  create mode 100644 linux/drivers/media/radio/radio-si4713.c
>  create mode 100644 linux/drivers/media/radio/si4713-i2c.c
>  create mode 100644 linux/drivers/media/radio/si4713-i2c.h
>  create mode 100644 linux/include/media/si4713.h
> 
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
