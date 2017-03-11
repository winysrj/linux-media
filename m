Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:35459 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754075AbdCKSBA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 13:01:00 -0500
Received: by mail-pg0-f50.google.com with SMTP id b129so49837646pgc.2
        for <linux-media@vger.kernel.org>; Sat, 11 Mar 2017 10:00:59 -0800 (PST)
MIME-Version: 1.0
From: Dmitrii Shcherbakov <fw.dmitrii@gmail.com>
Date: Sat, 11 Mar 2017 21:00:58 +0300
Message-ID: <CAC1b7XExt=f97GW0vh2jOppMwZJdkL1iZX0i6_T2rzsEOcKO4g@mail.gmail.com>
Subject: usb_video.c: 0bda:579f Realtek - corrupted frames and low FPS of
 captured mjpeg video frames
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

I have a usb camera built into my laptop (hardware details here
https://paste.ubuntu.com/24126969/) and I am looking for some guidance
on how to debug it further - any feedback is highly appreciated.

I am aware that this hardware is probably buggy/does not follow the
UVC spec/vendor only cared about Windows etc.

I am trying to capture mjpeg-encoded video at various resolutions and
frame rates via ffmpeg using v4l2 and the uvc kernel driver.

Test results (kernel logs with uvc driver in verbose mode and ffmpeg
output are included):
https://paste.ubuntu.com/24126930/
https://paste.ubuntu.com/24126960/

uname -r
4.11.0-041100rc1-generic

Conclusions:
- using any resolution higher than 640x480 results in corrupted bottom
half of the image (grey and green artifacts)
- frame rate is low on any resolution, even when I specify 640x480
with 30 or 15 fps via v4l2 it is nowhere near that point

frame=3D  179 fps=3D7.7 q=3D-1.0 Lsize=3D    3882kB time=3D00:00:23.06
bitrate=3D1378.6kbits/s speed=3D0.994x

- the kernel log is filled with the following messages

=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: uvc_v4l2_mmap
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: Allocated 5 URB buff=
ers of
32x512 bytes each.
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: frame 1 stats: 0/0/1=
 packets,
0/0/1 pts (!early initial), 0/1 scr, last pts/stc/sof
6446951/6832111/975
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: Marking buffer as ba=
d (error bit set).
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: Frame complete (FID =
bit toggled).
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: frame 2 stats: 0/0/1=
 packets,
0/0/1 pts (!early initial), 0/0 scr, last pts/stc/sof 3617775107/0/0
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: Marking buffer as ba=
d (error bit set).
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: Frame complete (EOF =
found).
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: Dropping payload (ou=
t of sync).
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: frame 3 stats: 0/0/2=
 packets,
1/1/2 pts (!early initial), 0/1 scr, last pts/stc/sof
8413602/8799007/1106
=D0=BC=D0=B0=D1=80 07 00:15:31 blade kernel: uvcvideo: Frame complete (EOF =
found).
=D0=BC=D0=B0=D1=80 07 00:15:32 blade kernel: uvcvideo: Dropping payload (ou=
t of sync).
=D0=BC=D0=B0=D1=80 07 00:15:32 blade kernel: uvcvideo: Marking buffer as ba=
d (error bit set).
=D0=BC=D0=B0=D1=80 07 00:15:32 blade kernel: uvcvideo: Dropping payload (ou=
t of sync).

- some entity types were not initialized at module loading time

=D0=BC=D0=B0=D1=80 06 20:47:35 blade kernel: uvcvideo: Found UVC 1.00 devic=
e USB
Camera (0bda:579f)
=D0=BC=D0=B0=D1=80 06 20:47:35 blade kernel: uvcvideo: Forcing device quirk=
s to 0x80
by module parameter for testing purpose.
=D0=BC=D0=B0=D1=80 06 20:47:35 blade kernel: uvcvideo: Please report requir=
ed quirks
to the linux-uvc-devel mailing list.
=D0=BC=D0=B0=D1=80 06 20:47:35 blade kernel: uvcvideo 1-7:1.0: Entity type =
for entity
Extension 4 was not initialized!
=D0=BC=D0=B0=D1=80 06 20:47:35 blade kernel: uvcvideo 1-7:1.0: Entity type =
for entity
Processing 2 was not initialized!
=D0=BC=D0=B0=D1=80 06 20:47:35 blade kernel: uvcvideo 1-7:1.0: Entity type =
for entity
Camera 1 was not initialized!
=D0=BC=D0=B0=D1=80 06 20:47:35 blade kernel: usbcore: registered new interf=
ace driver uvcvideo

- tried different quirks non of which made any difference (I can try a
specific one or a combination if there are any ideas). I cannot
diagnose what it is so this was just random poking.

- a similar thread for XPS 12 with a Realtek webcam
https://www.spinics.net/lists/linux-media/msg73476.html

- the buffer is marked as bad in uvc_video_decode_start based upon a
UVC_STREAM_ERR flag:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/media/usb/uvc/uvc_video.c#n1004

If anybody has any pointers/suggestions, please let me know.

Thanks in advance!
