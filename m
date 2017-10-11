Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42606 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750959AbdJKX1p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 19:27:45 -0400
Date: Thu, 12 Oct 2017 00:27:34 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH] media: staging/imx: do not return error in link_notify
 for unknown sources
Message-ID: <20171011232734.GA12236@n2100.armlinux.org.uk>
References: <1507057753-31808-1-git-send-email-steve_longerbeam@mentor.com>
 <20171011214906.GX20805@n2100.armlinux.org.uk>
 <87b48a34-4beb-eb21-3361-28f6edb6d73c@gmail.com>
 <20171011230633.GZ20805@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011230633.GZ20805@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 12, 2017 at 12:06:33AM +0100, Russell King - ARM Linux wrote:
> Now, if you mean "known" to be equivalent with "recognised by
> imx-media" then, as I've pointed out several times already, that
> statement is FALSE.  I'm not sure how many times I'm going to have to
> state this fact.  Let me re-iterate again.  On my imx219 driver, I
> have two subdevs.  Both subdevs have controls attached.  The pixel
> subdev is not "recognised" by imx-media, and without a modification
> like my or your patch, it fails.  However, with the modification,
> this "unrecognised" subdev _STILL_ has it's controls visible through
> imx-media.

If you refuse to believe what I'm saying, then read through:

http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=csi-v6&id=e3f847cd37b007d55b76282414bfcf13abb8fc9a

and look at this:

# for f in 2 3 4 5 6 7 8 9; do v4l2-ctl -L -d /dev/video$f; done
# ./cam/cam-setup.sh
# v4l2-ctl -L -d /dev/video6

User Controls

                           gain (int)    : min=256 max=4095 step=1 default=256 value=256
                     fim_enable (bool)   : default=0 value=0
                fim_num_average (int)    : min=1 max=64 step=1 default=8 value=8              fim_tolerance_min (int)    : min=2 max=200 step=1 default=50 value=50
              fim_tolerance_max (int)    : min=0 max=500 step=1 default=0 value=0
                   fim_num_skip (int)    : min=0 max=256 step=1 default=2 value=2
         fim_input_capture_edge (int)    : min=0 max=3 step=1 default=0 value=0
      fim_input_capture_channel (int)    : min=0 max=1 step=1 default=0 value=0

Camera Controls

         exposure_time_absolute (int)    : min=1 max=399 step=1 default=399 value=166

Image Source Controls

              vertical_blanking (int)    : min=32 max=64814 step=1 default=2509
value=2509 flags=read-only
            horizontal_blanking (int)    : min=2168 max=31472 step=1 default=2168 value=2168 flags=read-only
                  analogue_gain (int)    : min=1000 max=8000 step=1 default=1000 value=1000
                red_pixel_value (int)    : min=0 max=1023 step=1 default=0 value=0 flags=inactive
          green_red_pixel_value (int)    : min=0 max=1023 step=1 default=0 value=0 flags=inactive
               blue_pixel_value (int)    : min=0 max=1023 step=1 default=0 value=0 flags=inactive
         green_blue_pixel_value (int)    : min=0 max=1023 step=1 default=0 value=0 flags=inactive

Image Processing Controls

                     pixel_rate (int64)  : min=160000000 max=278400000 step=1 default=278400000 value=278400000 flags=read-only
                   test_pattern (menu)   : min=0 max=9 default=0 value=0
                                0: Disabled
                                1: Solid Color
                                2: 100% Color Bars
                                3: Fade to Grey Color Bar
                                4: PN9
                                5: 16 Split Color Bar
                                6: 16 Split Inverted Color Bar
                                7: Column Counter
                                8: Inverted Column Counter
                                9: PN31

Now, the pixel array subdev has these controls:
	gain
	vertical_blanking
	horizontal_blanking
	analogue_gain
	pixel_rate
	exposure_time_absolute

The root subdev (which is the one which connects to your code) has
these controls:
	red_pixel_value
	green_red_pixel_value
	blue_pixel_value
	green_blue_pixel_value
	test_pattern

As you can see from the above output, _all_ controls from _both_ subdevs
are listed.

Now, before you spot your old patch adding v4l2_pipeline_inherit_controls()
and try to blame that for this, nothing in my kernel calls that function,
so that patch can be dropped, and so it's not responsible for this.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
