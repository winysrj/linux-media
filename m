Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHDfS3n024327
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 08:41:28 -0500
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHDfOGF005429
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 08:41:24 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id EC85E134DF4B
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:41:22 +0000 (GMT)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TJ7QJFhho4XL for <video4linux-list@redhat.com>;
	Wed, 17 Dec 2008 13:41:22 +0000 (GMT)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id A5D66134DF47
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:41:22 +0000 (GMT)
Message-ID: <49490182.3000507@pickworth.me.uk>
Date: Wed, 17 Dec 2008 13:41:22 +0000
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <4948F603.1070906@wakelift.de>
In-Reply-To: <4948F603.1070906@wakelift.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: zc3xx webcam (041e:4034 Creative Webcam Instant) stopped working
 some time ago (since gspca kernel integration?)
Reply-To: ian@pickworth.me.uk
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

Timo Paulssen wrote:
> Hello,
> 
> I recently tried using my webcam, the Creative Webcam Instant (usb ID
> 041e:4034) again, but I can't get it to work any more.
> 
> When I started using this webcam, i could get it to work with the
> spca5xx driver, which I usually compiled per hand and inserted into the
> kernel. Then came gspcav1, which worked, too. But with the gspca, that
> is integrated in the kernel now (I'm using 2.6.27.9 retrieved from
> kernel.org) the webcam won't work.
> 

I'm not a developer, so can't explain what the change is, but there is a
significant change to where the webcam data gets processed which was
introduced with the move of the gspca drivers into the kernel.

Basically, you now need a user space driver library - libv4l - to do the
work. You can get the library from here:

http://people.atrpms.net/~hdegoede/libv4l-0.5.7.tar.gz

After making it, you preload it when running spcaview like this:

LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so spcaview -d /dev/video_webcam

as an example.

Regards
Ian

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
