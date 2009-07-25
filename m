Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57249 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZGYOee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 10:34:34 -0400
Date: Sat, 25 Jul 2009 17:23:51 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] v4l2-ctl: Add G_MODULATOR before set/get frequency
Message-ID: <20090725142350.GH10561@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1248453732-1966-1-git-send-email-eduardo.valentin@nokia.com>
 <200907251610.53698.hverkuil@xs4all.nl>
 <20090725140801.GG10561@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090725140801.GG10561@esdhcp037198.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 25, 2009 at 04:08:01PM +0200, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> On Sat, Jul 25, 2009 at 04:10:53PM +0200, ext Hans Verkuil wrote:
> > On Friday 24 July 2009 18:42:12 Eduardo Valentin wrote:
> > > As there can be modulator devices with get/set frequency
> > > callbacks, this patch adds support to them in v4l2-ctl utility.
> > 
> > Thanks for this patch.
> > 
> > I've implemented it somewhat differently (using the new V4L2_CAP_MODULATOR
> > to decide whether to call G_TUNER or G_MODULATOR) and pushed it to my
> > v4l-dvb-strctrl tree. I've also improved the string print function so things
> > like newlines and carriage returns are printed as \r and \n.
> > 
> > Can you mail me the output of 'v4l2-ctl --all -L' based on this updated
> > version of v4l2-ctl? I'd like to check whether everything is now reported
> > correctly.
> 
> Yes sure. But there is also the RDS output for txsubchannel. This is missing
> now for G_MODULATOR. RDS is also missing in S_MODULATOR. S_MODULATOR is also
> confusing to me. The strings can be set only with one value? I though I could
> do something like:
> 
> v4l2-ctl -d /dev/radio0 --set-modulator=rds,stereo

Here is an output with you new version:
/ # v4l2-ctl -d /dev/radio0 --all -L
Driver Info:
        Driver name   : radio-si4713
        Card type     : Silicon Labs Si4713 Modulator
        Bus info      : 
        Driver version: 0
        Capabilities  : 0x00080800
                RDS Output
                Modulator
Audio output: 0 (FM Modulator Audio Out)
Frequency: 1408000 (88.000000 MHz)
Video Standard = 0x00000000
Modulator:
        Name                 : FM Modulator
        Capabilities         : 62.5 Hz stereo rds 
        Frequency range      : 76.0 MHz - 108.0 MHz
        Subchannel modulation: stereo+rds

User Controls

                           mute (bool) : default=1 value=0

FM Radio Modulator Controls

                 rds_program_id (int)  : min=0 max=65535 step=1 default=0 value=0
               rds_program_type (int)  : min=0 max=31 step=1 default=0 value=0
           rds_signal_deviation (int)  : min=0 max=90000 step=10 default=200 value=200 flags=slider
                    rds_ps_name (str)  : min=0 max=97 value='Si4713  ' len=97
                 rds_radio_text (str)  : min=0 max=385 value='Si4713  \r' len=385
  audio_limiter_feature_enabled (bool) : default=1 value=1
     audio_limiter_release_time (int)  : min=250 max=102390 step=50 default=5010 value=5010 flags=slider
        audio_limiter_deviation (int)  : min=0 max=90000 step=10 default=66250 value=66250 flags=slider
audio_compression_feature_enabl (bool) : default=1 value=1
         audio_compression_gain (int)  : min=0 max=20 step=1 default=15 value=15 flags=slider
    audio_compression_threshold (int)  : min=-40 max=0 step=1 default=-40 value=-40 flags=slider
  audio_compression_attack_time (int)  : min=0 max=5000 step=500 default=0 value=0 flags=slider
 audio_compression_release_time (int)  : min=100000 max=1000000 step=100000 default=1000000 value=1000000 flags=slider
     pilot_tone_feature_enabled (bool) : default=1 value=1
           pilot_tone_deviation (int)  : min=0 max=90000 step=10 default=6750 value=6750 flags=slider
           pilot_tone_frequency (int)  : min=0 max=19000 step=1 default=19000 value=19000 flags=slider
          pre_emphasis_settings (menu) : min=0 max=2 default=1 value=1
               tune_power_level (int)  : min=0 max=120 step=1 default=88 value=88 flags=slider
         tune_antenna_capacitor (int)  : min=0 max=191 step=1 default=0 value=109 flags=slider

So far so good for G_MODULATOR and for String with escaped characters. 
I also tried S_MODULATOR. Looks good but there is a bug:
			else if (!strcmp(optarg, "stereo-rds"))
				txsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_RDS;
			else if (!strcmp(optarg, "mono-rds"))
				txsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_RDS;

As you can see, you cannot properly set stereo-rds, it will keep it mono. Otherwise it is fine to me.

BR,

> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > > 
> > > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > > ---
> > >  v4l2-apps/util/v4l2-ctl.cpp |   10 +++++++++-
> > >  1 files changed, 9 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/v4l2-apps/util/v4l2-ctl.cpp b/v4l2-apps/util/v4l2-ctl.cpp
> > > index fc9e459..ff74177 100644
> > > --- a/v4l2-apps/util/v4l2-ctl.cpp
> > > +++ b/v4l2-apps/util/v4l2-ctl.cpp
> > > @@ -1962,12 +1962,16 @@ int main(int argc, char **argv)
> > >  
> > >  	if (options[OptSetFreq]) {
> > >  		double fac = 16;
> > > +		struct v4l2_modulator mt;
> > >  
> > > +		memset(&mt, 0, sizeof(struct v4l2_modulator));
> > >  		if (doioctl(fd, VIDIOC_G_TUNER, &tuner, "VIDIOC_G_TUNER") == 0) {
> > >  			fac = (tuner.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> > > +			vf.type = tuner.type;
> > > +		} else if (doioctl(fd, VIDIOC_G_MODULATOR, &mt, "VIDIOC_G_MODULATOR") == 0) {
> > > +			fac = (mt.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> > >  		}
> > >  		vf.tuner = 0;
> > > -		vf.type = tuner.type;
> > >  		vf.frequency = __u32(freq * fac);
> > >  		if (doioctl(fd, VIDIOC_S_FREQUENCY, &vf,
> > >  			"VIDIOC_S_FREQUENCY") == 0)
> > > @@ -2418,9 +2422,13 @@ set_vid_fmt_error:
> > >  
> > >  	if (options[OptGetFreq]) {
> > >  		double fac = 16;
> > > +		struct v4l2_modulator mt;
> > >  
> > > +		memset(&mt, 0, sizeof(struct v4l2_modulator));
> > >  		if (doioctl(fd, VIDIOC_G_TUNER, &tuner, "VIDIOC_G_TUNER") == 0) {
> > >  			fac = (tuner.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> > > +		} else if (doioctl(fd, VIDIOC_G_MODULATOR, &mt, "VIDIOC_G_MODULATOR") == 0) {
> > > +			fac = (mt.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> > >  		}
> > >  		vf.tuner = 0;
> > >  		if (doioctl(fd, VIDIOC_G_FREQUENCY, &vf, "VIDIOC_G_FREQUENCY") == 0)
> > 
> > 
> > 
> > -- 
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> 
> -- 
> Eduardo Valentin

-- 
Eduardo Valentin
