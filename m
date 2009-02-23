Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:58762 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZBWKCk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 05:02:40 -0500
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: Haupauge Nova-T 500 2.6.28 regression dib0700
Date: Mon, 23 Feb 2009 10:52:25 +0100
Cc: dheitmueller@linuxtv.org, pb@linuxtv.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231052.25875.j@jannau.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have some difficulties with the Hauppauge Nova-T 500 and 2.6.28 kernels.

Following USB errors appear with 2.6.28.4 every 100ms:

Feb 15 02:46:03 golem [ 7720.876132] usb 2-1: events/3 timed out on ep1in len=0/6
Feb 15 02:46:03 golem [ 7720.976039] usb 2-1: events/3 timed out on ep1in len=0/6
Feb 15 02:46:03 golem [ 7721.076068] usb 2-1: events/3 timed out on ep1in len=0/6

The device is still useable but occasionally I see the same error
 with additional usb errors (iirc same kernel and config)

Feb 17 20:33:17 golem [   14.733031] ehci_hcd 0000:01:06.2: reused qh ffff8800bf80d140 schedule
Feb 17 20:33:17 golem [   14.733040] usb 2-1: link qh64-0001/ffff8800bf80d140 start 63 [2/0 us]
Feb 17 20:33:17 golem [   14.783035] usb 2-1: unlink qh64-0001/ffff8800bf80d140 start 63 [2/0 us]
Feb 17 20:33:17 golem [   14.783107] usb 2-1: events/3 timed out on ep1in len=0/6
...
Feb 17 20:34:12 golem [  128.130059] ehci_hcd 0000:01:06.2: reused qh ffff8800bf80d140 schedule
Feb 17 20:34:12 golem [  128.130069] usb 2-1: link qh64-0001/ffff8800bf80d140 start 63 [2/0 us]
Feb 17 20:34:12 golem [  128.131007] ehci_hcd 0000:01:06.2: force halt; handhake ffffc20000050014 00 
004000 00000000 -> -110

ehci gives up and the device is unuseabe.

This is still the case with 2.6.28.7.

git bisect blames following change:

| commit 99afb989b05b9fb1c7b3831ce4b7a000b214acdb
| Author: Devin Heitmueller <devin.heitmueller@gmail.com>
| Date:   Sat Nov 15 07:13:07 2008 -0300
|
|     V4L/DVB (9639): Make dib0700 remote control support work with firmware v1.20

2.6.28.x with DVB drivers from v4l-dvb hg works as expected bu I fail
to see which changeset fixed it. If you have an idea I'll test it.
Otherwise I'll bisect v4l-dvb hg.

This should be fixed in 2.6.28-stable.

Janne
