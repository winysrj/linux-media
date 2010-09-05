Return-path: <mchehab@localhost>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:14645 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754338Ab0IESXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 14:23:45 -0400
Subject: Re: [PATCH] LED control
From: Andy Walls <awalls@md.metrocast.net>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
In-Reply-To: <87sk1oty46.fsf@macbook.be.48ers.dk>
References: <20100904131048.6ca207d1@tele> <4C834D46.5030801@redhat.com>
	 <87sk1oty46.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 14:23:18 -0400
Message-ID: <1283710998.2057.62.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sun, 2010-09-05 at 10:04 +0200, Peter Korsgaard wrote:
> >>>>> "Hans" == Hans de Goede <hdegoede@redhat.com> writes:
> 
> Hi,
> 
>  >> +	<entry><constant>V4L2_CID_LEDS</constant></entry>
>  >> +	<entry>integer</entry>
>  >> +	<entry>Switch on or off the LED(s) or illuminator(s) of the device.
>  >> +	    The control type and values depend on the driver and may be either
>  >> +	    a single boolean (0: off, 1:on) or the index in a menu type.</entry>
>  >> +	</row>
> 
>  Hans> I think that using one control for both status leds (which is
>  Hans> what we are usually talking about) and illuminator(s) is a bad
>  Hans> idea. I'm fine with standardizing these, but can we please have 2
>  Hans> CID's one for status lights and one for the led. Esp, as I can
>  Hans> easily see us supporting a microscope in the future where the
>  Hans> microscope itself or other devices with the same bridge will have
>  Hans> a status led, so then we will need 2 separate controls anyways.
> 
> Why does this need to go through the v4l2 api and not just use the
> standard LED (sysfs) api in the first place?

It puts a larger burden on the application programmer.

Video capture applications are already programmed to provide controls to
the user using the V4L2 API for manipulating all aspects of the incoming
video image.  Using something different for turning on subject
illumination would be an exceptional case. 

The V4L2 control API also allows applications to be written such that
they need no apriori knowledge about a video driver's controls, and yet
can still present all driver supported controls to the user for
manipulation.  The VIDIOC_QUERYCTL interface allows applications to
discover controls and metadata to build a UI.  Two applications that
illustrate the point are 'qv4l2' (a Qt control GUI) and 'v4l2-ctl' (a
CLI control UI) found here:

http://git.linuxtv.org/v4l-utils.git?a=tree;f=utils;h=8d37309cc3b896d11fc77d9f275f82f02ee9c03d;hb=HEAD
 

As an example, here is the output of v4l2-ctl -L for my QX3 microscope:

$ v4l2-ctl -d /dev/video1 -L
                     brightness (int)  : min=0 max=100 step=1 default=50 value=50
                       contrast (int)  : min=0 max=96 step=8 default=48 value=48
                     saturation (int)  : min=0 max=100 step=1 default=50 value=50
         light_frequency_filter (menu) : min=0 max=2 default=1 value=1
				0: NoFliker
				1: 50 Hz
				2: 60 Hz
             compression_target (menu) : min=0 max=1 default=0 value=0
				0: Quality
				1: Framerate
                          lamps (menu) : min=0 max=3 default=0 value=0
				0: Off
				1: Bottom
				2: Top
				3: Both

And here is the output for my PVR-350 TV capture card:

$ v4l2-ctl -d /dev/video2 -L

User Controls

                     brightness (int)  : min=0 max=255 step=1 default=128 value=128 flags=slider
                       contrast (int)  : min=0 max=127 step=1 default=64 value=64 flags=slider
                     saturation (int)  : min=0 max=127 step=1 default=64 value=64 flags=slider
                            hue (int)  : min=-128 max=127 step=1 default=0 value=0 flags=slider
                         volume (int)  : min=0 max=65535 step=655 default=58880 value=58880 flags=slider
                           mute (bool) : default=0 value=0

