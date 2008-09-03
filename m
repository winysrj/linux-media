Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m83Lmo6r011034
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 17:48:51 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m83LmLFN022320
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 17:48:40 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2841404rvb.51
	for <video4linux-list@redhat.com>; Wed, 03 Sep 2008 14:48:40 -0700 (PDT)
Message-ID: <2df568dc0809031448y3e70715codb5f3a0be505f6cf@mail.gmail.com>
Date: Wed, 3 Sep 2008 15:48:39 -0600
From: "Gordon Smith" <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: saa7134_empress standard vs input
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

Greetings -

I have a RTD Technologies VFG7350 (saa7134 based, two channel,
hardware encoder per channel, no tuner) running current v4l-dvb in
2.6.25-gentoo-r7.

Short form question: Is it necessary to do something to connect an
input standard to an MPEG encoder?

I seem to have a disconnect between input signal and the MPEG encoder.
In this case, there is a NTSC camera signal on the input.
Raw data and input selection are on video0. Raw data can be read from
and input selected on video0. MPEG encoder output is on video2. MPEG
data can be read from video2, but it looks like PAL aspect with NTSC
data (extra lines at bottom of image repeat uppermost lines).


$ v4l2-ctl --get-standard --device /dev/video0
Video Standard = 0x0000b000
        NTSC-M/M-JP/M-KR
$ v4l2-ctl --get-standard --device /dev/video2
Video Standard = 0x000000ff
        PAL-B/B1/G/H/I/D/D1/K


The input standard is automatically selected by the hardware.
Is there something that needs to be set to match the standard between
input and encoder?

Thanks,
Gordon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
