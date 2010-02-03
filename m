Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13HsE3C008867
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 12:54:14 -0500
Received: from mail-bw0-f217.google.com (mail-bw0-f217.google.com
	[209.85.218.217])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13Hs3io009705
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 12:54:04 -0500
Received: by bwz9 with SMTP id 9so222965bwz.30
	for <video4linux-list@redhat.com>; Wed, 03 Feb 2010 09:54:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>
References: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>
Date: Wed, 3 Feb 2010 12:54:02 -0500
Message-ID: <829197381002030954j6ebc845fl269e2f72bffbcba@mail.gmail.com>
Subject: Re: Saving YUVY image from V4L2 buffer to file
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Owen O' Hehir" <oo_hehir@hotmail.com>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, Feb 3, 2010 at 12:40 PM, Owen O' Hehir <oo_hehir@hotmail.com> wrote:
>
> Hello All,
>
> I'm trying to save a captured image from a USB camera to a file. The capture is based on V4L2 video capture example from the V4L2 API spec. http://v4l2spec.bytesex.org/spec/a16706.htm
>
> The V4L2 set pointers (via mmap) to to the USB image (in YUV 4:2:2 (YUYV)) and as far as I can see the simplest way to save the image in a recognised format is in RGB format, specifically in PPM (Netpbm color image format).
>
> As such I've expanded the process_image function:

Independent of the conversion function, are you sure you are getting a
valid YUV frame at all?  A completely green frame is what you will get
back if you had a buffer which was memset(0).  Hence it's possible
that the data you are passing *into* your conversion function is
completely blank.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
