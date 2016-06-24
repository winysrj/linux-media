Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49090 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbcFXQVO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 12:21:14 -0400
Date: Fri, 24 Jun 2016 18:21:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160624162109.GA29604@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> As omap3isp driver supports only one endpoint on ccp2 interface,
> but cameras on N900 require different strobe settings, so far
> it is not possible to have both cameras correctly working with
> the same board DTS. DTS patch in the series has the correct
> settings for the front camera. This is a problem still to be
> solved.
> 
> The needed pipeline could be made with:
> 
> media-ctl -r
> media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2 [1]'
> media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
> media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
> media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
> media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
> media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
> media-ctl -V '"vs6555 pixel array 2-0010":0 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
> media-ctl -V '"vs6555 binner 2-0010":1 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
> media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 648x488]'
> media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 648x488]'
> media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 648x488]'
> media-ctl -V '"OMAP3 ISP preview":1 [UYVY 648x488]'
> media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 656x488]'
> 
> and tested with:
> 
> mplayer -tv driver=v4l2:width=656:height=488:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://
>

Ok, I played with the back sensor, and can get it to work in 1Mpix
mode, but not in 5Mpix mode. 1MPix mode works ok both in previewer
mode and in capture mode. 5Mpix mode does 4 copies of the frame in
previewer (thus unusable), and when I try it in capture mode, I get

[  222.952514] omap3isp 480bc000.isp: CCDC won't become idle!
[  224.515716] omap3isp 480bc000.isp: Unable to stop OMAP3 ISP CCDC

(script below can do it).

Any ideas? Thanks,
								Pavel

import subprocess
import time
import os

# TODO: Camera gain does not work                                                               
# LED indicator mode is not usable                                                              
# LED torch mode only has one brightness setting                                                

# sudo /my/v4l-utils/utils/media-ctl/media-ctl -p                                               
# This seems to have good description:                                                          
# https://www.compulab.co.il/workspace/mediawiki/index.php5/CM-T3730:_Linux:_Camera             

# aptitude install ufraw ?                                                                      

class Camera:
    mc="/my/v4l-utils/utils/media-ctl/media-ctl"
    ya="/my/tui/yavta/yavta"
    def __init__(m):
        if 1:
            # 4 copies in preview mode, "CCDC won't become idle!" in raw mode.                  
            m.win_x, m.win_y = 1200, 900
            m.cap_x, m.cap_y = 2592, 1968
...
    def media_ctl(m, s):
        if 0 != subprocess.call(['sudo', m.mc] + s):
            print("Call ", s, " failed?")

    def media_l(m, s):
        m.media_ctl(['-l', s])

    def media_v(m, s):
        m.media_ctl(['-V', s])

    def back_full(m):
        m.media_ctl(['-r'])

        m.media_l('"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]')
        m.media_l('"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]')
        m.media_l('"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]')
        m.media_l('"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0 [1]')

        size = "%dx%d" % (m.cap_x, m.cap_y)
        m.media_v('"et8ek8 3-003e":0 [SGRBG10 %s]' % size)
        m.media_v('"OMAP3 ISP CCP2":0 [SGRBG10 %s]' % size)
        m.media_v('"OMAP3 ISP CCP2":1 [SGRBG10 %s]' % size)
        m.media_v('"OMAP3 ISP CCDC":1 [SGRBG10 %s]' % size)
...
    def run_full(m):
	os.system(m.ya+" --capture=8 --pause --skip 0 --format SGRBG10 --size %dx%d /dev/video2\
 --file=/tmp/delme#" % (m.cap_x, m.cap_y))


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
