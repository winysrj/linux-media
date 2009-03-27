Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2RH52mH003254
	for <video4linux-list@redhat.com>; Fri, 27 Mar 2009 13:05:02 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.242])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2RH4hI5021727
	for <video4linux-list@redhat.com>; Fri, 27 Mar 2009 13:04:43 -0400
Received: by an-out-0708.google.com with SMTP id c2so779031anc.36
	for <video4linux-list@redhat.com>; Fri, 27 Mar 2009 10:04:43 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 Mar 2009 11:04:42 -0600
Message-ID: <2df568dc0903271004p4f2e551fo4c459d2759062d2b@mail.gmail.com>
From: Gordon Smith <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: saa7134 encoded data loss
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

Hello -

I have a RTD Technologies VFG7350 (saa7134 based, no tuner) running current
v4l-dvb in debian 2.6.26-1.

Using live555 MediaServer, I can capture MPEG output:
{{{
cat /dev/video2 > test.ts
}}}
and stream without error to VLC client for as long as I care to watch.

If I use live555 test program to stream directly to network:
{{{
$ cat /dev/video2 | sudo ./testMPEG2TransportStreamer
}}}
the client shows continuous partial data loss after a variable amount of
time (~2.5 minutes).

I believe the test program uses the same underlying code as MediaServer, but
I haven't verified that yet.


I'd like to ask if the dmesg output below shows abnormality?

saa7134 modprobe.d settings:
{{{
options saa7134 core_debug=1 ts_debug=1 video_debug=1
}}}

dmesg during error free playback:
{{{
[  867.865020] saa7133[0]/ts: buffer_activate [cedce480]<7>saa7133[0]/ts: -
[top]     buf=cedce480 next=cedce180
[  867.865036] saa7133[0]/core: dmabits: task=0x00 ctrl=0x20 irq=0x30000
split=yes
[  867.865045] saa7133[0]/core: buffer_next #2 prev=caa80f2c/next=cedce1ac
[  867.865254] saa7133[0]/core: buffer_queue caa80e40
[  867.878682] saa7133[0]/core: buffer_finish cedce480
[  867.878695] saa7133[0]/core: buffer_next cedce180
[prev=caa80e6c/next=cedce1ac]
[  867.878703] saa7133[0]/ts: buffer_activate [cedce180]<7>saa7133[0]/ts: -
[bottom]  buf=cedce180 next=cedce780
[  867.878718] saa7133[0]/core: dmabits: task=0x00 ctrl=0x20 irq=0x30000
split=yes
[  867.878727] saa7133[0]/core: buffer_next #2 prev=caa80e6c/next=cedce7ac
[  867.878934] saa7133[0]/core: buffer_queue cedce480
[  867.892339] saa7133[0]/core: buffer_finish cedce180
[  867.892353] saa7133[0]/core: buffer_next cedce780
[prev=cedce4ac/next=cedce7ac]
}}}

dmesg during packet loss:
{{{
[  570.720624] saa7133[0]/ts: buffer_activate [caa67e20]<7>saa7133[0]/ts: -
[bottom]  buf=caa67e20 next=caa67e20
[  570.720640] saa7133[0]/core: dmabits: task=0x00 ctrl=0x20 irq=0x30000
split=yes
[  570.720649] saa7133[0]/core: buffer_next #2 prev=cf97c714/next=cf97c714
[  570.729136] saa7133[0]/core: buffer_queue cedce180
[  570.734314] saa7133[0]/core: buffer_finish caa67e20
[  570.734325] saa7133[0]/core: buffer_next cedce180
[prev=cedce1ac/next=cedce1ac]
[  570.734333] saa7133[0]/ts: buffer_activate [cedce180]<7>saa7133[0]/ts: -
[top]     buf=cedce180 next=cedce180
[  570.734349] saa7133[0]/core: dmabits: task=0x00 ctrl=0x20 irq=0x30000
split=yes
[  570.734358] saa7133[0]/core: buffer_next #2 prev=cf97c714/next=cf97c714
[  570.747999] saa7133[0]/core: buffer_finish cedce180
[  570.748009] saa7133[0]/core: buffer_next 00000000
[  570.748019] saa7133[0]/core: dmabits: task=0x00 ctrl=0x00 irq=0x0
split=yes
[  570.749162] saa7133[0]/core: buffer_queue cedce780
[  570.773149] saa7133[0]/core: buffer_queue cedce900
[  570.773160] saa7133[0]/ts: buffer_activate [cedce900]<7>saa7133[0]/ts: -
[top]     buf=cedce900 next=cedce780
[  570.773177] saa7133[0]/core: dmabits: task=0x00 ctrl=0x20 irq=0x30000
split=yes
[  570.789159] saa7133[0]/core: buffer_queue cedce540
[  570.800566] saa7133[0]/core: buffer_finish cedce900
[  570.800578] saa7133[0]/core: buffer_next cedce780
[prev=cedce56c/next=cedce7ac]
}}}

In particular, is this ok?
{{{
[  570.748009] saa7133[0]/core: buffer_next 00000000
[  570.748019] saa7133[0]/core: dmabits: task=0x00 ctrl=0x00 irq=0x0
split=yes
}}}
It does not appear during normal playback.


Thanks for your assistance,
Gordon
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
