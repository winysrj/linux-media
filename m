Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35620 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab0BYAxj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 19:53:39 -0500
Received: by gyh20 with SMTP id 20so1005398gyh.19
        for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 16:53:38 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 25 Feb 2010 08:53:38 +0800
Message-ID: <6e8e83e21002241653q2928b041mecf2e9eaffcada79@mail.gmail.com>
Subject: Development of TM6000
From: Bee Hock Goh <beehock@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

>From what I have gather so far, it seem that you are the only person
who might still be keen in the continue development of TM6000 driver.
Apparently, I saw that you are also pretty much occupied with other
works at hand.

I have recently bought a USB stick(MSI Vox II) that have the
TM5600/XC2028 chipset. Using the latest source from
http://linuxtv.org/hg/v4l-dvb and activating the TM6000 under staging,
I was able to detect the tuner stick. Firmware was extracted using the
tridvid.sys from the windows driver CD.

Unfortunately, this is the furthest that I can go. Both tvtime and
mplayer were able to load but the notebook just freeze some time.

Do you have any pointer on how I can get it to work?

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: Trident TVMaster TM5600/6000
 Tuner cap:
 Tuner rxs: MONO
 Capabilites:  video capture  tuner  read/write  streaming
 supported norms: 0 = NTSC-M; 1 = NTSC-M-JP; 2 = PAL; 3 = PAL-BG; 4 =
PAL-H; 5 = PAL-I; 6 = PAL-DK; 7 = PAL-M; 8 = PAL-N; 9 = PAL-Nc; 10 =
PAL-60; 11 = SECAM; 12 = SECAM-B; 13 = SECAM-G; 14 = SECAM-H; 15 =
SECAM-DK; 16 = SECAM-L; 17 = SECAM-Lc;
 inputs: 0 = Television; 1 = Composite; 2 = S-Video;
 Current input: 0
 Current format: YUYV
v4l2: current audio mode is : MONO
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument


On a side note, I am starting to look through documentation on
developing v4l driver so that I can work on the existing TM6000
driver. Unfortunately, while I am verse in programming(userspace
only), C and Assembly is only something I am familiar with many years
back during school days. So its going to take a while for me to catch
up.

I guess working on the driver on my own might be the only possibility
if you cannot afford the time to work on it.
