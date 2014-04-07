Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57477 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaDGAEr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Apr 2014 20:04:47 -0400
Received: by mail-pd0-f178.google.com with SMTP id x10so5779345pdj.9
        for <linux-media@vger.kernel.org>; Sun, 06 Apr 2014 17:04:46 -0700 (PDT)
Received: from [192.168.20.3] ([120.155.51.210])
        by mx.google.com with ESMTPSA id ir10sm32606494pbc.59.2014.04.06.17.04.42
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 06 Apr 2014 17:04:45 -0700 (PDT)
From: Ryley Angus <ryleyjangus@gmail.com>
Content-Type: multipart/mixed; boundary="Apple-Mail=_7988D175-5A69-4CA1-AD51-7A322ED43559"
Subject: [RFC] Fix interrupted recording with Hauppauge HD-PVR
Message-Id: <C2340839-C85B-4DDF-8590-FA9049D6E65E@gmail.com>
Date: Mon, 7 Apr 2014 10:04:35 +1000
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail=_7988D175-5A69-4CA1-AD51-7A322ED43559
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

(Sorry in advance for probably breaking a few conventions of the mailing =
lists. First time using one so please let me know what I=92m doing =
wrong)

I=92m writing this because of an issue I had with my Hauppauge HD-PVR. I =
record from my satellite set top box using component video and optical =
audio input. I basically use "cat /dev/video0 > ~/video.ts=94 or use dd. =
The box is set to output audio as AC-3 over optical, but most channels =
are actually output as stereo PCM. When the channel is changed between a =
PCM channel and (typically to a movie channel) to a channel utilising =
AC-3, the HD-PVR stops the recording as the set top box momentarily =
outputs no audio. Changing between PCM channels doesn=92t cause any =
issues.

My main problem was that when this happens, cat/dd doesn=92t actually =
exit. When going through the hdpvr driver source and the dmesg output, I =
found the hdpvr driver wasn=92t actually shutting down the device =
properly until I manually killed cat/dd.

I=92ve seen references to this issue being a hardware issue from as far =
back as 2010: =
http://forums.gbpvr.com/showthread.php?46429-HD-PVR-drops-recording-on-cha=
nnel-change-Hauppauge-says-too-bad .

I tracked my issue to the file =93hdpvr-video.c=94. Specifically, =93if =
(wait_event_interruptible(dev->wait_data, buf->status =3D =
BUFSTAT_READY)) {=93 (line ~450). The device seems to get stuck waiting =
for the buffer to become ready. But as far as I can tell, when the =
channel is changed between a PCM and AC-3 broadcast the buffer status =
will never actually become ready.=20

I haven=92t really ever done much coding, but I wrote a really nasty =
patch for this which tracks the devices buffer status and stops/starts =
the devices recording when the buffer is not ready for a period of time. =
In my limited testing it has worked perfectly, no output is overwritten, =
the output is in sync and the recording changes perfectly between stereo =
AC-3 (PCM input is encoded to AC-3 by the hardware) and 5.1 AC-3 no =
matter how frequently I change the channels back and forth. All changes =
are transparent to cat/dd and neither exit prematurely. Manually killing =
cat/dd seems to properly shut down the device. There is a half-second =
glitch in the resultant where the recording restarts, but this amounts =
to less than a second of lost footage during the change and compared to =
having the device hang, I can live with it. I haven=92t had the device =
restart recording when it shouldn=92t have.

So considering my code is really messy, I=92d love it if someone could =
make some suggestions to make the code better and make sure I don=92t =
have too many logic errors. I don=92t really know too much about kernel =
coding practices either. And if anyone who=92s experienced my issue =
could try out my change and let me know that=92d be great. You will have =
to run "v4l2-ctl --verbose -d /dev/video0 -c audio_encoding=3D4=94 to =
ensure the 5.1 AC-3 is captured properly (AAC capture of 5.1 sources =
doesn=92t seem possible) and "v4l2-ctl --verbose -d $MPEG4_IN =
--set-audio-input=3D2=94 to capture from the optical input.

Thanks in advance,

ryley


--- a/hdpvr-video.c	2014-04-07 09:34:31.000000000 +1000
+++ b/hdpvr-video.c	2014-04-07 09:37:44.000000000 +1000
@@ -453,11 +453,17 @@
 					ret =3D -EAGAIN;
 				goto err;
 			}
-
-			if (wait_event_interruptible(dev->wait_data,
-					      buf->status =3D=3D =
BUFSTAT_READY)) {
-				ret =3D -ERESTARTSYS;
-				goto err;
+			int counter=3D0;
+			while (buf->status !=3D BUFSTAT_READY) {
+				counter++;
+				msleep(20);
+				if (counter =3D=3D 30) {
+					v4l2_dbg(MSG_INFO, hdpvr_debug, =
&dev->v4l2_dev,
+                                                "limit hit, counter is =
%d, buf status is %d\n", counter, buf->status);
+					counter=3D0;
+					ret =3D =
hdpvr_stop_streaming(dev);
+					ret =3D =
hdpvr_start_streaming(dev);
+				}
 			}
 		}


--Apple-Mail=_7988D175-5A69-4CA1-AD51-7A322ED43559
Content-Disposition: attachment;
	filename=resume-recording-during-spdif-channel-change.patch
Content-Type: application/octet-stream;
	name="resume-recording-during-spdif-channel-change.patch"
Content-Transfer-Encoding: 7bit

diff -Naur a/hdpvr-video.c b/hdpvr-video.c
--- a/hdpvr-video.c	2014-04-07 09:34:31.000000000 +1000
+++ b/hdpvr-video.c	2014-04-07 09:37:44.000000000 +1000
@@ -453,11 +453,17 @@
 					ret = -EAGAIN;
 				goto err;
 			}
-
-			if (wait_event_interruptible(dev->wait_data,
-					      buf->status == BUFSTAT_READY)) {
-				ret = -ERESTARTSYS;
-				goto err;
+			int counter=0;
+			while (buf->status != BUFSTAT_READY) {
+				counter++;
+				msleep(20);
+				if (counter == 30) {
+					v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
+                                                "limit hit, counter is %d, buf status is %d\n", counter, buf->status);
+					counter=0;
+					ret = hdpvr_stop_streaming(dev);
+					ret = hdpvr_start_streaming(dev);
+				}
 			}
 		}
 

--Apple-Mail=_7988D175-5A69-4CA1-AD51-7A322ED43559
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii





--Apple-Mail=_7988D175-5A69-4CA1-AD51-7A322ED43559--
