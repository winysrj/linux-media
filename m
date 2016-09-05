Return-path: <linux-media-owner@vger.kernel.org>
Received: from pv33p04im-asmtp002.me.com ([17.143.181.11]:48388 "EHLO
        pv33p04im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932140AbcIEToA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 15:44:00 -0400
Received: from process-dkim-sign-daemon.pv33p04im-asmtp002.me.com by
 pv33p04im-asmtp002.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0OD100300PVU5S00@pv33p04im-asmtp002.me.com> for
 linux-media@vger.kernel.org; Mon, 05 Sep 2016 19:43:59 +0000 (GMT)
Content-type: multipart/mixed;
 boundary="Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41"
MIME-version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: uvcvideo error on second capture from USB device,
 leading to V4L2_BUF_FLAG_ERROR
From: Oliver Collyer <ovcollyer@mac.com>
In-reply-to: <20160904192538.75czuv7c2imru6ds@zver>
Date: Mon, 05 Sep 2016 22:43:49 +0300
Cc: Andrey Utkin <andrey_utkin@fastmail.com>
Message-id: <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi

So I built 4.8-rc5 from source, added in a line to videobuf2-v4l2.c to =
output to the kernel debug when it sets the error flag and repeated my =
tests.

I get exactly the same result.

I also enabled the uvc_trace output in case it helps.

Attached are the following files:

dmesg_reload_uvcvideo_trace - this shows the dmesg output after running =
modprobe to remove and then re-add the uvcvideo module. This was done at =
the start of my test to clean things up.
dmesg_first_ffmpeg_capture - this shows the dmesg output after running a =
test capture using ffmpeg. All is working smoothly at this point.
ffmpeg_first_ffmpeg_capture - this is the output from ffmpeg which =
corresponds to the above. FFmpeg doesn=E2=80=99t report any problems.
dmesg_second_ffmpeg_capture - this shows where it goes wrong. First you =
get error -71 (EPROTO) somewhere in uvcvideo. After this, my additional =
trace picks up the setting of the V4L2_BUF_FLAG_ERROR flag. This occurs =
on line 267 of videobuf2-v4l2.c
ffmpeg_second_ffmpeg_capture - this is the output from ffmpeg which =
corresponds to the above. As you can see it reports a corrupted dequeued =
buffer. On this occasion it handles it ok, with just one further warning =
regarding =E2=80=9CPast duration too large=E2=80=9D.
fmpeg_third_ffmpeg_capture - I ran a third ffmpeg capture and this time =
you can see FFmpeg struggling to deal with the difference in the =
timestamps between the input and the output, presumably a knock-on =
effect of the initial buffer corruption. These warnings continue =
indefinitely if you leave FFmpeg running. The only workaround I=E2=80=99ve=
 so far come up with is to add an option to FFmpeg to simply discard the =
timestamps from the capture and calculate new ones, or to raise the =
threshold FFmpeg uses for this warning but this is rather papering over =
the cracks I feel.
dmesg_api_capture_example - finally I ran the code that comes with the =
V4L2 API to confirm that it isn=E2=80=99t an issue being caused by =
FFmpeg. As you can see, error -71 occurs followed by the usual buffer =
error flag.

I do not have any knowledge of uvcvideo and the associated classes apart =
from the studying I=E2=80=99ve done the past day or two, but it seems =
likely that error -71 and the later setting of V4L2_BUF_FLAG_ERROR are =
linked. Also, the fact it only happens in captures after the first one =
suggests something isn=E2=80=99t being cleared down or released properly =
in uvcvideo/v4l2-core at the end of the first capture.

Let me know what I need to do next to further narrow it down.

Regards

Oliver


--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41
Content-Disposition: attachment;
	filename=dmesg_api_capture_example.txt
Content-Type: text/plain;
	name="dmesg_api_capture_example.txt"
Content-Transfer-Encoding: quoted-printable

[ 1138.087237] uvcvideo: uvc_v4l2_open
[ 1138.180909] uvcvideo: Resuming interface 0
[ 1138.180910] uvcvideo: Resuming interface 1
[ 1138.182123] uvcvideo: uvc_v4l2_mmap
[ 1138.182189] uvcvideo: uvc_v4l2_mmap
[ 1138.182239] uvcvideo: uvc_v4l2_mmap
[ 1138.182286] uvcvideo: uvc_v4l2_mmap
[ 1138.182440] uvcvideo: Allocated 5 URB buffers of 16x1024 bytes each.
[ 1138.182446] uvcvideo: uvc_v4l2_poll
[ 1138.185884] uvcvideo: Non-zero status (-71) in video completion =
handler.
[ 1138.185924] uvcvideo: uvc_v4l2_poll
[ 1138.185927] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[ 1138.185940] uvcvideo: uvc_v4l2_poll
[ 1138.185941] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[ 1138.185945] uvcvideo: uvc_v4l2_poll
[ 1138.185946] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[ 1138.185948] uvcvideo: uvc_v4l2_poll
[ 1138.185949] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[ 1138.185953] uvcvideo: uvc_v4l2_poll
[ 1138.196427] uvcvideo: Frame complete (EOF found).
[ 1138.196453] uvcvideo: uvc_v4l2_poll
[ 1138.196473] uvcvideo: frame 1 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[ 1138.196475] uvcvideo: uvc_v4l2_poll
[ 1138.206993] uvcvideo: Frame complete (EOF found).
[ 1138.207022] uvcvideo: uvc_v4l2_poll
[ 1138.207046] uvcvideo: uvc_v4l2_poll
[ 1138.233023] uvcvideo: frame 2 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[ 1138.243566] uvcvideo: Frame complete (EOF found).
[ 1138.243582] uvcvideo: uvc_v4l2_poll
[ 1138.243613] uvcvideo: uvc_v4l2_poll
[ 1138.273054] uvcvideo: frame 3 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[ 1138.283533] uvcvideo: Frame complete (EOF found).
[ 1138.283547] uvcvideo: uvc_v4l2_poll
[ 1138.283560] uvcvideo: uvc_v4l2_poll
[ 1138.313057] uvcvideo: frame 4 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[ 1138.323574] uvcvideo: Frame complete (EOF found).
[ 1138.323589] uvcvideo: uvc_v4l2_poll
[ 1138.323621] uvcvideo: uvc_v4l2_poll
[ 1138.353018] uvcvideo: frame 5 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[ 1138.363587] uvcvideo: Frame complete (EOF found).
[ 1138.363645] uvcvideo: uvc_v4l2_poll
[ 1138.372573] uvcvideo: uvc_v4l2_release
[ 1140.376210] uvcvideo: Suspending interface 1
[ 1140.376211] uvcvideo: Suspending interface 0


--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41
Content-Disposition: attachment;
	filename=dmesg_first_ffmpeg_capture.txt
Content-Type: text/plain;
	name="dmesg_first_ffmpeg_capture.txt"
Content-Transfer-Encoding: quoted-printable

[  773.705527] uvcvideo: uvc_v4l2_open
[  773.800021] uvcvideo: Resuming interface 0
[  773.800023] uvcvideo: Resuming interface 1
[  773.800047] uvcvideo: Trying format 0x32315559 (YU12): 1920x1080.
[  773.800048] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  773.800422] uvcvideo: Trying format 0x32315559 (YU12): 1920x1080.
[  773.800423] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  773.800787] uvcvideo: Trying format 0x32315659 (YV12): 1920x1080.
[  773.800788] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  773.801158] uvcvideo: Trying format 0x50323234 (422P): 1920x1080.
[  773.801159] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  773.801532] uvcvideo: Trying format 0x56595559 (YUYV): 1920x1080.
[  773.801532] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  773.801925] uvcvideo: Setting frame interval to 1/25 (400000).
[  773.813144] uvcvideo: uvc_v4l2_mmap
[  773.813237] uvcvideo: uvc_v4l2_mmap
[  773.813300] uvcvideo: uvc_v4l2_mmap
[  773.813366] uvcvideo: uvc_v4l2_mmap
[  773.813428] uvcvideo: uvc_v4l2_mmap
[  773.813491] uvcvideo: uvc_v4l2_mmap
[  773.813552] uvcvideo: uvc_v4l2_mmap
[  773.813614] uvcvideo: uvc_v4l2_mmap
[  773.813677] uvcvideo: uvc_v4l2_mmap
[  773.813739] uvcvideo: uvc_v4l2_mmap
[  773.813800] uvcvideo: uvc_v4l2_mmap
[  773.813862] uvcvideo: uvc_v4l2_mmap
[  773.813923] uvcvideo: uvc_v4l2_mmap
[  773.813985] uvcvideo: uvc_v4l2_mmap
[  773.814046] uvcvideo: uvc_v4l2_mmap
[  773.814107] uvcvideo: uvc_v4l2_mmap
[  773.814175] uvcvideo: uvc_v4l2_mmap
[  773.814236] uvcvideo: uvc_v4l2_mmap
[  773.814297] uvcvideo: uvc_v4l2_mmap
[  773.814358] uvcvideo: uvc_v4l2_mmap
[  773.814420] uvcvideo: uvc_v4l2_mmap
[  773.814480] uvcvideo: uvc_v4l2_mmap
[  773.814542] uvcvideo: uvc_v4l2_mmap
[  773.814603] uvcvideo: uvc_v4l2_mmap
[  773.814664] uvcvideo: uvc_v4l2_mmap
[  773.814725] uvcvideo: uvc_v4l2_mmap
[  773.814787] uvcvideo: uvc_v4l2_mmap
[  773.814848] uvcvideo: uvc_v4l2_mmap
[  773.814909] uvcvideo: uvc_v4l2_mmap
[  773.814971] uvcvideo: uvc_v4l2_mmap
[  773.815032] uvcvideo: uvc_v4l2_mmap
[  773.815092] uvcvideo: uvc_v4l2_mmap
[  773.815254] uvcvideo: Allocated 5 URB buffers of 16x1024 bytes each.
[  773.880959] uvcvideo: Frame complete (EOF found).
[  773.910414] uvcvideo: frame 1 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  773.920953] uvcvideo: Frame complete (EOF found).
[  773.950412] uvcvideo: frame 2 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  773.960953] uvcvideo: Frame complete (EOF found).
[  773.990411] uvcvideo: frame 3 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.000952] uvcvideo: Frame complete (EOF found).
[  774.030413] uvcvideo: frame 4 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.040964] uvcvideo: Frame complete (EOF found).
[  774.070411] uvcvideo: frame 5 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.080952] uvcvideo: Frame complete (EOF found).
[  774.110410] uvcvideo: frame 6 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.120951] uvcvideo: Frame complete (EOF found).
[  774.150411] uvcvideo: frame 7 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.160951] uvcvideo: Frame complete (EOF found).
[  774.190410] uvcvideo: frame 8 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.200950] uvcvideo: Frame complete (EOF found).
[  774.230410] uvcvideo: frame 9 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.240951] uvcvideo: Frame complete (EOF found).
[  774.270410] uvcvideo: frame 10 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.280946] uvcvideo: Frame complete (EOF found).
[  774.310410] uvcvideo: frame 11 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.320950] uvcvideo: Frame complete (EOF found).
[  774.350411] uvcvideo: frame 12 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.360950] uvcvideo: Frame complete (EOF found).
[  774.390409] uvcvideo: frame 13 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.400949] uvcvideo: Frame complete (EOF found).
[  774.430425] uvcvideo: frame 14 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.440949] uvcvideo: Frame complete (EOF found).
[  774.470410] uvcvideo: frame 15 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.480949] uvcvideo: Frame complete (EOF found).
[  774.510409] uvcvideo: frame 16 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.520948] uvcvideo: Frame complete (EOF found).
[  774.550409] uvcvideo: frame 17 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.560949] uvcvideo: Frame complete (EOF found).
[  774.590411] uvcvideo: frame 18 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.600948] uvcvideo: Frame complete (EOF found).
[  774.630412] uvcvideo: frame 19 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.640944] uvcvideo: Frame complete (EOF found).
[  774.670410] uvcvideo: frame 20 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.680947] uvcvideo: Frame complete (EOF found).
[  774.710409] uvcvideo: frame 21 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.720947] uvcvideo: Frame complete (EOF found).
[  774.750409] uvcvideo: frame 22 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.760942] uvcvideo: Frame complete (EOF found).
[  774.790408] uvcvideo: frame 23 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.800946] uvcvideo: Frame complete (EOF found).
[  774.830407] uvcvideo: frame 24 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.840946] uvcvideo: Frame complete (EOF found).
[  774.870408] uvcvideo: frame 25 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.880947] uvcvideo: Frame complete (EOF found).
[  774.910406] uvcvideo: frame 26 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.920945] uvcvideo: Frame complete (EOF found).
[  774.950404] uvcvideo: frame 27 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  774.960941] uvcvideo: Frame complete (EOF found).
[  774.990408] uvcvideo: frame 28 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.000945] uvcvideo: Frame complete (EOF found).
[  775.030408] uvcvideo: frame 29 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.040944] uvcvideo: Frame complete (EOF found).
[  775.070408] uvcvideo: frame 30 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.080945] uvcvideo: Frame complete (EOF found).
[  775.110409] uvcvideo: frame 31 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.120944] uvcvideo: Frame complete (EOF found).
[  775.150407] uvcvideo: frame 32 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.160939] uvcvideo: Frame complete (EOF found).
[  775.190405] uvcvideo: frame 33 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.200945] uvcvideo: Frame complete (EOF found).
[  775.230404] uvcvideo: frame 34 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.240943] uvcvideo: Frame complete (EOF found).
[  775.270403] uvcvideo: frame 35 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.280943] uvcvideo: Frame complete (EOF found).
[  775.310404] uvcvideo: frame 36 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.320942] uvcvideo: Frame complete (EOF found).
[  775.350403] uvcvideo: frame 37 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.360942] uvcvideo: Frame complete (EOF found).
[  775.390402] uvcvideo: frame 38 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.400943] uvcvideo: Frame complete (EOF found).
[  775.430404] uvcvideo: frame 39 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.440942] uvcvideo: Frame complete (EOF found).
[  775.470413] uvcvideo: frame 40 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.480941] uvcvideo: Frame complete (EOF found).
[  775.510401] uvcvideo: frame 41 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.520941] uvcvideo: Frame complete (EOF found).
[  775.550401] uvcvideo: frame 42 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.560940] uvcvideo: Frame complete (EOF found).
[  775.590400] uvcvideo: frame 43 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.600936] uvcvideo: Frame complete (EOF found).
[  775.630399] uvcvideo: frame 44 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.640940] uvcvideo: Frame complete (EOF found).
[  775.670400] uvcvideo: frame 45 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.680935] uvcvideo: Frame complete (EOF found).
[  775.710402] uvcvideo: frame 46 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.720940] uvcvideo: Frame complete (EOF found).
[  775.750401] uvcvideo: frame 47 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.760939] uvcvideo: Frame complete (EOF found).
[  775.790399] uvcvideo: frame 48 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.800939] uvcvideo: Frame complete (EOF found).
[  775.830400] uvcvideo: frame 49 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.840938] uvcvideo: Frame complete (EOF found).
[  775.870397] uvcvideo: frame 50 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.880937] uvcvideo: Frame complete (EOF found).
[  775.910400] uvcvideo: frame 51 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.920937] uvcvideo: Frame complete (EOF found).
[  775.950416] uvcvideo: frame 52 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  775.960938] uvcvideo: Frame complete (EOF found).
[  775.990398] uvcvideo: frame 53 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.000932] uvcvideo: Frame complete (EOF found).
[  776.030402] uvcvideo: frame 54 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.040938] uvcvideo: Frame complete (EOF found).
[  776.070397] uvcvideo: frame 55 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.080936] uvcvideo: Frame complete (EOF found).
[  776.110398] uvcvideo: frame 56 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.120938] uvcvideo: Frame complete (EOF found).
[  776.150396] uvcvideo: frame 57 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.160936] uvcvideo: Frame complete (EOF found).
[  776.190395] uvcvideo: frame 58 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.200935] uvcvideo: Frame complete (EOF found).
[  776.230396] uvcvideo: frame 59 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.240936] uvcvideo: Frame complete (EOF found).
[  776.270394] uvcvideo: frame 60 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.280935] uvcvideo: Frame complete (EOF found).
[  776.310395] uvcvideo: frame 61 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.320935] uvcvideo: Frame complete (EOF found).
[  776.350394] uvcvideo: frame 62 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.360934] uvcvideo: Frame complete (EOF found).
[  776.390394] uvcvideo: frame 63 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.400934] uvcvideo: Frame complete (EOF found).
[  776.430393] uvcvideo: frame 64 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.440924] uvcvideo: Frame complete (EOF found).
[  776.470391] uvcvideo: frame 65 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.480924] uvcvideo: Frame complete (EOF found).
[  776.510393] uvcvideo: frame 66 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.520932] uvcvideo: Frame complete (EOF found).
[  776.550393] uvcvideo: frame 67 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.560932] uvcvideo: Frame complete (EOF found).
[  776.590394] uvcvideo: frame 68 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.600932] uvcvideo: Frame complete (EOF found).
[  776.630392] uvcvideo: frame 69 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.640954] uvcvideo: Frame complete (EOF found).
[  776.670392] uvcvideo: frame 70 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.680931] uvcvideo: Frame complete (EOF found).
[  776.710392] uvcvideo: frame 71 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.720932] uvcvideo: Frame complete (EOF found).
[  776.750391] uvcvideo: frame 72 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.760931] uvcvideo: Frame complete (EOF found).
[  776.790390] uvcvideo: frame 73 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.800931] uvcvideo: Frame complete (EOF found).
[  776.830391] uvcvideo: frame 74 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.840931] uvcvideo: Frame complete (EOF found).
[  776.870390] uvcvideo: frame 75 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.880930] uvcvideo: Frame complete (EOF found).
[  776.910389] uvcvideo: frame 76 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.920929] uvcvideo: Frame complete (EOF found).
[  776.950390] uvcvideo: frame 77 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  776.960929] uvcvideo: Frame complete (EOF found).
[  776.990389] uvcvideo: frame 78 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.000929] uvcvideo: Frame complete (EOF found).
[  777.030388] uvcvideo: frame 79 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.040928] uvcvideo: Frame complete (EOF found).
[  777.070389] uvcvideo: frame 80 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.080929] uvcvideo: Frame complete (EOF found).
[  777.110388] uvcvideo: frame 81 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.120928] uvcvideo: Frame complete (EOF found).
[  777.150393] uvcvideo: frame 82 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.160928] uvcvideo: Frame complete (EOF found).
[  777.190388] uvcvideo: frame 83 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.200928] uvcvideo: Frame complete (EOF found).
[  777.230387] uvcvideo: frame 84 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.240929] uvcvideo: Frame complete (EOF found).
[  777.270389] uvcvideo: frame 85 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.280927] uvcvideo: Frame complete (EOF found).
[  777.310387] uvcvideo: frame 86 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.320927] uvcvideo: Frame complete (EOF found).
[  777.350387] uvcvideo: frame 87 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.360926] uvcvideo: Frame complete (EOF found).
[  777.390386] uvcvideo: frame 88 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.400926] uvcvideo: Frame complete (EOF found).
[  777.430386] uvcvideo: frame 89 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.440927] uvcvideo: Frame complete (EOF found).
[  777.470385] uvcvideo: frame 90 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.480926] uvcvideo: Frame complete (EOF found).
[  777.510386] uvcvideo: frame 91 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.520926] uvcvideo: Frame complete (EOF found).
[  777.550384] uvcvideo: frame 92 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.560925] uvcvideo: Frame complete (EOF found).
[  777.590384] uvcvideo: frame 93 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.600915] uvcvideo: Frame complete (EOF found).
[  777.630384] uvcvideo: frame 94 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.640924] uvcvideo: Frame complete (EOF found).
[  777.670385] uvcvideo: frame 95 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.680921] uvcvideo: Frame complete (EOF found).
[  777.710384] uvcvideo: frame 96 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.720921] uvcvideo: Frame complete (EOF found).
[  777.750384] uvcvideo: frame 97 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.760923] uvcvideo: Frame complete (EOF found).
[  777.790382] uvcvideo: frame 98 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.800930] uvcvideo: Frame complete (EOF found).
[  777.830382] uvcvideo: frame 99 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.840920] uvcvideo: Frame complete (EOF found).
[  777.870384] uvcvideo: frame 100 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.880919] uvcvideo: Frame complete (EOF found).
[  777.910383] uvcvideo: frame 101 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.920917] uvcvideo: Frame complete (EOF found).
[  777.950383] uvcvideo: frame 102 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  777.960920] uvcvideo: Frame complete (EOF found).
[  777.990382] uvcvideo: frame 103 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.000919] uvcvideo: Frame complete (EOF found).
[  778.030382] uvcvideo: frame 104 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.040921] uvcvideo: Frame complete (EOF found).
[  778.070382] uvcvideo: frame 105 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.080918] uvcvideo: Frame complete (EOF found).
[  778.110380] uvcvideo: frame 106 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.120920] uvcvideo: Frame complete (EOF found).
[  778.150382] uvcvideo: frame 107 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.160917] uvcvideo: Frame complete (EOF found).
[  778.190380] uvcvideo: frame 108 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.200917] uvcvideo: Frame complete (EOF found).
[  778.230380] uvcvideo: frame 109 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.240917] uvcvideo: Frame complete (EOF found).
[  778.270379] uvcvideo: frame 110 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.280917] uvcvideo: Frame complete (EOF found).
[  778.310379] uvcvideo: frame 111 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.320917] uvcvideo: Frame complete (EOF found).
[  778.350378] uvcvideo: frame 112 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.360919] uvcvideo: Frame complete (EOF found).
[  778.390379] uvcvideo: frame 113 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.400919] uvcvideo: Frame complete (EOF found).
[  778.430377] uvcvideo: frame 114 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.440918] uvcvideo: Frame complete (EOF found).
[  778.470382] uvcvideo: frame 115 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.480918] uvcvideo: Frame complete (EOF found).
[  778.510378] uvcvideo: frame 116 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.520917] uvcvideo: Frame complete (EOF found).
[  778.550376] uvcvideo: frame 117 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.560917] uvcvideo: Frame complete (EOF found).
[  778.590376] uvcvideo: frame 118 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.600917] uvcvideo: Frame complete (EOF found).
[  778.630377] uvcvideo: frame 119 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.640917] uvcvideo: Frame complete (EOF found).
[  778.670376] uvcvideo: frame 120 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.680915] uvcvideo: Frame complete (EOF found).
[  778.710376] uvcvideo: frame 121 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.720916] uvcvideo: Frame complete (EOF found).
[  778.750377] uvcvideo: frame 122 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.760916] uvcvideo: Frame complete (EOF found).
[  778.790376] uvcvideo: frame 123 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.800915] uvcvideo: Frame complete (EOF found).
[  778.830376] uvcvideo: frame 124 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.840915] uvcvideo: Frame complete (EOF found).
[  778.870373] uvcvideo: frame 125 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.880904] uvcvideo: Frame complete (EOF found).
[  778.910374] uvcvideo: frame 126 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.920914] uvcvideo: Frame complete (EOF found).
[  778.950374] uvcvideo: frame 127 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  778.960914] uvcvideo: Frame complete (EOF found).
[  778.990374] uvcvideo: frame 128 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.000914] uvcvideo: Frame complete (EOF found).
[  779.030373] uvcvideo: frame 129 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.040914] uvcvideo: Frame complete (EOF found).
[  779.070373] uvcvideo: frame 130 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.080913] uvcvideo: Frame complete (EOF found).
[  779.110393] uvcvideo: frame 131 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.120913] uvcvideo: Frame complete (EOF found).
[  779.150372] uvcvideo: frame 132 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.160912] uvcvideo: Frame complete (EOF found).
[  779.190371] uvcvideo: frame 133 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.200912] uvcvideo: Frame complete (EOF found).
[  779.230371] uvcvideo: frame 134 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.240909] uvcvideo: Frame complete (EOF found).
[  779.270371] uvcvideo: frame 135 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.280912] uvcvideo: Frame complete (EOF found).
[  779.310372] uvcvideo: frame 136 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.320911] uvcvideo: Frame complete (EOF found).
[  779.350371] uvcvideo: frame 137 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  779.360909] uvcvideo: Frame complete (EOF found).
[  779.381600] uvcvideo: uvc_v4l2_release
[  782.175302] uvcvideo: Suspending interface 1
[  782.175303] uvcvideo: Suspending interface 0



