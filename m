Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f200.google.com ([209.85.223.200]:59881 "EHLO
	mail-iw0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbZIIVm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 17:42:59 -0400
Received: by iwn38 with SMTP id 38so18695iwn.33
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 14:43:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Sep 2009 16:43:02 -0500
Message-ID: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com>
Subject: LinuxTV firmware blocks all wireless connections / traffic
From: Clinton Meyer <clintonmeyer22@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Purchased a Hauppauge WinTV-HVR-950Q USB Hybrid TV stick to capture ATSC OTA TV.

Am running MEPIS 8.06 on all three machines, Debian 5 Lenny based, KDE
3.5.10, kernel 2.6.27-1-mepis-smp

All three machines now have wireless blocked, either do not connect or
all packets dropped/blocked if a connection is made.

Used the resources from LinuxTV (dot) org

to get it working, they are referenced and posted as follows:
 linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-950Q#Firmware

******** *********** **********
 Quote:
In order to use the LinuxTV driver, you need to download and install
the firmware for the xc5000.

Quote:
wget  ... steventoth (dot) net/linux/xc50...25271_WHQL (dot) zip
wget ... steventoth (dot) net/linux/xc5000/extract (dot) sh
 sh extract (dot) sh
cp dvb-fe-xc5000-1.1 (dot) fw /lib/firmware
:Unquote

Note: Though the usual directory location in which the firmware file
is placed is /lib/firmware, this may differ in the case of some
distros; consult your distro's documentation for the appropriate
location.

The firmware will be added lazily (on-demand) when you first use the driver.
Drivers

The xc5000 driver needed for this WinTV-HVR-950Q is already part of
the latest Linux kernel (part of v4l-dvb drivers).

Analog support was merged into the mainline v4l-dvb tree on March 18, 2009.
:Unquote
******** *********** ********** ******** *********** **********
So on Saturday I got this up and running... and Sunday morning
recorded one show successfully that had set up on a timer.

Then set up three consecutive shows for the afternoon.
They were all part of a series on the same channel. Here are the results:

    * Show A, 2.5 hours long, 13.2gb file size, appears to be OK.
    * Show B, 2.0 hours long, 3.7gb file size, appears to be OK.
     * Show C, supposed to be 2.0 hours long, result was 2.7gb file
size, about the first hour is missing.

At about this point, I lost wireless internet connectivity on TV
recording laptop. Machine sees the access point, but won't connect.

Went to my main desktop where i had first worked with this Hauppauge
WinTV-HVR-950Q USB Hybrid TV stick and that machine also lost
internet, even though it was right next to AP and got a very good
signal.

Thought it was maybe the AP, so switched it out for a working spare.
 Same results.
Packed up laptop and a spare laptop, along with a MEPIS 8.06 LiveCD
and an 8.06 Live USB stick and hit the road to go to a reliable high
speed wifi spot.
Same results... changins ISPs resulted in the same issues.
 Also same ting happened with the spare laptop, an IBM T43 Thinkpad I
had also done the "wget ... steventoth (dot)
net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL (dot) zip"
firmware thing to.

Was able to get one machine, while running a LIVE USB session, to
connect, but zero packets received.. ALL were blocked. The connection
information said ALL packets were dropped.
 None of the two other machines connected to wireless on a LiveCD or
LiveUSB thing too
Three machines. All different brands (HP, Dell, and IBM) with
different wifi cards. All three see the access point ESSID, but none
connect.

This does not *feel* good. What got flashed? Can this be resolved?

Came home. No difference. Grabbed a laptop that i had NOT done the
firmware thing to and that is what I am using to write this. Hooked
right up to the AP.

Please help... that is too much hardware disabled for me to think calmly.
I'd really like to make the USB tv tuner work... what a great way to
PVR / DVR, but I need wireless.

Can provide any details requested to drive this towards a fix!

Thank you,
Clinton
