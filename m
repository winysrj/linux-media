Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m47BaLLV010096
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 07:36:21 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m47Ba9WK022548
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 07:36:09 -0400
Received: by ug-out-1314.google.com with SMTP id s2so120439uge.6
	for <video4linux-list@redhat.com>; Wed, 07 May 2008 04:36:08 -0700 (PDT)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Video-4l-list" <video4linux-list@redhat.com>
Date: Wed, 7 May 2008 14:36:03 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071436.03569.maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [BUG] sound is unmuted by default with 2.6.26-rc1 on my FlyVideo
	2000
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

Hi,

I was very busy, thus I didn't follow kernel development lately.
I skipped whole 2.6.25 cycle.

Now I have a bit more free time, so I updated kernel to 2.6.25, and then
to latest -git.

In latest git I noticed that sound output of my TV card is unmuted by default.

commit 7bff4b4d3ad2b9ff42b4087f409076035af1d165, clears all GPIO lines,
and on my card mute is implemented with external chip which is connected via GPIO,
and this results in the above bug.

The code that clears all gpios executed last, thus it undoes the saa7134_tvaudio_setmute
in saa7134_video_init2.

moving saa7134_tvaudio_setmute after gpio clearing doesn't help, bacause this function is
"smart" thus it remembers last mute state and touches the hardware only if this state changes.
(And first time it is called from video_mux, thus explict call from saa7134_video_init2 isn't necessary I think)

I once had trouble with this thing, when wrote the resume code, thus I added a flag (dev->insuspend
that made this function set mute state always when set.
(This is a bit hackish, but I had to use this flag anyway in other places, so I decided that this is ok)

I could remove this "smart" check, but I tested and found that this function is called qute often from tvaudio thread, and thus this check probably is correct.



Best regards,
	Maxim Levitsky

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