--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41
Content-Disposition: attachment;
	filename=dmesg_reload_uvcvideo_trace.txt
Content-Type: text/plain;
	name="dmesg_reload_uvcvideo_trace.txt"
Content-Transfer-Encoding: quoted-printable

[  714.682235] usbcore: deregistering interface driver uvcvideo
[  714.776488] uvcvideo: Resuming interface 0
[  714.776489] uvcvideo: Resuming interface 1
[  715.013267] media: Linux media interface: v0.10
[  715.027964] Linux video capture interface: v2.00
[  715.046526] uvcvideo: Found UVC 1.00 device XI100DUSB-HDMI =
(2935:0001)
[  715.063148] uvcvideo 2-4:1.0: Entity type for entity Processing 2 was =
not initialized!
[  715.063151] uvcvideo 2-4:1.0: Entity type for entity Camera 1 was not =
initialized!
[  715.063255] input: XI100DUSB-HDMI as =
/devices/pci0000:00/0000:00:14.0/usb2/2-4/2-4:1.0/input/input15
[  715.063330] usbcore: registered new interface driver uvcvideo
[  715.063331] USB Video Class driver (1.1.1)


--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41
Content-Disposition: attachment;
	filename=dmesg_second_ffmpeg_capture.txt
Content-Type: text/plain;
	name="dmesg_second_ffmpeg_capture.txt"
