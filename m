Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:29013 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZGYOSn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 10:18:43 -0400
Date: Sat, 25 Jul 2009 17:08:01 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] v4l2-ctl: Add G_MODULATOR before set/get frequency
Message-ID: <20090725140801.GG10561@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1248453732-1966-1-git-send-email-eduardo.valentin@nokia.com>
 <200907251610.53698.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907251610.53698.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 25, 2009 at 04:10:53PM +0200, ext Hans Verkuil wrote:
> On Friday 24 July 2009 18:42:12 Eduardo Valentin wrote:
> > As there can be modulator devices with get/set frequency
> > callbacks, this patch adds support to them in v4l2-ctl utility.
> 
> Thanks for this patch.
> 
> I've implemented it somewhat differently (using the new V4L2_CAP_MODULATOR
> to decide whether to call G_TUNER or G_MODULATOR) and pushed it to my
> v4l-dvb-strctrl tree. I've also improved the string print function so things
> like newlines and carriage returns are printed as \r and \n.
> 
> Can you mail me the output of 'v4l2-ctl --all -L' based on this updated
> version of v4l2-ctl? I'd like to check whether everything is now reported
> correctly.

Yes sure. But there is also the RDS output for txsubchannel. This is missing
now for G_MODULATOR. RDS is also missing in S_MODULATOR. S_MODULATOR is also
confusing to me. The strings can be set only with one value? I though I could
do something like:

v4l2-ctl -d /dev/radio0 --set-modulator=rds,stereo

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > ---
> >  v4l2-apps/util/v4l2-ctl.cpp |   10 +++++++++-
> >  1 files changed, 9 insertions(+), 1 deletions(-)
> > 
> > diff --git a/v4l2-apps/util/v4l2-ctl.cpp b/v4l2-apps/util/v4l2-ctl.cpp
> > index fc9e459..ff74177 100644
> > --- a/v4l2-apps/util/v4l2-ctl.cpp
> > +++ b/v4l2-apps/util/v4l2-ctl.cpp
> > @@ -1962,12 +1962,16 @@ int main(int argc, char **argv)
> >  
> >  	if (options[OptSetFreq]) {
> >  		double fac = 16;
> > +		struct v4l2_modulator mt;
> >  
> > +		memset(&mt, 0, sizeof(struct v4l2_modulator));
> >  		if (doioctl(fd, VIDIOC_G_TUNER, &tuner, "VIDIOC_G_TUNER") == 0) {
> >  			fac = (tuner.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> > +			vf.type = tuner.type;
> > +		} else if (doioctl(fd, VIDIOC_G_MODULATOR, &mt, "VIDIOC_G_MODULATOR") == 0) {
> > +			fac = (mt.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> >  		}
> >  		vf.tuner = 0;
> > -		vf.type = tuner.type;
> >  		vf.frequency = __u32(freq * fac);
> >  		if (doioctl(fd, VIDIOC_S_FREQUENCY, &vf,
> >  			"VIDIOC_S_FREQUENCY") == 0)
> > @@ -2418,9 +2422,13 @@ set_vid_fmt_error:
> >  
> >  	if (options[OptGetFreq]) {
> >  		double fac = 16;
> > +		struct v4l2_modulator mt;
> >  
> > +		memset(&mt, 0, sizeof(struct v4l2_modulator));
> >  		if (doioctl(fd, VIDIOC_G_TUNER, &tuner, "VIDIOC_G_TUNER") == 0) {
> >  			fac = (tuner.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> > +		} else if (doioctl(fd, VIDIOC_G_MODULATOR, &mt, "VIDIOC_G_MODULATOR") == 0) {
> > +			fac = (mt.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
> >  		}
> >  		vf.tuner = 0;
> >  		if (doioctl(fd, VIDIOC_G_FREQUENCY, &vf, "VIDIOC_G_FREQUENCY") == 0)
> 
> 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
