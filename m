Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:18659 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbZE2HiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 03:38:11 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "\\\"ext Hans Verkuil\\\"" <hverkuil@xs4all.nl>,
	"\\\"ext Mauro Carvalho Chehab\\\"" <mchehab@infradead.org>
Cc: "\\\"Nurkkala Eero.An (EXT-Offcode/Oulu)\\\""
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\"ext Douglas Schilling Landgraf\\\"" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv5 8 of 8] FMTx: si4713: Add document file
Date: Fri, 29 May 2009 10:33:28 +0300
Message-Id: <1243582408-13084-9-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1243582408-13084-8-git-send-email-eduardo.valentin@nokia.com>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-2-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-3-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-4-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-5-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-6-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-7-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-8-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Eduardo Valentin <eduardo.valentin@nokia.com>
# Date 1243414607 -10800
# Branch export
# Node ID fadf1cddf504609cdb4889f4aa3305ca8d15323a
# Parent  b1d98e675a3c4e9e6d247701c9ac18239e3dcc1c
Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 Documentation/video4linux/si4713.txt |  133 ++++++++++++++++++++++++++++++++++
 1 files changed, 133 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/si4713.txt

diff -r b1d98e675a3c -r fadf1cddf504 linux/Documentation/video4linux/si4713.txt
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/Documentation/video4linux/si4713.txt	Wed May 27 11:56:47 2009 +0300
@@ -0,0 +1,133 @@
+Driver for I2C radios for the Silicon Labs Si4713 FM Radio Transmitters
+
+Copyright (c) 2009 Nokia Corporation
+Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
+
+
+Information about the Device
+============================
+This chip is a Silicon Labs product. It is a I2C device, currently on 0×63 address.
+Basically, it has transmission and signal noise level measurement features.
+
+The Si4713 integrates transmit functions for FM broadcast stereo transmission.
+The chip also allows integrated receive power scanning to identify low signal
+power FM channels.
+
+The chip is programmed using commands and responses. There are also several
+properties which can change the behavior of this chip.
+
+Users must comply with local regulations on radio frequency (RF) transmission.
+
+Device driver description
+=========================
+There are two modules to handle this device. One is a I2C device driver
+and the other is a platform driver.
+
+The I2C device driver exports a v4l2-subdev interface to the kernel. Also
+it exports several device properties through sysfs interface to the user land.
+All properties can also be accessed by v4l2 extended controls interface, by
+using the v4l2-subdev calls (g_ext_ctrls, s_ext_ctrls).
+
+The platform device driver exports a v4l2 radio device interface to user land.
+So, it uses the I2C device driver as a sub device in order to send the user
+commands to the actual device. Basically it is a wrapper to the I2C device driver.
+
+So, in summary, the device driver has two interfaces to the user space.
+
+Applications can use v4l2 radio API to specify frequency of operation, mute state,
+etc. But mostly of its properties will be present in the extended controls.
+However, the device properties can also be accessed through its sysfs directory.
+
+When the v4l2 mute property is set to 1 (true), the driver will turn the chip off.
+
+Properties description
+======================
+
+The properties can be accessed in sysfs device directory. Using v4l2 extended
+controls as well.
+
+# ls
+acomp_attack_time        modalias                 rds_radio_text
+acomp_enabled            name                     region
+acomp_gain               pilot_deviation          region_bottom_frequency
+acomp_release_time       pilot_enabled            region_channel_spacing
+acomp_threshold          pilot_frequency          region_preemphasis
+antenna_capacitor        power                    region_top_frequency
+bus                      power_level              stereo_enabled
+driver                   rds_enabled              subsystem
+limiter_deviation        rds_pi                   tune_measure
+limiter_enabled          rds_ps_name              uevent
+limiter_release_time     rds_pty
+
+Here is a summary of them:
+
+* Pilot is an audible tone sent by the device.
+
+pilot_frequency - Configures the frequency of the stereo pilot tone.
+pilot_deviation - Configures pilot tone frequency deviation level.
+pilot_enabled - Enables or disables the pilot tone feature.
+
+* The si4713 device is capable of applying audio compression to the transmitted signal.
+
+acomp_enabled - Enables or disables the audio dynamic range control feature.
+acomp_gain - Sets the gain for audio dynamic range control.
+acomp_threshold - Sets the threshold level for audio dynamic range control.
+acomp_attack_time - Sets the attack time for audio dynamic range control.
+acomp_release_time - Sets the release time for audio dynamic range control.
+
+* Limiter setups audio deviation limiter feature. Once a over deviation occurs,
+it is possible to adjust the front-end gain of the audio input and always
+prevent over deviation.
+
+limiter_enabled - Enables or disables the limiter feature.
+limiter_deviation - Configures audio frequency deviation level.
+limiter_release_time - Sets the limiter release time.
+
+* Tuning power
+
+power_level - Sets the output power level for signal transmission.
+antenna_capacitor - This selects the value of antenna tuning capacitor manually
+or automatically if set to zero.
+tune_measure - With this you can get the value of signal length of a specific frequency.
+
+* RDS related
+
+rds_enabled - Enables or disables the RDS feature.
+rds_ps_name - Sets the RDS ps name field for transmission.
+rds_radio_text - Sets the RDS radio text for transmission.
+rds_pi - Sets the RDS PI field for transmission.
+rds_pty - Sets the RDS PTY field for transmission.
+
+* Region related
+
+Setting region will affect other region properties.
+
+region_bottom_frequency
+region_channel_spacing
+region_preemphasis
+region_top_frequency
+region - Selects which country specific setting should be assumed.
+
+* stereo_enabled - Enables or disables stereo mode.
+
+Testing
+=======
+Testing is usually done with fmtools utility for managing FM tuner cards.
+The tool can be found under Debian/Testing packages.
+
+The basic command list is:
+
+$ fm on     # Sets mute = false
+$ fm off    # Sets mute = true
+$ fm <freq> # Tunes to the frequency <freq>
+
+Of course, you should have the audio working and play something through alsa
+API to get something different of mute transmitted.
+
+To play with the above described properties, you can just use 'echo' and
+'cat' commands. For example, changing the rds_ps_name property, you just do:
+
+echo "Dummy FM Station" > /sys/bus/i2c/devices/X-0063/rds_ps_name
+
+where "X" is the i2c bus id which the device is connected.
+
