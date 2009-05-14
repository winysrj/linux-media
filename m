Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42043 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374AbZENLws (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 07:52:48 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH v3 7/7] FMTx: si4713: Add document file
Date: Thu, 14 May 2009 14:47:01 +0300
Message-Id: <1242301622-29672-8-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1242301622-29672-7-git-send-email-eduardo.valentin@nokia.com>
References: <1242301622-29672-1-git-send-email-eduardo.valentin@nokia.com>
 <1242301622-29672-2-git-send-email-eduardo.valentin@nokia.com>
 <1242301622-29672-3-git-send-email-eduardo.valentin@nokia.com>
 <1242301622-29672-4-git-send-email-eduardo.valentin@nokia.com>
 <1242301622-29672-5-git-send-email-eduardo.valentin@nokia.com>
 <1242301622-29672-6-git-send-email-eduardo.valentin@nokia.com>
 <1242301622-29672-7-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 Documentation/video4linux/si4713.txt |  133 ++++++++++++++++++++++++++++++++++
 1 files changed, 133 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/si4713.txt

diff --git a/Documentation/video4linux/si4713.txt b/Documentation/video4linux/si4713.txt
new file mode 100644
index 0000000..fff2104
--- /dev/null
+++ b/Documentation/video4linux/si4713.txt
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
-- 
1.6.2.GIT

