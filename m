Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43823 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbcDVPof (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 11:44:35 -0400
Date: Fri, 22 Apr 2016 12:44:25 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>
Subject: Re: [PATCH 0/8] Input: atmel_mxt_ts - output raw touch diagnostic
 data via V4L
Message-ID: <20160422124425.39ac140f@recife.lan>
In-Reply-To: <571A40C0.90208@xs4all.nl>
References: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
	<5719E03D.2010201@xs4all.nl>
	<20160422114517.0e7430bd@recife.lan>
	<571A3E3E.60601@itdev.co.uk>
	<571A40C0.90208@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Apr 2016 17:18:24 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 04/22/2016 05:07 PM, Nick Dyer wrote:
> > On 22/04/2016 15:45, Mauro Carvalho Chehab wrote:  
> >> Em Fri, 22 Apr 2016 10:26:37 +0200
> >> Hans Verkuil <hverkuil@xs4all.nl> escreveu:  
> >>> On 04/21/2016 11:31 AM, Nick Dyer wrote:  
> >>>> This is a series of patches to add diagnostic data support to the Atmel
> >>>> maXTouch driver. It's a rewrite of the previous implementation which output via
> >>>> debugfs: it now uses a V4L2 device in a similar way to the sur40 driver.
> >>>>
> >>>> There are significant performance advantages to putting this code into the
> >>>> driver. The algorithm for retrieving the data has been fairly consistent across
> >>>> a range of chips, with the exception of the mXT1386 series (see patch).
> >>>>
> >>>> We have a utility which can read the data and display it in a useful format:
> >>>> 	https://github.com/ndyer/heatmap/commits/heatmap-v4l
> >>>>
> >>>> These patches are also available from
> >>>> 	https://github.com/ndyer/linux/commits/diagnostic-v4l
> >>>>
> >>>> Any feedback appreciated.    
> >>>
> >>> FYI: we're working on a new buffer type for meta data:
> >>>
> >>> https://patchwork.linuxtv.org/patch/33938/
> >>> https://patchwork.linuxtv.org/patch/33939/  
> >>
> >> One of the things I missed on your patchset is the content of the
> >> new format you added (V4L2_PIX_FMT_YS16). You should be patching
> >> the V4L2 docbook too, in order to add it there.  
> > 
> > OK, will do. I also see that I forgot Kconfig changes for CONFIG_VIDEO_V4L2
> > etc.
> >   
> >> That's said, if the output is really an image, I don't think it
> >> should be mapped via the new V4L2_BUF_TYPE_META_CAPTURE. This type of
> >> buffer is meant to be used on non-image metadata, like image statistics
> >> to feed auto whitebalance and other similar AAA algorithms.  
> > 
> > The output is raw touch data - i.e. a rectangular grid of nodes each having
> > an integer value. I think it is an image in some senses, although perhaps
> > it's a matter of opinion!
> > 
> > You can see an example of a Atmel MXT capacitive touch device here (using
> > this patchset):
> > https://www.youtube.com/watch?v=Uj4T6fUCySw
> > 
> > There are touch devices which can deliver much higher resolution/framerate.
> > For example here's the data coming from a SUR40 which is an optical touch
> > sensor but uses V4L in a similar way:
> > https://www.youtube.com/watch?v=e-JNqTY_3b0
> >   
> >> It could still make sense to use the new device type (VFL_TYPE_META) for
> >> such drivers, as we don't want applications to identify those devices as
> >> if they are a webcam.  
> > 
> > I agree it may be a little confusing if things like Skype start picking up
> > these devices. Could we #define V4L2_INPUT_TYPE_TOUCH_SENSOR to solve that
> > problem?
> >   
> 
> That might be an idea. I have to admit that I didn't look at the patches in
> detail. It mentioned diagnostics, so I didn't realize that it is a image
> with a width and height, even though it is not a regular video input.
> 
> Adding a new input type won't prevent anyone from picking it up, since
> nobody tests that field :-)

Yeah, I agree.

> On the other hand, it would be a good place to tell the user that it
> is from a touch sensor.
> 
> Using the upcoming metadata feature wouldn't work since there is no width
> and height in the metadata format.
> 
> I wonder what others think about adding a new type value.

IMO, two things should be done here:

1) Add some caps flag to help userspace to identify what's there
   on those devices;

2) Make sure that udev/systemd won't be naming the devnodes as
   "/dev/video";


The latter one could be solved with either the new dev meta or
with another VFL_TYPE for input systems (like VFL_TYPE_TOUCH_SENSOR)
and use this code snippet:

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index d8e5994cccf1..4d3e574eba49 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -887,6 +887,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
                /* Use device name 'swradio' because 'sdr' was already taken. */
                name_base = "swradio";
                break;
+       case VFL_TYPE_TOUCH_SENSOR:
+               name_base = "v4l-touch";
+               break;
        default:
                printk(KERN_ERR "%s called with unknown type: %d\n",
                       __func__, type);


Such change would cause __video_register_device() to pass a different
name_base to:
	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);

This way, udev/systemd will use a different name (by default, 
/dev/v4l-touch0), and existing apps won't identify this as a
webcam.

Regards,
Mauro
