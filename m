Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GJtqgJ003598
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 15:55:52 -0400
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GJtE8Y025789
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 15:55:14 -0400
Received: by el-out-1112.google.com with SMTP id n30so2689461elf.7
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 12:55:14 -0700 (PDT)
Message-ID: <37219a840803161255u33ed14d9p327c0f68db3cd13c@mail.gmail.com>
Date: Sun, 16 Mar 2008 15:55:14 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: Linux-dvb <linux-dvb@linuxtv.org>,
	"Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: [RFC] Hybrid Tuner Refactoring, phase 3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Phase three of my hybrid tuner refactoring work deals with the
"tuner-simple" and "dvb-pll" tuner modules.

There are a number of "simple", four (or five) -byte "tin can" tuners
that each use both the tuner-simple module for analog tuning support,
and the dvb-pll module for digital tuning support.  This has been a
long-standing issue, since a single piece of hardware is being
controlled by two separate driver modules.  Each individual module can
never have full knowledge of the device's state, since tuner-simple
and dvb-pll do not interact with one another.

In the "tuner-refactor-phase-3" development repository, I've converted
a selection of drivers to use tuner-simple for both analog and digital
tuning support, while disabling digital-only support for those tuners
in the dvb-pll module.  The advantage is that a single driver is now
supporting both analog and digital tuning functions for each device,
and each side of the driver has full access to the tuner hardware and
driver state.

http://linuxtv.org/hg/~mkrufky/tuner-refactor-phase-3

Users of devices that use the Philips TUV1236d or FCV1236d tuners will
find that they now have better control of rf input selection.  see
"modinfo tuner-simple" for details.  Devices that use those tuners
include, Kworld PlusTV / ATSC 110/115, ATi HDTV Wonder, pcHDTV 2000,
Hauppauge WinTV-D, DViCO FusionHDTV II, Kworld USB2800, Sasem / OnAir
HDTV USB2.  (note: some of the drivers for these devices only support
analog tuning at the moment)

I've already successfully tested these changes on devices that use the
following tuners:

LG TDVS-H06xF
Philips FMD1216ME
Philips FCV 1236D
Philips TUV 1236D
Thomson DTT 761x

(  It's handy to have my own v4l/dvb supported cards museum ;-)  )

The following three devices remain untested, but I do not expect any problems:

Microtune 4042 FI5 (DViCO FusionHDTV3 Gold-Q)
Thomson FE6600 (DViCO FusionHDTV DVB-T Hybrid)
Philips TD1316 (Avermedia AverTV DVB-T 777)

Please test the changes on your devices, and post any feedback to this thread.

-Michael Krufky

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
