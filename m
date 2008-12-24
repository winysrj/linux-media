Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOJ74b2028306
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 14:07:04 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBOJ6p0V013727
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 14:06:52 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1212943fga.7
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 11:06:51 -0800 (PST)
Message-ID: <30353c3d0812241106ie3ac395p2800ee88947d5a13@mail.gmail.com>
Date: Wed, 24 Dec 2008 14:06:51 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Manas Bhattacharya" <bhattacharya.manas@gmail.com>
In-Reply-To: <b9476b930812240930l60e1ca74ua53c4b16c40ecc85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9476b930812240930l60e1ca74ua53c4b16c40ecc85@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: help: v4l2 pixel format setting
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

On Wed, Dec 24, 2008 at 12:30 PM, Manas Bhattacharya
<bhattacharya.manas@gmail.com> wrote:
> Hi all
>  I  need help in setting pixel values to my wecam. My camera is Frontech
> ecam jil 2220 model
> The PC cam controller installed  Sn9c120  .Any pixel format i want to
> set(say yuyv,yuv420 etc) VIDIOC_S_FORMAT returns me Bayer Rgb (sbggr8)
> format .can u please help me in identifying the problem
>       Manas Bhattacharya

Correct, this looks like the right behavior. The vidioc_s_format ioctl
only requests that the camera return the data in the format requested.
If the camera does not support the requested format then it will set
the format to something it does support and return that format to you.
The reasoning behind this is that format conversions are not allowed
to be done in kernel space. If you really need yuyv, yuv420, etc. from
a camera that only supports sbggr8 then you should look at using
libv4l which will happily convert from the camera's native format to
the one you require.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
