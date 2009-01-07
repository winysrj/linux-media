Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n07Kv37p029554
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 15:57:03 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n07KuUC7032652
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 15:56:34 -0500
Received: by qw-out-2122.google.com with SMTP id 3so3637910qwe.39
	for <video4linux-list@redhat.com>; Wed, 07 Jan 2009 12:56:30 -0800 (PST)
Message-ID: <412bdbff0901071248p5c0ddee3qa034a0db7021998@mail.gmail.com>
Date: Wed, 7 Jan 2009 15:48:15 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: marilynnpg@tx.rr.com
In-Reply-To: <20090107203537.3M8BX.5758.root@cdptpa-web12-z01>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <412bdbff0901071123u37284eb7k7b2f861e91555bf0@mail.gmail.com>
	<20090107203537.3M8BX.5758.root@cdptpa-web12-z01>
Cc: video4linux-list@redhat.com
Subject: Re: Windows vs Linux DVR System?
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

On Wed, Jan 7, 2009 at 3:35 PM,  <marilynnpg@tx.rr.com> wrote:
> Devin, All that you are saying may be true.  All that I can say is that when I combine the USB 36ft cable with my Logitech QuickCam Pro at 30 frames/ second with a 960 by 720 pixels frame size, it worked flawlessly.

Sure, for simple CCD analog capture devices, I can see that working.

For any device with a tuner, analog decoder, or ATSC/DVB demodulator,
you're already pretty much at 500ma.  In fact, using an inline meter,
I have seen devices exceed 500ma and it results in some fun debugging
for some environments depending on how the USB host handles exceeding
the maximum power threshold.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
