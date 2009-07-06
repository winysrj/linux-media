Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n662jIM2001067
	for <video4linux-list@redhat.com>; Sun, 5 Jul 2009 22:45:18 -0400
Received: from mail-ew0-f220.google.com (mail-ew0-f220.google.com
	[209.85.219.220])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n662j4EM002961
	for <video4linux-list@redhat.com>; Sun, 5 Jul 2009 22:45:05 -0400
Received: by ewy20 with SMTP id 20so4159158ewy.3
	for <video4linux-list@redhat.com>; Sun, 05 Jul 2009 19:45:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A5140F0.40909@gmail.com>
References: <4A5089CF.3070606@gmail.com>
	<26aa882f0907051330y6f092ca3x18e1f58e883352d4@mail.gmail.com>
	<4A511E18.2010305@gmail.com>
	<26aa882f0907051606x9b9f63bi6a7a9d5ea7db6126@mail.gmail.com>
	<4A5140F0.40909@gmail.com>
Date: Sun, 5 Jul 2009 22:45:03 -0400
Message-ID: <26aa882f0907051945k2d568e18ib47a9dd8aa9a6ccf@mail.gmail.com>
From: Jackson Yee <jackson@gotpossum.com>
To: fsulima <fsulima@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Please advise: 4channel capture device with HW compression for
	Linux based DVR
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

On Sun, Jul 5, 2009 at 8:10 PM, fsulima<fsulima@gmail.com> wrote:
> Oh, this is too pricy.
> Are you talking only about cards with H/W encoding or about all low profile
> multiple port capture cards?

*ALL* low profile multiple port capture cards. The good hardware
encode cards, particularly the h264 ones, run in the thousands.

> So, could you please say more about LP vs regular PCI capturers (W/O H/W
> encoding)? Are there inexpensive LP solutions?

None in my experience that work with four ports and 30fps per port
under $500. I would suggest four WinTV USB2's and possibly an
additional PCI to USB card which would take some of the load off of
your motherboard's main USB hub. That should cost about $250-300
depending on sale prices for the WinTV USB2. I've never tried four in
a single system, but theoretically, it should work well.

Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
