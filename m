Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53477 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1KLKdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 05:33:18 -0500
Received: by vws1 with SMTP id 1so4049078vws.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 02:33:17 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 12 Nov 2011 10:33:17 +0000
Message-ID: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com>
Subject: HVR-4000 may be broken in kernel mods (again) ?
From: "jonathanjstevens@gmail.com" <jonathanjstevens@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Description of problem:
Support for Hauupauge HVR-4000 appears to be broken (again) in kernel mods.
This is a bit of a tale of woe, but this hardware is supposed to have been
sorted in stock kernel roundabout 3.0.
Stock F16 kernel cannot scan or tune in mythtv, kaffeine, w_scan, or dvbscan.
Compiled/Installed latest video-media build still no joy.
I used another USB DVB (nova-t) to scan, and using the results obtained from
w_scan on this managed to get tzap to FE LOCK. However this only worked with
tzap - no other app can get a lock.
Have tested with i2c reset patch enabled and not, and also with strobing patch
enabled and not (cs88-dvb.c). Also with mythtv kludge (delaying on FE close in
dvbutils.cpp). All make no difference.
So sad :(

Version-Release number of selected component (if applicable):
Linux mythtvtuner.home 3.1.0-7.fc16.x86_64 #1 SMP Tue Nov 1 21:10:48 UTC 2011
x86_64 x86_64 x86_64 GNU/Linux

How reproducible:
Install F16 and try to make use of HVR-4000.

Steps to Reproduce:
1. Install F16 on a machine with HVR-4000
2. Try to use it
3. Cry
Actual results:
Can't scan or tune.
Expected results:
Can scan and tune and be happy.
Additional info:
Should mention this machine is also running Xen.
If necessary I have a spare machine I can put a HVR-4000 into and can compile
whatever you want to try to fix this. Pretty sure this is a problem upstream in
video-media, but will report here to try and get some help!
Willing to put in the hours this side to get to the bottom of this,
sorry I don't have the programming skills to attack it myself.
All the problems historically that the HVR-4000 has had in v4l were supposed to
be fixed in 3.0...
Let me know what additional info you might want?
Jonathan
