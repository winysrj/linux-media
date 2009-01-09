Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <5e9665e10901081920q4d99fe3ercf163a285d1462c5@mail.gmail.com>
Date: Fri, 9 Jan 2009 12:20:16 +0900
From: "DongSoo Kim" <dongsoo.kim@gmail.com>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: =?EUC-KR?B?x/zB2CCx6A==?= <riverful.kim@samsung.com>,
	video4linux-list@redhat.com, kyungmin.park@samsung.com,
	jongse.won@samsung.com
Subject: Any rules in making ioctl or cids?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Hello everyone.

I'm facing with some questions about "Can I make it ioctl or CID?"

Because if I make it in ioctl It should occupy one of the extra ioctl
number for v4l2, and I'm afraid it deserves that.

Actually I'm working on strobe flash device (like xenon flash, LED
flash and so on...) for digital camera.

And in my opinion it looks good in v4l2 than in misc device. (or..is
there some subsystems for strobe light? sorry I can't find it yet)

As far as I worked on, strobe light seems to be more easy to control
over ioctl than CID. Since we need to check its status (like not
charged, turned off etc..).

But here is the thing.

"Is that really worthy of occupying an ioctl number for v4l2?"

Can I use extra ioctl numbers as many as I like for v4l2 if It is reasonable?

Can I have a rule if there is a rule for that?


-- 
========================================================
Dong Soo, Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
           dongsoo45.kim@samsung.com
========================================================

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
