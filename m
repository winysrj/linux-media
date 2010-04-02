Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f217.google.com ([209.85.218.217]:54412 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab0DBPCO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 11:02:14 -0400
Received: by bwz9 with SMTP id 9so1662583bwz.29
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 08:02:12 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 2 Apr 2010 16:54:30 +0200
Message-ID: <k2pd9def9db1004020754n2e035de8z8d6af54e6bddb281@mail.gmail.com>
Subject: V4L2 application compliance testing
From: Markus Rechberger <mrechberger@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

we recently got around to test several video4linux2 applications and
noticed that quite a few kernel drivers do not provide support
properly testing applications for v4l2 compliance.

http://sundtek.de/images/vivi.png

we ported and modified the vivi to userspace, the testpackage is
supposed to work with x86-64/x86-32/arm (eabi4/oabi)/mips and
ppc(32/64),
This virtual driver is also supposed to support all systems starting
from Debian Potato (32bit) on.

A quick shot for installing and testing:
$ wget http://sundtek.de/media/sundtek_installer.sh
$ chmod 777 sundtek_installer.sh
$ ./sundtek_installer.sh

adding a virtual driver (run this for each virtual interface you want to have):
$ /opt/bin/mediaclient --tvdummy

displaying the virtual device information:
$ /opt/bin/mediaclient -e
**** List of Media Hardware Devices ****
device 1: [Virtual Video (vivi) Capture Board]  ANALOG-TV
  [ANALOG-TV]:
     VIDEO0: /dev/video2

deleting the virtual device:
$ /opt/bin/mediaclient --remove=[deviceid as indicated with mediaclient -e]

to remove the package
$ ./sundtek_installer -u

So far we tested:
* VLC (v4l1)
* VLC (v4l2)
* tvtime
* mplayer
* motion (v4l1)
* ekiga
* MythTV
* xawtv
* Zapping (poorly this application does not work with all
distributions anymore since it's not maintained anymore).

The virtual driver prints the frequency into the video when testing the tuner.

If this driver works out with your application you can be sure that
most legacy videodrivers will also work with your
TV application. Aside of that we're also about to release the FreeBSD
and Mac ports for the virtual driver (the
package basically ports the V4L1/V4L2 interface to all other operating systems).

Markus