Content-Transfer-Encoding: quoted-printable

[  842.073192] uvcvideo: uvc_v4l2_open
[  842.166927] uvcvideo: Resuming interface 0
[  842.166929] uvcvideo: Resuming interface 1
[  842.166951] uvcvideo: Trying format 0x32315559 (YU12): 1920x1080.
[  842.166953] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  842.167330] uvcvideo: Trying format 0x32315559 (YU12): 1920x1080.
[  842.167330] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  842.167675] uvcvideo: Trying format 0x32315659 (YV12): 1920x1080.
[  842.167675] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  842.168049] uvcvideo: Trying format 0x50323234 (422P): 1920x1080.
[  842.168049] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  842.168407] uvcvideo: Trying format 0x56595559 (YUYV): 1920x1080.
[  842.168408] uvcvideo: Using default frame interval 16666.7 us (59.9 =
fps).
[  842.168806] uvcvideo: Setting frame interval to 1/25 (400000).
[  842.180274] uvcvideo: uvc_v4l2_mmap
[  842.180358] uvcvideo: uvc_v4l2_mmap
[  842.180419] uvcvideo: uvc_v4l2_mmap
[  842.180480] uvcvideo: uvc_v4l2_mmap
[  842.180539] uvcvideo: uvc_v4l2_mmap
[  842.180599] uvcvideo: uvc_v4l2_mmap
[  842.180658] uvcvideo: uvc_v4l2_mmap
[  842.180720] uvcvideo: uvc_v4l2_mmap
[  842.180780] uvcvideo: uvc_v4l2_mmap
[  842.180840] uvcvideo: uvc_v4l2_mmap
[  842.180899] uvcvideo: uvc_v4l2_mmap
[  842.180958] uvcvideo: uvc_v4l2_mmap
[  842.181018] uvcvideo: uvc_v4l2_mmap
[  842.181077] uvcvideo: uvc_v4l2_mmap
[  842.181137] uvcvideo: uvc_v4l2_mmap
[  842.181197] uvcvideo: uvc_v4l2_mmap
[  842.181257] uvcvideo: uvc_v4l2_mmap
[  842.181316] uvcvideo: uvc_v4l2_mmap
[  842.181376] uvcvideo: uvc_v4l2_mmap
[  842.181437] uvcvideo: uvc_v4l2_mmap
[  842.181497] uvcvideo: uvc_v4l2_mmap
[  842.181556] uvcvideo: uvc_v4l2_mmap
[  842.181616] uvcvideo: uvc_v4l2_mmap
[  842.181676] uvcvideo: uvc_v4l2_mmap
[  842.181736] uvcvideo: uvc_v4l2_mmap
[  842.181796] uvcvideo: uvc_v4l2_mmap
[  842.181855] uvcvideo: uvc_v4l2_mmap
[  842.181914] uvcvideo: uvc_v4l2_mmap
[  842.181974] uvcvideo: uvc_v4l2_mmap
[  842.182034] uvcvideo: uvc_v4l2_mmap
[  842.182094] uvcvideo: uvc_v4l2_mmap
[  842.182153] uvcvideo: uvc_v4l2_mmap
[  842.182310] uvcvideo: Allocated 5 URB buffers of 16x1024 bytes each.
[  842.185644] uvcvideo: Non-zero status (-71) in video completion =
handler.
[  842.185645] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185668] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185671] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185674] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185697] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185699] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185702] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185708] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185712] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185715] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185718] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185741] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185745] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185762] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185766] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185770] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185774] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185778] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185782] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185786] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185791] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185811] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185814] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185818] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185823] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185827] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185831] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185835] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185840] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185843] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185847] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.185850] videobuf2-v4l2.c - setting V4L2_BUF_FLAG_ERROR
[  842.196149] uvcvideo: Frame complete (EOF found).
[  842.196191] uvcvideo: frame 1 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.206690] uvcvideo: Frame complete (EOF found).
[  842.219595] uvcvideo: frame 2 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.230135] uvcvideo: Frame complete (EOF found).
[  842.259592] uvcvideo: frame 3 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.270148] uvcvideo: Frame complete (EOF found).
[  842.299594] uvcvideo: frame 4 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.310134] uvcvideo: Frame complete (EOF found).
[  842.339594] uvcvideo: frame 5 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.350134] uvcvideo: Frame complete (EOF found).
[  842.379592] uvcvideo: frame 6 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.390134] uvcvideo: Frame complete (EOF found).
[  842.419592] uvcvideo: frame 7 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.430133] uvcvideo: Frame complete (EOF found).
[  842.459592] uvcvideo: frame 8 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.470134] uvcvideo: Frame complete (EOF found).
[  842.499592] uvcvideo: frame 9 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.510121] uvcvideo: Frame complete (EOF found).
[  842.539593] uvcvideo: frame 10 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.550133] uvcvideo: Frame complete (EOF found).
[  842.579592] uvcvideo: frame 11 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.590121] uvcvideo: Frame complete (EOF found).
[  842.619594] uvcvideo: frame 12 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.630131] uvcvideo: Frame complete (EOF found).
[  842.659592] uvcvideo: frame 13 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.670105] uvcvideo: Frame complete (EOF found).
[  842.699592] uvcvideo: frame 14 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.710111] uvcvideo: Frame complete (EOF found).
[  842.739593] uvcvideo: frame 15 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.750128] uvcvideo: Frame complete (EOF found).
[  842.779592] uvcvideo: frame 16 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.790120] uvcvideo: Frame complete (EOF found).
[  842.819591] uvcvideo: frame 17 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.830120] uvcvideo: Frame complete (EOF found).
[  842.859590] uvcvideo: frame 18 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.870131] uvcvideo: Frame complete (EOF found).
[  842.899591] uvcvideo: frame 19 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.910129] uvcvideo: Frame complete (EOF found).
[  842.939590] uvcvideo: frame 20 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.950129] uvcvideo: Frame complete (EOF found).
[  842.979588] uvcvideo: frame 21 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  842.990132] uvcvideo: Frame complete (EOF found).
[  843.019589] uvcvideo: frame 22 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.030128] uvcvideo: Frame complete (EOF found).
[  843.059589] uvcvideo: frame 23 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.070117] uvcvideo: Frame complete (EOF found).
[  843.099588] uvcvideo: frame 24 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.110128] uvcvideo: Frame complete (EOF found).
[  843.139588] uvcvideo: frame 25 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.150128] uvcvideo: Frame complete (EOF found).
[  843.179587] uvcvideo: frame 26 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.190127] uvcvideo: Frame complete (EOF found).
[  843.219587] uvcvideo: frame 27 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.230127] uvcvideo: Frame complete (EOF found).
[  843.259587] uvcvideo: frame 28 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.270126] uvcvideo: Frame complete (EOF found).
[  843.299586] uvcvideo: frame 29 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.310127] uvcvideo: Frame complete (EOF found).
[  843.339586] uvcvideo: frame 30 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.350126] uvcvideo: Frame complete (EOF found).
[  843.379587] uvcvideo: frame 31 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.390125] uvcvideo: Frame complete (EOF found).
[  843.419586] uvcvideo: frame 32 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.430114] uvcvideo: Frame complete (EOF found).
[  843.459586] uvcvideo: frame 33 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.470126] uvcvideo: Frame complete (EOF found).
[  843.499586] uvcvideo: frame 34 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.510125] uvcvideo: Frame complete (EOF found).
[  843.539585] uvcvideo: frame 35 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.550124] uvcvideo: Frame complete (EOF found).
[  843.579587] uvcvideo: frame 36 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.590114] uvcvideo: Frame complete (EOF found).
[  843.619585] uvcvideo: frame 37 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.630123] uvcvideo: Frame complete (EOF found).
[  843.659585] uvcvideo: frame 38 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.670124] uvcvideo: Frame complete (EOF found).
[  843.699584] uvcvideo: frame 39 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.710123] uvcvideo: Frame complete (EOF found).
[  843.739584] uvcvideo: frame 40 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.750123] uvcvideo: Frame complete (EOF found).
[  843.779582] uvcvideo: frame 41 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.790111] uvcvideo: Frame complete (EOF found).
[  843.819582] uvcvideo: frame 42 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.830122] uvcvideo: Frame complete (EOF found).
[  843.859582] uvcvideo: frame 43 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.870111] uvcvideo: Frame complete (EOF found).
[  843.899584] uvcvideo: frame 44 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.910121] uvcvideo: Frame complete (EOF found).
[  843.939582] uvcvideo: frame 45 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.950110] uvcvideo: Frame complete (EOF found).
[  843.979582] uvcvideo: frame 46 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  843.990121] uvcvideo: Frame complete (EOF found).
[  844.019582] uvcvideo: frame 47 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.030120] uvcvideo: Frame complete (EOF found).
[  844.059582] uvcvideo: frame 48 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.070110] uvcvideo: Frame complete (EOF found).
[  844.099581] uvcvideo: frame 49 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.110121] uvcvideo: Frame complete (EOF found).
[  844.139580] uvcvideo: frame 50 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.150119] uvcvideo: Frame complete (EOF found).
[  844.179580] uvcvideo: frame 51 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.190119] uvcvideo: Frame complete (EOF found).
[  844.219581] uvcvideo: frame 52 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.230119] uvcvideo: Frame complete (EOF found).
[  844.259579] uvcvideo: frame 53 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.270098] uvcvideo: Frame complete (EOF found).
[  844.299578] uvcvideo: frame 54 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.310118] uvcvideo: Frame complete (EOF found).
[  844.339579] uvcvideo: frame 55 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.350119] uvcvideo: Frame complete (EOF found).
[  844.379576] uvcvideo: frame 56 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.390117] uvcvideo: Frame complete (EOF found).
[  844.419577] uvcvideo: frame 57 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.430117] uvcvideo: Frame complete (EOF found).
[  844.459577] uvcvideo: frame 58 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.470118] uvcvideo: Frame complete (EOF found).
[  844.499576] uvcvideo: frame 59 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.510096] uvcvideo: Frame complete (EOF found).
[  844.539576] uvcvideo: frame 60 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.550116] uvcvideo: Frame complete (EOF found).
[  844.579578] uvcvideo: frame 61 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.590116] uvcvideo: Frame complete (EOF found).
[  844.619578] uvcvideo: frame 62 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.630116] uvcvideo: Frame complete (EOF found).
[  844.659576] uvcvideo: frame 63 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.670116] uvcvideo: Frame complete (EOF found).
[  844.699575] uvcvideo: frame 64 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.710116] uvcvideo: Frame complete (EOF found).
[  844.739577] uvcvideo: frame 65 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.750115] uvcvideo: Frame complete (EOF found).
[  844.779575] uvcvideo: frame 66 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.790115] uvcvideo: Frame complete (EOF found).
[  844.819576] uvcvideo: frame 67 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.830114] uvcvideo: Frame complete (EOF found).
[  844.859574] uvcvideo: frame 68 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.870115] uvcvideo: Frame complete (EOF found).
[  844.899576] uvcvideo: frame 69 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.910114] uvcvideo: Frame complete (EOF found).
[  844.939574] uvcvideo: frame 70 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.950113] uvcvideo: Frame complete (EOF found).
[  844.979574] uvcvideo: frame 71 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  844.990113] uvcvideo: Frame complete (EOF found).
[  845.019573] uvcvideo: frame 72 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.030113] uvcvideo: Frame complete (EOF found).
[  845.059573] uvcvideo: frame 73 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.070112] uvcvideo: Frame complete (EOF found).
[  845.099574] uvcvideo: frame 74 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.110111] uvcvideo: Frame complete (EOF found).
[  845.139572] uvcvideo: frame 75 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.150112] uvcvideo: Frame complete (EOF found).
[  845.179571] uvcvideo: frame 76 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.190111] uvcvideo: Frame complete (EOF found).
[  845.219572] uvcvideo: frame 77 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.230111] uvcvideo: Frame complete (EOF found).
[  845.259571] uvcvideo: frame 78 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.270111] uvcvideo: Frame complete (EOF found).
[  845.299571] uvcvideo: frame 79 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.310104] uvcvideo: Frame complete (EOF found).
[  845.339571] uvcvideo: frame 80 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.350111] uvcvideo: Frame complete (EOF found).
[  845.379571] uvcvideo: frame 81 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.390109] uvcvideo: Frame complete (EOF found).
[  845.419568] uvcvideo: frame 82 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.430100] uvcvideo: Frame complete (EOF found).
[  845.459568] uvcvideo: frame 83 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.470099] uvcvideo: Frame complete (EOF found).
[  845.499569] uvcvideo: frame 84 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.510109] uvcvideo: Frame complete (EOF found).
[  845.539568] uvcvideo: frame 85 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.550097] uvcvideo: Frame complete (EOF found).
[  845.579570] uvcvideo: frame 86 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.590108] uvcvideo: Frame complete (EOF found).
[  845.619569] uvcvideo: frame 87 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.630108] uvcvideo: Frame complete (EOF found).
[  845.659568] uvcvideo: frame 88 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.670108] uvcvideo: Frame complete (EOF found).
[  845.699567] uvcvideo: frame 89 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.710107] uvcvideo: Frame complete (EOF found).
[  845.739566] uvcvideo: frame 90 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.750107] uvcvideo: Frame complete (EOF found).
[  845.779566] uvcvideo: frame 91 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.790107] uvcvideo: Frame complete (EOF found).
[  845.819566] uvcvideo: frame 92 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.830106] uvcvideo: Frame complete (EOF found).
[  845.859567] uvcvideo: frame 93 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.870107] uvcvideo: Frame complete (EOF found).
[  845.899565] uvcvideo: frame 94 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.910106] uvcvideo: Frame complete (EOF found).
[  845.939568] uvcvideo: frame 95 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.950105] uvcvideo: Frame complete (EOF found).
[  845.979564] uvcvideo: frame 96 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  845.990105] uvcvideo: Frame complete (EOF found).
[  846.019563] uvcvideo: frame 97 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.030104] uvcvideo: Frame complete (EOF found).
[  846.059564] uvcvideo: frame 98 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.070105] uvcvideo: Frame complete (EOF found).
[  846.099566] uvcvideo: frame 99 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.110105] uvcvideo: Frame complete (EOF found).
[  846.139565] uvcvideo: frame 100 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.150104] uvcvideo: Frame complete (EOF found).
[  846.179563] uvcvideo: frame 101 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.190103] uvcvideo: Frame complete (EOF found).
[  846.219563] uvcvideo: frame 102 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.230104] uvcvideo: Frame complete (EOF found).
[  846.259563] uvcvideo: frame 103 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.270104] uvcvideo: Frame complete (EOF found).
[  846.299561] uvcvideo: frame 104 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.310102] uvcvideo: Frame complete (EOF found).
[  846.339563] uvcvideo: frame 105 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.350067] uvcvideo: Frame complete (EOF found).
[  846.379560] uvcvideo: frame 106 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.390102] uvcvideo: Frame complete (EOF found).
[  846.419560] uvcvideo: frame 107 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.430101] uvcvideo: Frame complete (EOF found).
[  846.459560] uvcvideo: frame 108 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.470102] uvcvideo: Frame complete (EOF found).
[  846.499560] uvcvideo: frame 109 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.510102] uvcvideo: Frame complete (EOF found).
[  846.539559] uvcvideo: frame 110 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.550101] uvcvideo: Frame complete (EOF found).
[  846.579560] uvcvideo: frame 111 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.590101] uvcvideo: Frame complete (EOF found).
[  846.619559] uvcvideo: frame 112 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.630101] uvcvideo: Frame complete (EOF found).
[  846.659559] uvcvideo: frame 113 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.670100] uvcvideo: Frame complete (EOF found).
[  846.699565] uvcvideo: frame 114 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.710099] uvcvideo: Frame complete (EOF found).
[  846.739558] uvcvideo: frame 115 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.750098] uvcvideo: Frame complete (EOF found).
[  846.779557] uvcvideo: frame 116 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.790099] uvcvideo: Frame complete (EOF found).
[  846.819557] uvcvideo: frame 117 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.830098] uvcvideo: Frame complete (EOF found).
[  846.859557] uvcvideo: frame 118 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.870089] uvcvideo: Frame complete (EOF found).
[  846.899558] uvcvideo: frame 119 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.910098] uvcvideo: Frame complete (EOF found).
[  846.939558] uvcvideo: frame 120 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.950098] uvcvideo: Frame complete (EOF found).
[  846.979557] uvcvideo: frame 121 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  846.990098] uvcvideo: Frame complete (EOF found).
[  847.019556] uvcvideo: frame 122 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.030097] uvcvideo: Frame complete (EOF found).
[  847.059556] uvcvideo: frame 123 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.070096] uvcvideo: Frame complete (EOF found).
[  847.099554] uvcvideo: frame 124 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.110086] uvcvideo: Frame complete (EOF found).
[  847.139556] uvcvideo: frame 125 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.150096] uvcvideo: Frame complete (EOF found).
[  847.179556] uvcvideo: frame 126 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.190095] uvcvideo: Frame complete (EOF found).
[  847.219558] uvcvideo: frame 127 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.230096] uvcvideo: Frame complete (EOF found).
[  847.259567] uvcvideo: frame 128 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.270104] uvcvideo: Frame complete (EOF found).
[  847.299557] uvcvideo: frame 129 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.310095] uvcvideo: Frame complete (EOF found).
[  847.339556] uvcvideo: frame 130 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.350098] uvcvideo: Frame complete (EOF found).
[  847.379556] uvcvideo: frame 131 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.390095] uvcvideo: Frame complete (EOF found).
[  847.419557] uvcvideo: frame 132 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.430094] uvcvideo: Frame complete (EOF found).
[  847.459557] uvcvideo: frame 133 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.470093] uvcvideo: Frame complete (EOF found).
[  847.499556] uvcvideo: frame 134 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.510092] uvcvideo: Frame complete (EOF found).
[  847.539557] uvcvideo: frame 135 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.550093] uvcvideo: Frame complete (EOF found).
[  847.579556] uvcvideo: frame 136 stats: 0/0/254 packets, 0/0/0 pts =
(!early !initial), 0/0 scr, last pts/stc/sof 0/0/0
[  847.590092] uvcvideo: Frame complete (EOF found).
[  847.613140] uvcvideo: uvc_v4l2_release
[  850.270210] uvcvideo: Suspending interface 1
[  850.270211] uvcvideo: Suspending interface 0


