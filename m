Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAPDWir2014308
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 08:32:44 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAPDWhlQ018615
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 08:32:43 -0500
Received: by yw-out-2324.google.com with SMTP id 5so986691ywb.81
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 05:32:43 -0800 (PST)
Message-ID: <62e5edd40811250322r5f87b35ub6223ead720263a3@mail.gmail.com>
Date: Tue, 25 Nov 2008 12:22:02 +0100
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Chia-I Wu" <olvaffe@gmail.com>
In-Reply-To: <20081125082002.GC18787@m500.domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <492B15E1.2080207@gmail.com> <20081125082002.GC18787@m500.domain>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, noodles@earth.li,
	qce-ga-devel@lists.sourceforge.net
Subject: Re: Please test the gspca-stv06xx branch
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

Hi,

2008/11/25 Chia-I Wu <olvaffe@gmail.com>:
> Hi Erik,
>
> On Mon, Nov 24, 2008 at 10:00:17PM +0100, Erik Andrén wrote:
>> I've reworked the driver somewhat and added initial support for th
>> pb0100.
>> Please test with the latest version of the gspca-stv06xx tree and
>> see if you can get an image. Ekiga works best for me at the moment.
> I am trying to make gspca-stv06xx work with my QuickCam Express
> (046d:0840).  It comes with the HDCS 1000 sensor.  So far, I am able to
> receive frames using gstreamer (with libv4l).  The colors are wrong
> though.
>
> While working on it, I encounter two minor issues:
>
> * stv06xx_write_sensor sends an extra packet unconditionally.  It causes
>  the function call return error.

Do you mean the extra packet to register 0x1704?
It's needed for my quickca

> * Turning LED on/off kills the device.  I have to re-plug the device to
>  make it work again.
>
> I could put those functions inside an if clause:
>
>        if (udev->descriptor.idProduct != 0x840)
>                do_something;
>
> and things work.  But as I do not have other cameras to test, I am not
> sure if this is the right way.  Do you have any suggestion?
>
> I will keep working on it.  But you can find a primitive patch and a
> sample image in the attachments.
>

Wow, thanks for the patch.
I'll review and probably commit it later today.

Best regards,
Erik

> --
> Regards,
> olv
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
