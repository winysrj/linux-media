Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab1FANVD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 09:21:03 -0400
Message-ID: <4DE63CCD.8050308@redhat.com>
Date: Wed, 01 Jun 2011 15:21:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.8.4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm happy to announce the release of v4l-utils-0.8.4. After some
somewhat boring releases, this release contains some interesting
improvements:
* Various enhancements to libv4l which should result in
   significantly less cpu usage with uvc HD cameras in several
   scenarios
* A library for associating video, audio, vbi and other devices with each
   other. This will allow apps to automatically do things like figure out
   which alsa input devices has the sound for the analog tv show you are
   watching. Note atm this lib does not have a stable API yet, and thus
   does not get installed by make install.

Full changelog:

v4l-utils-0.8.4
---------------
* Utils changes
   * Various small fixes (hverkuil, mchehab)
   * qv4l2: Add support for configuring the framerate for devices which support
     this like uvc cams (hdegoede)
   * parse_tcpdump_log.pl: new parser for tcpdump / wireshark made usbmon
     dumps (mchehab)
   * New lib_media_dev lib, to pair audio devices with video devices
     (and other combinations) for now this lives in utils and does not get
     installed systemwide, as the API is not stable (mchehab)
* libv4l changes
   * Add many more laptop models to the upside down devices table (hdegoede)
   * Some small bugfixes (hdegoede)
   * Add vicam cameras to list of cameras need sw auto gain + whitebalance
     (hdegoede)
   * Add support for M420 pixelformat (hdegoede)
   * Add support for Y10B pixelformat (Antonio Ospite)
   * Add support for JPGL pixelformat (jfmoine)
   * Modified (rewrote) jpeg decompression code to use libjpeg[-turbo], for
     much lower cpu load when doing jpeg decompression (hdegoede)
   * Detect usb connection speed of devices (hdegoede)
   * Rewrite src format selection algorithm, taking bandwidth into account and
     choosing the format which will give us the lowest CPU load while still
     allowing 30 fps (hdegoede)
   * Intercept S_PARM and redo src format selection based on new fps setting,
     potentially switching from JPG to YUYV / M420 when the app lowers the
     fps, resulting in a significant lower cpu load (hdegoede)

Go get it here:
http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.4.tar.bz2

You can always find the latest developments here:
http://git.linuxtv.org/v4l-utils.git

Regards,

Hans