--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41
Content-Disposition: attachment;
	filename=ffmpeg_first_ffmpeg_capture.txt
Content-Type: text/plain;
	name="ffmpeg_first_ffmpeg_capture.txt"
Content-Transfer-Encoding: quoted-printable

oliver@NUC-1:~$ ./ffmpeg -f v4l2 -thread_queue_size 1024 -video_size =
1920x1080 -framerate 25 -i /dev/video0 -f alsa -thread_queue_size 1024 =
-i "hw:CARD=3DXI100DUSBHDMI,DEV=3D0" -vcodec libx265 -preset ultrafast =
-vb 3200k -maxrate 3200k -bufsize 3200k -vf yadif=3D1 -acodec aac -ab =
192k -t 60 -f mpegts ~/Desktop/capture.ts -y
ffmpeg version N-81511-gaabe12e Copyright (c) 2000-2016 the FFmpeg =
developers
  built with gcc 5.4.0 (Ubuntu 5.4.0-6ubuntu1~16.04.2) 20160609
  configuration: --enable-gpl --enable-version3 --enable-static =
--enable-libx264 --enable-libx265 --enable-nvenc --enable-libpulse =
--disable-debug
  libavutil      55. 29.100 / 55. 29.100
  libavcodec     57. 54.101 / 57. 54.101
  libavformat    57. 48.101 / 57. 48.101
  libavdevice    57.  0.102 / 57.  0.102
  libavfilter     6. 58.100 /  6. 58.100
  libswscale      4.  1.100 /  4.  1.100
  libswresample   2.  1.100 /  2.  1.100
  libpostproc    54.  0.100 / 54.  0.100
