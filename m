Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4J1bFx003419
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 14:01:37 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB4J1Lpv031248
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 14:01:21 -0500
Received: by ug-out-1314.google.com with SMTP id j30so4658900ugc.13
	for <video4linux-list@redhat.com>; Thu, 04 Dec 2008 11:01:21 -0800 (PST)
Message-ID: <412bdbff0812041101i7a2a5bebjeed2299a2065f79@mail.gmail.com>
Date: Thu, 4 Dec 2008 14:01:20 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Steve Fink" <sphink@gmail.com>
In-Reply-To: <7d7f2e8c0812041009w487b5aabwaf27d5c7d917b1ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7d7f2e8c0812032307y3b12f74cr8c00175618add7a1@mail.gmail.com>
	<412bdbff0812040659l2c441ed8mcc9cd00573b3f939@mail.gmail.com>
	<7d7f2e8c0812041009w487b5aabwaf27d5c7d917b1ab@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: v4l support for "Pinnacle PCTV HD Pro USB Stick"
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

On Thu, Dec 4, 2008 at 1:09 PM, Steve Fink <sphink@gmail.com> wrote:
> Ok, thanks. I guess I'll try returning this one, then.
>
> I wonder if there's any way to apply pressure -- I mean, encouragement
> -- to manufacturers to either change model numbers or at least release
> serial number ranges or something along with specs for their hardware.
> The only reason I bought this device was because it had composite
> input and Linux support -- or at least, the earlier version with
> exactly the same description did.
>
> I suppose I could take a quick stab at making my app decode the mpeg
> frames, but it's really suboptimal for my setup (I am very sensitive
> to latency and CPU load.)

Just to be clear, the analog is not being converted into MPEG inside
the device.  Analog isn't supported at all.  When somebody finally
does get around to adding the device driver support, it will behave
just like any other v4l device (providing uncompressed video).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
