Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBU0TUaO021289
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 19:29:30 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBU0TDbq026543
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 19:29:14 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1929529qwe.39
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 16:29:13 -0800 (PST)
Message-ID: <412bdbff0812291629o72c552ecq1b1fba6c44d99b06@mail.gmail.com>
Date: Mon, 29 Dec 2008 19:29:13 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Trevor Campbell" <tca42186@bigpond.net.au>
In-Reply-To: <4959678C.40407@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495564E3.4070702@bigpond.net.au>
	<412bdbff0812261919k425a3a24w7910628cc9865a83@mail.gmail.com>
	<4959678C.40407@bigpond.net.au>
Cc: video4linux-list@redhat.com
Subject: Re: em28xx: new board id [1b80:e302]
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

On Mon, Dec 29, 2008 at 7:13 PM, Trevor Campbell
<tca42186@bigpond.net.au> wrote:
> I have created a page as requested at
> http://www.linuxtv.org/wiki/index.php/Kaiser_Baas_USB_DVD_Maker_2_(KBA0300300)

Ok, great.  This is just an em2861/saa7113 combination with no tuner
or digital support.  Should be pretty straightforward.

We probably just need a device profile.

I'll see about putting together a patch that you can apply and see if
it works.  Ping me in a few days if you don't hear back from me.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