Input #0, video4linux2,v4l2, from '/dev/video0':
  Duration: N/A, start: 773.483020, bitrate: 829440 kb/s
    Stream #0:0: Video: rawvideo (YUY2 / 0x32595559), yuyv422, =
1920x1080, 829440 kb/s, 25 fps, 25 tbr, 1000k tbn, 1000k tbc
Guessed Channel Layout for Input Stream #1.0 : stereo
Input #1, alsa, from 'hw:CARD=3DXI100DUSBHDMI,DEV=3D0':
  Duration: N/A, start: 1473103066.167109, bitrate: 1536 kb/s
    Stream #1:0: Audio: pcm_s16le, 48000 Hz, 2 channels, s16, 1536 kb/s
x265 [info]: HEVC encoder version 2.0+1-6a9b6a828f79
x265 [info]: build info [Linux][GCC 5.4.0][64 bit] 8bit
x265 [info]: using cpu capabilities: MMX2 SSE2Fast SSSE3 SSE4.2 AVX AVX2 =
FMA3 LZCNT BMI2
x265 [info]: Main 4:2:2 10 profile, Level-4.1 (Main tier)
x265 [info]: Thread pool created using 8 threads
x265 [info]: frame threads / pool features       : 3 / wpp(34 rows)
x265 [info]: Coding QT: max CU size, min CU size : 32 / 16
x265 [info]: Residual QT: max TU size, max depth : 32 / 1 inter / 1 =
intra
x265 [info]: ME / range / subpel / merge         : dia / 57 / 0 / 2
x265 [info]: Keyframe min / max / scenecut       : 25 / 250 / 0
x265 [info]: Lookahead / bframes / badapt        : 5 / 3 / 0
x265 [info]: b-pyramid / weightp / weightb       : 1 / 0 / 0
x265 [info]: References / ref-limit  cu / depth  : 1 / off / off
x265 [info]: AQ: mode / str / qg-size / cu-tree  : 1 / 0.0 / 32 / 1
x265 [info]: Rate Control / qCompress            : ABR-3200 kbps / 0.60
x265 [info]: tools: rd=3D2 psy-rd=3D2.00 early-skip rskip tmvp =
fast-intra
x265 [info]: tools: strong-intra-smoothing lslices=3D6 deblock
[mpegts @ 0x2bf5440] Using AVStream.codec to pass codec parameters to =
muxers is deprecated, use AVStream.codecpar instead.
    Last message repeated 1 times
