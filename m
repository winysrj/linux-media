Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHEQEAw016341
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 09:26:14 -0500
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHEQ14c031224
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 09:26:01 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id B7C2B134DF4F
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 14:26:00 +0000 (GMT)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v7fpOexSJr6W for <video4linux-list@redhat.com>;
	Wed, 17 Dec 2008 14:26:00 +0000 (GMT)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 62493134DF4B
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 14:26:00 +0000 (GMT)
Message-ID: <49490BF7.8010902@pickworth.me.uk>
Date: Wed, 17 Dec 2008 14:25:59 +0000
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <4948F603.1070906@wakelift.de> <49490182.3000507@pickworth.me.uk>
	<494906F5.40102@wakelift.de>
In-Reply-To: <494906F5.40102@wakelift.de>
Content-Type: text/plain; charset=ISO-8859-1
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
> Thank you very much! This made it work. I wonder why this information
> isn't made prominent somewhere on some v4l information place (linuxtv
> wiki?). Is it because the driver's not yet stable?

I forgot another thing - after the driver change I found that the
exposure was all wrong. The answer for that is another user space
program - v4l2ucp - which adjusts the exposure rate, white balance etc.

Its project page is here:

http://sourceforge.net/projects/v4l2ucp/

Don't know about the documentation. I think v4l is a tricky area to
document, it keeps changing.

Regards
Ian

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
