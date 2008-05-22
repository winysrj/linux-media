Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4M6vkTi006267
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 02:57:46 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4M6vUNP027103
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 02:57:31 -0400
Date: Thu, 22 May 2008 08:57:07 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Ryan Churches <ryan.churches@gmail.com>
Message-ID: <20080522065707.GA226@daniel.bse>
References: <a93d57c00805211820k5e1b4920ga548e1d541f20b3e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a93d57c00805211820k5e1b4920ga548e1d541f20b3e@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: scrambled video with bttv driver and bt848 (card=98)
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

On Wed, May 21, 2008 at 09:20:02PM -0400, Ryan Churches wrote:
> http://www.ubintel.com/files/nph-zms.jpeg

Looks like wrong tv standard.

> If i cat the video to a file and try to play it in VLC

cat /dev/videoX > file will never produce anything playable with bttv.
The bt878 can not compress your pictures. Your file will contain
uncompressed pictures without any headers that indicate the size.

> bttv15: subsystem: 1836:1540 (UNKNOWN)
> please mail id, board name and the correct card= insmod option to
> video4linux-list@redhat.com

What is your card's name?
This id is completely different from the PV150 id's in the driver.

> bttv15: PLL: 28636363 => 35468950 . ok

So it's trying to capture PAL video.
Do you live in a NTSC country?
If not, do you even have a 28.6 MHz crystal on your card?

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