Output #0, mpegts, to '/home/oliver/Desktop/capture.ts':
  Metadata:
    encoder         : Lavf57.48.101
    Stream #0:0: Video: hevc (libx265), yuv422p, 1920x1080, q=3D2-31, =
3200 kb/s, 50 fps, 90k tbn, 50 tbc
    Metadata:
      encoder         : Lavc57.54.101 libx265
    Stream #0:1: Audio: aac (LC), 48000 Hz, stereo, fltp, delay 1024, =
padding 0, 192 kb/s
    Metadata:
      encoder         : Lavc57.54.101 aac
Stream mapping:
  Stream #0:0 -> #0:0 (rawvideo (native) -> hevc (libx265))
  Stream #1:0 -> #0:1 (pcm_s16le (native) -> aac (native))
Press [q] to stop, [?] for help
frame=3D   21 fps=3D0.0 q=3D-0.0 size=3D      20kB time=3D00:00:00.10 =
bitrate=3D1557.5kbits/frame=3D   50 fps=3D 49 q=3D-0.0 size=3D     101kB =
time=3D00:00:00.68 bitrate=3D1215.4kbits/frame=3D   75 fps=3D 49 q=3D-0.0 =
size=3D     150kB time=3D00:00:01.19 bitrate=3D1025.6kbits/frame=3D  100 =
fps=3D 49 q=3D-0.0 size=3D     295kB time=3D00:00:01.70 =
bitrate=3D1415.8kbits/frame=3D  126 fps=3D 50 q=3D-0.0 size=3D     367kB =
time=3D00:00:02.21 bitrate=3D1354.8kbits/frame=3D  151 fps=3D 50 q=3D-0.0 =
size=3D     490kB time=3D00:00:02.70 bitrate=3D1480.8kbits/frame=3D  176 =
fps=3D 50 q=3D-0.0 size=3D     575kB time=3D00:00:03.22 =
bitrate=3D1461.6kbits/frame=3D  202 fps=3D 50 q=3D-0.0 size=3D     637kB =
time=3D00:00:03.73 bitrate=3D1398.1kbits/frame=3D  226 fps=3D 50 q=3D-0.0 =
size=3D     736kB time=3D00:00:04.22 bitrate=3D1426.6kbits/frame=3D  252 =
fps=3D 50 q=3D-0.0 size=3D     830kB time=3D00:00:04.75 =
bitrate=3D1429.7kbits/frame=3D  267 fps=3D 49 q=3D-0.0 Lsize=3D     =
877kB time=3D00:00:05.28 bitrate=3D1361.0kbits/s speed=3D0.965x   =20
video:784kB audio:1kB subtitle:0kB other streams:0kB global headers:0kB =
muxing overhead: 11.752733%
x265 [info]: frame I:      2, Avg QP:34.86  kb/s: 6412.80=20
x265 [info]: frame P:     67, Avg QP:17.32  kb/s: 4282.73=20
x265 [info]: frame B:    198, Avg QP:20.02  kb/s: 100.78 =20
x265 [info]: consecutive B-frames: 4.3% 0.0% 0.0% 95.7%=20

