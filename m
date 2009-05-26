Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6.versatel.nl ([62.58.50.97]:59689 "EHLO smtp6.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbZEZLpK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 07:45:10 -0400
Message-ID: <4A1BD670.2080406@hhs.nl>
Date: Tue, 26 May 2009 13:45:52 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4l release: 0.5.98: the gamma correction release!
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This is probably the last test release for the 0.6.x series,
the video processing code has been rewritten and works very
nicely now. Please give this release a thorough testing!

The software whitebalancing and gamma correction can make a
very positive difference on the image quality given of by
cheaper cams.

libv4l now automatically enables fake controls to enable
software white-balancing and gamma for most webcams (all
those will will need conversion anyways).

So when you startup v4l2ucp you should see a checkbox
for whitebalance and a slider for gamma (the default setting
of 1000 == 1.0 is no gamma correction).

Now start your favorite webcam viewing app and play around with the
2 controls. If whitebalancing makes a *strongly noticable* positive
difference for your webcam please mail me info about your cam (the usb id),
then I can add it to the list of cams which will have the whitebalancing
algorithm enabled by default. The same goes for cams which benefit from
a significant gamma correction. For example this release sets the
gamma to 1500 (1.5) for pac207 cams by default, resulting in a much
improved image.


libv4l-0.5.98
-------------
* Add software gamma correction
* Add software auto gain / exposure
* Add support for separate vflipping and hflipping
* Add fake controls controlling the software h- and v-flipping
* Add ability to determine upside down cams based on DMI info
* Add the capability to provide 320x240 to apps if the cam can only
   do 320x232 (some zc3xx cams) by adding black borders
* Rewrite video processing code to make it easier to add more video filters
   (and with little extra processing cost). As part of this the normalize
   filter has been removed as it wasn't functioning satisfactory anyways
* Support V4L2_CTRL_FLAG_NEXT_CTRL for fake controls by Adam Baker
* Some makefile improvements by Gregor Jasny
* Various small bugfixes and tweaks
* The V4L2_ENABLE_ENUM_FMT_EMULATION v4l2_fd_open flag is obsolete, libv4l2
   now *always* reports emulated formats through the ENUM_FMT ioctl


Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.98.tar.gz

Regards,

Hans

