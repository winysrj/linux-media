Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:37073 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbeLACHq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 21:07:46 -0500
Date: Fri, 30 Nov 2018 15:58:07 +0100
From: Andreas Pape <ap@ca-pape.de>
To: kieran.bingham@ideasonboard.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] media: stkwebcam: Bugfix for not correctly
 initialized camera
Message-Id: <20181130155807.f1be928e4fc3a05e13fc710b@ca-pape.de>
In-Reply-To: <b527358c-8fb9-fbe5-be19-43e8992e85c7@ideasonboard.com>
References: <20181123161454.3215-1-ap@ca-pape.de>
        <20181123161454.3215-3-ap@ca-pape.de>
        <b527358c-8fb9-fbe5-be19-43e8992e85c7@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

thanks for the review.

On Mon, 26 Nov 2018 12:48:08 +0000
Kieran Bingham <kieran.bingham@ideasonboard.com> wrote:

> This one worries me a little... (but hopefully not too much)
>

As mentioned, I don't have any experience concerning video drivers;-). I found
this patch more or less experimentally....
 
> 
> > Signed-off-by: Andreas Pape <ap@ca-pape.de>
> > ---
> >  drivers/media/usb/stkwebcam/stk-webcam.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
> > index e61427e50525..c64928e36a5a 100644
> > --- a/drivers/media/usb/stkwebcam/stk-webcam.c
> > +++ b/drivers/media/usb/stkwebcam/stk-webcam.c
> > @@ -1155,6 +1155,8 @@ static int stk_vidioc_streamon(struct file *filp,
> >  	if (dev->sio_bufs == NULL)
> >  		return -EINVAL;
> >  	dev->sequence = 0;
> > +	stk_initialise(dev);
> > +	stk_setup_format(dev);
> 
> Glancing through the code base - this seems to imply to me that s_fmt
> was not set/called (presumably by cheese) as stk_setup_format() is
> called only by stk_vidioc_s_fmt_vid_cap() and stk_camera_resume().
> 
> Is this an issue?
> 
> I presume that this means the camera will just operate in a default
> configuration until cheese chooses something more specific.
>

Could be. I had a video but colours, sensitivity and possibly other things
were crap or at least very "psychedelic". Therefore the idea came up that
some kind of initialisation was missing here. 

> Actually - looking further this seems to be the case, as the mode is
> simply stored in dev->vsettings.mode, and so this last setup stage will
> just ensure the configuration of the hardware matches the driver.
> 
> So it seems reasonable to me - but should it be set any earlier?
> Perhaps not.
> 
> 
> Are there any complaints when running v4l2-compliance on this device node?
> 

Here is the output of v4l2-compliance:

v4l2-compliance SHA   : not available

Driver Info:
	Driver name   : stk
	Card type     : stk
	Bus info      : usb-0000:00:1d.7-5
	Driver version: 4.15.18
	Capabilities  : 0x85200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x05200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 4 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		warn: v4l2-test-formats.cpp(732): TRY_FMT cannot handle an invalid pixelformat.
		warn: v4l2-test-formats.cpp(733): This may or may not be a problem. For more information see:
		warn: v4l2-test-formats.cpp(734): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
		test VIDIOC_TRY_FMT: OK
		warn: v4l2-test-formats.cpp(997): S_FMT cannot handle an invalid pixelformat.
		warn: v4l2-test-formats.cpp(998): This may or may not be a problem. For more information see:
		warn: v4l2-test-formats.cpp(999): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		warn: v4l2-test-buffers.cpp(538): VIDIOC_CREATE_BUFS not supported
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 7

Kind regards,
Andreas


-- 
Andreas Pape <ap@ca-pape.de>