encoded 267 frames in 5.48s (48.76 fps), 1197.46 kb/s, Avg QP:19.45
[aac @ 0x2bf0f60] Qavg: 65536.000


--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41
Content-Disposition: attachment;
	filename=ffmpeg_second_ffmpeg_capture.txt
Content-Type: text/plain;
	name="ffmpeg_second_ffmpeg_capture.txt"
Content-Transfer-Encoding: quoted-printable

oliver@NUC-1:~$ ./ffmpeg -f v4l2 -thread_queue_size 1024 -video_size =
1920x1080 -framerate 25 -i /dev/video0 -f alsa -thread_queue_size 1024 =
-i "hw:CARD=3DXI100DUSBHDMI,DEV=3D0" -vcodec libx265 -preset ultrafast =
-vb 3200k -maxrate 3200k -bufsize 3200k -vf yadif=3D1 -acodec aac -ab =
192k -t 60 -f mpegts ~/Desktop/capture.ts -y
ffmpeg version N-81511-gaabe12e Copyright (c) 2000-2016 the FFmpeg =
developers
  built with gcc 5.4.0 (Ubuntu 5.4.0-6ubuntu1~16.04.2) 20160609
  configuration: --enable-gpl --enable-version3 --enable-static =
--enable-libx264 --enable-libx265 --enable-nvenc --enable-libpulse =
--disable-debug
  libavutil      55. 29.100 / 55. 29.100
  libavcodec     57. 54.101 / 57. 54.101
  libavformat    57. 48.101 / 57. 48.101
  libavdevice    57.  0.102 / 57.  0.102
  libavfilter     6. 58.100 /  6. 58.100
  libswscale      4.  1.100 /  4.  1.100
  libswresample   2.  1.100 /  2.  1.100
  libpostproc    54.  0.100 / 54.  0.100
[video4linux2,v4l2 @ 0x2d0e560] Dequeued v4l2 buffer contains corrupted =
data (0 bytes).
    Last message repeated 31 times
Input #0, video4linux2,v4l2, from '/dev/video0':
  Duration: N/A, start: 841.799371, bitrate: 829440 kb/s
    Stream #0:0: Video: rawvideo (YUY2 / 0x32595559), yuyv422, =
1920x1080, 829440 kb/s, 25 fps, 25 tbr, 1000k tbn, 1000k tbc
Guessed Channel Layout for Input Stream #1.0 : stereo
Input #1, alsa, from 'hw:CARD=3DXI100DUSBHDMI,DEV=3D0':
  Duration: N/A, start: 1473103134.484202, bitrate: 1536 kb/s
    Stream #1:0: Audio: pcm_s16le, 48000 Hz, 2 channels, s16, 1536 kb/s
x265 [info]: HEVC encoder version 2.0+1-6a9b6a828f79
x265 [info]: build info [Linux][GCC 5.4.0][64 bit] 8bit
x265 [info]: using cpu capabilities: MMX2 SSE2Fast SSSE3 SSE4.2 AVX AVX2 =
FMA3 LZCNT BMI2
x265 [info]: Main 4:2:2 10 profile, Level-4.1 (Main tier)
x265 [info]: Thread pool created using 8 threads
x265 [info]: frame threads / pool features       : 3 / wpp(34 rows)
x265 [info]: Coding QT: max CU size, min CU size : 32 / 16
x265 [info]: Residual QT: max TU size, max depth : 32 / 1 inter / 1 =
intra
x265 [info]: ME / range / subpel / merge         : dia / 57 / 0 / 2
x265 [info]: Keyframe min / max / scenecut       : 25 / 250 / 0
x265 [info]: Lookahead / bframes / badapt        : 5 / 3 / 0
x265 [info]: b-pyramid / weightp / weightb       : 1 / 0 / 0
x265 [info]: References / ref-limit  cu / depth  : 1 / off / off
x265 [info]: AQ: mode / str / qg-size / cu-tree  : 1 / 0.0 / 32 / 1
x265 [info]: Rate Control / qCompress            : ABR-3200 kbps / 0.60
x265 [info]: tools: rd=3D2 psy-rd=3D2.00 early-skip rskip tmvp =
fast-intra
x265 [info]: tools: strong-intra-smoothing lslices=3D6 deblock
[mpegts @ 0x2d29440] Using AVStream.codec to pass codec parameters to =
muxers is deprecated, use AVStream.codecpar instead.
    Last message repeated 1 times
Output #0, mpegts, to '/home/oliver/Desktop/capture.ts':
  Metadata:
    encoder         : Lavf57.48.101
    Stream #0:0: Video: hevc (libx265), yuv422p, 1920x1080, q=3D2-31, =
3200 kb/s, 50 fps, 90k tbn, 50 tbc
    Metadata:
      encoder         : Lavc57.54.101 libx265
    Stream #0:1: Audio: aac (LC), 48000 Hz, stereo, fltp, delay 1024, =
padding 0, 192 kb/s
    Metadata:
      encoder         : Lavc57.54.101 aac
Stream mapping:
  Stream #0:0 -> #0:0 (rawvideo (native) -> hevc (libx265))
  Stream #1:0 -> #0:1 (pcm_s16le (native) -> aac (native))
Press [q] to stop, [?] for help
Past duration 0.737694 too large
frame=3D   25 fps=3D0.0 q=3D-0.0 size=3D      36kB time=3D00:00:00.21 =
bitrate=3D1364.5kbits/frame=3D   51 fps=3D 50 q=3D-0.0 size=3D     102kB =
time=3D00:00:00.72 bitrate=3D1151.9kbits/frame=3D   76 fps=3D 50 q=3D-0.0 =
size=3D     145kB time=3D00:00:01.21 bitrate=3D 976.7kbits/frame=3D  101 =
fps=3D 50 q=3D-0.0 size=3D     293kB time=3D00:00:01.72 =
bitrate=3D1388.8kbits/frame=3D  127 fps=3D 50 q=3D-0.0 size=3D     367kB =
time=3D00:00:02.24 bitrate=3D1342.6kbits/frame=3D  151 fps=3D 50 q=3D-0.0 =
size=3D     486kB time=3D00:00:02.73 bitrate=3D1457.1kbits/frame=3D  177 =
fps=3D 50 q=3D-0.0 size=3D     580kB time=3D00:00:03.24 =
bitrate=3D1465.0kbits/frame=3D  202 fps=3D 50 q=3D-0.0 size=3D     634kB =
time=3D00:00:03.73 bitrate=3D1392.0kbits/frame=3D  227 fps=3D 50 q=3D-0.0 =
size=3D     739kB time=3D00:00:04.24 bitrate=3D1425.4kbits/frame=3D  253 =
fps=3D 50 q=3D-0.0 size=3D     831kB time=3D00:00:04.75 =
bitrate=3D1430.7kbits/frame=3D  263 fps=3D 49 q=3D-0.0 Lsize=3D     =
876kB time=3D00:00:05.20 bitrate=3D1379.6kbits/s dup=3D0 drop=3D1 =
speed=3D0.967x   =20
video:783kB audio:1kB subtitle:0kB other streams:0kB global headers:0kB =
muxing overhead: 11.578809%
x265 [info]: frame I:      2, Avg QP:34.86  kb/s: 6431.20=20
x265 [info]: frame P:     66, Avg QP:17.10  kb/s: 4360.92=20
x265 [info]: frame B:    195, Avg QP:19.80  kb/s: 97.53  =20
x265 [info]: consecutive B-frames: 4.4% 0.0% 0.0% 95.6%=20

encoded 263 frames in 5.38s (48.87 fps), 1215.59 kb/s, Avg QP:19.24
[aac @ 0x2d253e0] Qavg: 65536.000


--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41
Content-Disposition: attachment;
	filename=ffmpeg_third_ffmpeg_capture.txt
