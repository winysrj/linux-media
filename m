Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55602 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab1JYDPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 23:15:45 -0400
Received: by iaby12 with SMTP id y12so61276iab.19
        for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 20:15:44 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Oct 2011 20:15:44 -0700
Message-ID: <CAC_8CRpShRg83NPMSMhiJ1fGZt2O7SHaKtvdyRjoRysLZNQaHw@mail.gmail.com>
Subject: Re: changed em28xx-cards-c; Plextor ConvertX AV100U now works!
From: Chris Tooley <euxneks@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, I'd like to confirm that the steps as posted by Don Kramer as per:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg19329.html

specifically:
adding this code to em28xx-cards.c (with the latest version of v4l
media_build git repo)

{ USB_DEVICE(0x093b, 0xa003),
            .driver_info = EM2820_BOARD_PINNACLE_DVC_90 }, /* Plextor Corp.
ConvertX AV100U A/V Capture Audio */

Has allowed me to record video with my Plextor AV100U video to USB
device. I was successfully able to get video from the S-Video input
and save as a mov file using "streamer" ala:

    streamer -c /dev/video0 -r30 -s640x480 -t 0:30 -o temp.mov

Mr. Kramer, I'd like to thank you for posting your solution!

$ uname -ar
Linux seraphim 2.6.38-12-generic #51-Ubuntu SMP Wed Sep 28 14:27:32
UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 11.04
Release:	11.04
Codename:	natty

(Also, I found that VLC was kind of glitchy, I suspect it is selecting
PAL when I am NTSC, PAL will get you a greyscale image with a big
green block underneath it when I select that using tvtime)

I haven't tested audio recording though, however, streamer seems to
allow a number of options, I suspect it might automatically select the
audio inputs from the device but I haven't tested that theory, and if
not, there is the audio in I can hack together ;)  The video is the
biggest thing in my opinion.

Is there a way I we can get this added to v4l? It's like 2 lines at most.

Thanks,
-Chris
