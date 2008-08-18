Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7IMGTIF002609
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 18:16:29 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7IMGG5K029623
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 18:16:16 -0400
Received: by rv-out-0506.google.com with SMTP id f6so4856371rvb.51
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 15:16:16 -0700 (PDT)
Message-ID: <2df568dc0808181516g49377e0fj73c104696d8616d4@mail.gmail.com>
Date: Mon, 18 Aug 2008 16:16:15 -0600
From: "Gordon Smith" <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: saa7134_empress hang on close()
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

I have a saa7134 based video capture card running in kernel
2.6.24.4(gentoo). I can view raw and compressed video on both channels
of the card
using xawtv and mplayer.

However, any program reading a compressed stream that attempts to exit,
hangs and is unkillable. This includes cat, mplayer, and the example V4L2
program capture.c.

I removed capture code from capture.c (because, unlike mplayer, it doesn't
capture) and left only open() and close() and found that it hangs on
close().

Any thoughts on how I might solve this problem?

Thanks,
Gordon
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
