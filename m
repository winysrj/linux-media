Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36258 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0FVVZU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jun 2010 17:25:20 -0400
Received: by wyi11 with SMTP id 11so249306wyi.19
        for <linux-media@vger.kernel.org>; Tue, 22 Jun 2010 14:25:18 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Jun 2010 23:25:18 +0200
Message-ID: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
Subject: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
From: Thorsten Hirsch <t.hirsch@web.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

as far as I know there's been some trouble in the past regarding
Markus Rechberger's em28xx driver (em28xx-new) and the official
development line, resulting in the current situation:

- M. Rechberger isn't developing his driver anymore
- kernel driver doesn't support em28xx/xc3028 based usb sticks
(cinergy usb t xs)

Can I help to solve the situation?

So far I opened a bug report on launchpad
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/460636)
describing the situation with both drivers. I also tried to update M.
Rechberger's driver making it work in more recent kernels. This worked
for a short while, but then my usb stick lost its official (terratec
branded) usb id and I couldn't manage to make it work again since. The
current situation for my patched version of M. Rechberger's driver is,
that everything seems to work fine except for locking channels / some
tuning stuff ...well, I don't know exactly, I just see that kaffeine
detects the device and can scan for channels. While the 2 signal bars
(snr/quality) are pretty active and even the green tuning led (in
kaffeine) is very often active, there is just no channel entering the
list.

Regarding the official em28xx driver my usb stick is far away from
working. It stops as soon as when the firmware is being loaded:

[  576.009547] xc2028 5-0060: Incorrect readback of firmware version

I already wrote an email to Mauro Carvalho Chehab (the author of the
em28xx driver) and he told me that my firmware file must be corrupted.
That's xc3028-v27.fw. My version is from Ubuntu's nonfree firmware
package. But it's the same file as when I follow Mauro's description
of how to extract the firmware from the Windows driver
(extract_xc3028.pl). So it looks as if the Cinergy USB T XS needs a
different xc3028-v27.fw file.

What about the firmware in M. Rechberger's driver? Well, it doesn't
depend on an external firmware file, because the firmware is included
in xc3028/xc3028_firmwares.h, which has the following copyright note:
(c) 2006, Xceive Corporation. Looks like the official one, so I guess
it should work. And since my device was already working with that
firmware a while ago when Markus was still developing his driver I
guess I should focus on the following question:

=> How can I extract the firmware from Xceive's official
xc3028/xc3028_firmwares.h and making it work with the em28xx driver
(vanilla kernel)?

I wrote a perl script for this job ...well, at least for extraction.
Now I've got 48 firmware files:

XC3028_base_firmware_i2c_files_base_firmwares_8mhz_init_SEQUENCE
XC3028_base_firmware_i2c_files_base_firmwares_8mhz_mts_init_SEQUENCE
XC3028_base_firmware_i2c_files_base_firmwares_fm_init_SEQUENCE
XC3028_base_firmware_i2c_files_base_firmwares_fm_input1_init_SEQUENCE
XC3028_base_firmware_i2c_files_base_firmwares_init_SEQUENCE
XC3028_base_firmware_i2c_files_base_firmwares_mts_init_SEQUENCE
XC3028_std_firmware_bg_pal_a2_a_SEQUENCE
XC3028_std_firmware_bg_pal_a2_a_mts_SEQUENCE
XC3028_std_firmware_bg_pal_a2_b_SEQUENCE
XC3028_std_firmware_bg_pal_a2_b_mts_SEQUENCE
XC3028_std_firmware_bg_pal_nicam_a_SEQUENCE
XC3028_std_firmware_bg_pal_nicam_a_mts_SEQUENCE
XC3028_std_firmware_bg_pal_nicam_b_SEQUENCE
XC3028_std_firmware_bg_pal_nicam_b_mts_SEQUENCE
XC3028_std_firmware_dk_pal_a2_SEQUENCE
XC3028_std_firmware_dk_pal_a2_mts_SEQUENCE
XC3028_std_firmware_dk_pal_nicam_SEQUENCE
XC3028_std_firmware_dk_pal_nicam_mts_SEQUENCE
XC3028_std_firmware_dk_secam_a2_dk1_SEQUENCE
XC3028_std_firmware_dk_secam_a2_dk1_mts_SEQUENCE
XC3028_std_firmware_dk_secam_a2_l_dk3_SEQUENCE
XC3028_std_firmware_dk_secam_a2_l_dk3_mts_SEQUENCE
XC3028_std_firmware_dtv6_atsc_2633_SEQUENCE
XC3028_std_firmware_dtv6_qam_2620_SEQUENCE
XC3028_std_firmware_dtv6_qam_2633_SEQUENCE
XC3028_std_firmware_dtv7_2620_SEQUENCE
XC3028_std_firmware_dtv7_2633_SEQUENCE
XC3028_std_firmware_dtv78_2620_SEQUENCE
XC3028_std_firmware_dtv78_2633_SEQUENCE
XC3028_std_firmware_dtv8_2620_SEQUENCE
XC3028_std_firmware_dtv8_2633_SEQUENCE
XC3028_std_firmware_fm_SEQUENCE
XC3028_std_firmware_i_pal_nicam_SEQUENCE
XC3028_std_firmware_i_pal_nicam_mts_SEQUENCE
XC3028_std_firmware_l_secam_am_SEQUENCE
XC3028_std_firmware_l_secam_nicam_SEQUENCE
XC3028_std_firmware_lp_secam_nicam_SEQUENCE
XC3028_std_firmware_mn_ntscpal_a2_SEQUENCE
XC3028_std_firmware_mn_ntscpal_a2_lcd_SEQUENCE
XC3028_std_firmware_mn_ntscpal_a2_lcd_nogd_SEQUENCE
XC3028_std_firmware_mn_ntscpal_a2_mts_SEQUENCE
XC3028_std_firmware_mn_ntscpal_btsc_SEQUENCE
XC3028_std_firmware_mn_ntscpal_btsc_lcd_SEQUENCE
XC3028_std_firmware_mn_ntscpal_btsc_lcd_nogd_SEQUENCE
XC3028_std_firmware_mn_ntscpal_eiaj_SEQUENCE
XC3028_std_firmware_mn_ntscpal_mts_SEQUENCE
XC3028_std_firmware_mn_ntscpal_mts_lcd_SEQUENCE
XC3028_std_firmware_mn_ntscpal_mts_lcd_nogd_SEQUENCE

What do I do now? How can I pack them into 1 firmware file that is
compatible with the kernel's em28xx driver?

Thorsten

P.S.: There's also another thing I was trying - I have the Windows BDA
driver's emBDA.sys file that consists of the firmware. Unfortunately
Mauro's extract_xc3028.pl doesn't work with it, because it works with
fixed offsets, thus it is tightly bound to the HVR driver Mauro was
using for extraction, which is hcw85bda.sys. I tried to find the same
hex patterns in my emBDA.sys that I could see at the offsets in
hcw85bda.sys, but I was not very successful. I think I could find 4
base firmware files and ~30 std firmware files, but I don't know their
sizes and ~10 offsets (or more) are still missing.