MPEG Encoder Controls

                    stream_type (menu) : min=0 max=5 default=0 value=0 flags=update
				0: MPEG-2 Program Stream
				2: MPEG-1 System Stream
				3: MPEG-2 DVD-compatible Stream
				4: MPEG-1 VCD-compatible Stream
				5: MPEG-2 SVCD-compatible Stream
              stream_vbi_format (menu) : min=0 max=1 default=0 value=0
				0: No VBI
				1: Private packet, IVTV format
       audio_sampling_frequency (menu) : min=0 max=2 default=1 value=1
				0: 44.1 kHz
				1: 48 kHz
				2: 32 kHz
                 audio_encoding (menu) : min=1 max=1 default=1 value=1 flags=update
				1: MPEG-1/2 Layer II
         audio_layer_ii_bitrate (menu) : min=9 max=13 default=10 value=10
				9: 192 kbps
				10: 224 kbps
				11: 256 kbps
				12: 320 kbps
				13: 384 kbps
              audio_stereo_mode (menu) : min=0 max=3 default=0 value=0 flags=update
				0: Stereo
				1: Joint Stereo
				2: Dual
				3: Mono
    audio_stereo_mode_extension (menu) : min=0 max=3 default=0 value=0 flags=inactive
				0: Bound 4
				1: Bound 8
				2: Bound 12
				3: Bound 16
                 audio_emphasis (menu) : min=0 max=2 default=0 value=0
				0: No Emphasis
				1: 50/15 us
				2: CCITT J17
                      audio_crc (menu) : min=0 max=1 default=0 value=0
				0: No CRC
				1: 16-bit CRC
                     audio_mute (bool) : default=0 value=0
                 video_encoding (menu) : min=0 max=1 default=1 value=1 flags=readonly
				0: MPEG-1
				1: MPEG-2
                   video_aspect (menu) : min=0 max=3 default=1 value=1
				0: 1x1
				1: 4x3
				2: 16x9
				3: 2.21x1
                 video_b_frames (int)  : min=0 max=33 step=1 default=2 value=2 flags=update
                 video_gop_size (int)  : min=1 max=34 step=1 default=15 value=15
              video_gop_closure (bool) : default=1 value=1
             video_bitrate_mode (menu) : min=0 max=1 default=0 value=0 flags=update
				0: Variable Bitrate
				1: Constant Bitrate
                  video_bitrate (int)  : min=0 max=27000000 step=1 default=6000000 value=6000000
             video_peak_bitrate (int)  : min=0 max=27000000 step=1 default=8000000 value=8000000
      video_temporal_decimation (int)  : min=0 max=255 step=1 default=0 value=0
                     video_mute (bool) : default=0 value=0
                 video_mute_yuv (int)  : min=0 max=16777215 step=1 default=32896 value=32896
            spatial_filter_mode (menu) : min=0 max=1 default=0 value=0 flags=update
				0: Manual
				1: Auto
                 spatial_filter (int)  : min=0 max=15 step=1 default=0 value=0 flags=slider
       spatial_luma_filter_type (menu) : min=0 max=4 default=1 value=1
				0: Off
				1: 1D Horizontal
				2: 1D Vertical
				3: 2D H/V Separable
				4: 2D Symmetric non-separable
     spatial_chroma_filter_type (menu) : min=0 max=1 default=1 value=1
				0: Off
				1: 1D Horizontal
           temporal_filter_mode (menu) : min=0 max=1 default=0 value=0 flags=update
				0: Manual
				1: Auto
                temporal_filter (int)  : min=0 max=31 step=1 default=8 value=8 flags=slider
             median_filter_type (menu) : min=0 max=4 default=0 value=0 flags=update
				0: Off
				1: Horizontal
				2: Vertical
				3: Horizontal/Vertical
				4: Diagonal
     median_luma_filter_minimum (int)  : min=0 max=255 step=1 default=0 value=0 flags=inactive slider
     median_luma_filter_maximum (int)  : min=0 max=255 step=1 default=255 value=255 flags=inactive slider
   median_chroma_filter_minimum (int)  : min=0 max=255 step=1 default=0 value=0 flags=inactive slider
   median_chroma_filter_maximum (int)  : min=0 max=255 step=1 default=255 value=255 flags=inactive slider
      insert_navigation_packets (bool) : default=0 value=0



v4l2-ctl needed no hardcoded knowledge of what the respective drivers
(gspca_cpia1 and ivtv) supported to build a UI.  Nor did the v4l2-ctl
need to go rummaging about in sysfs to find which control applied to
which video device node, because the driver simply tell the app upon
request: "here are your options for controlling this device".  No
guesswork on where the control for this device may be located in sysfs,
and no exceptional application code to be written just to toggle an
illuminator on and off.

Regards,
Andy

