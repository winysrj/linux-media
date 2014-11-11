Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:51858 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKKRqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 12:46:47 -0500
Received: by mail-vc0-f180.google.com with SMTP id hy10so4559638vcb.11
        for <linux-media@vger.kernel.org>; Tue, 11 Nov 2014 09:46:46 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 11 Nov 2014 19:46:46 +0200
Message-ID: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
Subject: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas or help?
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: "hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At Bluecherry, we have issues with servers which have 3 solo6110 cards
(and cards have up to 16 analog video cameras connected to them, and
being actively read).
This is a kernel which I tested with such a server last time. It is
based on linux-next of October, 31, with few patches of mine (all are
in review for upstream).
https://github.com/krieger-od/linux/ . The HEAD commit is
949e18db86ebf45acab91d188b247abd40b6e2a1 at the moment.

The problem is the following: after ~1 hour of uptime with working
application reading the streams, one card (the same one every time)
stops producing interrupts (counter in /proc/interrupts freezes), and
all threads reading from that card hang forever in
ioctl(VIDIOC_DQBUF). The application uses libavformat (ffmpeg) API to
read the corresponding /dev/videoX devices of H264 encoders.
Application restart doesn't help, just interrupt counter increases by
64. To help that, we need reboot or programmatic PCI device reset by
"echo 1 > /sys/bus/pci/devices/0000\:03\:05.0/reset", which requires
unloading app and driver and is not a solution obviously.

We had this issue for a long time, even before we used libavformat for
reading from such sources.
A few days ago, we had standalone ffmpeg processes working stable for
several days. The kernel was 3.17, the only probably-relevant change
in code over the above mentioned revision is an additional bool
variable set in solo_enc_v4l2_isr() and checked in solo_ring_thread()
to figure out whether to do or skip solo_handle_ring(). The variable
was guarded with spin_lock_irqsave(). I am not sure if it makes any
difference, will try it again eventually.

Any thoughts, can it be a bug in driver code causing that (please
point which areas of code to review/fix)? Or is that desperate
hardware issue? How to figure out for sure whether it is the former or
the latter?

-- 
Bluecherry developer.
