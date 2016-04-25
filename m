Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53710 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbcDYQKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 12:10:19 -0400
Date: Mon, 25 Apr 2016 13:10:13 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] tvp686x: Don't go past array
Message-ID: <20160425131013.141d5b4f@recife.lan>
In-Reply-To: <20160425152640.GA24174@laptop.cereza>
References: <d25dd8ca8edffc6cc8cee2dac9b907c333a0aa84.1461403421.git.mchehab@osg.samsung.com>
	<571E0159.9050406@xs4all.nl>
	<20160425094000.1dc6db29@recife.lan>
	<20160425152640.GA24174@laptop.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Apr 2016 12:26:40 -0300
Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> escreveu:

> Hi Mauro, Hans:
> 
> Thanks for the fixes to this driver :-)
> 
> On 25 Apr 09:40 AM, Mauro Carvalho Chehab wrote:
> > Ezequiel,
> > 
> > Btw, I'm not seeing support for fps != 25 (or 30 fps) on this driver.
> > As the device seems to support setting the fps, you should be adding
> > support on it for VIDIOC_S_PARM and VIDIOC_G_PARM.
> > 
> > On both ioctls, the driver should return the actual framerate used.
> > So, you'll need to add a code that would convert from the 15 possible
> > framerate converter register settings to v4l2_fract.
> >   
> 
> OK, thanks for the information.
> 
> In fact, framerate support is implemented in the driver that is in
> production.
> 
> Support for s_parm, g_parm was in the original submission [1]
> but we removed it later [2] because we thought it was unused.

hmm... from [1], the support were provided by:

+static void tw686x_set_framerate(struct tw686x_video_channel *vc,
+				 unsigned int fps)
+{
+	unsigned int map;
+
+	if (vc->fps == fps)
+		return;
+
+	map = tw686x_fields_map(vc->video_standard, fps) << 1;
+	map |= map << 1;
+	if (map > 0)
+		map |= BIT(31);
+	reg_write(vc->dev, VIDEO_FIELD_CTRL[vc->ch], map);
+	vc->fps = fps;
+}

+static int tw686x_g_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *sp)
+{
+	struct tw686x_video_channel *vc = video_drvdata(file);
+	struct v4l2_captureparm *cp = &sp->parm.capture;
+
+	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	sp->parm.capture.readbuffers = 3;
+
+	cp->capability = V4L2_CAP_TIMEPERFRAME;
+	cp->timeperframe.numerator = 1;
+	cp->timeperframe.denominator = vc->fps;
+	return 0;
+}

+static int tw686x_s_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *sp)
+{
+	struct tw686x_video_channel *vc = video_drvdata(file);
+	struct v4l2_captureparm *cp = &sp->parm.capture;
+	unsigned int denominator = cp->timeperframe.denominator;
+	unsigned int numerator = cp->timeperframe.numerator;
+	unsigned int fps;
+
+	if (vb2_is_busy(&vc->vidq))
+		return -EBUSY;
+
+	fps = (!numerator || !denominator) ? 0 : denominator / numerator;
+	if (vc->video_standard & V4L2_STD_625_50)
+		fps = (!fps || fps > 25) ? 25 : fps;
+	else
+		fps = (!fps || fps > 30) ? 30 : fps;
+	tw686x_set_framerate(vc, fps);
+
+	return tw686x_g_parm(file, priv, sp);
+}

Basically, s_parm just stores the fps received from the user and
g_parm just returns 1/fps. The only validation it does is to avoid
fps == 0 or fps > max_fps. This is not what the API docbook states.
It should, instead, return the actual framerate that it was
programmed on the hardware.

Looking at the code, it is not returning the actual framerate, as
the framerate seems to have only 15 possible values,
from 0 (meaning no temporal decimation - e. g. just use the
standard default) to 14:

static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
{
	static const unsigned int map[15] = {
		0x00000000, 0x00000001, 0x00004001, 0x00104001, 0x00404041,
		0x01041041, 0x01104411, 0x01111111, 0x04444445, 0x04511445,
		0x05145145, 0x05151515, 0x05515455, 0x05551555, 0x05555555
	};

	static const unsigned int std_625_50[26] = {
		0, 1, 1, 2,  3,  3,  4,  4,  5,  5,  6,  7,  7,
		   8, 8, 9, 10, 10, 11, 11, 12, 13, 13, 14, 14, 0
	};

	static const unsigned int std_525_60[31] = {
		0, 1, 1, 1, 2,  2,  3,  3,  4,  4,  5,  5,  6,  6, 7, 7,
		   8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
	};

	unsigned int i;

	if (std & V4L2_STD_525_60) {
		if (fps > ARRAY_SIZE(std_525_60))
			fps = 30;
		i = std_525_60[fps];
	} else {
		if (fps > ARRAY_SIZE(std_625_50))
			fps = 25;
		i = std_625_50[fps];
	}

	return map[i];
}

>From the above, clearly it uses the same frame rate if "fps" var is
set to 1 to 2 (on 60Hz) and 1 to 3 (on 50 Hz).

What *I* suspect from the above is that the code setting a
temporal decimation register to zero (i = 0 -> map = 0x00000000)
in order to disable the temporal decimation;

And when "i" var is between 1 to 14, the temporal decimation block is
enabled and the real frame rate is given by:

	vc->real_fps = (fps * i) / 15

So, the driver should actually store the value of "i" and use it
when setting the framerate.

Btw, in the 60 Hz case, usually the fps is not 30 Hz, but,
instead, 30000/1001.

So, I guess the code at s_parm should be doing something like:

	if (std & V4L2_STD_525_60) {
		cp->timeperframe.numerator = 1001;
		cp->timeperframe.denominator = vc->real_fps * 1000;
	} else {
		cp->timeperframe.numerator = 1;
		cp->timeperframe.denominator = vc->real_fps;
	}


> I can't see how we came to that conclusion, since it is actually
> used to set the framerate!
> 
> Anyway, since we are discussing this, I would like to know if
> having s_parm/g_parm is enough for framerate setting support.

Yes.

> When I implemented this a year ago, the v4l2src gstreamer plugin
> seemed to require enum_frame_size and enum_frame_interval as well.
> It didn't make much sense, but I ended up implementing them
> to get it to work. Should that be required?
> 
> (To be honest, v4lsrc is quite picky regarding parameters,
> so it wouldn't be that surprising if it needs some love).

That sounds like a problem at v4l2src. You should talk with
gst developers if this is still an issue there.

I don't mind if you implement those two ioctls as well.

Regards,
Mauro
