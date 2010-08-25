Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64942 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0HYXh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 19:37:58 -0400
Received: by iwn5 with SMTP id 5so1006890iwn.19
        for <linux-media@vger.kernel.org>; Wed, 25 Aug 2010 16:37:57 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Aug 2010 19:37:57 -0400
Message-ID: <AANLkTi=JP+eOyx2V4MEQw6ntZFM7djfp_twZPCp0cxPh@mail.gmail.com>
Subject: firmware / i2c bug in hdpvr
From: martin forget <mforget0@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

issue (device lockup) on hauppage hdpvr

symptoms:   the hdpvr stays in encoding mode (blue light on) , but
cat /dev/video0 results in input/output error after 5-15minutes of
encoding 480i(front-input) or 480p(back input) video.

this issue is not hapenning when encoding 720p or 1080i video.

context:
hdpvr running firmware 1.5.7  (latest from hauppage)
i have tried on multiple systems , running different distros (fedora,
ubuntu jaunty,karmic,lucid) and with multiple hdpvr units and the bug
is consistent.

my system (one of the test systems)
ubuntu karmic, with a v4l-dvb git from 2010-08-19

how to replicate:
have a hdpvr running, connect the front-input to a regular composite  input

v4l2-ctl --set-input=1 --set-audio-input=2  (composite input, 480i)
dd if=/dev/video0 of=/somewhere.ts
(leave it running for 10-15 minutes)

(note: this will not happen when using the component input at 720p or
1080x, only with a resolution of 480i(composite)  or 480p(component) )

the dd will die (in/out error)
then the device blue light will be light and there is no way to reset
the device other than a power-cycle on the hdpvr.

when the hdpvr is locked,

cat /dev/video results in input/output error
v4l2-ctl --list-video-fmt will result in bad-address
lsusb -v will take 5-10 seconds and report "connection lost" when
trying to give details about the hdpvr.

rmmod hdpvr/ modprobe hdpvr will not correct the lock-up. ,
but reports "device init failed"   (when hdpvr_debug=1)

physically power-cycling the device will correct the problem .

-thanks
-martin