Content-Type: text/plain;
	name="ffmpeg_third_ffmpeg_capture.txt"
Content-Transfer-Encoding: quoted-printable

oliver@NUC-1:~$ ./ffmpeg -f v4l2 -thread_queue_size 1024 -video_size =
1920x1080 -framerate 25 -i /dev/video0 -f alsa -thread_queue_size 1024 =
-i "hw:CARD=3DXI100DUSBHDMI,DEV=3D0" -vcodec libx265 -preset ultrafast =
-vb 3200k -maxrate 3200k -bufsize 3200k -vf yadif=3D1 -acodec aac -ab =
192k -t 60 -f mpegts ~/Desktop/capture.ts -y
ffmpeg version N-81511-gaabe12e Copyright (c) 2000-2016 the FFmpeg =
developers
  built with gcc 5.4.0 (Ubuntu 5.4.0-6ubuntu1~16.04.2) 20160609
  configuration: --enable-gpl --enable-version3 --enable-static =
--enable-libx264 --enable-libx265 --enable-nvenc --enable-libpulse =
--disable-debug
  libavutil      55. 29.100 / 55. 29.100
  libavcodec     57. 54.101 / 57. 54.101
  libavformat    57. 48.101 / 57. 48.101
  libavdevice    57.  0.102 / 57.  0.102
  libavfilter     6. 58.100 /  6. 58.100
  libswscale      4.  1.100 /  4.  1.100
  libswresample   2.  1.100 /  2.  1.100
  libpostproc    54.  0.100 / 54.  0.100
[video4linux2,v4l2 @ 0x29e7560] Dequeued v4l2 buffer contains corrupted =
data (0 bytes).
    Last message repeated 31 times
Input #0, video4linux2,v4l2, from '/dev/video0':
  Duration: N/A, start: 1080.263350, bitrate: 829440 kb/s
    Stream #0:0: Video: rawvideo (YUY2 / 0x32595559), yuyv422, =
1920x1080, 829440 kb/s, 25 fps, 25 tbr, 1000k tbn, 1000k tbc
Guessed Channel Layout for Input Stream #1.0 : stereo
Input #1, alsa, from 'hw:CARD=3DXI100DUSBHDMI,DEV=3D0':
  Duration: N/A, start: 1473103372.947138, bitrate: 1536 kb/s
    Stream #1:0: Audio: pcm_s16le, 48000 Hz, 2 channels, s16, 1536 kb/s
x265 [info]: HEVC encoder version 2.0+1-6a9b6a828f79
x265 [info]: build info [Linux][GCC 5.4.0][64 bit] 8bit
x265 [info]: using cpu capabilities: MMX2 SSE2Fast SSSE3 SSE4.2 AVX AVX2 =
FMA3 LZCNT BMI2
x265 [info]: Main 4:2:2 10 profile, Level-4.1 (Main tier)
x265 [info]: Thread pool created using 8 threads
x265 [info]: frame threads / pool features       : 3 / wpp(34 rows)
x265 [info]: Coding QT: max CU size, min CU size : 32 / 16
x265 [info]: Residual QT: max TU size, max depth : 32 / 1 inter / 1 =
intra
x265 [info]: ME / range / subpel / merge         : dia / 57 / 0 / 2
x265 [info]: Keyframe min / max / scenecut       : 25 / 250 / 0
x265 [info]: Lookahead / bframes / badapt        : 5 / 3 / 0
x265 [info]: b-pyramid / weightp / weightb       : 1 / 0 / 0
x265 [info]: References / ref-limit  cu / depth  : 1 / off / off
x265 [info]: AQ: mode / str / qg-size / cu-tree  : 1 / 0.0 / 32 / 1
x265 [info]: Rate Control / qCompress            : ABR-3200 kbps / 0.60
x265 [info]: tools: rd=3D2 psy-rd=3D2.00 early-skip rskip tmvp =
fast-intra
x265 [info]: tools: strong-intra-smoothing lslices=3D6 deblock
[mpegts @ 0x2a02440] Using AVStream.codec to pass codec parameters to =
muxers is deprecated, use AVStream.codecpar instead.
    Last message repeated 1 times
Output #0, mpegts, to '/home/oliver/Desktop/capture.ts':
  Metadata:
    encoder         : Lavf57.48.101
    Stream #0:0: Video: hevc (libx265), yuv422p, 1920x1080, q=3D2-31, =
3200 kb/s, 50 fps, 90k tbn, 50 tbc
    Metadata:
      encoder         : Lavc57.54.101 libx265
    Stream #0:1: Audio: aac (LC), 48000 Hz, stereo, fltp, delay 1024, =
padding 0, 192 kb/s
    Metadata:
      encoder         : Lavc57.54.101 aac
Stream mapping:
  Stream #0:0 -> #0:0 (rawvideo (native) -> hevc (libx265))
  Stream #1:0 -> #0:1 (pcm_s16le (native) -> aac (native))
Press [q] to stop, [?] for help
Past duration 0.737587 too large
Past duration 0.835243 too large
Past duration 0.835213 too large
Past duration 0.835197 too large
Past duration 0.835320 too large
Past duration 0.835442 too large
Past duration 0.835213 too large
Past duration 0.834999 too large
Past duration 0.834969 too large
Past duration 0.834938 too large
Past duration 0.835243 too large
Past duration 0.835548 too large
Past duration 0.835564 too large
Past duration 0.835594 too large
    Last message repeated 2 times
Past duration 0.835670 too large
Past duration 0.835747 too large
    Last message repeated 2 times
frame=3D   22 fps=3D0.0 q=3D-0.0 size=3D      21kB time=3D00:00:00.12 =
bitrate=3D1322.4kbits/Past duration 0.835594 too large
Past duration 0.835442 too large
Past duration 0.835640 too large
Past duration 0.835838 too large
Past duration 0.835869 too large
Past duration 0.835899 too large
Past duration 0.835915 too large
Past duration 0.835945 too large
    Last message repeated 2 times
Past duration 0.835991 too large
Past duration 0.836037 too large
Past duration 0.836021 too large
Past duration 0.835991 too large
Past duration 0.836037 too large
Past duration 0.836098 too large
Past duration 0.836113 too large
Past duration 0.836143 too large
Past duration 0.836174 too large
Past duration 0.836189 too large
    Last message repeated 2 times
Past duration 0.836235 too large
Past duration 0.836296 too large
Past duration 0.836220 too large
Past duration 0.836143 too large
Past duration 0.836266 too large
Past duration 0.836388 too large
Past duration 0.836372 too large
frame=3D   51 fps=3D 50 q=3D-0.0 size=3D     102kB time=3D00:00:00.70 =
bitrate=3D1182.9kbits/Past duration 0.836342 too large
Past duration 0.836449 too large
Past duration 0.836540 too large
    Last message repeated 2 times
Past duration 0.836571 too large
Past duration 0.836586 too large
Past duration 0.836647 too large
Past duration 0.836693 too large
    Last message repeated 2 times
Past duration 0.836723 too large
Past duration 0.836739 too large
Past duration 0.836800 too large
frame=3D   65 fps=3D 46 q=3D-0.0 Lsize=3D     146kB time=3D00:00:01.24 =
bitrate=3D 964.2kbits/s dup=3D0 drop=3D1 speed=3D0.875x   =20
video:128kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB =
muxing overhead: 13.423185%
x265 [info]: frame I:      1, Avg QP:36.94  kb/s: 264.80 =20
x265 [info]: frame P:     17, Avg QP:28.68  kb/s: 2860.12=20
x265 [info]: frame B:     47, Avg QP:31.85  kb/s: 68.03  =20
x265 [info]: consecutive B-frames: 11.1% 0.0% 5.6% 83.3%=20

encoded 65 frames in 1.42s (45.77 fps), 801.29 kb/s, Avg QP:31.10
[aac @ 0x29fe3e0] Qavg: 65536.000


--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii




> On 4 Sep 2016, at 22:25, Andrey Utkin <andrey_utkin@fastmail.com> wrote:
> 
> Hi!
> Seems like weird error in V4L subsystem or in uvcvideo driver, in the
> most standard usage scenario.
> Please retry with kernel and FFmpeg as new as possible, best if compiled
> from latest upstream sources.
> For kernel please try release 4.7.2 or even linux-next
> (git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git), for
> FFmpeg please make a git clone from git://source.ffmpeg.org/ffmpeg.git
> and there do "./configure && make" and run obtained "ffmpeg" binary.
> 
> Please CC me when you come back with your results.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Apple-Mail=_BDD59087-67CD-43F3-897C-220D9C444D41--
