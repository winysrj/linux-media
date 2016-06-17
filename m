Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60064 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbcFQQmf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 12:42:35 -0400
Date: Fri, 17 Jun 2016 18:42:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Nokia N900 cameras -- pipeline setup in python (was Re: [RFC PATCH
 00/24] Make Nokia N900 cameras working)
Message-ID: <20160617164226.GA27876@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20160427030850.GA17034@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

First, I re-did pipeline setup in python, it seems slightly less hacky
then in shell.

I tried to modify fcam-dev to work with the new interface, but was not
successful so far. I can post patches if someone is interested
(mplayer works for me, but that's not too suitable for taking photos).

I tried to get gstreamer to work, with something like:

class Camera:
    gst="/usr/bin/gst-launch"
    def __init__(m):
        pass

    def run(m):
        if 0 != subprocess.call(
                [m.gst, "-v", "--gst-debug-level=2",
#                 "v4l2src", "device=/dev/video2", "num-buffers=3", "!",                     
#                 "video/x-raw-yuv,width=864,height=656", "!",                               
                 "v4l2src", "device=/dev/video6", "num-buffers=3", "!",
                 "video/x-raw-yuv,width=800,height=600,format=(fourcc)UYVY", "!",
# ,format=(fourcc)YU12                                                                       
                 "ffmpegcolorspace", "!",
                 "jpegenc", "!",
                 "filesink", "location=delme.jpg" ]):


But could not get it to work so far.

Best regards,

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--NzB8fVQJ5HfG6fxh
Content-Type: text/x-python; charset=us-ascii
Content-Disposition: attachment; filename="camera.py"

#!/usr/bin/python3

import subprocess
import os

class Camera:
    mc="/my/v4l-utils/utils/media-ctl/media-ctl"
    def __init__(m):
        m.win_x, m.win_y = 800, 600
        m.cap_x, m.cap_y = 864, 656
        #m.cap_x, m.cap_y = 2592, 1968

    def media_ctl(m, s):
        if 0 != subprocess.call(['sudo', m.mc] + s):
            print("Call ", s, " failed?")

    def media_l(m, s):
        m.media_ctl(['-l', s])

    def media_v(m, s):
        m.media_ctl(['-V', s])

    def back(m):
        m.media_ctl(['-r'])

        m.media_l('"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]')
        m.media_l('"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]')
        m.media_l('"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]')
        m.media_l('"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]')
        m.media_l('"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]')
        m.media_l('"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]')

        size = "%dx%d" % (m.cap_x, m.cap_y)
        m.media_v('"et8ek8 3-003e":0 [SGRBG10 %s]' % size)
        m.media_v('"OMAP3 ISP CCP2":0 [SGRBG10 %s]' % size)
        m.media_v('"OMAP3 ISP CCP2":1 [SGRBG10 %s]' % size)
        m.media_v('"OMAP3 ISP CCDC":2 [SGRBG10 %s]' % size)
        m.media_v('"OMAP3 ISP preview":1 [UYVY %s]' % size)
        m.media_v('"OMAP3 ISP resizer":1 [UYVY %dx%d]' % (m.win_x, m.win_y))

    def perms(m):
        os.system("sudo chmod 666 /dev/video? /dev/v4l-subdev*")

    def run(m):
        os.system("mplayer -tv driver=v4l2:width=%d:height=%d:outfmt=uyvy:device=/dev/video6 -vo x11 -vf screenshot tv://" % (m.win_x, m.win_y))

c = Camera()
c.back()
c.perms()
c.run()


--NzB8fVQJ5HfG6fxh--
