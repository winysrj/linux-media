Return-path: <linux-media-owner@vger.kernel.org>
Received: from pv33p04im-asmtp001.me.com ([17.143.181.10]:47607 "EHLO
        pv33p04im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755311AbcIJKVf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 06:21:35 -0400
Received: from process-dkim-sign-daemon.pv33p04im-asmtp001.me.com by
 pv33p04im-asmtp001.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0ODA00L009VPNO00@pv33p04im-asmtp001.me.com> for
 linux-media@vger.kernel.org; Sat, 10 Sep 2016 10:21:16 +0000 (GMT)
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: uvcvideo error on second capture from USB device,
 leading to V4L2_BUF_FLAG_ERROR
From: Oliver Collyer <ovcollyer@mac.com>
In-reply-to: <20160910101440.nlb4sp43u36yj4ql@zver>
Date: Sat, 10 Sep 2016 13:21:10 +0300
Cc: linux-media@vger.kernel.org, Support INOGENI <support@inogeni.com>,
        james.liu@magewell.net
Content-transfer-encoding: quoted-printable
Message-id: <E8CA02F7-7F3C-4D0A-BAFC-24CAB8A57AEB@mac.com>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
 <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
 <20160905201935.wpgtrtt7e4bjjylo@zver>
 <FE81AFD0-C5F1-4FE7-A282-3294E668066C@mac.com>
 <20160906122823.toxscjyxomrh2col@zver>
 <71006CF0-B710-435A-B5A5-C0D0D20DE34F@mac.com>
 <20160910101440.nlb4sp43u36yj4ql@zver>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> I have written a patch for FFmpeg that deals with the problem for =
both
>> devices so it=E2=80=99s not really an issue for me anymore, but I=E2=80=
=99m not sure
>> if the patch will get accepted in their master git as it=E2=80=99s a =
little
>> messy.
>=20
> Please post this patch here!

Here you go, Andrey. This patch basically makes it throw away corrupted =
buffers and then also the first 8 buffers after the last corrupted =
buffer.

It=E2=80=99s not sufficient just to throw away the corrupted buffers as =
I have noticed that the first few legitimate buffers appear at slightly =
irregular time intervals leading to FFmpeg spewing out a bunch of =
warnings for the duration of the capture. In my tests around 3 buffers =
have to be ignored but I=E2=80=99ve fixed it at 8 to be on the safe =
side. It=E2=80=99s a bit ugly though, to be honest, I don=E2=80=99t know =
how the number of buffers that need to be ignored would depend on the =
framerate, video size etc, but it works for my 1080i test.

With this patch, you get some warnings at the start, for both devices, =
as it encounters (and recovers from) the corrupted buffers but after =
that the captures work just fine.


diff --git a/libavdevice/v4l2.c b/libavdevice/v4l2.c
old mode 100644
new mode 100755
index ddf331d..7b4a826
--- a/libavdevice/v4l2.c
+++ b/libavdevice/v4l2.c
@@ -79,6 +79,7 @@ struct video_data {
=20
     int buffers;
     volatile int buffers_queued;
+    int buffers_ignore;
     void **buf_start;
     unsigned int *buf_len;
     char *standard;
@@ -519,7 +520,9 @@ static int mmap_read_frame(AVFormatContext *ctx, =
AVPacket *pkt)
         av_log(ctx, AV_LOG_WARNING,
                "Dequeued v4l2 buffer contains corrupted data (%d =
bytes).\n",
                buf.bytesused);
-        buf.bytesused =3D 0;
+        s->buffers_ignore =3D 8;
+        enqueue_buffer(s, &buf);
+        return FFERROR_REDO;
     } else
 #endif
     {
@@ -529,14 +532,28 @@ static int mmap_read_frame(AVFormatContext *ctx, =
AVPacket *pkt)
             s->frame_size =3D buf.bytesused;
=20
         if (s->frame_size > 0 && buf.bytesused !=3D s->frame_size) {
-            av_log(ctx, AV_LOG_ERROR,
+            av_log(ctx, AV_LOG_WARNING,
                    "Dequeued v4l2 buffer contains %d bytes, but %d were =
expected. Flags: 0x%08X.\n",
                    buf.bytesused, s->frame_size, buf.flags);
+            s->buffers_ignore =3D 8;
             enqueue_buffer(s, &buf);
-            return AVERROR_INVALIDDATA;
+            return FFERROR_REDO;
         }
     }
=20
+   =20
+    /* if we just encounted some corrupted buffers then we ignore the =
next few
+     * legitimate buffers because they can arrive at irregular =
intervals, causing
+     * the timestamps of the input and output streams to be out-of-sync =
and FFmpeg
+     * to continually emit warnings. */
+    if (s->buffers_ignore) {
+        av_log(ctx, AV_LOG_WARNING,
+               "Ignoring dequeued v4l2 buffer due to earlier =
corruption.\n");
+        s->buffers_ignore --;
+        enqueue_buffer(s, &buf);
+        return FFERROR_REDO;
+    }
+
     /* Image is at s->buff_start[buf.index] */
     if (avpriv_atomic_int_get(&s->buffers_queued) =3D=3D =
FFMAX(s->buffers / 8, 1)) {
         /* when we start getting low on queued buffers, fall back on =
copying data */
@@ -608,6 +625,7 @@ static int mmap_start(AVFormatContext *ctx)
         }
     }
     s->buffers_queued =3D s->buffers;
+    s->buffers_ignore =3D 0;
=20
     type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
     if (v4l2_ioctl(s->fd, VIDIOC_STREAMON, &type) < 0) {

