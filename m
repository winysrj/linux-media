Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAUHbM1E017574
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 12:37:22 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.235])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAUHbBF6016486
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 12:37:11 -0500
Received: by rv-out-0506.google.com with SMTP id f6so2392596rvb.51
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 09:37:10 -0800 (PST)
Message-ID: <e5df86c90811300937t4da8ff48s827e41bd55c2891c@mail.gmail.com>
Date: Sun, 30 Nov 2008 11:37:10 -0600
From: "Mark Jenks" <mjenks1968@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: HVR-1800 problems.
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

I have a HVR-1800 that I am trying to capture Svideo and stereo from a
SA4250 Cablebox.

If I tune the cable box to a channel, and try and run:
mplayer driver=v4l2:device=/dev/video0:input=2:normid=0 -vo -xv tv://

All I get is a scrambled screen that is mostly green, and no signal at
all.   If I try to run it a second or third time or more, the input changes
to 0 and it will not listen to the mplayer command to select input=2 no
matter what I try.

Does anyone out there have this working and can point me in the right
direction to get this working?   I would really like to get .mpg output from
the svideo and analog stereo from this card.

Otherwise, does anyone know of a card that I could use, that would work
better?

-Mark
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
