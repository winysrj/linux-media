Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46804 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab0IOPpF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 11:45:05 -0400
Received: by qwh6 with SMTP id 6so249639qwh.19
        for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 08:45:04 -0700 (PDT)
MIME-Version: 1.0
From: Christopher Friedt <chrisfriedt@gmail.com>
Date: Wed, 15 Sep 2010 11:44:44 -0400
Message-ID: <AANLkTinAjJ2_qxFVJuJ=TRr7+OJPtHnESKW7yHpoXev7@mail.gmail.com>
Subject: pwc driver breakage in recent(ish) kernels (for old hardware)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everyone,

I've been using a Logitech Sphere for years on various projects. This
model is probably from the first batch ever made. In lsusb it shows up
as

046d:08b5 Logitech, Inc. QuickCam Sphere

It's a bit troublesome, because on older kernel versions (~2.4.x,
~2.6.2x) I never had a single issue with this hardware at all, on
several different platforms ranging from x86 to x86_64, to arm
(ep93xx), etc. However, somewhere between then and now, the pwc driver
underwent some changes rendering this device unusable in any recent
kernel. All of my old apps and new apps (including cheese, mplayer,
etc) simply hang indefinitely waiting to read a single frame (using
the v4l2 mmap api). The v4l2 read api also hangs indefinitely (using
pwcgrab). A few of the very old apps that I have also use the v4l1
api, with a 2.4.26 kernel, and that actually works.

I can verify that the hardware itself is fine on windows (also using
very old drivers from Logitech).

Who has been working on this driver? What were the major changes that
have been applied? I'm guessing that the bridge / sensor init sequence
has been messed up somehow. Any ideas?

Cheers,

Chris
