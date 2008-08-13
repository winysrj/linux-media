Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DNXHEU010124
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 19:33:17 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7DNXFKJ026229
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 19:33:16 -0400
Received: by nf-out-0910.google.com with SMTP id d3so121779nfc.21
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 16:33:15 -0700 (PDT)
Date: Thu, 14 Aug 2008 09:33:20 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>, Hartmut Hackmann
	<hartmut.hackmann@t-online.de>, video4linux-list@redhat.com, "Mauro
	Carvalho Chehab" <mchehab@infradead.org>, gert.vervoort@hccnet.nl
Message-ID: <20080814093320.49265ec1@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/+YmaRw8iBJ+5hNbHVIobMox"
Cc: 
Subject: MPEG stream work
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

--MP_/+YmaRw8iBJ+5hNbHVIobMox
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Now I have MPEG stream from the saa6752hs MPEG encoder TV card of Beholder M6.

See test video 
http://debian.oshec.org/binary/tmp/mpeg01.dat

This is my script for configure TV card and read data

<script start>

echo "Set Frequency..."
./v4l2-ctl --set-freq=623.25 -d /dev/video0
echo "Set INPUT Id"
./v4l2-ctl --set-input=0 -d /dev/video0
echo "Set Norm"
./v4l2-ctl -s=secam-d -d /dev/video0
echo "Set INPUT Id"
./v4l2-ctl --set-input=0 -d /dev/video1
echo "Set Norm"
./v4l2-ctl -s=secam-d -d /dev/video1
echo "Start MPEG"
echo "Configure MPEG stream"
echo "Set Bitrate mode"
./v4l2-ctl -c video_bitrate_mode=0 -d /dev/video1
echo "Set audio sampling frequency"
./v4l2-ctl -c audio_sampling_frequency=1 -d /dev/video1
echo "Set audio encoding"
./v4l2-ctl -c audio_encoding_layer=1 -d /dev/video1
echo "Set audio bitrate"
./v4l2-ctl -c audio_layer_ii_bitrate=11 -d /dev/video1
echo "Set video bitrate"
./v4l2-ctl -c video_bitrate=7500000 -d /dev/video1
./v4l2-ctl -c video_peak_bitrate=9500000 -d /dev/video1
echo "Set aspect video"
./v4l2-ctl -c video_aspect=1 -d /dev/video1

cat /dev/video1 > test

<script stop>

But I have a trouble. I can't set correct Freq for TV tuner. I send command to tuner
but data from tuner to MPEG encoder is wrong. The encoder send to host stream with "snow window".
Anybody can help me??

With my best regards, Dmitry.

--MP_/+YmaRw8iBJ+5hNbHVIobMox
Content-Type: application/octet-stream; name=test.bin
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=test.bin

RwEEEppHQh23/Vv0IzsMwv/Mo5oi7pyWGdHSV923333dTbpSerPbchCHJRZLdulJZWK4tmR3OyMq
RJKQGYrIQlKNt3x7/7dDut3QNW9mLS4ClO2S34zozdYxHHrbxFS2/3TgCd0o+27jRmDtgs+UYjbf
Mp+7MluvOT5Q1HQGtunJ2GGj8+W+C6/4pB4ZkckusJZO3yQkYp92iLsGhBfRunDdtnbEjvm4COBK
fIbDe604tDd+//fimy7GtPxHAQQTzbv3dGUK7uRrSQ2IZM41eYvDduwwbjnbrPiLKlKs3Unf7JQl
DMy9nx62z1mGldPcszJw3n7MzCP/zydAZiUjdwwvJ2QMduf1hI1T9ekdAzdvskYN+zb/p2ZSlMbE
WtShKyX0jVKSM+7ZG6ldS1PKhPLUNT2RkElaMrffuKNqi0jduyF5au+bO4834dWofDGMT90/pP++
z9tuI8RYFJ6M/NGpbdussX8cMw2zluWENvuf+6j8bhbWjUcBBBTyH/+yOjt+nMEtktn3x2MXFyuT
fxqC/uSdvz8EPhoqItnXmboZPYJ/7/Zew1AD0RH9XNRj0fn/J57Lr+Vg1CEl7deR/++JKdzkGfZl
y9KWw1GOfKWvjFKMFxFkGrGq/2G7ZKkD19nMpy/vz9kmM799834rbvL8d9w3fb5jVoWdjSSsTXM=

--MP_/+YmaRw8iBJ+5hNbHVIobMox
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/+YmaRw8iBJ+5hNbHVIobMox--
