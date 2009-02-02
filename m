Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n129ZviU022797
	for <video4linux-list@redhat.com>; Mon, 2 Feb 2009 04:35:57 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n129Y00R015684
	for <video4linux-list@redhat.com>; Mon, 2 Feb 2009 04:34:28 -0500
Received: by fg-out-1718.google.com with SMTP id 19so514447fgg.7
	for <video4linux-list@redhat.com>; Mon, 02 Feb 2009 01:34:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902012227.46111.laurent.pinchart@skynet.be>
References: <286e6b7c0902010957g62d19274u8bbe75932e6a1f9@mail.gmail.com>
	<200902012227.46111.laurent.pinchart@skynet.be>
Date: Mon, 2 Feb 2009 09:34:00 +0000
Message-ID: <286e6b7c0902020134n4362b073n541fba3dda959b44@mail.gmail.com>
From: D <d.a.nstowell+v4l@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: VIDIOCGMBUF "Invalid argument" (hasciicam on eee,
	2.6.27-8-eeepc)
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

2009/2/1, Laurent Pinchart <laurent.pinchart@skynet.be>:
> The UVC driver doesn't support the deprecated V4L1 API. The v4l1compat.so
>  wrapper might help you, as it translates V4L1 calls to V4L2.

Ah, thanks. Doing this...

LD_PRELOAD=/usr/lib64/libv4l/v4l1compat.so ./hasciicam

...allows hasciicam to get beyond the point I described above, but
then it gets terminated with a message " *** buffer overflow detected
***: ./hasciicam terminated".

It looks like the better way forward would be to move up to the
current API. I've found the V4L2 API reference now. Do you know of any
"transition guides" that might help me update the code?

Thanks,
Dan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
