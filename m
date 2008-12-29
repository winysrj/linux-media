Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBTKkPqM024577
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 15:46:25 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBTKkDAW032438
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 15:46:13 -0500
Date: Mon, 29 Dec 2008 15:46:12 -0500
From: Jim Paris <jim@jtan.com>
To: Timo Paulssen <timo@wakelift.de>
Message-ID: <20081229204611.GA9421@psychosis.jim.sh>
References: <49528845.20904@wakelift.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49528845.20904@wakelift.de>
Cc: video4linux-list@redhat.com
Subject: Re: recording from a playstation eye
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Timo,

> 1. mencoder.
> I couldn't get mencoder to work at all, used something like this:
> mencoder -cache 128 -tv
> driver=v4l2:width=640:height=480:outfmt=i420:fps=60:forceaudio:adevice=/dev/dsp:immediatemode=0:forceaudio
> tv:// -oac copy -ovc copy -o test.avi
> which led to a "floating point exception"

The crash is here, stream/tvi_v4l2.c:

    /* setup video parameters */
    if (!priv->tv_param->noaudio) {
        if (priv->video_buffer_size_max < (3*priv->standard.frameperiod.denominator) /
                                               priv->standard.frameperiod.numerator
            *priv->audio_secs_per_block) {
            mp_msg(MSGT_TV, MSGL_ERR, "Video buffer shorter than 3 times audio frame duration.\n"
                   "You will probably experience heavy framedrops.\n");
        }
    }

There is no video standard set by the ov534 driver, so it's a
divide-by-zero.  If you comment out this section and rebuild mencoder,
it will work better, although there are still issues with framerate.

To fix it for real, we probably need gspca to handle VIDIOC_G_STD.
Currently gspca leaves this up to v4l2 which returns a successful
error code, but no meaningful standard.  If VIDIOC_G_STD returned an
error instead, mplayer would fall back to VIDIOC_G_PARM which might
work correctly (or maybe not, my quick tests failed.  I think mplayer
needs some work in this area.)


> 2. cheese.
> All i see is the gstreamer test video input signal, even though I set it
> correctly in gstreamer-properties and even the preview works.

I don't know what's going on with cheese, it flashes the LED once
briefly for me, but doesn't show video.  gstreamer-properties crashes
when I hit preview after showing the first frame for a split second.


> 3. gstreamer.
> When running gst-launch-0.10 v4l2src device="/dev/video0" ! xvimagesink
> I get a nice video, but its framerate is way too low and there is a
> ~1sec delay; this is unacceptable. when i try to set framerate=60, it
> claims to not know the framerate option, even though the documentation
> clearly states its existance.

This seems to fix the framerate and delay with gst-launch:

gst-launch-0.10 v4l2src ! video/x-raw-yuv, framerate=60/1 ! xvimagesink


> 4. ffmpeg.
> when running ffplay -f video4linux2 /dev/video0 -s 640x480, I get
> "[video4linux2 @ 0xb801f680]The v4l2 frame is 614400 bytes, but 460800
> bytes are expected" multiple times.
> when using any of the two libv4l shared libraries I get half a second
> worth of frames out of it, then the image freezes and i get
> "[video4linux2 @ 0xb7f49680]ioctl(VIDIOC_DQBUF): Input/output error".

No idea about that I/O error, but it seems to work reasonably well
with v4l1 and v4l1compat here:

LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so ffplay -f video4linux /dev/video0 -s 640x480


> 5. spcaview.
> (when using the preloads) Video is fine, recorded from wrong microphone,
> mv'd /dev/dsp1 to /dev/dsp, but now I get really bad sound - everytime
> there is sound, it sounds really trashy.

I can't get spcaview to do sound at all over here.  Anyway, you might
verify that the sound is working independently with e.g. audacity.
Maybe your app is getting confused by the 4-channel audio.  If you
tell audacity to use "Oss: /dev/dsp1" and set the number of channels
to 4, you get a nice view of the effects of the camera's microphone
array.

-jim

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
